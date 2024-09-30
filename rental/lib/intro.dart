import 'package:flutter/material.dart';
import 'package:rental/contact.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rental/login.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int? accountId = 1;
  List<Contact> _contactsList = [];
  List<Map<String, dynamic>> _imageList = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    List<Contact> myList = await getContacts();

    setState(() {
      _contactsList = myList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            },
            icon: Icon(Icons.login),
          )
        ],
      ),
      body: Column(
        children: [
          ClipRRect(
            child: Image.asset(
              'assets/images/logo.jpg',
              height: 200,
              width: 200,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Anster Autoworks ',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'List of Rental Cars ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          FutureBuilder(
            future: getContacts(),
            builder: (context, snapShot) {
              switch (snapShot.connectionState) {
                case ConnectionState.waiting:
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Loading......."),
                    ],
                  );
                case ConnectionState.done:
                  if (snapShot.hasError) {
                    print(snapShot.hasError);
                    return Text("Errors : ${snapShot.error}");
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _contactsList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Card(
                            child: ListTile(
                              leading: _contactsList[index]
                                      .imageFilename!
                                      .isNotEmpty
                                  ? GestureDetector(
                                      onTap: () async {
                                        var images = await getImages(
                                            _contactsList[index].id!);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Center(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        "${_contactsList[index].model!}"),
                                                    Text(
                                                      "${_contactsList[index].price!} per day",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    _contactsList[index]
                                                        .description!,
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    child: ListView.separated(
                                                      itemCount: images.length,
                                                      separatorBuilder: (context,
                                                              index) =>
                                                          SizedBox(
                                                              height:
                                                                  10), // Add spacing between items
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Image.network(
                                                          "http://localhost/rental/lib/cars_images/${images[index]['cars_image']}?timestamp=${DateTime.now().microsecondsSinceEpoch}",
                                                          fit: BoxFit.contain,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                Center(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.blue),
                                                    ),
                                                    child: Text(
                                                      "Close",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Image.network(
                                        "http://localhost/rental/lib/images/${_contactsList[index].imageFilename!}?timestamp=${DateTime.now().microsecondsSinceEpoch}",
                                        height: 60,
                                        width: 40,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Icon(Icons.car_rental),
                              title: Text(_contactsList[index].model!),
                              subtitle: Text(_contactsList[index].description!),
                              trailing:
                                  Text("${_contactsList[index].price} per day"),
                            ),
                          ),
                        );
                      },
                    ),
                  );

                default:
                  return Text("Error : ${snapShot.error}");
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<Contact>> getContacts({bool search = false}) async {
    String url = 'http://localhost/rental/lib/api/contacts.php';

    final Map<String, dynamic> queryParams = {
      "operation": "getCar",
      "json": "",
    };

    http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: queryParams));
    if (response.statusCode == 200) {
      var contacts = jsonDecode(response.body);

      var contactList = List.generate(
          contacts.length, (index) => Contact.fromJson(contacts[index]));

      return contactList;
    } else {
      return [];
    }
  }

  Future<List> getImages(int carsId) async {
    String url = 'http://localhost/rental/lib/api/contacts.php';

    // final Map<String, dynamic> queryParams = {
    //   "userId": widget.userId.toString(),
    // };
    final Map<String, dynamic> jsonData = {
      "carsId": carsId.toString(),
    };
    final Map<String, dynamic> queryParams = {
      "operation": "getImages",
      "json": jsonEncode(jsonData),
    };

    http.Response response =
        await http.get(Uri.parse(url).replace(queryParameters: queryParams));
    if (response.statusCode == 200) {
      var contacts = jsonDecode(response.body);
      return contacts;
    } else {
      return [];
    }
  }

  Widget createListMaps() {
    return ListView.builder(
      itemCount: _imageList.length,
      itemBuilder: (context, index) {
        return Card(
          child: GestureDetector(
            onTap: () {
              ShowPic("Image Viewer", _imageList[index]['cars_image']);
            },
            child: ListTile(
              leading: Image.network(
                "http://localhost/rental/lib/cars_images/${_imageList[index]['cars_image']}?timestamp=${DateTime.now().microsecondsSinceEpoch}",
                height: 60,
                width: 40,
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }

  void ShowPic(String title, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              title,
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.network(
              "http://localhost/rental/lib/cars_images/$imageUrl?timestamp=${DateTime.now().microsecondsSinceEpoch}",
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }
}
