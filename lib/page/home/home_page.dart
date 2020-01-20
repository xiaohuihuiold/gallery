import 'dart:math';

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
    print(httpData);
    _dataTree = DataTree.fromJson(httpData.data);
    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  void _onTap(DataTreeNode node) {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onFrame);
  }

  @override
  Widget build(BuildContext context) {
    Widget treeView;
    if (!_initialized) {
      treeView = const Center(
        child: Text('加载中'),
      );
    } else {
      DataTreeNodeArray array = _dataTree.root.getNode('data->illustrations');

      treeView = Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                child: DataTreeView(
                  onTap: _onTap,
                  dataTreeNode: _dataTree.root,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: array?.length ?? 0,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext buildContext, int index) {
                  DataTreeNodeObject item = array[index];
                  return ListTile(
                    title: Text('${item.getNode('title')}'),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Image.network(
                            'https://img.cheerfun.dev:23334/get/${(item.getNode('imageUrls')as DataTreeNodeArray)[0].getNode('squareMedium')}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('图集'),
      ),
      body: treeView,
    );
  }
}
