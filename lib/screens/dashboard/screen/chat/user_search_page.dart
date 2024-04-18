import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final _searchController = TextEditingController();
  Stream<QuerySnapshot>? _searchResultsStream;

  @override
  void initState() {
    super.initState();
    _searchResultsStream =
        FirebaseFirestore.instance.collection("user").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search users...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchResultsStream = FirebaseFirestore.instance
                  .collection("user")
                  .where("firstName", isGreaterThanOrEqualTo: value)
                  .snapshots();
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _searchResultsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data?.docs[index];
              print('search document value: ${document?.data()}');
              return ListTile(
                title: Text(
                  document?.get('firstName'),
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  // handle tap on search result
                },
              );
            },
          );
        },
      ),
    );
  }
}
