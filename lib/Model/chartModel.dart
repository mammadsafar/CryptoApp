class ChartModel {
  int time;
  double? open;
  double? high;
  double? low;
  double? close;

  ChartModel({required this.time, this.open, this.high, this.low, this.close});

  factory ChartModel.fromJson(List l) {
    print(l);
    return ChartModel(
      time: l[0] == null ? null : l[0]!,
      open: l[1] == null ? null : l[1]!,
      high: l[2] == null ? null : l[2]!,
      low: l[3] == null ? null : l[3]!,
      close: l[4] == null ? null : l[4]!,
    );
  }
  // // Start: Added method
  // @override
  // String toString() => toJson().toString();
  // // End: Added method
}
