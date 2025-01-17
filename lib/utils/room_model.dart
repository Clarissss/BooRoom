class RoomModel {
   final String id;
   final String name;
   final String capacity;
   final String room_img;

   RoomModel({
      required this.id,
      required this.name,
      required this.capacity,
      required this.room_img
   });

   factory RoomModel.fromJson(Map data) {
      return RoomModel(
         id: data['_id'],
         name: data['name'],
         capacity: data['capacity'],
         room_img: data['room_img']
      );
   }
}