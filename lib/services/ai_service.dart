import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AIService {
  final String geminiApiKey;

  AIService({required this.geminiApiKey});

  Future<String> chatGeminiAPI(String prompt) async {
    if (geminiApiKey.isEmpty) {
      throw Exception('API key is missing. Please add a valid API key in the settings.');
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String? messageContent = responseBody['candidates']?[0]['content']['parts']?[0]['text'];

        if (messageContent != null) {
          return messageContent;
        } else {
          throw Exception('No response from AI. Please check the API key and try again.');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid API key. Please update the API key in the settings.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // Log the error for debugging
      debugPrint('Error in chatGeminiAPI: $e');
      throw Exception(
          'Failed to connect to the AI service. Please check your internet connection and try again.');
    }
  }
}
