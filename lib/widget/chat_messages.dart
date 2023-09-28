import 'package:chat_app/widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Chat').orderBy(
        'createdAt',
        descending: true,
        )
        .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return Center(
            child: Text('No messages found.'),
          );
        }

        if (chatSnapshots.hasError) {
          return Center(
            child: Text('Something went wrong.'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40, 
            left: 13,
            right:13, 
          ),
            reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index){
            final ChatMessages = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length 
            ? loadedMessages[index + 1].data()
            :null ;

          final currentMessageUsername = ChatMessages['userId'];
          final nextMessageUsername =
              nextChatMessage != null ? nextChatMessage['userId'] :null; 
          final nextUserIsSame = nextMessageUsername == currentMessageUsername;

          if(nextUserIsSame){
            return MessageBubble.next(
              message: ChatMessages['text'], 
              isMe: authenticatedUser.uid == currentMessageUsername,
            );
          }
          else{
            return MessageBubble.first(
              userImage: ChatMessages['userImage'], 
              username: ChatMessages['username'], 
              message: ChatMessages['text'], 
              isMe: authenticatedUser.uid == currentMessageUsername,);
          }
          },
        );
      },
    );
  }
}
