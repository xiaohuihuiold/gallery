import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/common/data_tree/data_tree.dart';
import 'package:gallery/common/http/http_data.dart';
import 'package:gallery/common/http/http_manager.dart';

void main() {
  test('data tree', () async {
    HttpData httpData = await HttpManager().fetch(
      url: 'https://api.pixivic.com/illustrations',
      params: {
        'keyword': 'shelter',
        'pageSize': 10,
        'page': 1,
      },
    );
    print(httpData.data);
    DataTree dataTree = DataTree.fromJson(httpData.data);
    dataTree.printTree();
  });
}
