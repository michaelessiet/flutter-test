import 'package:velocity_x/velocity_x.dart';

class MyStore extends VxStore {
  int count = 0;
}

class Increment extends VxMutation<MyStore> {
  @override
  perform() => store?.count++;
}