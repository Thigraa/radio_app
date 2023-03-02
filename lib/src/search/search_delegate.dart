import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/src/models/radio_response.dart';
import 'package:radio_app/src/providers/radio_provider.dart';
import 'package:radio_app/src/widgets/radio_item.dart';

class RadioSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Search radio station';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  Widget _emptyContainer() {
    return Container(
      color: Color(0xff2C302E),
      child: Center(
        child: Icon(
          Icons.radio,
          color: Colors.white,
          size: 130,
        ),
      ),
    );
  }

  Widget _noDataContainer() {
    return Container(
      color: Color(0xff2C302E),
      child: Center(
        child: Text(
          "We couldn't find radio stations with this name :( ",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontFamily: 'Baloo2', fontSize: 25),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) () => _emptyContainer();

    final radioProvider = Provider.of<RadioProvider>(context, listen: false);

    radioProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: radioProvider.suggestionStream,
      builder: (context, AsyncSnapshot<List<Station>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _noDataContainer();
        final stations = snapshot.data!;
        return Container(
          color: Color(0xff2C302E),
          child: ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              stations[index].heroId = 'search-${stations[index].radioId}';
              return RadioItem(
                radioStation: stations[index],
              );
            },
          ),
        );
      },
    );
  }
}
