import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';

Future<void> preloadRegion() async {
  final store = FMTCStore('mapStore');
  final bounds = LatLngBounds(
    LatLng(-90, -180),
    LatLng(90, 180),
  );
  final region = RectangleRegion(bounds);
  final downloadable = region.toDownloadable(
    minZoom: 3,
    maxZoom: 15,
    options: TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.app',
    ),
  );

  store.download.startForeground(region: downloadable);
}
