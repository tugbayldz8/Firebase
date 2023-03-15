import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController nameCont = TextEditingController();
  TextEditingController ratingCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference moviesRef = _firestore.collection('movies');
    var babaRef = _firestore.collection('movies').doc('Baba');
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Firestore CRUD İşlemleri'),
      ),
      // resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          child: Column(
            children: [
              /* ElevatedButton(
                onPressed: () async {
                  var response = await babaRef.get();
                  //veriyi snapshottan çıkarmamız gerek
                  var veri = response.data();
                  print(veri!['name']);
                },
                child: Text('get data'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var response = await moviesRef.get();
                  //veriyi snapshottan çıkarmamız gerek
                  var list = response.docs;
                  print(list[2].data());
                },
                child: Text('get querysnapshot'),
              ),*/
              /*StreamBuilder<DocumentSnapshot>(
                //neyi dinlediğimiz bilgisi, hangi streami
                stream: babaRef.snapshots(),
                //streamden her yeni veri aktığında aşağıdaki metodu çalıştır
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  return Text('${asyncSnapshot.data.data()}');
                },
              ),*/
              StreamBuilder<QuerySnapshot>(
                //neyi dinlediğimiz bilgisi, hangi streami
                stream: moviesRef.snapshots(),
                //streamden her yeni veri aktığında aşağıdaki metodu çalıştır
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Center(child: Text('Bir hata oluştu'));
                  } else {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> listOfDocSnap =
                          asyncSnapshot.data.docs;
                      return Flexible(
                        child: ListView.builder(
                            itemCount: listOfDocSnap.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.amberAccent,
                                child: ListTile(
                                  title: Text(
                                    '${listOfDocSnap[index]['name']}',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  subtitle: Text(
                                    '${listOfDocSnap[index]['rating']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        await listOfDocSnap[index]
                                            .reference
                                            .delete();
                                      },
                                      icon: Icon(Icons.delete)),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 100),
                child: Form(
                    child: Column(
                  children: [
                    TextField(
                      controller: nameCont,
                      decoration:
                          InputDecoration(hintText: 'Film adını giriniz'),
                    ),
                    TextField(
                      controller: ratingCont,
                      decoration: InputDecoration(hintText: 'Rating giriniz'),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Text('Ekle'),
          onPressed: () async {
            print(nameCont.text);
            print(ratingCont.text);
            // Text alanındaki veriden bir map oluşturualcak(firesbaseden map şeklinde geliyodu burdan da öyle gitmeli.
            Map<String, dynamic> movieData = {
              'name': nameCont.text,
              'rating': ratingCont.text
            };
            //Veriyi yazmak istediğimiz refereansa ulaşcağız ve ilgili metodu çağıracağız.
            await moviesRef.doc(nameCont.text).set(movieData);
          }),
    );
  }
}
