abstract class MetricObject {
  MetricType type = MetricType.unknown;

  void validate();
}

enum MetricType {
  unknown,
  temperature,
}
