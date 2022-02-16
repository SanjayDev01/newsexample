// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:newsexample/auth/signin_screen.dart';
import 'package:newsexample/components/news_card.dart';
import 'package:newsexample/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:newsexample/models/news_article.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String apiUrl = Config().url;
  List<Articles> articlesList = [];
  List<Articles> articlesList1 = [];

  bool isLoad = false;
  bool isRefresh = false;

  int newsPage = 1;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    getNews();
  }

  onRefresh() {
    setState(() {
      isRefresh = true;
    });
    getNews();

    if (isRefresh) {
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshFailed();
    }
    setState(() {
      isRefresh = false;
    });
  }

  onLoading() {
    setState(() {
      isLoad = true;
    });
    getNews();
    if (isLoad) {
      refreshController.loadComplete();
    } else {
      refreshController.loadFailed();
    }
  }

  getNews() async {
    if (isRefresh) {
      setState(() {
        newsPage = 1;
        isLoad = false;
        articlesList.clear();
        articlesList1.clear();
      });
    }
    try {
      EasyLoading.show(status: 'loading...');

      Uri uri = Uri.parse(
          "https://newsapi.org/v2/everything?q=a&pageSize=20&page=$newsPage&apiKey=bc98639f05e548859be86cc53f1b2e9f");
      var response = await http.get(uri);
      if (response.body != null) {
        var newsArticles = NewsAPI.fromJson(json.decode(response.body));
        articlesList = newsArticles.articles;
        print(articlesList);

        setState(() {
          isLoad
              ? articlesList.addAll(articlesList1)
              : articlesList == articlesList1;

          newsPage = newsPage + 1;
        });
        print("articlesList1 $articlesList1");
      }
      EasyLoading.dismiss();
      setState(() {});
    } catch (e) {
      EasyLoading.dismiss();

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          onRefresh: onRefresh,
          onLoading: onLoading,
          child: SingleChildScrollView(
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
                ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: articlesList.length,
                    separatorBuilder: (context, index) => Divider(),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 16, right: 16),
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
          ))),
    );
  }
}
