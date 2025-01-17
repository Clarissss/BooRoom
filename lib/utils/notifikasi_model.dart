class NotifikasiModel {
   final String id;
   final String user;
   final String reason;
   final String title;

   NotifikasiModel({
      required this.id,
      required this.user,
      required this.reason,
      required this.title
   });

   factory NotifikasiModel.fromJson(Map data) {
      return NotifikasiModel(
         id: data['_id'],
         user: data['user'],
         reason: data['reason'],
         title: data['title']
      );
   }
}