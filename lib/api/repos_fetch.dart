import 'package:http/http.dart' as http;
import 'dart:convert';

class GithubApi {
  static const String _baseUrl = "https://api.github.com";
  static  List<dynamic> publicRepositories = [];

  static Future<List<dynamic>> fetchRepositories() async {
    try
    {
    final response =
        await http.get(Uri.parse("$_baseUrl/users/freeCodeCamp/repos"));

    if (response.statusCode == 200) {
      final List<dynamic> repositories = json.decode(response.body);
    print(repositories);
       publicRepositories = repositories
          .where((repository) => repository["private"] == false)
          .toList();
          print(publicRepositories);
          print("dsklfjldskf");
      return publicRepositories;
    } else {
      throw Exception('Failed to load repositories');
    }
    }
    catch(e)
    {
      print(e);
      return publicRepositories;
    }
  }
}
