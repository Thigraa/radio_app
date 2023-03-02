import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:radio_app/src/search/search_delegate.dart';
import 'package:radio_app/src/models/radio_response.dart';
import 'package:radio_app/src/providers/radio_provider.dart';
import 'package:radio_app/src/widgets/header.dart';
import 'package:radio_app/src/widgets/radio_listView.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final radioStation = radioProvider.selectedStation;
    return Scaffold(
      backgroundColor: Color(0xff2C302E),
      body: Stack(
        children: [
          Stack(
            children: [
              _HomeScreenHeader(),
              Container(
                padding: EdgeInsets.only(top: 200),
                child: RadioListView(
                  title: 'Emisoras nacionales',
                  stations: radioProvider.radioStations,
                  onNextPage: radioProvider.getStations,
                ),
              ),
            ],
          ),
          radioProvider.isPlaying ? _NowPlayingSnack(screenSize: screenSize, radioStation: radioStation) : Container()
        ],
      ),
    );
  }
}

class _HomeScreenHeader extends StatelessWidget {
  const _HomeScreenHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HeaderOla(),
        Positioned(
          left: 40,
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    'radio app',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 35,
                      fontFamily: 'Baloo2',
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => showSearch(context: context, delegate: RadioSearchDelegate()),
                    icon: const Icon(
                      Icons.search_outlined,
                      size: 30,
                      color: Colors.black87,
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _NowPlayingSnack extends StatelessWidget {
  const _NowPlayingSnack({
    Key? key,
    required this.screenSize,
    required this.radioStation,
  }) : super(key: key);

  final Size screenSize;
  final Station radioStation;

  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FadeInUp(
          child: Container(
            height: 50,
            width: screenSize.width,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xff2C302E),
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[BoxShadow(color: Colors.black54, blurRadius: 5, spreadRadius: 1)],
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'player');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Hero(
                    tag: radioStation.heroId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FadeInImage(
                        height: 40,
                        width: 40,
                        placeholder: const AssetImage('assets/icon-no-image.png'),
                        image: NetworkImage(radioStation.radioImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      width: screenSize.width * 0.65,
                      child: Text(
                        radioStation.radioName,
                        style: TextStyle(color: Colors.white, fontFamily: 'Baloo2', fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          radioProvider.radioPlayer.stop();
                          radioProvider.isPlaying = false;
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                        ),
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
