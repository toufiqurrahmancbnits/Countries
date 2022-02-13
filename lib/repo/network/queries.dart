class Queries{

  //----------Query For Country----------//
  String countryQuery(){
    return  '''
    query {
      countries {
        name
        languages {
          code
          name
        }
      }
    }
  ''';
  }
  //------------Query for language----------//
  String languageQuery(){
    return '''
    query Query {
      languages {
        name
        code
      }
    }
  ''';
  }
 //------------------search query for searching the country by code----------------//
  String searchCountryByCodeQuery({String? code}){
    return '''
    query Query {
      country(code: "$code") {
      name
      }
    }
  ''';
  }
}