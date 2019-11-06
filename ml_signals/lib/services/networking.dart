import 'dart:convert';
import 'package:http/http.dart' as http;


class NetworkHelper{
  NetworkHelper(this.url, this.method, {this.headers, this.body});

  final String url;
  final String method; 
  final Map<String, String> headers;
  final String body;
  http.Response response;
  Future getData() async {
    if (method.toLowerCase().compareTo("post") == 0){
      response = await http.post(url, headers: headers, body: body);
    }
    else {
      response = await http.get(url);
    }
    if (response.statusCode == 200){
      String data = response.body;
      return jsonDecode(data);
    }
    else{
      print(response.statusCode);
    }
  }
}