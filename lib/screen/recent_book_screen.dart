import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RecentBooksScreen extends StatefulWidget {
  @override
  _RecentBooksScreenState createState() => _RecentBooksScreenState();
}

class _RecentBooksScreenState extends State<RecentBooksScreen> {
  late Future<List<dynamic>> _recentBooks;

  @override
  void initState() {
    super.initState();
    _recentBooks = ApiService.fetchRecentBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recently Added Books'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _recentBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  leading: Image.network(book['image'], width: 50),
                  title: Text(book['title']),
                  subtitle: Text(book['authors']),
                  onTap: () {
                    // Arahkan ke detail buku
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
