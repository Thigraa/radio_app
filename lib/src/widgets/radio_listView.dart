import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/src/providers/radio_provider.dart';
import 'package:radio_app/src/widgets/radio_item.dart';

import '../models/radio_response.dart';

class RadioListView extends StatefulWidget {
  final title;
  final List<Station> stations;
  final Function onNextPage;

  const RadioListView({Key? key, this.title, required this.stations, required this.onNextPage}) : super(key: key);

  @override
  State<RadioListView> createState() => _RadioListViewState();
}

class _RadioListViewState extends State<RadioListView> {
  final ScrollController scrollController = ScrollController();
  bool _fetching = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500) {
        if (!_fetching) {
          _fetching = true;
          widget.onNextPage();
        }
      } else {
        _fetching = false;
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stations.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 250,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xffB7B0E8),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                itemCount: widget.stations.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, int index) {
                  widget.stations[index].heroId = '${widget.title}-${index}-${widget.stations[index].radioId}';
                  return RadioItem(
                    radioStation: widget.stations[index],
                  );
                }),
          )
        ],
      ),
    );
  }
}
