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
                    await auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return ChatPage();
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
          ]),
        ),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddPostPage();
          }));
        },
      ),
    );
  }
}

class AddPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('戻る'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
