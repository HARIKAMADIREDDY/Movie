import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quad/details_screen.dart';
//import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  TextEditingController _controller = TextEditingController();

  searchMovies(String query) async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
              hintText: 'Search for a movie...',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => searchMovies(_controller.text),
              )),
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          var movie = searchResults[index]['show'];
          return ListTile(
            leading: Image.network(movie['image'] != null ? movie['image']['medium'] : ''),
            title: Text(movie['name']),
            subtitle: Text(movie['summary'] != null
                ? movie['summary'].replaceAll(RegExp('<[^>]*>'), '')
                : 'No summary available'),
            onTap: () {
               Navigator.push(
                 context,
                MaterialPageRoute(
                     builder: (context) => DetailsScreen(movie: movie)),
               );
            },
          );
        },
      ),
    );
  }
}