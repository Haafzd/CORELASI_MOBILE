class ScheduleItem {
  final int sessionId;
  final String subjectName;
  final String className;
  final String status;
  final String timeRange;
  final DateTime startTime;
  final DateTime endTime;

  ScheduleItem({
    required this.sessionId,
    required this.subjectName,
    required this.className,
    required this.status,
    required this.timeRange,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    final start = DateTime.parse(json['jam_mulai_iso']);
    final end = DateTime.parse(json['jam_selesai_iso']);
    return ScheduleItem(
      sessionId: json['id'],
      subjectName: json['nama_mapel'],
      className: json['nama_kelas'],
      status: json['status_sesi'] ?? '',
      timeRange:
          '${json['jam_mulai_display']} - ${json['jam_selesai_display']}',
      startTime: start,
      endTime: end,
    );
  }
}
