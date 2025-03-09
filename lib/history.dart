import 'package:cloud_firestore/cloud_firestore.dart';

import 'exports.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentGradient = themeProvider.currentGradient;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat History"),
        backgroundColor: themeProvider.themeData.primaryColor,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: currentGradient, // Use the current gradient
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .doc(_auth.currentUser?.uid)
              .collection('chatHistory')
              .orderBy('timestamp', descending: true) // Order by timestamp
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No chat history available.'));
            }

            final chatSessions = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: chatSessions.length,
              itemBuilder: (context, index) {
                final session = chatSessions[index];
                final timestamp = session['timestamp'] as Timestamp;
                final messages = session['messages'] as List<dynamic>;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  color: themeProvider.themeData.scaffoldBackgroundColor,
                  child: ExpansionTile(
                    title: Text(
                      'Conversation ${index + 1}',
                      style: TextStyle(
                        color: themeProvider.themeData.textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${messages.length} messages - ${_formatTimestamp(timestamp)}',
                      style: TextStyle(
                        color: themeProvider.themeData.textTheme.bodyMedium?.color,
                      ),
                    ),
                    children: messages.map<Widget>((message) {
                      final sender = message['sender'] as String;
                      final text = message['message'] as String;

                      return ListTile(
                        title: Text(
                          sender,
                          style: TextStyle(
                            color: sender == 'WispAI'
                                ? themeProvider.themeData.primaryColor
                                : themeProvider.themeData.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          text,
                          style: TextStyle(
                            color: themeProvider.themeData.textTheme.bodyMedium?.color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Format timestamp to a readable string
  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
