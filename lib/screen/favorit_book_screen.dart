import 'package:flutter/material.dart';
import 'package:project_uas/services/database_helper.dart';

class FavoritesScreen extends StatelessWidget {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Books'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite books.'));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final book = favorites[index];
                return ListTile(
                  leading: Image.network(
                    book['image'],
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  title: Text(book['title']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await dbHelper.removeFavorite(book['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Book removed from favorites')),
                      );
                      (context as Element).reassemble();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
