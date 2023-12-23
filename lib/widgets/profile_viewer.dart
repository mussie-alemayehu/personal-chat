import 'package:chat/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileViewer extends StatelessWidget {
  const ProfileViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          const Text('Name of the user'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
