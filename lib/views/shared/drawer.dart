library devfest_florida_app.drawer;

// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:devfest_florida_app/views/schedule_home.dart';
import 'package:devfest_florida_app/views/speaker_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, required;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final List<DrawerItem> kAllDrawerMenuItems = drawerMenuItems();
final Map<String, WidgetBuilder> _kRoutes = new Map<String, WidgetBuilder>.fromIterable(
  kAllDrawerMenuItems,
  key: (DrawerItem item) => item.routeName,
  value: (DrawerItem item) => item.buildRoute,
);

class LinkTextSpan extends TextSpan {
  LinkTextSpan({ TextStyle style, String url, String text }) : super(
      style: style,
      text: text ?? url,
      recognizer: new TapGestureRecognizer()..onTap = () {
        launch(url);
      }
  );
}

class ConfAppDrawerHeader extends StatefulWidget {
  const ConfAppDrawerHeader({ Key key }) : super(key: key);

  @override
  _ConfAppDrawerHeaderState createState() => new _ConfAppDrawerHeaderState();
}

class _ConfAppDrawerHeaderState extends State<ConfAppDrawerHeader> {

  @override
  Widget build(BuildContext context) {
    return new DrawerHeader(
        decoration:new BoxDecoration(
            color: const Color(0xff1e90ff),
        ),
        duration: const Duration(milliseconds: 750),
        child: new Image.asset('assets/images/devfest-logo.png')
    );
  }
}

class ConfAppDrawer extends StatelessWidget {
  const ConfAppDrawer({
    Key key,
    this.onPlatformChanged,
    this.onSendFeedback,
  }) :  super(key: key);

  final ValueChanged<TargetPlatform> onPlatformChanged;

  final VoidCallback onSendFeedback;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(color: themeData.accentColor);

    final Widget locationItem = new ListTile(
      leading: const Icon(Icons.message),
      title: const Text('Send feedback'),
      onTap: onSendFeedback ?? () {
        launch('https://github.com/flutter/flutter/issues/new');
      },
    );

    final Widget aboutItem = new AboutListTile(
        icon: const Icon(Icons.info),
        applicationVersion: 'June 2017 Preview',
        applicationLegalese: '© 2017 The Chromium Authors',
        aboutBoxChildren: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: new RichText(
                  text: new TextSpan(
                      children: <TextSpan>[
                        new TextSpan(
                            style: aboutTextStyle,
                            text: "Flutter is an early-stage, open-source project to help "
                                "developers build high-performance, high-fidelity, mobile "
                                "apps for iOS and Android from a single codebase. "
                        ),
                        new TextSpan(
                            style: aboutTextStyle,
                            text: ".\n\nTo see the source code for this app, please visit the "
                        ),
                        new LinkTextSpan(
                            style: linkStyle,
                            url: 'https://goo.gl/iv1p4G',
                            text: 'flutter github repo'
                        ),
                        new TextSpan(
                            style: aboutTextStyle,
                            text: "."
                        )
                      ]
                  )
              )
          )
        ]
    );

    final List<Widget> drawerItems = new List<Widget>();
    drawerItems.add(new ConfAppDrawerHeader());
    kAllDrawerMenuItems.forEach((drawerItem)=> drawerItems.add(drawerItem));
    drawerItems.add(new Divider(color: Colors.grey[400], height: 0.4,),);
    drawerItems.add(locationItem);
    drawerItems.add(aboutItem);

    return new Drawer(child: new ListView(primary: false, children: drawerItems));
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    @required this.title,
    this.leadingIcon,
    this.subtitle,
    @required this.category,
    @required this.routeName,
    @required this.buildRoute,
  }) : assert(title != null),
        assert(category != null),
        assert(routeName != null),
        assert(buildRoute != null);

  final String title;
  final Icon leadingIcon;
  final String subtitle;
  final String category;
  final String routeName;
  final WidgetBuilder buildRoute;

  @override
  Widget build(BuildContext context) {
    return new MergeSemantics(
      child: new ListTile(
          leading: leadingIcon,
          title: new Text(title),
          onTap: () {
            if (routeName != null) {
              Timeline.instantSync('Start Transition', arguments: <String, String>{
                'from': '/',
                'to': routeName
              });
              Navigator.pop(context);
              Navigator.pushNamed(context, routeName);
            }
          }
      ),
    );
  }
}

List<DrawerItem> drawerMenuItems() {
  final List<DrawerItem> appItems = <DrawerItem>[
    new DrawerItem(
      title: 'Schedule',
      leadingIcon: const Icon(Icons.view_quilt),
      category: 'Drawer Menu',
      subtitle: '',
      routeName: ScheduleHomeWidget.routeName,
      buildRoute: (BuildContext context) => new ScheduleHomeWidget(),
    ),
    new DrawerItem(
      title: 'Speakers',
      leadingIcon: const Icon(Icons.record_voice_over),
      subtitle: '',
      category: 'Drawer Menu',
      routeName: SpeakerListWidget.routeName,
      buildRoute: (BuildContext context) => new SpeakerListWidget(),
    )
  ];
  return appItems;
}