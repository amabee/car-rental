import 'package:flutter/material.dart';
import 'package:rental/addcars.dart';
import 'package:rental/contact.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;

import 'package:rental/widgets.dart';

class Homepage extends StatefulWidget {
  final String accountId;
  final String userFullname;

  Homepage({
    required this.accountId,
    required this.userFullname,
  });

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Contact> _contactsList = [];
  List<Map<String, dynamic>> _imageList = [];
  TextEditingController _searchController = new TextEditingController();

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
        backgroundColor: Colors.blue[200],
        title: Text('Anster Autoworks'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Addcars(
                      accountId: widget.accountId,
                      userFullname: widget.userFullname),
                ),
              );
            },
            icon: Icon(Icons.car_rental),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'My List of Rental Cars ',
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
                        return Card(
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
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  _contactsList[index]
                                                      .description!,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
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
                            subtitle:
                                Text("${_contactsList[index].price} per day"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    selectCarImage(_contactsList[index].id!);
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showUpdateForm(index);
                                  },
                                  icon: const Icon(Icons.edit_note),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDeleteForm(index);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                IconButton(
                                  onPressed: () {
                                    selectImage(_contactsList[index].id!);
                                  },
                                  icon: const Icon(Icons.image_search),
                                ),
                              ],
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

    final Map<String, dynamic> json;
    if (search) {
      json = {
        "searchKey": _searchController.text,
        "accountId": widget.accountId
      };
    } else {
      int accountIdInt = int.parse(widget.accountId);

      json = Contact.jsonData(
        accountId: accountIdInt,
      ).toJson();
    }

    // var json = Contact.jsonData(
    //   userId: widget.userId,
    //   groupId: selectedGroupId,
    // ).toJson();

    var operation = search ? "search" : "getContact";

    final Map<String, dynamic> queryParams = {
      "operation": operation,
      "json": jsonEncode(json),
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

  void showUpdateForm(int index) {
    final formKey = GlobalKey<FormState>();
    String model = _contactsList[index].model!;
    String description = _contactsList[index].description!;
    String price = _contactsList[index].price!;
    int id = _contactsList[index].id!;
    int accountId = _contactsList[index].accountId!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text("Update Form"),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Model"),
                  initialValue: model,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter model";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    model = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  initialValue: description,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter description";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Price"),
                  initialValue: price,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    price = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Contact contact = Contact(
                    id: id,
                    accountId: accountId,
                    model: model,
                    description: description,
                    price: price,
                  );

                  if (await update(contact) == 1) {
                    Navigator.pop(context);
                    _contactsList = await getContacts();
                    setState(() {});
                    showMessageBox(context, "Success!", "Update Successfully!");
                  } else {
                    showMessageBox(context, "Failed!", "Update Failed!");
                  }
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<int> update(Contact contact) async {
    Uri url = Uri.parse('http://localhost/rental/lib/api/contacts.php');

    Map<String, dynamic> jsonData = contact.toJson2();

    Map<String, dynamic> data = {
      "operation": "update",
      "json": jsonEncode(jsonData),
    };

    http.Response response = await http.post(url, body: data);

    return int.parse(response.body);
  }

  void showDeleteForm(int index) {
    int id = _contactsList[index].id!;
    showDialog(
      context: context,
      barrierDismissible: false,
      // barrierColor: Colors.red,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text("Delete"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Are you sure you want to delete ${_contactsList[index].model}?")
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (await delete(id) == 1) {
                  Navigator.pop(context);
                  _contactsList = await getContacts();
                  setState(() {});
                  showMessageBox(context, "Success!", "Delete Successfully!");
                } else {
                  showMessageBox(context, "Failed!", "Delete Failed!");
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<int> delete(int contactId) async {
    Uri url = Uri.parse('http://localhost/rental/lib/api/contacts.php');

    Map<String, dynamic> jsonData = {"id": contactId};

    Map<String, dynamic> data = {
      "operation": "delete",
      "json": jsonEncode(jsonData),
    };

    http.Response response = await http.post(url, body: data);

    return int.parse(response.body);
  }

  Future<void> selectImage(int carId) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      final PlatformFile file = result.files.first;
      uploadImage(file, carId);
    }
    print(carId);
  }

  void uploadImage(PlatformFile file, int carId) {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(html.Blob([file.bytes]));

    reader.onLoadEnd.listen((e) async {
      if (reader.readyState == html.FileReader.DONE) {
        final imageData = base64Encode(reader.result as List<int>);

        Map<String, dynamic> jsonData = {
          "carId": carId,
          "file": imageData,
        };
        Map<String, dynamic> json = {
          "operation": "uploadImage",
          "json": jsonEncode(jsonData),
        };

        var response = await http.post(
          Uri.parse('http://localhost/rental/lib/api/contacts.php'),
          body: json,
        );
        if (response.statusCode == 200) {
          // _contactsList = await getContacts(search: false);
          // setState(() {});
          showMessageBox(context, "Success", response.body);
        } else {
          showMessageBox(context, "Failed", response.body);
        }
      }
    });
  }

  Future<void> selectCarImage(int carId) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      final PlatformFile file = result.files.first;
      uploadCarImage(file, carId);
    }
    print(carId);
  }

  void uploadCarImage(PlatformFile file, int carId) {
    print("my carId ${carId}");
    final reader = html.FileReader();
    reader.readAsArrayBuffer(html.Blob([file.bytes]));

    reader.onLoadEnd.listen((e) async {
      if (reader.readyState == html.FileReader.DONE) {
        final imageData = base64Encode(reader.result as List<int>);

        Map<String, dynamic> jsonData = {
          "carId": carId,
          "files": imageData,
        };
        Map<String, dynamic> json = {
          "operation": "uploadCarImage",
          "json": jsonEncode(jsonData),
        };

        var response = await http.post(
          Uri.parse('http://localhost/rental/lib/api/contacts.php'),
          body: json,
        );
        if (response.statusCode == 200) {
          // _contactsList = await getContacts(search: false);
          // setState(() {});

          showMessageBox(context, "Success", response.body);
        } else {
          showMessageBox(context, "Failed", response.body);
        }
      }
    });
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

  // void ShowPic(String title) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return FutureBuilder(
  //           future: getImages(carsId),
  //           builder: (context, snapShot) {
  //             switch (snapShot.connectionState) {
  //               case ConnectionState.waiting:
  //                 return const Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     CircularProgressIndicator(),
  //                     SizedBox(
  //                       height: 15,
  //                     ),
  //                     Text("Loading......."),
  //                   ],
  //                 );
  //               case ConnectionState.done:
  //                 if (snapShot.hasError) {
  //                   print(snapShot.hasError);
  //                   return Text("Errors : ${snapShot.error}");
  //                 }
  //                 return Expanded(
  //                   child: createListMaps(),
  //                 );

  //               default:
  //                 return Text("Error : ${snapShot.error}");
  //             }
  //           },
  //         );
  //       });
  // }
}
