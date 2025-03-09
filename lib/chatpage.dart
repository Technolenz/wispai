import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wisp_ai/services/ai_service.dart';
import 'exports.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late AIService aiService;
  late stt.SpeechToText speech;
  late FlutterTts flutterTts;
  bool _isListening = false;
  bool _showKeyboard = false;
  String _lastWords = '';
  String _userName = 'User';
  String? _apiKey;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _chatHistory = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    flutterTts = FlutterTts();
    _initSpeech();
    _initTts();
    _loadUserData();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    _scrollController.dispose();
    flutterTts.stop();
    speech.stop();
    super.dispose();
  }

  // Initialize TTS
  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  // Speak the AI's response using TTS
  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  // Stop TTS on double-tap
  void _stopTts() async {
    await flutterTts.stop();
  }

  // Load user data (username and API key) from Firestore
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirestoreService().getUserInfo(user.uid);
      setState(() {
        _userName = userData['name'] ?? 'User';
        _apiKey = userData['geminiApiKey'];
      });

      if (_apiKey == null || _apiKey!.isEmpty) {
        _showApiKeyError();
      } else {
        aiService = AIService(geminiApiKey: _apiKey!);
      }
    }
  }

  // Show error if API key is missing or invalid
  void _showApiKeyError() {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a valid API key in the settings.'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  Future<void> _initSpeech() async {
    bool available = await speech.initialize();
    if (available) {
      debugPrint("Speech recognition initialized successfully.");
    }
  }

  void _startListening() {
    speech.listen(
      onResult: (result) {
        setState(() => _lastWords = result.recognizedWords);
      },
      listenFor: const Duration(seconds: 10),
    );
    setState(() => _isListening = true);
  }

  void _stopListening() async {
    speech.stop();
    if (_lastWords.trim().isEmpty) return;

    setState(() {
      _isListening = false;
      _chatHistory.add({'sender': _userName, 'message': _lastWords});
    });

    _processUserMessage(_lastWords);
    _lastWords = '';
  }

  void _processUserMessage(String message) async {
    try {
      final response = await aiService.chatGeminiAPI(message);
      setState(() {
        _chatHistory.add({'sender': 'WispAI', 'message': response});
        _scrollToBottom();
      });
      _speak(response); // Speak the AI's response
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _toggleKeyboard() {
    setState(() {
      _showKeyboard = !_showKeyboard;
      if (_showKeyboard) {
        FocusScope.of(context).requestFocus(_focusNode);
      } else {
        FocusScope.of(context).unfocus();
      }
    });
  }

  void _handleKeyboardInput(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _chatHistory.add({'sender': _userName, 'message': text});
      _textController.clear();
      _showKeyboard = false;
    });

    _processUserMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Save chat history to Firestore when the page is popped
  Future<void> _saveChatHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _chatHistory.isNotEmpty) {
      await FirestoreService().saveChatHistory(
        userId: user.uid,
        chatHistory: _chatHistory,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentGradient = themeProvider.currentGradient;

    return WillPopScope(
      onWillPop: () async {
        await _saveChatHistory();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("WispAI"),
          backgroundColor: themeProvider.themeData.primaryColor,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: currentGradient, // Use the current gradient
          ),
          child: GestureDetector(
            onTap: _toggleKeyboard,
            onDoubleTap: _stopTts, // Stop TTS on double-tap
            onLongPressStart: (_) => _startListening(),
            onLongPressEnd: (_) => _stopListening(),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _chatHistory.length,
                    itemBuilder: (context, index) {
                      final entry = _chatHistory[index];
                      return ChatBubble(
                        sender: entry['sender']!,
                        message: entry['message']!,
                        isUser: entry['sender'] == _userName,
                        themeProvider: themeProvider,
                        isLastAiResponse: index == _chatHistory.length - 1 && entry['sender'] == "WispAI",
                      );
                    },
                  ),
                ),
                if (_showKeyboard)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      style: const TextStyle(fontSize: 18.0),
                      onSubmitted: _handleKeyboardInput,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: themeProvider.themeData.primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                        onPressed: _isListening ? _stopListening : _startListening,
                        iconSize: 50.0,
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard),
                        onPressed: _toggleKeyboard,
                        iconSize: 50.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isUser;
  final bool isLastAiResponse;
  final ThemeProvider themeProvider;

  const ChatBubble({
    super.key,
    required this.sender,
    required this.message,
    required this.isUser,
    required this.isLastAiResponse,
    required this.themeProvider,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard!"), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isUser
                  ? themeProvider.themeData.primaryColor
                  : themeProvider.themeData.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: MarkdownBody(
              data: message, // Auto-formatting text with Markdown
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 16.0,
                  color: themeProvider.themeData.textTheme.bodyLarge?.color ?? Colors.white,
                ),
              ),
            ),
          ),
          if (isLastAiResponse) // Show copy icon only for last AI message
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () => _copyToClipboard(context),
              tooltip: "Copy response",
            ),
        ],
      ),
    );
  }
}


/// A widget that animates text (character by character) and renders it as Markdown.
class AnimatedMarkdownText extends StatefulWidget {
  final String text;
  final Duration charDelay;
  const AnimatedMarkdownText({
    Key? key,
    required this.text,
    this.charDelay = const Duration(milliseconds: 20),
  }) : super(key: key);

  @override
  _AnimatedMarkdownTextState createState() => _AnimatedMarkdownTextState();
}

class _AnimatedMarkdownTextState extends State<AnimatedMarkdownText> {
  String _displayedText = "";
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(widget.charDelay, (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _currentIndex++;
          _displayedText = widget.text.substring(0, _currentIndex);
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedMarkdownText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _timer?.cancel();
      _currentIndex = 0;
      _displayedText = "";
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: _displayedText,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
    );
  }
}
