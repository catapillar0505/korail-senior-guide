import 'package:flutter/material.dart';
import '../utils/hangul_utils.dart';

class PlaceSelectionModal extends StatefulWidget {
  final String title; // '출발' or '도착'
  final String currentPlace;

  const PlaceSelectionModal({
    super.key,
    required this.title,
    required this.currentPlace,
  });

  @override
  State<PlaceSelectionModal> createState() => _PlaceSelectionModalState();
}

class _PlaceSelectionModalState extends State<PlaceSelectionModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Main stations displayed in '주요역' section
  final List<List<String>> mainStationsList = [
    ['서울', '용산'],
    ['광명', '영등포'],
    ['수원', '평택'],
  ];

  // Additional stations for search
  final List<List<String>> additionalStations = [
    ['광양', '광주'],
    ['광주송정', '광천'],
    ['서광주', ''],
  ];

  List<List<String>> get mainStations {
    // Always display the same main stations regardless of departure/arrival
    return mainStationsList;
  }

  List<List<String>> get filteredStations {
    if (_searchQuery.isEmpty) {
      return mainStations;
    }

    // Combine all stations for search
    List<String> allStations = [
      ...mainStationsList.expand((row) => row),
      ...additionalStations.expand((row) => row),
    ].where((s) => s.isNotEmpty).toList();

    List<String> filtered = allStations.where((station) {
      return HangulUtils.matchesSearch(station, _searchQuery);
    }).toList();

    // Convert back to 2D array
    List<List<String>> result = [];
    for (int i = 0; i < filtered.length; i += 2) {
      if (i + 1 < filtered.length) {
        result.add([filtered[i], filtered[i + 1]]);
      } else {
        result.add([filtered[i], '']);
      }
    }
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF9CA3AF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: '역 명의 초성 또는 전체를 입력해 주세요.',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF9CA3AF),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF9CA3AF),
                    size: 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Main stations section
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '주요역',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Station grid
                    ...filteredStations.map((row) => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStationButton(row[0]),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: row[1].isEmpty
                                  ? const SizedBox()
                                  : _buildStationButton(row[1]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    )),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationButton(String stationName) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, stationName);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            stationName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
