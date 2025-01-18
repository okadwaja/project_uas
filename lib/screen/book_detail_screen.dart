import 'package:flutter/material.dart';
import 'package:project_uas/services/database_helper.dart';
import '../services/api_service.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({Key? key, required this.bookId}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final dbHelper = DatabaseHelper();
    final status = await dbHelper.isFavorite(widget.bookId);
    setState(() {
      isFavorite = status;
    });
  }

  Future<void> _toggleFavorite(Map<String, dynamic> book) async {
    final dbHelper = DatabaseHelper();
    if (isFavorite) {
      await dbHelper.removeFavorite(book['id']);
    } else {
      await dbHelper.addFavorite({
        'id': book['id'],
        'title': book['title'],
        'authors': book['authors'],
        'image': book['image'],
      });
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () async {
              final book = await ApiService.getBookDetails(widget.bookId);
              if (book != null) {
                _toggleFavorite(book);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.getBookDetails(widget.bookId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No data available for this book.'));
          } else {
            final book = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      book['image'] ?? '',
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 150,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    book['title'] ?? 'No title available',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (book['subtitle'] != null && book['subtitle'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        book['subtitle'],
                        style: const TextStyle(
                            fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    "Authors: ${book['authors'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Publisher: ${book['publisher'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Year: ${book['year'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pages: ${book['pages'] ?? 'Unknown'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book['description'] ?? 'No description available.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final url = book['download'] ?? '';
                        if (url.isNotEmpty) {
                          // Implementasi fungsi unduhan di sini
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Download URL: $url')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Download URL not available.')),
                          );
                        }
                      },
                      child: const Text('Download Book'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
