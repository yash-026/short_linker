import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, String> urlHistoryMap = {};

  @override
  void initState() {
    super.initState();
    fetchUrlData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('History'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: urlHistoryMap.length,
        itemBuilder: (context, index) {
          final longUrl = urlHistoryMap.keys.elementAt(index);
          final shortUrl = urlHistoryMap[longUrl];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).colorScheme.primary
            ),
            child: ListTile(
              title: Text(longUrl),
              subtitle : Row(
                children: [
                  Expanded(
                    flex: 9,
                      child: Text(shortUrl!)
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: shortUrl.toString()))
                              .then(
                                  (_) =>
                                  ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(
                                      const SnackBar(content: Text('Copied!')))
                          );
                        },
                        icon: const Icon(Icons.copy)
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void fetchUrlData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final urlHistory = pref.getString('urlHistory');
    final longUrlHistory = pref.getString('longUrlHistory');

    if (urlHistory != null && longUrlHistory != null) {
      for (int i = 0; i < urlHistory.length; i++) {
        final shortUrl = urlHistory[i];
        final longUrl = longUrlHistory[i];
        urlHistoryMap[longUrl] = shortUrl;
      }
    }
    setState(() {});
  }
}

