import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:eliteemanager/extras/strings.dart';

class ApiCall {
  String handleRequestError(e) {
    if (e is TimeoutException) {
      e = Strings.requestTimeOutMsg;
    } else {
      e = Strings.connectionErrorMsg;
    }
    return e;
  }

  Future<dynamic> loginAdmin(String email, String password) async {
    var body = {
      "email": email,
      "password": password,
    };

    try {
      http.Response response = await http.post(
          '${Strings.base_url}/${Strings.release_version}/admin/auth/signin',
          body: body);
      var decoded = await jsonDecode(response.body);

      if (decoded != null) {
        if (response.statusCode < 300) {
          Map<String, dynamic> loginResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
                "data": decoded['data']
              };
          return loginResponse();
        } else {
          Map<String, dynamic> loginResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
              };
          return loginResponse();
        }
      } else {
        Map<String, dynamic> loginResponse() => {
              "statusCode": response.statusCode,
              "status": 'Failed at Call',
              "message": 'No response gotten',
            };
        return loginResponse();
      }
    } catch (e) {
      handleRequestError(e);
    }
  }

  Future<dynamic> getCategories() async {
    try {
      http.Response response = await http
          .get('${Strings.base_url}/${Strings.release_version}/category');

      var decoded = jsonDecode(response.body);

      if (decoded != null) {
        if (response.statusCode < 300) {
          Map<String, dynamic> getResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "data": decoded['data'],
                "message": decoded['message']
              };
          return getResponse();
        } else {
          Map<String, dynamic> getResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message']
              };
          return getResponse();
        }
      } else {
        Map<String, dynamic> getResponse() => {
              "statusCode": response.statusCode,
              "status": "Failed at call",
              "message": 'No response gotten',
            };
        return getResponse();
      }
    } catch (e) {
      handleRequestError(e);
    }
  }

  Future<dynamic> getSubCategories(String id) async {
    try {
      http.Response response = await http.get(
          '${Strings.base_url}/${Strings.release_version}/sub-category/category/$id');

      var decoded = jsonDecode(response.body);

      if (decoded != null) {
        if (response.statusCode < 300) {
          Map<String, dynamic> getResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "data": decoded['data'],
                "message": decoded['message']
              };
          return getResponse();
        } else {
          Map<String, dynamic> getResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message']
              };
          return getResponse();
        }
      } else {
        Map<String, dynamic> getResponse() => {
              "statusCode": response.statusCode,
              "status": "Failed at call",
              "message": 'No response gotten',
            };
        return getResponse();
      }
    } catch (e) {
      handleRequestError(e);
    }
  }

  Future<dynamic> addCategory(String categoryName, String token) async {
    var body = {"category_name": categoryName};
    var header = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    try {
      http.Response response = await http.post(
        '${Strings.base_url}/${Strings.release_version}/category',
        body: body,
        headers: header,
      );

      var decoded = jsonDecode(response.body);

      if (decoded != null) {
        if (response.statusCode < 300) {
          Map<String, dynamic> postResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
                "data": decoded['data']
              };
          return postResponse();
        } else {
          Map<String, dynamic> postResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
              };
          return postResponse();
        }
      } else {
        Map<String, dynamic> postResponse() => {
              "statusCode": response.statusCode,
              "status": "Failed at call",
              "message": 'No response gotten',
            };
        return postResponse();
      }
    } catch (e) {
      handleRequestError(e);
    }
  }

  Future<dynamic> delCategory(int id, String token) async {
    var header = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    try {
      http.Response response = await http.delete(
        '${Strings.base_url}/${Strings.release_version}/category/$id',
        headers: header,
      );

      var decoded = jsonDecode(response.body);

      if (decoded != null) {
        if (response.statusCode < 300) {
          Map<String, dynamic> delResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
              };
          return delResponse();
        } else {
          Map<String, dynamic> delResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
              };
          return delResponse();
        }
      } else {
        Map<String, dynamic> delResponse() => {
              "statusCode": response.statusCode,
              "status": "Failed at call",
              "message": 'No response gotten',
            };
        return delResponse();
      }
    } catch (e) {
      handleRequestError(e);
    }
  }

  Future<dynamic> getProducts(String id, String token) async {
    var header = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    try {
      http.Response response = await http.get(
        '${Strings.base_url}/${Strings.release_version}/product/sub-category/$id',
        headers: header,
      );
      print('The response code is ${response.statusCode}');
      var decoded = jsonDecode(response.body);

      if (decoded != null) {
        if (response.statusCode < 300) {
          Map<String, dynamic> postResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
                "data": decoded['data']
              };
          return postResponse();
        } else {
          Map<String, dynamic> postResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
              };
          return postResponse();
        }
      } else {
        Map<String, dynamic> postResponse() => {
              "statusCode": response.statusCode,
              "status": "Failed at call",
              "message": 'No response gotten',
            };
        return postResponse();
      }
    } catch (e) {
      handleRequestError(e);
    }
  }

  Future<dynamic> addSubCategory(
    String id,
    String subCategoryName,
    String token,
  ) async {
    var body = {
      "category_id": id,
      "sub_category_name": subCategoryName,
    };
    var header = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    try {
      http.Response response = await http.post(
        '${Strings.base_url}/${Strings.release_version}/sub-category',
        body: body,
        headers: header,
      );

      var decoded = jsonDecode(response.body);

      if (decoded != null) {
        if (response.statusCode < 300) {
          Map<String, dynamic> postResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
                "data": decoded['data']
              };
          return postResponse();
        } else {
          Map<String, dynamic> postResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
              };
          return postResponse();
        }
      } else {
        Map<String, dynamic> postResponse() => {
              "statusCode": response.statusCode,
              "status": "Failed at call",
              "message": 'No response gotten',
            };
        return postResponse();
      }
    } catch (e) {
      handleRequestError(e);
    }
  }

  Future<dynamic> addProducts(body, String token) async {
    var header = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    try {
      http.Response response = await http.post(
        '${Strings.base_url}/${Strings.release_version}/product',
        headers: header,
        body: body,
      );
      print(response);

      var decoded = jsonDecode(response.body);

      print("apicall: decoded");

      if (decoded != null) {
        if (response.statusCode < 300) {
          Map<String, dynamic> postResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
                "data": decoded['data']
              };
          return postResponse();
        } else {
          Map<String, dynamic> postResponse() => {
                "statusCode": response.statusCode,
                "status": decoded['status'],
                "message": decoded['message'],
              };
          return postResponse();
        }
      } else {
        Map<String, dynamic> postResponse() => {
              "statusCode": response.statusCode,
              "status": "Failed at call",
              "message": 'No response gotten',
            };
        return postResponse();
      }
    } catch (e) {
      handleRequestError(e);
    }
  }
}
