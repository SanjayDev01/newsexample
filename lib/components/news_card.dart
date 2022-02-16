// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:newsexample/screens/news_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatelessWidget {
  final String imgUrl, title, desc, content, posturl;

  NewsCard(
      {required this.imgUrl,
      required this.desc,
      required this.title,
      required this.content,
      required this.posturl});

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NewsDetails(
            content: content,
            postUrl: posturl,
            title: title,
            description: desc,
            imgUrl: imgUrl,
          );
        }));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 24),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          imgUrl,
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.bookmark_add_outlined,
                              color: Colors.redAccent,
                              size: 32,
                            ),
                          )),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: IconButton(
                            onPressed: () {
                              _launchURL(posturl);
                            },
                            icon: Icon(
                              Icons.language,
                              color: Colors.blue,
                              size: 32,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    desc,
                    maxLines: 2,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
