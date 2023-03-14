import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommitsPage extends StatefulWidget {
  CommitsPage({Key? key}) : super(key: key);

  @override
  _CommitsPageState createState() => _CommitsPageState();
}

class _CommitsPageState extends State<CommitsPage> {
  final String _username = "freeCodeCamp"; // Replace with desired username
  List<dynamic> _repoNames = []; // List to hold repository names
  Map<String, String> _lastCommits = {}; // Map to hold last commit information

  @override
  void initState() {
    super.initState();
    _getRepos();
  }

   Future<void> _getRepos() async {
    try {
      final response = await http.get(Uri.parse('https://api.github.com/users/$_username/repos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _repoNames = data.map((repo) => repo['name']).toList();
        });
        await _getLastCommits();
      } else {
        throw Exception('Failed to load repositories');
      }
    } catch (e) {
      setState(() {
        _repoNames = []; // Clear the list of repositories
        _lastCommits = {}; // Clear the map of last commits
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load repositories. Please check your internet connection and try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  Future<void> _getLastCommits() async {
    for (final repoName in _repoNames) {
      final response = await http.get(Uri.parse(
          'https://api.github.com/repos/$_username/$repoName/commits'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final commit = data.first;
          final message = commit['commit']['message'];
          final author = commit['commit']['author']['name'];
          final date = commit['commit']['author']['date'];
          setState(() {
            _lastCommits[repoName] = '$message by $author on $date';
          });
        }
      } else {
        throw Exception('Failed to load last commit for $repoName');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GitHub Commits"),
      ),
      body: _repoNames.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _repoNames.length,
              itemBuilder: (BuildContext context, int index) {
                final repoName = _repoNames[index];
                final lastCommit = _lastCommits[repoName];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(repoName),
                        subtitle: lastCommit != null ? Text(lastCommit) : null,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
