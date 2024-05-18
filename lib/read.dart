import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({Key? key}) : super(key: key);

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late Future<List> _futureData;

  @override
  void initState() {
    super.initState();

    _futureData = _fetchData();
  }

  Future<List> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://barnatoretkujdestar.org/read.php'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to load data: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.14,
          ),
          child: AppBar(
            flexibleSpace: const Stack(
              fit: StackFit.expand,
              children: [
                Image(
                  image: AssetImage('images/splash.png'),
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<List>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return DataCard(data: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final Map<String, dynamic>? data; // Make data nullable

  const DataCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if data is null before accessing its properties
    if (data == null) {
      return Container(); // Return an empty container or a loading indicator
    }

    // Access data safely using the null-aware operator (?.)
    final String name = data!['name'] ?? '';
    final String adresa = data!['adresa'] ?? '';
    final String telephone = data!['telephone'] ?? '';
    final String latitude = data!['latitude']?.toString() ?? '';
    final String longitude = data!['longitude']?.toString() ?? '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              "Barnatorja: $name",
              style: const TextStyle(fontSize: 20.0, color: Colors.green),
            ),
            Text(
              "Adresa: $adresa",
              style: const TextStyle(fontSize: 20.0, color: Colors.green),
            ),
            Text(
              "Nr. Tel: $telephone",
              style: const TextStyle(fontSize: 18.0, color: Colors.red),
            ),
            const SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              ),
              onPressed: () {
                _launchURL(
                  latitude,
                  longitude,
                );
              },
              child: const Text('Lokacioni'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchURL(
  String latitude,
  String longitude,
) async {
  final url =
      'https://www.google.com/maps?saddr=My+Location&daddr=$latitude,$longitude';
  await canLaunchUrlString(url)
      ? await launchUrlString(url)
      : throw 'Could not lanch $url';
}
