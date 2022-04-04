import './routing/routing_data.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    print('queryParameters: ${uriData.queryParameters} path: ${uriData.path}');
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }

  // String getUri() {
  //   var uriData = Uri.parse(this);
  //   return uriData.path;
  // }
}