import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Firebase初期化
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAuthPage(),
    );
  }
}

class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

// ログイン画面用Widget
class _MyAuthPageState extends State<MyAuthPage> {
  // 入力されたメールアドレス
  String newUserEmail = '';
  // 入力されたパスワード
  String newUserPassword = '';
  // 登録・ログインに関する情報を表示
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "メールアドレス"),
            onChanged: (String value) {
              setState(() {
                newUserEmail = value;
              });
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(labelText: 'パスワード(6文字以上)'),
            obscureText: true,
            onChanged: (String value) {
              setState(() {
                newUserPassword = value;
              });
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              try {
                // メール/パスワードでユーザ登録
                final FirebaseAuth auth = FirebaseAuth.instance;
                final UserCredential result =
                    await auth.createUserWithEmailAndPassword(email: newUserEmail, password: newUserPassword);
                // 登録したユーザー情報
                final User user = result.user!;
                setState(() {
                  infoText = "登録OK:${user.email}";
                });
              } catch (e) {
                setState(() {
                  infoText = "登録NG:${e.toString()}";
                });
              }
            },
            child: Text("ユーザー登録"),
          ),
          const SizedBox(height: 8),
          Text(infoText)
        ],
      ),
    )));
  }
}

// class ChatPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('チャット'),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
//                 return LoginPage();
//               }));
//             },
//             icon: Icon(Icons.close),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//             return AddPostPage();
//           }));
//         },
//       ),
//     );
//   }
// }

// class AddPostPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('チャット投稿'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('戻る'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//     );
//   }
// }
