import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://www.dbooks.org/api';

  // Fetch recently added books
  static Future<List<dynamic>> fetchRecentBooks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recent'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['books'];
      } else {
        throw Exception(
            'Failed to load recent books. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load recent books. Status code: $e');
    }
  }

  // Search books by query
  static Future<List<dynamic>> searchBooks(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search/$query'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['books'];
      } else {
        throw Exception(
            'Failed to search books. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search books. Status code: $e');
    }
  }

  // Get book details by ID
  static Future<Map<String, dynamic>> getBookDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/book/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        return {};
      } else {
        throw Exception(
            'Failed to fetch book details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch book details. Status code: $e');
      // return {};
    }
  }
}
