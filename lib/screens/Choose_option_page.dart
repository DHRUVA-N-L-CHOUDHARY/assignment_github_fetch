import 'package:assignment_github_fetch/screens/commits_page.dart';
import 'package:assignment_github_fetch/screens/repos_fetch_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChooseOption extends StatelessWidget {
  const ChooseOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 40,
              width: 150,
              color: Colors.blue,
              child: TextButton(
                child: Text("Commits Page",style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return CommitsPage();
                    },
                  ));
                },
              ),
            ),
          ),
          Center(
            child: Container(
              height: 40,
              width: 150,
              color: Colors.blue,
              child: TextButton(
                child: Text("Repos Page",style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return RepositoryList();
                    },
                  ));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
