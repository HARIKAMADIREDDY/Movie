import 'dart:convert';
import 'package:flutter/material.dart';
import 'details_screen.dart';
import 'package:http/http.dart' as http;
import 'search_screen.dart'; // Assuming SearchScreen is already created

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = jsonDecode(response.body);
      });
    } else {
      // Handle the error case if the API request fails
      print('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Navigate to the SearchScreen when search icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()), // Correct navigation
              );
            },
          ),
        ],
      ),
      body: movies.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading spinner until data is fetched
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                var movie = movies[index]['show']; // Access the show details
                return ListTile(
                  leading: movie['image'] != null
                      ? Image.network(movie['image']['medium'])
                      : Icon(Icons.image_not_supported), // Fallback for missing image
                  title: Text(movie['name']),
                  subtitle: Text(movie['summary'] != null
                      ? movie['summary'].replaceAll(RegExp('<[^>]*>'), '') // Clean HTML tags
                      : 'No summary available'),
                  onTap: () {
                    // Handle onTap event (could navigate to a movie details screen)
                    
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsScreen(movie:movie)),
              );
          
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
        currentIndex: 0, // Set this based on the current active screen if needed
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()), // Navigate to SearchScreen
            );
          }
        },
      ),
    );
  }
}
