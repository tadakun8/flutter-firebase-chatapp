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

// ログイン画面用Widget
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: Text('ログイン'),
            onPressed: () async {
              // チャット画面に遷移＋ログイン画面を破棄
              // NOTE: pushReplacementはpopで戻れない(画面の入れ替え)
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return ChatPage();
                }),
              );
            },
          )
        ],
      )),
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
