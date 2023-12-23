import 'package:flutter/material.dart';

import './available_users_screen.dart';
import '../widgets/profile_viewer.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                // borderRadius: const BorderRadius.only(
                //   bottomRight: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.top,
                left: 15,
                right: 15,
                bottom: 15,
              ),
              child: ListView(
                children: [
                  const ProfileViewer(),
                  const SizedBox(height: 15),
                  ListTile(
                    leading: Icon(
                      Icons.people,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(
                      'Available Users',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(AvailableUsersScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
