import 'package:chat_app/widget/chat_messages.dart';
import 'package:chat_app/widget/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat app"), 
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, icon: 
          Icon(Icons.exit_to_app,
          color: Theme.of(context).colorScheme.primary,
          )),
        ],
      ),
      body: Column(
        children: [const
          Expanded(child:ChatMessages(), 
          ),
          NewMessages(),
        ],
      ),
      );
    
  }
}