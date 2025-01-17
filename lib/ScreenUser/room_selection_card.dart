import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bookingroom/utils/config.dart';
import 'package:bookingroom/utils/restApi.dart';
import 'package:bookingroom/utils/room_model.dart';

class RoomSelectionCard extends StatefulWidget {
  @override
  _RoomSelectionCardState createState() => _RoomSelectionCardState();
}

class _RoomSelectionCardState extends State<RoomSelectionCard> {
  List<RoomModel> rooms = [];
  final DataService ds = DataService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectAllRoom();
  }

  Future<void> selectAllRoom() async {
    try {
      String response = await ds.selectAll(token, project, 'room', appid);
      List data = jsonDecode(response);
      setState(() {
        rooms = data.map((e) => RoomModel.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load rooms. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.cyan,
          ),
        ),
      );
    }

    if (rooms.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.room_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No rooms available',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Calculate the number of columns based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: selectAllRoom,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    // Handle room selection
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(fileUri + room.room_img),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {},
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${room.capacity}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room.name,
                                style: const TextStyle(
                                  fontFamily: 'Itim',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  SizedBox(width: 4),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}