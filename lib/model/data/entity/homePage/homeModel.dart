
class HomeModel {
  HomeModel({
    required this.recent_activities,
    required this.done_travels,
    required this.done_loads,
  });

  RecentActivitiesModel recent_activities;
  DoneTravelsModel done_travels;
  List<ActiveExclusiveTravelsModel>? done_loads;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    recent_activities:RecentActivitiesModel.fromJson(json["recent_activities"]),
    done_travels:DoneTravelsModel.fromJson(json["done_travels"]),
    done_loads:json["done_loads"] != null? List<ActiveExclusiveTravelsModel>.from(
      json["done_loads"].map((x) => ActiveExclusiveTravelsModel.fromJson(x))):null,
  );
}
class DoneTravelsModel{
  DoneTravelsModel({
    required this.done_exclusive_travels,
    required this.done_normal_travels,
  });

  List<ActiveExclusiveTravelsModel>? done_exclusive_travels;
  List<ActiveExclusiveTravelsModel>? done_normal_travels;

  factory DoneTravelsModel.fromJson(Map<String, dynamic> json) => DoneTravelsModel(
    done_exclusive_travels:json["done_exclusive_travels"] != null? List<ActiveExclusiveTravelsModel>.from(
        json["done_exclusive_travels"].map((x) => ActiveExclusiveTravelsModel.fromJson(x))):null,
    done_normal_travels:json["done_normal_travels"] != null? List<ActiveExclusiveTravelsModel>.from(
        json["done_normal_travels"].map((x) => ActiveExclusiveTravelsModel.fromJson(x))):null,
  );
}

class RecentActivitiesModel{
  RecentActivitiesModel({
    required this.active_exclusive_travels,
    required this.active_normal_travels,
    required this.active_loads,
  });

  List<ActiveExclusiveTravelsModel>? active_exclusive_travels;
  List<ActiveExclusiveTravelsModel>? active_normal_travels;
  List<ActiveExclusiveTravelsModel>? active_loads;

  factory RecentActivitiesModel.fromJson(Map<String, dynamic> json) => RecentActivitiesModel(
    active_exclusive_travels:json["active_exclusive_travels"] != null? List<ActiveExclusiveTravelsModel>.from(
        json["active_exclusive_travels"].map((x) => ActiveExclusiveTravelsModel.fromJson(x))) : null,
    active_normal_travels:json["active_normal_travels"] != null? List<ActiveExclusiveTravelsModel>.from(
        json["active_normal_travels"].map((x) => ActiveExclusiveTravelsModel.fromJson(x))):null,
    active_loads:json["active_loads"] != null? List<ActiveExclusiveTravelsModel>.from(
        json["active_loads"].map((x) => ActiveExclusiveTravelsModel.fromJson(x))):null,
  );
}
class ActiveExclusiveTravelsModel {
  ActiveExclusiveTravelsModel({
    this.id,
    this.total_price,
    this.discount_amount,
    this.status,
    this.source_state,
    this.source_city,
    this.start_date_time,
    this.driver_info,
    this.destination_city,
    this.destination_state,
    this.destinations_count,
    this.travelType,
    this.path_info,
    this.status_index,
    this.discount_percentage,
    this.final_price,
    this.load_type_name,
    this.passengers_count,
    this.travel_time_estimation,
    this.max_delivery_time,
    this.travel_date_time,
    this.rated
  });
  int? id;
  int? total_price;
  int? discount_amount;
  String? status;
  String? source_state;
  String? source_city;
  String? start_date_time;
  String? travel_date_time;
  DriverInfoModel? driver_info;
  bool? rated;
  String? destination_state;
  String? destination_city;
  int? status_index;
  int? destinations_count;
  int? final_price;
  int? discount_percentage;
  String? load_type_name;
  int? passengers_count;
  String? max_delivery_time;
  //EXT -> 0, normalTravel -> 1, Load -> 2
  int? travelType;
  List<PathInfoModel>? path_info;
  double? travel_time_estimation;

  factory ActiveExclusiveTravelsModel.fromJson(Map<String, dynamic> json) => ActiveExclusiveTravelsModel(
    id: json["id"],
    total_price: json["total_price"],
    discount_amount: json["discount_amount"],
    status: json["status"],
    source_state: json["source_state"],
    source_city: json["source_city"],
    start_date_time : json["start_date_time"],
    travel_date_time: json["travel_date_time"],
    driver_info :json["driver_info"] != null?DriverInfoModel.fromJson(json["driver_info"]) : null,
    destination_state :json["destination_state"],
    destination_city :json["destination_city"],
    destinations_count :json["destinations_count"],
    status_index: json["status_index"],
    path_info:json["path_info"] != null? List<PathInfoModel>.from(
        json["path_info"].map((x) => PathInfoModel.fromJson(x))):null,
    discount_percentage: json["discount_percentage"],
    final_price: json["final_price"],
    load_type_name: json["load_type_name"],
    rated:json["rated"],
    passengers_count: json["passengers_count"],
    travelType: json["travelType"],
    travel_time_estimation: json["travel_time_estimation"],
    max_delivery_time: json["max_delivery_time"]
  );
}
class DriverInfoModel {
  DriverInfoModel({
    required this.id,
    required this.load_discount,
    required this.mobile_number,
    required this.name,
    required this.image,
  });

  int? id;
  double? load_discount;
  String? mobile_number;
  String? name;
  String? image;

  factory DriverInfoModel.fromJson(Map<String, dynamic> json) => DriverInfoModel(
    id: json["id"],
    load_discount : json["load_discount"],
    mobile_number: json["mobile_number"],
    name: json["name"],
    image: json["image"],
  );
}
class PathInfoModel {
  PathInfoModel({
    required this.stop_time,
    required this.destination_state,
    required this.destination_city,
  });

  int? stop_time;
  String? destination_state;
  String? destination_city;

  factory PathInfoModel.fromJson(Map<String, dynamic> json) => PathInfoModel(
    stop_time: json["stop_time"],
    destination_state : json["destination_state"],
    destination_city : json["destination_city"],
  );
}