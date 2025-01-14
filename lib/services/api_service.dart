import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://www.dbooks.org/api';

  // Fetch recently added books
  static Future<List<dynamic>> fetchRecentBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/recent'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['books'];
    } else {
      throw Exception('Failed to load recent books');
    }
  }

  // Search books by query
  static Future<List<dynamic>> searchBooks(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['books'];
    } else {
      throw Exception('Failed to search books');
    }
  }

  // Get book details by ID
  static Future<Map<String, dynamic>> getBookDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/book/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch book details');
    }
  }
}
