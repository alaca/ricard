import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:richard/models/list_play_item.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ringtone_set/ringtone_set.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  String currentlyPlaying = "";
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<ListPlayItem>> getPlayList() async {
    String json = await rootBundle.loadString('lib/config/playlist.json');
    final playList = jsonDecode( json )['playlist'] as List;
    List<ListPlayItem> items = playList.map( ( item ) => ListPlayItem.fromMap( item )).toList();

    return items;
  }

  Icon getPlayIcon(ListPlayItem item) {
    Color currentColor = (currentlyPlaying == item.sound)
        ? Colors.blueAccent
        : Colors.white70;

    return Icon(Icons.play_circle_fill_outlined, color: currentColor);
  }

  void playSound(ListPlayItem item) {
    setState(() {
      currentlyPlaying = item.sound;
    });

    audioPlayer.open(
        Audio("assets/sounds/${item.sound}")
    );

    audioPlayer.play();

    audioPlayer.playlistAudioFinished.listen((Playing playing){
      setState(() {
        currentlyPlaying = "";
      });
    });
  }

  void _launchURL(String url) async => await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Widget getDrawer(){
    return Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 120.0,
                child: DrawerHeader(
                  child: Text('KUD Bleke i Konji', style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(color: Colors.black87),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.all(15.0)
                ),
              ),
              ListTile(
                title: Text('Facebook', style: TextStyle(color: Colors.black)),
                onTap: () => _launchURL("https://www.facebook.com/Konji-nezavisna-lista-za-grad-Zadar-341440762643701/"),
              ),
              ListTile(
                title: Text('YouTube', style: TextStyle(color: Colors.black)),
                onTap: () => _launchURL("https://www.youtube.com/channel/UCjTHXMBBp87vwnTY9CPgfoA"),
              ),
              ListTile(
                title: Text('Instagram', style: TextStyle(color: Colors.black)),
                onTap: () => _launchURL("https://www.instagram.com/ricard_official9/"),
              ),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Ričard"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<ListPlayItem>>(
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      ListPlayItem item = snapshot.data![index];

                      return Container(
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: item.subtitle != ""
                              ? Text(item.subtitle)
                              : null,
                          leading: IconButton(
                            padding: EdgeInsets.all(0),
                            iconSize: 36,
                            icon: getPlayIcon(item),
                            onPressed: () => playSound(item),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed:  () => showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.share),
                                        title: Text("Podijeli"),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.music_note),
                                        title: Text('Postavi kao melodiju zvona'),
                                        onTap: () async {
                                          String result;
                                          try {
                                            result = await RingtoneSet.setRingtone("assets/sounds/${item.sound}");
                                          } on PlatformException {
                                            result = 'Error';
                                          }

                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(result))
                                          );

                                          //Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.notifications),
                                        title: Text('Postavi kao zvuk obavijesti'),
                                        onTap: () async {
                                          String result;
                                          try {
                                            result = await RingtoneSet.setNotification("assets/sounds/${item.sound}");
                                          } on PlatformException {
                                            result = 'Error';
                                          }

                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(result))
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }
                            ),
                          ),
                          onTap: () => playSound(item),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 0.1, color: Colors.white70 )
                          ),
                        ),
                      );
                    },
                  );
                },
                future: getPlayList(),
              ),
            ),
          ],
        ),
      ),
      drawer: getDrawer(),
    );
  }
}