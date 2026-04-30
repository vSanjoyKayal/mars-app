class MissionModel {

  final String missionName;
  final String missionCode;
  final String crewCount;
  final String missionStatus;
  final String missionDuration;
  final String captainsMessage;
  final String information;

  MissionModel({
    required this.missionName,
    required this.missionCode,
    required this.crewCount,
    required this.missionStatus,
    required this.missionDuration,
    required this.captainsMessage,
    required this.information,
  });

  factory MissionModel.fromJson(Map<String, dynamic> acf) {
    return MissionModel(
      missionName: acf['mission_name'] ?? '',
      missionCode: acf['mission_code'] ?? '',
      crewCount: acf['crew_count'] ?? '',
      missionStatus: acf['mission_status'] ?? '',
      missionDuration: acf['mission_duration'] ?? '',
      captainsMessage: acf['captains_message'] ?? '',
      information: acf['information'] ?? '',
    );
  }
}