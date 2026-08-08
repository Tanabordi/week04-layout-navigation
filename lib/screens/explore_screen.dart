import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/destination.dart';
import '../widgets/destination_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';

  List<Destination> get _filteredDestinations {
    if (_searchQuery.isEmpty) return sampleDestinations;
    return sampleDestinations
        .where(
          (d) =>
              d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              d.country.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              d.tags.any(
                (t) => t.toLowerCase().contains(_searchQuery.toLowerCase()),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สำรวจ'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'ค้นหา Destination...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _filteredDestinations.isEmpty
                ? _buildEmptyState()
                : _buildGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 💡 ข้อแตกต่าง:
    // MediaQuery.of(context).size.width คือ "ความกว้างรวมของทั้งหน้าจอ" (Screen Width)
    // constraints.maxWidth ใน LayoutBuilder คือ "ความกว้างของพื้นที่ที่เหลือ" ที่ Widget แม่กำหนดมาให้ (Available Parent Space)
    // การเลือกใช้: ควรใช้ LayoutBuilder เมื่อต้องการให้ Widget ยืดหยุ่นปรับขนาดตามพื้นที่ที่โดนจำกัดจากแม่ และใช้ MediaQuery เมื่อต้องการค่าที่อิงจากขนาดเครื่องโทรศัพท์/หน้าจอจริงๆ
    
    return LayoutBuilder(
      builder: (context, constraints) {
        print('Screen Width: $screenWidth, Constraints Max Width: ${constraints.maxWidth}');

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: _filteredDestinations.length,
          itemBuilder: (context, index) {
            final destination = _filteredDestinations[index];
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
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'ไม่พบ Destination ที่ค้นหา',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            '"$_searchQuery"',
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
