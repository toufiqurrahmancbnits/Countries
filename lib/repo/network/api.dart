import 'dart:convert';

import 'package:ezcountries/repo/model/country_model.dart';
import 'package:ezcountries/repo/network/queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Api {
  final HttpLink httpLink = HttpLink(
    'https://countries.trevorblades.com/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () => "",
  );
  late Link link;
  late GraphQLClient client;
  Country? countries;
  Queries queries = Queries();

  Api() {
    link = authLink.concat(httpLink);
    client = GraphQLClient(link: link, cache: GraphQLCache());
  }
  //---- fetch api for fetching the country-----------//
  Future fetchCountry() async {
    final String query = queries.countryQuery();
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
      ),
    );

    return json.encode(result.data);
  }
  //------------- fetch api for fetching the language--------------//
  Future fetchLanguages() async {
    final String query = queries.languageQuery();
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    return json.encode(result.data!['languages']);
  }
  //-----------fetch api for fetching the country by code------------//
  Future fetchCountryByCode(context, {String? code}) async {
    final String query = queries.searchCountryByCodeQuery(code: code);
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    if (result.hasException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Country Code Not Found"),
        backgroundColor: Colors.red,
      ));
      return null;
    }
    return json.encode(result.data);
  }
}
