import 'package:Problem/components/colored_button.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  int SEARCH_TIME_SECONDS = 2;
  bool isCalling = false;
  var _allItems = [];

  var _filteredItems = [];

  var _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _filterList();
    _filteredItems = _allItems;
    _searchController.addListener(_filterList);
  }

  void _filterList() async {
    final query = _searchController.text.toLowerCase();

    if (isCalling || _lastQuery == query) {
      return;
    }

    isCalling = true;

    Future.delayed(Duration(seconds: SEARCH_TIME_SECONDS), () {
      isCalling = false;

      _filterList();
    });

    var body = {"query": query};
    _lastQuery = query;
    postService(URL_PROBLEM_SEARCH_QUERY, body).then((response) {
      if (response.isSuccess) {
        setState(() {
          print('get query list ${response.body}');
          _filteredItems = response.body;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                addHorizontalSpace(),
                ColoredButton(
                    onPressed: () {
                      searchQuery(_searchController.text);
                    },
                    child: Icon(
                      Icons.search,
                      color: COLOR_BASE,
                      size: getTextTheme().headlineMedium?.fontSize,
                    ))
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredItems[index]),
                    onTap: () {
                      searchQuery(_filteredItems[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchQuery(String data) {
    Navigator.pop(context, data);
  }
}
