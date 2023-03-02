import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/radio_response.dart';
import '../providers/radio_provider.dart';

class RadioItem extends StatelessWidget {
  final Station radioStation;

  const RadioItem({
    Key? key,
    required this.radioStation,
  });

  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context);
    return FadeInLeft(
      duration: Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () {
          radioProvider.selectedStation = radioStation;
          Navigator.pushNamed(context, 'player');
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 60, 65, 62),
            borderRadius: BorderRadius.circular(15),
            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black38, blurRadius: 5, offset: Offset(0, 3))],
          ),
          child: Row(
            children: [
              _Image(radioStation: radioStation),
              const SizedBox(
                width: 10,
              ),
              _TitleAndGenre(radioStation: radioStation),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleAndGenre extends StatelessWidget {
  const _TitleAndGenre({
    Key? key,
    required this.radioStation,
  }) : super(key: key);

  final Station radioStation;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            radioStation.radioName,
            style: TextStyle(color: Colors.white, fontFamily: 'Baloo2', fontSize: 20),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
          Text(
            radioStation.genre,
            style: TextStyle(color: Colors.white70, fontFamily: 'Baloo2', fontSize: 15),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
    required this.radioStation,
  }) : super(key: key);

  final Station radioStation;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CachedNetworkImage(
        height: 80,
        width: 80,
        placeholder: (context, url) => Container(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            color: Color(0xffB7B0E8),
          ),
        ),
        errorWidget: (context, url, error) => new Icon(Icons.image_not_supported_outlined, color: Color(0xffB7B0E8)),
        imageUrl: radioStation.radioImage,
        fit: BoxFit.cover,
      ),
    );
  }
}
