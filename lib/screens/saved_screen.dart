import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/destination.dart';
import '../models/saved_state.dart';
import '../widgets/destination_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('บันทึกไว้')),
      // 1. ใช้ ValueListenableBuilder ดักฟัง State กลาง (แก้ปัญหาหน้าจอไม่ยอมรีเฟรชตอนสลับ Tab กลับมา)
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: SavedState.savedIds,
        builder: (context, savedIds, _) {
          // ดึงข้อมูล Destination ที่ตรงกับ ID ในกระเป๋ากลางมาแสดง
          final savedDestinations = sampleDestinations
              .where((d) => savedIds.contains(d.id))
              .toList();

          // 2. ถ้ายังไม่ได้กดบันทึกอะไรเลย ก็ให้โชว์หน้า Empty State ว่างๆ
          if (savedDestinations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 64, color: Colors.pink.shade200),
                  const SizedBox(height: 16),
                  const Text('ยังไม่มีรายการที่บันทึก',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          // 3. ถ้ามีข้อมูล ก็เอามาใส่ GridView โดยใช้ LayoutBuilder ปรับ Responsive ให้เหมือนหน้า Explore
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;
              if (constraints.maxWidth < 600) {
                crossAxisCount = 2;
              } else if (constraints.maxWidth < 840) {
                crossAxisCount = 3;
              } else if (constraints.maxWidth < 1200) {
                crossAxisCount = 4;
              } else {
                crossAxisCount = 5;
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: savedDestinations.length,
                itemBuilder: (context, index) {
                  final destination = savedDestinations[index];
                  return DestinationCard(
                    destination: destination,
                    onTap: () {
                      context.pushNamed(
                        'destination-detail',
                        pathParameters: {'id': destination.id},
                        extra: destination,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
