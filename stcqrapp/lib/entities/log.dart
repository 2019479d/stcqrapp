class Log {
  int materialNo;
  String length;
  String girth;
  String volume;
  String reducedVolume;
  String time;
  String visibleMaterialNo;
  String qrId;
  String category;
  String timberClass;
  String species;
  int active;
  String lotNo;
  String salePrice;
  String valueGrade;
  String valuePrice;
  String transCost;
  int userId;
  String username;
  int regionId;
  String regionText;
  String depotId;
  String depotText;
  double? newVolume;
  double? midGrithPrice;
  String? grading;
  double? newTransCost;
  double? salesPrice;

  Log({
    required this.materialNo,
    required this.length,
    required this.girth,
    required this.volume,
    required this.reducedVolume,
    required this.time,
    required this.visibleMaterialNo,
    required this.qrId,
    required this.category,
    required this.timberClass,
    required this.species,
    required this.active,
    required this.lotNo,
    required this.salePrice,
    required this.valueGrade,
    required this.valuePrice,
    required this.transCost,
    required this.userId,
    required this.username,
    required this.regionId,
    required this.regionText,
    required this.depotId,
    required this.depotText,
    this.grading = "A",
    this.midGrithPrice = 0.0,
    this.newTransCost = 0.0,
    this.newVolume = 0.0,
    this.salesPrice = 0.0,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      materialNo: json['material_no'],
      length: json['length'],
      girth: json['girth'],
      volume: json['volume'],
      reducedVolume: json['reduced_volume'],
      time: json['time'],
      visibleMaterialNo: json['visible_material_no'],
      qrId: json['qr_id'],
      category: json['category'],
      timberClass: json['timber_class'],
      species: json['specis'],
      active: json['active'],
      lotNo: json['lot_no'],
      salePrice: json['sale_price'],
      valueGrade: json['value_grade'],
      valuePrice: json['value_price'],
      transCost: json['transCost'],
      userId: json['user']['id'],
      username: json['user']['username'],
      regionId: json['region']['region_id'],
      regionText: json['region']['region_txt'],
      depotId: json['depot']['depot_id'],
      depotText: json['depot']['depot_txt'],
    );
  }
}
