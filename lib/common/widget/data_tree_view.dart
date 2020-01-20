import 'package:flutter/material.dart';
import 'package:gallery/common/data_tree/data_tree.dart';

class DataTreeView extends StatefulWidget {
  final DataTreeNode dataTreeNode;
  final int depth;
  final Function(DataTreeNode node) onTap;

  const DataTreeView({
    Key key,
    this.dataTreeNode,
    this.depth = 0,
    this.onTap,
  }) : super(key: key);

  @override
  _DataTreeViewState createState() => _DataTreeViewState();
}

class _DataTreeViewState extends State<DataTreeView> {
  @override
  Widget build(BuildContext context) {
    DataTreeNode dataTreeNode = widget.dataTreeNode;
    Widget child;
    if (dataTreeNode is DataTreeNodeValue) {
      child = Container(
        margin: const EdgeInsets.only(left: 8.0, top: 4.0),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.grey, blurRadius: 0.0),
          ],
        ),
        child: Text('${dataTreeNode.value}'),
      );
    } else if (dataTreeNode is DataTreeNodeArray) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: List<Widget>.generate(dataTreeNode.length, (int index) {
          return DataTreeView(
            onTap: widget.onTap,
            dataTreeNode: dataTreeNode[index],
            depth: widget.depth - 1,
          );
        }),
      );
    } else if (dataTreeNode is DataTreeNodeObject) {
      List<String> keys = dataTreeNode.keys.toList();
      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(dataTreeNode.length, (int index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap(dataTreeNode[keys[index]]);
                  }
                },
                child: DataTreeView(
                  onTap: widget.onTap,
                  dataTreeNode: DataTreeNodeValue(keys[index]),
                  depth: widget.depth,
                ),
              ),
              DataTreeView(
                dataTreeNode: DataTreeNodeValue(':'),
                depth: widget.depth,
              ),
              DataTreeView(
                onTap: widget.onTap,
                dataTreeNode: dataTreeNode[keys[index]],
                depth: widget.depth + 1,
              ),
            ],
          );
        }),
      );
    }
    return child;
  }
}
