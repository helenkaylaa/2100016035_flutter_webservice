import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/mobil.dart';

class MobilPage extends StatefulWidget {
  const MobilPage({Key? key}) : super(key: key);

  @override
  _MobilPageState createState() => _MobilPageState();
}

class _MobilPageState extends State<MobilPage> {
  Future<List<Mobil>> fetchMobil() async {
    var url = Uri.parse('https://example.com/api/mobil');
    var response = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/json",
    });

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Mobil> listMobil = [];
    for (var d in data) {
      if (d != null) {
        listMobil.add(Mobil.fromJson(d));
      }
    }

    return listMobil;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobil List'),
      ),
      body: FutureBuilder(
        future: fetchMobil(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return Column(
                children: const [
                  Text(
                    "Tidak ada data mobil :(",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, blurRadius: 2.0)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${snapshot.data![index].model}",
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("Brand: ${snapshot.data![index].brand}"),
                      Text("Color: ${snapshot.data![index].color}"),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
