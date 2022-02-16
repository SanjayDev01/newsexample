// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:newsexample/auth/signin_screen.dart';
import 'package:newsexample/components/news_card.dart';
import 'package:newsexample/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:newsexample/models/news_article.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String apiUrl = Config().url;
  List<Articles> articlesList = [];

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    try {
      Uri uri = Uri.parse(apiUrl);
      var response = await http.get(uri);
      var newsArticles = NewsAPI.fromJson(json.decode(response.body));
      if (newsArticles.status == "ok") {
        setState(() {
          articlesList = newsArticles.articles;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Text(
              "Welcome ${currentUser.displayName}\n to News App",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListView.builder(
              itemCount: articlesList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return NewsCard(
                  imgUrl: articlesList[index].urlToImage,
                  title: articlesList[index].title,
                  desc: articlesList[index].description,
                  content: articlesList[index].content,
                  posturl: articlesList[index].url,
                );
              }),
        ],
      ),
    ));
  }
}
