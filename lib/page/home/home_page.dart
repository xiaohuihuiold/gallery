import 'package:flutter/material.dart';
import 'package:gallery/common/data_tree/data_tree.dart';
import 'package:gallery/common/http/http_data.dart';
import 'package:gallery/common/http/http_manager.dart';
import 'package:gallery/common/widget/data_tree_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataTree _dataTree;
  bool _initialized = false;

  Future<Null> _onFrame(_) async {
    HttpData httpData = await HttpManager().fetch(
      url: 'https://api.pixivic.com/illustrations',
      params: {
        'keyword': 'shelter',
        'pageSize': 10,
        'page': 1,
      },
    );
    _dataTree = DataTree.fromJson(httpData.data);
    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onFrame);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (!_initialized) {
      body = const Center(
        child: Text('加载中'),
      );
    } else {
      body = SingleChildScrollView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          child: DataTreeView(
            dataTreeNode: _dataTree.root,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('图集'),
      ),
      body: body,
    );
  }
}
