import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力されたメールアドレス
  String email = '';
  // 入力されたパスワード
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "メールアドレス"),
              onChanged: (String value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "パスワード"),
              onChanged: (String value) {
                setState(() {
                  password = value;
                });
              },
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Text(infoText),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                child: Text("ユーザー登録"),
                onPressed: () async {
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final result = await auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return ChatPage(result.user!);
                      }),
                    );
                  } catch (e) {
                    setState(() {
                      infoText = e.toString();
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: OutlinedButton(
                child: Text('ログイン'),
                onPressed: () async {
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final result = await auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return ChatPage(result.user!);
                      }),
                    );
                  } catch (e) {
                    setState(() {
                      infoText = "ログインに失敗しました:${e.toString()}";
                    });
                  }
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  ChatPage(this.user);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
        actions: [
          IconButton(
            onPressed: () async {
              // 内部で保持しているログイン情報が初期化される
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Text("ログイン情報:${user.email}"),
        ),
        Expanded(
          // FutureBuilder
          // 非同期処理の結果を元にWidgetを作れる
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('posts').orderBy('date').get(),
            builder: (context, snapshot) {
              // データが取得できた場合
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView(
                  children: documents.map((document) {
                    return Card(
                      child: ListTile(
                        title: Text(document['text']),
                        subtitle: Text(document['email']),
                      ),
                    );
                  }).toList(),
                );
              }
              return Center(
                child: Text('読み込み中'),
              );
            },
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddPostPage(user);
            }),
          );
        },
      ),
    );
  }
}

class AddPostPage extends StatefulWidget {
  // 引数からユーザ情報を受け取る
  AddPostPage(this.user);
  // ユーザ情報
  final User user;
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  // 入力した投稿メッセージ
  String messageText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '投稿メッセージ'),
                // 複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 3,
                onChanged: (String value) {
                  messageText = value;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('投稿'),
                  onPressed: () async {
                    final date = DateTime.now().toLocal().toIso8601String();
                    final email = widget.user.email;
                    await FirebaseFirestore.instance.collection('posts').doc().set({
                      'text': messageText,
                      'email': email,
                      'date': date,
                    });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
