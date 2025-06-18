abstract class MetricObject {
  MetricType type = MetricType.unknown;

  bool validate();

  void clear();
}

enum MetricType {
  unknown,
  temperature,
}
