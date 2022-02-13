import 'package:ezcountries/repo/provider/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchCountry extends StatefulWidget {
  const SearchCountry({Key? key}) : super(key: key);

  @override
  _SearchCountryState createState() => _SearchCountryState();
}

class _SearchCountryState extends State<SearchCountry> {
  TextEditingController _controller = TextEditingController();
  String? name;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CountryProvider provider = Provider.of<CountryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: 'Enter code ....',
              ),
            ),
            SizedBox(
              height: 20,
            ),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(name ?? "Please enter the country code to search"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                color: Colors.white,
                minWidth: double.infinity,
                height: 50,
                onPressed: () async {
                  name = await (provider.getCountryNameByCode(context,
                      code: _controller.text.trim().toUpperCase()));
                  _controller.clear();
                },
                child: Text(
                  'Continue', 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
