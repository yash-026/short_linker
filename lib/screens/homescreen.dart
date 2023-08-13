// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:short_linker/screens/historyscreen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Short Linker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter URL here',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: 150.0,
                height: 50.0,
                child: ElevatedButton(
                    onPressed: () async{
                      final shortUrl = await shortenUrl(url: controller.text);
                        showDialog(
                            context: context,
                            builder: (context) {
                          return SizedBox(
                            height: 100.0,
                            child: AlertDialog(
                              title: const Text('Your URL shortened successfully!'),
                              content: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async{
                                      if(await canLaunchUrlString(shortUrl!)){
                                        await launchUrlString(shortUrl);
                                      }
                                      else{
                                        throw 'Could not launch $shortUrl';
                                      }
                                    },
                                    child: Text(
                                        shortUrl.toString(),
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline
                                      ),
                                    ),
                                  ),
                                  IconButton(onPressed: () {
                                    Clipboard.setData(ClipboardData(text: shortUrl.toString()))
                                        .then(
                                            (_) =>
                                                ScaffoldMessenger
                                                    .of(context)
                                                    .showSnackBar(
                                      const SnackBar(content: Text('Copied!')
                                      ))
                                    );
                                  }, icon: const Icon(Icons.copy)
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        );
                        controller.clear();
                        setUrlData(shortUrl, controller.text);
                    },
                    child: Text(
                        'Submit',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                ),
              ),
            ),
            SizedBox(
              width: 150.0,
              height: 50.0,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryScreen())
                    );
                  },
                  child: Text(
                    'History',
                  style: TextStyle(
                    fontSize:20.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),)
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> shortenUrl ({required url}) async {
    try{
      final result = await http.post(
        Uri.parse('https://cleanuri.com/api/v1/shorten'),
          body: {
            'url': url
          }
      );
      if(result.statusCode == 200){
        final jsonUri = jsonDecode(result.body);
        final urlString = Uri.encodeFull(jsonUri['result_url']);
        return urlString;
      }
    }
    catch(e){
      debugPrint('Error- ${e.toString()}');
    }
    return null;
  }

  Future<void> setUrlData(urlData, longUrlData) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('urlHistory', urlData);
    pref.setString('longUrlHistory', longUrlData);
  }
}
