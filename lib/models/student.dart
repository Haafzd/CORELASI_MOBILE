enum AttendanceStatus { hadir, tidakHadir }

class StudentAttendance {
  final String nis;
  final String name;
  final AttendanceStatus status;

  StudentAttendance({
    required this.nis,
    required this.name,
    required this.status,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    final statusStr = (json['status_kehadiran'] ?? '').toString().toLowerCase();
    final status = statusStr == 'hadir'
        ? AttendanceStatus.hadir
        : AttendanceStatus.tidakHadir;
    return StudentAttendance(
      nis: json['nis'],
      name: json['nama_siswa'],
      status: status,
    );
  }
}
