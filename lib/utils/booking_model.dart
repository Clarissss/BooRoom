class BookingModel {
   final String id;
   final String date;
   final String start_time;
   final String end_time;
   final String status;
   final String desc;
   final String user;
   final String room;
   final String stat1;
   final String stat2;
   final String stat3;

   BookingModel({
      required this.id,
      required this.date,
      required this.start_time,
      required this.end_time,
      required this.status,
      required this.desc,
      required this.user,
      required this.room,
      required this.stat1,
      required this.stat2,
      required this.stat3
   });

   factory BookingModel.fromJson(Map data) {
      return BookingModel(
         id: data['_id'],
         date: data['date'],
         start_time: data['start_time'],
         end_time: data['end_time'],
         status: data['status'],
         desc: data['desc'],
         user: data['user'],
         room: data['room'],
         stat1: data['stat1'],
         stat2: data['stat2'],
         stat3: data['stat3']
      );
   }
}