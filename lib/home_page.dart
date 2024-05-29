import 'package:aplikasi_api_sederhana/detail.dart';
import 'package:aplikasi_api_sederhana/add_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> users = [];
  Map<String, String>? specificUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadSpecificUser();
  }

  Future<void> _loadData() async {
    var url = Uri.parse("https://reqres.in/api/users");
    var response = await http.get(url);
    var data = jsonDecode(response.body)['data'] as List;

    setState(() {
      users = data
          .map<Map<String, String>>((user) => {
                'id': user['id'].toString(),
                'first_name': user['first_name'],
                'last_name': user['last_name'],
                'avatar': user['avatar'],
                'email': user['email']
              })
          .toList();
      isLoading = false;
    });
  }

  Future<void> _loadSpecificUser() async {
    var url = Uri.parse("https://reqres.in/api/users/7");
    var response = await http.get(url);
    var data = jsonDecode(response.body)['data'];

    setState(() {
      specificUser = {
        'id': data['id'].toString(),
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'avatar': data['avatar'],
        'email': data['email']
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan, // Ubah warna menjadi cyan
        title: Text(widget.title),
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "List Users",
                        style: TextStyle(
                            fontSize: 18, // Ubah ukuran font menjadi 18
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Expanded(child: UserListView(users: users)),
                if (specificUser != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'List User By Id',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(specificUser!['avatar']!),
                      ),
                    ),
                  ),
                  title: Text(
                      '${specificUser!['id']} - ${specificUser!['first_name']} ${specificUser!['last_name']}'),
                  subtitle: Text('${specificUser!['email']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(user: specificUser!)),
                    );
                  },
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahPengguna()),
          );
        },
        tooltip: 'Tambah Pengguna',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserListView extends StatelessWidget {
  final List<Map<String, String>> users;

  const UserListView({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(users[index]['avatar']!),
              ),
            ),
          ),
          title: Text('${users[index]['id']}'),
          subtitle: Text(
              '${users[index]['first_name']} ${users[index]['last_name']}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(user: users[index])),
            );
          },
        );
      },
    );
  }
}
