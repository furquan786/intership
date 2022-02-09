import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intership/addmovie.dart';
import 'package:intership/firebasemodel/firesebase.dart';
import 'package:intership/login.dart';
import 'package:intership/updatemovielist.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    setState(() {
      initialise();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      initialise();
    });
  }

  late Databse db;
  List docs = [];
  initialise() {
    db = Databse();
    db.initiliase();
    db.read().then((value) {
      setState(() {
        docs = value;
      });
    });
  }

  late int index = docs.length;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Movies',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.logout,
                size: 20,
                color: Colors.red,
              ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMovie(db: db),
              ),
            ).then((value) => {
                  if (value != null)
                    {
                      setState(() {
                        initialise();
                      })
                    }
                });
          },
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (BuildContext context, index) {
            return Card(
              color: Color.fromRGBO(70, 72, 50, 1),
              margin: EdgeInsets.all(15),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Updatemovielist(
                        movie: docs[index],
                        db: db,
                        url: docs[index],
                      ),
                    ),
                  ).then((value) => {
                        if (value != null)
                          {
                            setState(() {
                              initialise();
                            })
                          }
                      });
                },
                contentPadding: EdgeInsets.only(right: 12, left: 20),
                title: Column(
                  children: [
                    Text(
                      "Movie: ${docs[index]['name']}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8.5,
                    ),
                    Text(
                      "Director: ${docs[index]['director']}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                leading: CircleAvatar(
                  radius: 50.4,
                  backgroundImage: NetworkImage(docs[index]['url'].length > 0
                      ? docs[index]['url']
                      : CircularProgressIndicator()),
                ),
                trailing: IconButton(
                    onPressed: () async {
                      db.delete(docs[index]['id']);
                      setState(() {
                        initialise();
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
              ),
            );
          }),
    );
  }
}
