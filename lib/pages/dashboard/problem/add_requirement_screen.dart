import 'package:Problem/components/floating_label_edit_box.dart';
import 'package:Problem/components/screen_action_bar.dart';
import 'package:Problem/components/screen_frame.dart';
import 'package:Problem/constants/local_constant.dart';
import 'package:Problem/constants/url_constant.dart';
import 'package:Problem/utils/api_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class AddRequirementScreen extends StatefulWidget {
  const AddRequirementScreen({super.key});

  @override
  State<AddRequirementScreen> createState() => _AddRequirementScreenState();
}

class _AddRequirementScreenState extends State<AddRequirementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _requirements = [];

  List<String> filteredSuggestions = [];

  bool isCalling = false;
  String? _lastQuery = null;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterList);
    _filterList();
  }

  void _filterList() {
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
    postService(URL_REQUIREMENT_SEARCH_QUERY, body).then((response) {
      if (response.isSuccess) {
        setState(() {
          print('get query list ${response.body}');
          _requirements = response.body;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenFrame(
      titleBar: ScreenActionBar(
        title: 'Add Requirement',
      ),
      body: Column(
        children: [
          addVerticalSpace(),
          FloatingLabelEditBox(
            labelText: 'Search',
            controller: _searchController,
            prefix: Icon(Icons.search_rounded),
          ),
          ..._requirements.map((skill) {
            return ListTile(
              onTap: () {
                setResult(skill['id']);
              },
              title: Row(
                children: [
                  Icon(Icons.search),
                  addHorizontalSpace(),
                  Text('${skill['name']}')
                ],
              ),
            );
          }).toList()
        ],
      ),
    );
  }

  void setResult(int requirement) {
    Navigator.pop(context, requirement);
  }
}
