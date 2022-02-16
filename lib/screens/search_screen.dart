// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:newsexample/components/news_card.dart';
import 'package:newsexample/config/config.dart';
import 'package:newsexample/models/news_article.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String apiUrl = Config().url;
  List<Articles> articlesList = [];
  List<Articles> articlesList1 = [];

  String searchText = "b";
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

  getNews() async {
    if (isRefresh) {
      setState(() {
        newsPage = 1;
        searchText = "b";
        isLoad = false;
        articlesList.clear();
        articlesList1.clear();
      });
    }
    try {
      EasyLoading.show(status: 'loading...');

      Uri uri = Uri.parse(
          "https://newsapi.org/v2/everything?q=$searchText&searchIn=title&pageSize=20&page=$newsPage&apiKey=22f9faf06b114d9f951527a89f75dca4");
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

  @override
  Widget build(BuildContext context) {
    var popularSearchList = ListView.separated(
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
        });

    var popularSearchLayout = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: const Text(
        //     'Popular search',
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        popularSearchList
      ],
    );

    return Scaffold(
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
      ),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: SingleChildScrollView(
          child: Container(
            //  height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: HexColor("#203F3B"),
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                              newsPage = 0;
                            });

                            getNews();
                          },
                          textInputAction: TextInputAction.search,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Regular",
                          ),
                          onSaved: (value) {
                            setState(() {
                              searchText = value!;
                              newsPage = 0;
                            });
                            getNews();
                          },
                          decoration: InputDecoration(
                            hintText: 'Search News title',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            filled: false,
                          ),
                          onFieldSubmitted: (term) {
                            setState(() {
                              searchText = term;
                              newsPage = 0;
                            });
                            getNews();
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/ic_search.png",
                            color: Theme.of(context).primaryColor,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                popularSearchLayout,
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
