import 'dart:convert';
import 'dart:developer';

import 'package:ezcountries/repo/model/country_model.dart';
import 'package:ezcountries/repo/network/api.dart';
import 'package:flutter/material.dart';

class CountryProvider extends ChangeNotifier {
  Api _api = Api();
  List<CountryElement>? _countries = [];
  List<Language> _languages = [];
  CountryElement? _country;
  List<CountryElement> filterCountries = [];
  List<CountryElement>? get countries => _countries;

  List<Language> get languages => _languages;

  CountryElement? get country => _country;

  Future notifylistener() async {
    notifyListeners();
  }
  //---------------------- for getting the countries-------------------//
  Future getCountryName() async {
    final result = await _api.fetchCountry();
    final decode = jsonDecode(result);
    final parse = Data.fromJson(decode);
    _countries = parse.countries;
    _countries!.sort((a, b) => a.name!.compareTo(b.name!));

    notifyListeners();
  }
  //----------------------for getting the languages ------------------//
  Future getLanguages() async {
    final result = await _api.fetchLanguages();
    final decode = jsonDecode(result);
    for (var l in decode) {
      languages.add(Language.fromJson(l));
    }
    notifyListeners();
  }
  //--------------------for searching the searching the country by code -------------------//
  Future getCountryNameByCode(context, {String? code}) async {
    final result = await _api.fetchCountryByCode(context, code: code);
    if (result != null) {
      final decode = jsonDecode(result);
      if (decode['country'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Country Code doesn't exists",
          style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.white),),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
        return;
      }
      final parse = CountryElement.fromJson(decode['country']);
      log('parse :- $parse');
      _country = parse;

      notifyListeners();
      return parse.name;
    }
  }
  //------------for getting the filtered list of countries by language--------------------//
  Future filter(languageName,provider) async {
    List<CountryElement> _tempCountries = [];
    _tempCountries.addAll(provider.countries!);
    for (var v in _tempCountries) {
      for (var l in v.languages!) {
        if (l.name!.toLowerCase().contains(languageName.toLowerCase())) {
          filterCountries.add(v);
          notifyListeners();
        }
      }
    }
  }
}
