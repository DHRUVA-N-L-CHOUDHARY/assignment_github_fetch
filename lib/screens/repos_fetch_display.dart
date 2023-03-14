import 'package:assignment_github_fetch/api/repos_fetch.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryList extends StatefulWidget {
  @override
  State<RepositoryList> createState() => _RepositoryListState();
}

class _RepositoryListState extends State<RepositoryList> {
  List<dynamic> _data = [];

  void _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: GithubApi.fetchRepositories(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          final repositories = snapshot.data!;
          // print(repositories);
          return Scaffold(
            body: ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (BuildContext context, int index) {
                final repository = repositories[index];
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
                        leading: Icon(Icons.code),
                        minLeadingWidth: 20,
                        title: Text(repository["name"]),
                        subtitle:
                            Text(repository["description"] ?? "No Description"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("lang:${repository["language"] ?? "NA"}"),
                            Text("forks: ${repository["forks"] ?? "NA"}"),
                            Text(
                                "open_issues: ${repository["open_issues"] ?? "NA"}"),
                          ],
                        ),
                        onTap: () async {
                          if (!await launchUrl(Uri.parse(repository["url"]))) {
                            throw Exception('Could not launch $repository["url"]');
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return Scaffold(
           
            body: Center(
              child: Image.asset(
                'assets/githubb.png',
                width: 300,
                height: 300,
              ),
            ),
          );
        }
      },
    );
  }
}

class RepositoryItem extends StatelessWidget {
  final dynamic repository;

  RepositoryItem(this.repository);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.code),
      title: Text(repository["name"]),
      subtitle: Text(repository["description"] ?? "No description"),
      trailing: Text(repository["language"] ?? ""),
      onTap: () {
        // Handle repository item tap
      },
    );
  }
}
