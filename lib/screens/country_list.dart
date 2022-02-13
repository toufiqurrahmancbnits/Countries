import 'package:ezcountries/repo/provider/country_provider.dart';
import 'package:ezcountries/screens/search_country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryList extends StatefulWidget {
  CountryList({Key? key}) : super(key: key);

  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  late CountryProvider provider;
  

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await provider.getCountryName();
      await provider.getLanguages();
    });
  }

  @override
  void dispose() {
    provider.countries!.clear();
    provider.languages.clear();
    provider.filterCountries.clear();

    super.dispose();
  }
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CountryProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: builddrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
          onPressed: (){
            Route route = MaterialPageRoute(builder: (_) => SearchCountry());
              Navigator.push(context, route);
          },
      ),
      appBar: AppBar(
        title: Text("eZCountries"),
        actions: [
          provider.filterCountries.isEmpty
              ? TextButton(
                  onPressed: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Text("Filter"),
                )
              : TextButton(
                  onPressed: () {
                    provider.filterCountries.clear();
                    provider.notifylistener();
                  },
                  child: Text("Close"),
                ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: provider.countries!.isEmpty
                ? Center(child: CupertinoActivityIndicator())
                : provider.filterCountries.isEmpty
                    ? _buildList()
                    : _buildFilterList(),
          ),
        ],
      ),
    );
  }
  //-------------------Countries List shown on UI-----------------------//
  Widget _buildList() {
    return ListView.separated(
        itemCount: provider.countries!.length,
        separatorBuilder: (context, index) => Divider(color: Colors.white,),
        itemBuilder: (context, index) {
          final countryName = provider.countries![index].name!;
          return ListTile(
            leading: Icon(CupertinoIcons.globe),
            title: Text(countryName),
          );
        });
  }
  //------------------------Filtered List shown on UI-----------------------//
  Widget _buildFilterList() {
    return ListView.separated(
        itemCount: provider.filterCountries.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final countryName = provider.filterCountries[index].name!;
          final countryLanguage = provider.filterCountries[index].languages!;
          return ListTile(
            leading: Icon(CupertinoIcons.globe),
            title: Text(countryName),
            trailing: countryLanguage.isNotEmpty
                ? Text(countryLanguage[0].name!)
                : Text(""),
          );
        });
  }

  //------------------------customise endDrawer for showing Fliter---------------//
  Drawer builddrawer(){
    return Drawer(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            padding:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Filter By Language",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: provider.languages.length,
                      itemBuilder: (context, index) {
                        final name = provider.languages[index].name!;
                        return ListTile(
                          onTap: () async {
                            await provider.filter(name,provider);
                            provider.notifylistener();
                            Navigator.of(context).pop();
                          },
                          title: Text(name),
                        );
                      }),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
