import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, String> user;

  const DetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user['first_name']} ${user['last_name']}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (user.containsKey('avatar'))
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(user['avatar']!),
                  ),
                ),
                width: 150.0,
                height: 150.0,
              ),
            const SizedBox(
              height: 20,
            ),
            Text('Id: ${user['id']}'),
            Text('Nama: ${user['first_name']} ${user['last_name']}'),
            if (user.containsKey('email')) Text('Email: ${user['email']}'),
          ],
        ),
      ),
    );
  }
}
