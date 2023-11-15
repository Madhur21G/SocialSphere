import 'package:flutter/material.dart';
import 'package:social_sphere/components/my_drawer.dart';
import 'package:social_sphere/components/my_list_tile.dart';
import 'package:social_sphere/components/my_posts_button.dart';
import 'package:social_sphere/components/my_textfield.dart';
import 'package:social_sphere/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController newPostController = TextEditingController();

  void postMessage() {
    if(newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("W A L L"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                      hintText: "Say something...",
                      obscureText: false,
                      controller: newPostController,
                  ),
                ),

                PostButton(
                    onTap: postMessage,
                )
              ],
            ),
          ),

          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final posts = snapshot.data!.docs;

                if(snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Text("No Posts.... Post Something!"),
                    ),
                  );
                }
                return Expanded(
                    child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];

                          String message = post['PostMessage'];
                          String userEmail = post['UserEmail'];

                          return MyListTile(title: message, subTitle: userEmail);
                        },
                    ),
                );
              },
          )
        ],
      ),
    );
  }
}
