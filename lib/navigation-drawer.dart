import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  final String currentTab;

  final Function(String tab) onTabSelected;

  NavigationDrawer({this.onTabSelected, this.currentTab});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "To-Done",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  "Get stuff done!",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            selected: currentTab == 'upcoming',
            leading: Icon(Icons.inbox),
            title: Text("Upcoming"),
            onTap: () {
              Navigator.of(context).pop();
              onTabSelected("upcoming");
            },
          ),
          ListTile(
            selected: currentTab == 'important',
            leading: Icon(Icons.star),
            title: Text("Important"),
            onTap: () {
              Navigator.of(context).pop();
              onTabSelected("important");
            },
          ),
          ListTile(
            leading: Icon(Icons.archive),
            selected: currentTab == 'archived',
            title: Text("Archived"),
            onTap: () {
              Navigator.of(context).pop();
              onTabSelected("archived");
            },
          )
        ],
      ),
    );
    ;
  }
}
