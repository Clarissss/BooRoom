// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DataService {
  Future insertUser(String appid, String name, String role, String email,
      String password, String user_img) async {
    String uri = 'https://io.etter.cloud/v4/insert';

    try {
      final response = await http.post(Uri.parse(uri), body: {
        'token': '675bbd40f853312de55091c5',
        'project': 'uas',
        'collection': 'user',
        'appid': appid,
        'name': name,
        'role': role,
        'email': email,
        'password': password,
        'user_img': user_img
      });

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future insertRoom(
      String appid, String name, String capacity, String room_img) async {
    String uri = 'https://io.etter.cloud/v4/insert';

    try {
      final response = await http.post(Uri.parse(uri), body: {
        'token': '675bbd40f853312de55091c5',
        'project': 'uas',
        'collection': 'room',
        'appid': appid,
        'name': name,
        'capacity': capacity,
        'room_img': room_img
      });

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future insertBooking(String appid, String date, String start_time, String end_time, String status, String desc, String user, String room, String stat1, String stat2, String stat3) async {
      String uri = 'https://io.etter.cloud/v4/insert';

      try {
         final response = await http.post(Uri.parse(uri), body: {
            'token': '675bbd40f853312de55091c5',
            'project': 'uas',
            'collection': 'booking',
            'appid': appid,
            'date': date,
            'start_time': start_time,
            'end_time': end_time,
            'status': status,
            'desc': desc,
            'user': user,
            'room': room,
            'stat1': stat1,
            'stat2': stat2,
            'stat3': stat3
         });
         if (response.statusCode == 200) {
            return response.body;
         } else {
            // Return an empty array
            return '[]';
         }
      } catch (e) {
         // Print error here
         return '[]';
      }
   }

  Future insertPendingBooking(
      String appid,
      String date,
      String start_time,
      String end_time,
      String status,
      String desc,
      String room,
      String capacity,
      String user) async {
    String uri = 'https://io.etter.cloud/v4/insert';

    try {
      final response = await http.post(Uri.parse(uri), body: {
        'token': '675bbd40f853312de55091c5',
        'project': 'uas',
        'collection': 'pending_booking',
        'appid': appid,
        'date': date,
        'start_time': start_time,
        'end_time': end_time,
        'status': status,
        'desc': desc,
        'room': room,
        'capacity': capacity,
        'user': user
      });

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future insertPendingBookingBku(
      String appid,
      String date,
      String start_time,
      String end_time,
      String status,
      String desc,
      String room,
      String capacity,
      String user) async {
    String uri = 'https://io.etter.cloud/v4/insert';

    try {
      final response = await http.post(Uri.parse(uri), body: {
        'token': '675bbd40f853312de55091c5',
        'project': 'uas',
        'collection': 'pending_booking_bku',
        'appid': appid,
        'date': date,
        'start_time': start_time,
        'end_time': end_time,
        'status': status,
        'desc': desc,
        'room': room,
        'capacity': capacity,
        'user': user
      });

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future insertPendingBookingProdi(
      String appid,
      String date,
      String start_time,
      String end_time,
      String status,
      String desc,
      String room,
      String capacity,
      String user) async {
    String uri = 'https://io.etter.cloud/v4/insert';

    try {
      final response = await http.post(Uri.parse(uri), body: {
        'token': '675bbd40f853312de55091c5',
        'project': 'uas',
        'collection': 'pending_booking_prodi',
        'appid': appid,
        'date': date,
        'start_time': start_time,
        'end_time': end_time,
        'status': status,
        'desc': desc,
        'room': room,
        'capacity': capacity,
        'user': user
      });

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future insertPendingBookingFakultas(
      String appid,
      String date,
      String start_time,
      String end_time,
      String status,
      String desc,
      String room,
      String capacity,
      String user) async {
    String uri = 'https://io.etter.cloud/v4/insert';

    try {
      final response = await http.post(Uri.parse(uri), body: {
        'token': '675bbd40f853312de55091c5',
        'project': 'uas',
        'collection': 'pending_booking_fakultas',
        'appid': appid,
        'date': date,
        'start_time': start_time,
        'end_time': end_time,
        'status': status,
        'desc': desc,
        'room': room,
        'capacity': capacity,
        'user': user
      });

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future insertNotifikasi(String appid, String user, String reason , String title) async {
      String uri = 'https://io.etter.cloud/v4/insert';

      try {
         final response = await http.post(Uri.parse(uri), body: {
            'token': '675bbd40f853312de55091c5',
            'project': 'uas',
            'collection': 'notifikasi',
            'appid': appid,
            'user': user,
            'reason': reason,
            'title' : title
         });

         if (response.statusCode == 200) {
            return response.body;
         } else {
            // Return an empty array
            return '[]';
         }
      } catch (e) {
         // Print error here
         return '[]';
      }
   }

  Future selectAll(
      String token, String project, String collection, String appid) async {
    String uri = 'https://io.etter.cloud/v4/select_all/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectId(String token, String project, String collection, String appid,
      String id) async {
    String uri = 'https://io.etter.cloud/v4/select_id/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/id/' +
        id;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectWhere(String token, String project, String collection,
      String appid, String where_field, String where_value) async {
    String uri = 'https://io.etter.cloud/v4/select_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/where_field/' +
        where_field +
        '/where_value/' +
        where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectOrWhere(String token, String project, String collection,
      String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://io.etter.cloud/v4/select_or_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/or_where_field/' +
        or_where_field +
        '/or_where_value/' +
        or_where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectWhereLike(String token, String project, String collection,
      String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://io.etter.cloud/v4/select_where_like/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wlike_field/' +
        wlike_field +
        '/wlike_value/' +
        wlike_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectWhereIn(String token, String project, String collection,
      String appid, String win_field, String win_value) async {
    String uri = 'https://io.etter.cloud/v4/select_where_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/win_field/' +
        win_field +
        '/win_value/' +
        win_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectWhereNotIn(String token, String project, String collection,
      String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://io.etter.cloud/v4/select_where_not_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wnotin_field/' +
        wnotin_field +
        '/wnotin_value/' +
        wnotin_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future removeAll(
      String token, String project, String collection, String appid) async {
    String uri = 'https://io.etter.cloud/v4/remove_all/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeId(String token, String project, String collection, String appid,
      String id) async {
    String uri = 'https://io.etter.cloud/v4/remove_id/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/id/' +
        id;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeWhere(String token, String project, String collection,
      String appid, String where_field, String where_value) async {
    String uri = 'https://io.etter.cloud/v4/remove_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/where_field/' +
        where_field +
        '/where_value/' +
        where_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeOrWhere(String token, String project, String collection,
      String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://io.etter.cloud/v4/remove_or_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/or_where_field/' +
        or_where_field +
        '/or_where_value/' +
        or_where_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeWhereLike(String token, String project, String collection,
      String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://io.etter.cloud/v4/remove_where_like/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wlike_field/' +
        wlike_field +
        '/wlike_value/' +
        wlike_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeWhereIn(String token, String project, String collection,
      String appid, String win_field, String win_value) async {
    String uri = 'https://io.etter.cloud/v4/remove_where_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/win_field/' +
        win_field +
        '/win_value/' +
        win_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeWhereNotIn(String token, String project, String collection,
      String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://io.etter.cloud/v4/remove_where_not_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wnotin_field/' +
        wnotin_field +
        '/wnotin_value/' +
        wnotin_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future updateAll(String update_field, String update_value, String token,
      String project, String collection, String appid) async {
    String uri = 'https://io.etter.cloud/v4/update_all';

    try {
      final response = await http.put(Uri.parse(uri), body: {
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateId(String update_field, String update_value, String token,
      String project, String collection, String appid, String id) async {
    String uri = 'https://io.etter.cloud/v4/update_id';

    try {
      final response = await http.put(Uri.parse(uri), body: {
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid,
        'id': id
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateWhere(
      String where_field,
      String where_value,
      String update_field,
      String update_value,
      String token,
      String project,
      String collection,
      String appid) async {
    String uri = 'https://io.etter.cloud/v4/update_where';

    try {
      final response = await http.put(Uri.parse(uri), body: {
        'where_field': where_field,
        'where_value': where_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateOrWhere(
      String or_where_field,
      String or_where_value,
      String update_field,
      String update_value,
      String token,
      String project,
      String collection,
      String appid) async {
    String uri = 'https://io.etter.cloud/v4/update_or_where';

    try {
      final response = await http.put(Uri.parse(uri), body: {
        'or_where_field': or_where_field,
        'or_where_value': or_where_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateWhereLike(
      String wlike_field,
      String wlike_value,
      String update_field,
      String update_value,
      String token,
      String project,
      String collection,
      String appid) async {
    String uri = 'https://io.etter.cloud/v4/update_where_like';

    try {
      final response = await http.put(Uri.parse(uri), body: {
        'wlike_field': wlike_field,
        'wlike_value': wlike_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateWhereIn(
      String win_field,
      String win_value,
      String update_field,
      String update_value,
      String token,
      String project,
      String collection,
      String appid) async {
    String uri = 'https://io.etter.cloud/v4/update_where_in';

    try {
      final response = await http.put(Uri.parse(uri), body: {
        'win_field': win_field,
        'win_value': win_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateWhereNotIn(
      String wnotin_field,
      String wnotin_value,
      String update_field,
      String update_value,
      String token,
      String project,
      String collection,
      String appid) async {
    String uri = 'https://io.etter.cloud/v4/update_where_not_in';

    try {
      final response = await http.put(Uri.parse(uri), body: {
        'wnotin_field': wnotin_field,
        'wnotin_value': wnotin_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future firstAll(
      String token, String project, String collection, String appid) async {
    String uri = 'https://io.etter.cloud/v4/first_all/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstWhere(String token, String project, String collection,
      String appid, String where_field, String where_value) async {
    String uri = 'https://io.etter.cloud/v4/first_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/where_field/' +
        where_field +
        '/where_value/' +
        where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstOrWhere(String token, String project, String collection,
      String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://io.etter.cloud/v4/first_or_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/or_where_field/' +
        or_where_field +
        '/or_where_value/' +
        or_where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstWhereLike(String token, String project, String collection,
      String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://io.etter.cloud/v4/first_where_like/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wlike_field/' +
        wlike_field +
        '/wlike_value/' +
        wlike_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstWhereIn(String token, String project, String collection,
      String appid, String win_field, String win_value) async {
    String uri = 'https://io.etter.cloud/v4/first_where_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/win_field/' +
        win_field +
        '/win_value/' +
        win_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstWhereNotIn(String token, String project, String collection,
      String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://io.etter.cloud/v4/first_where_not_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wnotin_field/' +
        wnotin_field +
        '/wnotin_value/' +
        wnotin_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastAll(
      String token, String project, String collection, String appid) async {
    String uri = 'https://io.etter.cloud/v4/last_all/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastWhere(String token, String project, String collection,
      String appid, String where_field, String where_value) async {
    String uri = 'https://io.etter.cloud/v4/last_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/where_field/' +
        where_field +
        '/where_value/' +
        where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastOrWhere(String token, String project, String collection,
      String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://io.etter.cloud/v4/last_or_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/or_where_field/' +
        or_where_field +
        '/or_where_value/' +
        or_where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastWhereLike(String token, String project, String collection,
      String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://io.etter.cloud/v4/last_where_like/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wlike_field/' +
        wlike_field +
        '/wlike_value/' +
        wlike_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastWhereIn(String token, String project, String collection,
      String appid, String win_field, String win_value) async {
    String uri = 'https://io.etter.cloud/v4/last_where_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/win_field/' +
        win_field +
        '/win_value/' +
        win_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastWhereNotIn(String token, String project, String collection,
      String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://io.etter.cloud/v4/last_where_not_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wnotin_field/' +
        wnotin_field +
        '/wnotin_value/' +
        wnotin_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomAll(
      String token, String project, String collection, String appid) async {
    String uri = 'https://io.etter.cloud/v4/random_all/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomWhere(String token, String project, String collection,
      String appid, String where_field, String where_value) async {
    String uri = 'https://io.etter.cloud/v4/random_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/where_field/' +
        where_field +
        '/where_value/' +
        where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomOrWhere(String token, String project, String collection,
      String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://io.etter.cloud/v4/random_or_where/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/or_where_field/' +
        or_where_field +
        '/or_where_value/' +
        or_where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomWhereLike(String token, String project, String collection,
      String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://io.etter.cloud/v4/random_where_like/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wlike_field/' +
        wlike_field +
        '/wlike_value/' +
        wlike_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomWhereIn(String token, String project, String collection,
      String appid, String win_field, String win_value) async {
    String uri = 'https://io.etter.cloud/v4/random_where_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/win_field/' +
        win_field +
        '/win_value/' +
        win_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomWhereNotIn(String token, String project, String collection,
      String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://io.etter.cloud/v4/random_where_not_in/token/' +
        token +
        '/project/' +
        project +
        '/collection/' +
        collection +
        '/appid/' +
        appid +
        '/wnotin_field/' +
        wnotin_field +
        '/wnotin_value/' +
        wnotin_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future<String> upload(
    String token,
    String project,
    List<int> file,
    String ext,
  ) async {
    try {
      String uri = 'https://io.etter.cloud/v4/upload';

      var request = http.MultipartRequest('POST', Uri.parse(uri));

      request.fields['token'] = token;
      request.fields['project'] = project;

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file,
        filename: 'filename.$ext',
      ));

      var response = await request.send();

      if (kDebugMode) {
        print(response);
      }

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);

        if (kDebugMode) {
          print(res.body);
        }

        return res
            .body; // Return the response body if the upload is successful.
      } else {
        return 'Upload failed with status code: ${response.statusCode}'; // Provide a message for failed uploads.
      }
    } catch (e) {
      return 'An error occurred: $e'; // Provide an error message in case of exceptions.
    }
  }
}
