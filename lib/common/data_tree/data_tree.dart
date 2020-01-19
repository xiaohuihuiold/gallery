class DataTree {
  DataTreeNode root;

  DataTree();

  factory DataTree.fromJson(dynamic json) {
    DataTree dataTree = DataTree();
    dataTree.root = dataTree._parseJson(json);
    return dataTree;
  }

  DataTreeNode _parseJson(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is Map) {
      return _parseMap(json);
    } else if (json is List) {
      return _parseList(json);
    } else {
      return DataTreeNodeValue(json);
    }
  }

  DataTreeNodeObject _parseMap(Map json) {
    DataTreeNodeObject dataTreeNodeObject = DataTreeNodeObject();
    json.forEach((dynamic key, dynamic value) {
      if (key is! String) {
        return;
      }
      dataTreeNodeObject[key] = _parseJson(value);
    });
    return dataTreeNodeObject;
  }

  DataTreeNodeArray _parseList(List json) {
    DataTreeNodeArray dataTreeNodeArray = DataTreeNodeArray();
    json.forEach((dynamic value) {
      dataTreeNodeArray.add(_parseJson(value));
    });
    return dataTreeNodeArray;
  }

  void printTree() {
    _printTree(0, root);
  }

  void _printTree(int depth, DataTreeNode node) {
    if (node == null) {
      return;
    }
    depth++;
    String hr = '-' * depth;
    if (node is DataTreeNodeObject) {
      node.forEach((String key, DataTreeNode node) {
        print('$hr $key:');
        print('$hr {');
        _printTree(depth, node);
        print('$hr }');
      });
    } else if (node is DataTreeNodeArray) {
      node.forEach((DataTreeNode node) {
        print('$hr [');
        _printTree(depth, node);
        print('$hr ]');
      });
    } else if (node is DataTreeNodeValue) {
      print('$hr ${node.value}');
    }
  }

  @override
  String toString() {
    return root?.toString();
  }
}

abstract class DataTreeNode {
  DataTreeNode parent;
}

class DataTreeNodeValue extends DataTreeNode {
  dynamic value;

  DataTreeNodeValue(this.value);

  @override
  String toString() {
    return value?.toString();
  }
}

class DataTreeNodeObject extends DataTreeNode {
  final Map<String, DataTreeNode> _objectMap = Map();

  int get length => _objectMap.length;

  Iterable<String> get keys => _objectMap.keys;

  Iterable<DataTreeNode> get values => _objectMap.values;

  void forEach(Function(String key, DataTreeNode node) callback) {
    _objectMap.forEach(callback);
  }

  DataTreeNode remove(String key) {
    DataTreeNode value = _objectMap.remove(key);
    value?.parent = null;
    return value;
  }

  DataTreeNode operator [](String key) {
    return _objectMap[key];
  }

  void operator []=(String key, DataTreeNode value) {
    value?.parent = this;
    _objectMap[key] = value;
  }

  @override
  String toString() {
    return _objectMap.toString();
  }
}

class DataTreeNodeArray extends DataTreeNode {
  final List<DataTreeNode> _values = List();

  int get length => _values.length;

  Iterable<DataTreeNode> get values => _values;

  void forEach(Function(DataTreeNode node) callback) {
    _values.forEach(callback);
  }

  DataTreeNode removeAt(int index) {
    DataTreeNode value = _values.removeAt(index);
    value?.parent = null;
    return value;
  }

  bool remove(DataTreeNode value) {
    value?.parent = null;
    return _values.remove(value);
  }

  void add(DataTreeNode value) {
    value?.parent = this;
    _values.add(value);
  }

  DataTreeNode operator [](int index) {
    return _values[index];
  }

  void operator []=(int index, DataTreeNode value) {
    value?.parent = this;
    _values[index] = value;
  }

  @override
  String toString() {
    return _values.toString();
  }
}
