import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_sphere/components/my_back_button.dart';
import 'package:social_sphere/components/my_list_tile.dart';
import 'package:social_sphere/helper/helper_function.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            displayMessageToUser("Something went wrong", context);
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.data == null){
            return const Text("No Data");
          }

          final users = snapshot.data!.docs;

          return Column(
            children: [

              const Padding(
                padding: const EdgeInsets.only(
                  top:50.0,
                  left: 25,
                ),
                child: Row(
                  children: [
                    MyBackButton(),
                  ],
                ),
              ),


              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final user = users[index];

                    String username = user['username'];
                    String email = user['email'];

                    return MyListTile(title: username, subTitle: email);
                  }
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
