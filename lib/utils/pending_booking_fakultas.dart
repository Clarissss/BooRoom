class PendingBookingFakultasModel {
  final String id;
  final String date;
  final String start_time;
  final String end_time;
  String status;
  final String desc;
  final String room;
  final String capacity;
  final String user;

  PendingBookingFakultasModel(
      {required this.id,
      required this.date,
      required this.start_time,
      required this.end_time,
      required this.status,
      required this.desc,
      required this.room,
      required this.capacity,
      required this.user});

  factory PendingBookingFakultasModel.fromJson(Map data) {
    return PendingBookingFakultasModel(
        id: data['_id'] ?? '',
        date: data['date'] ?? '',
        start_time: data['start_time']?? '',
        end_time: data['end_time']?? '',
        status: data['status']?? '',
        desc: data['desc']?? '',
        room: data['room']?? '',
        capacity: data['capacity']??'',
        user: data['user']);
  }
}
