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

  // Selectable stations only
  final Set<String> selectableStations = {'용산', '광주', '광주송정'};

  // Station categories
  final Map<String, List<String>> stationCategories = {
    '주요역': ['서울', '용산', '광명', '영등포', '수원', '평택', '천안아산', '오송'],
    'ㄱ': ['가남', '가평', '각계', '감곡장호원', '강릉', '강진', '계룡', '고래불', '공주', '광명', '광양', '광주', '광주송정', '광천', '구례구', '구미', '김제', '김천'],
    'ㄴ': ['나전', '나주', '남성현', '남원', '남창', '남춘천', '논산', '능주'],
    'ㄷ': ['다시', '단양', '대곡', '대구', '대야', '대전', '대천', '덕소', '도계', '도고온천'],
  };

  Map<String, List<String>> get displayedStations {
    if (_searchQuery.isEmpty) {
      return stationCategories;
    }

    // Search across all categories
    Map<String, List<String>> result = {};

    stationCategories.forEach((category, stations) {
      List<String> filtered = stations.where((station) {
        return HangulUtils.matchesSearch(station, _searchQuery);
      }).toList();

      if (filtered.isNotEmpty) {
        result[category] = filtered;
      }
    });

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

          // Stations section by category
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...displayedStations.entries.map((entry) {
                      String category = entry.key;
                      List<String> stations = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category title
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0288D1),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Station grid (2 columns)
                          ..._buildStationGrid(stations),

                          const SizedBox(height: 24),
                        ],
                      );
                    }).toList(),
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

  List<Widget> _buildStationGrid(List<String> stations) {
    List<Widget> rows = [];
    for (int i = 0; i < stations.length; i += 2) {
      rows.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStationButton(stations[i]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < stations.length
                      ? _buildStationButton(stations[i + 1])
                      : const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    }
    return rows;
  }

  Widget _buildStationButton(String stationName) {
    final bool isSelectable = selectableStations.contains(stationName);

    return InkWell(
      onTap: isSelectable
          ? () {
              Navigator.pop(context, stationName);
            }
          : null,
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
