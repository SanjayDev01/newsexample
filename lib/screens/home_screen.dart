// ignore_for_file: avoid_unnecessary_containers, unnecessary_string_interpolations, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:newsexample/auth/signin_screen.dart';
import 'package:newsexample/screens/bookmark_screen.dart';
import 'package:newsexample/screens/news_screen.dart';
import 'package:newsexample/screens/search_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  onBack() {
    return showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Warning'),
        content: Text('Do you really want to exit'),
        actions: [
          FlatButton(
              child: Text('Yes'), onPressed: () => SystemNavigator.pop()),
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(c, false),
          ),
        ],
      ),
    );
  }

  List<Widget> _widgetOptions = <Widget>[NewsScreen(), BookmarkScreen()];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await onBack();
        result ??= false;
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#203F3B"),
          title: Shimmer.fromColors(
            baseColor: Colors.redAccent,
            highlightColor: Colors.white38,
            child: const Text(
              'News App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          elevation: 0.0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchScreen();
                  }));
                },
                icon: Icon(Icons.search)),
          ],
        ),
        backgroundColor: Colors.white70,
        body: Container(
            child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        )),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: HexColor("#203F3B"),
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), label: "Bookmark"),
          ],
        ),
      ),
    );
  }
}
