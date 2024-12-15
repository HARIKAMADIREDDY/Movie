import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic movie;

  DetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            movie['image'] != null
                ? Image.network(movie['image']['medium'])
                : Container(),
            SizedBox(height: 10),
            Text(movie['name'], style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text(movie['summary'] != null
                ? movie['summary'].replaceAll(RegExp('<[^>]*>'), '')
                : 'No summary available'),
            SizedBox(height: 10),
            Text('Genres: ${movie['genres'].join(', ')}'),
            Text('Premiered: ${movie['premiered']}'),
            Text('Language: ${movie['language']}'),
          ],
        ),
      ),
    );
  }
}