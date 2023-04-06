class ApiEndPoints {
  //here we define strings for url ( without condidering baseurl) to use in ExTripImp
  //neshan api's
  final String searchLocationForUser = "v1/";
  final String locationToAddress = "v4/";

  //xTravel server api's
  final String getExTripInfo = 'exclusive_travel_info_api/';
  final String createExTrip = 'mobile_app_passenger_exclusive_travel_api/';
  final String batchDest = 'mobile_app_batch_exclusive_destination_api/';
  final String cancelExTrip = 'mobile_app_cancel_exclusive_travel_api/';
  final String exTrPayment = 'mobile_app_pay_exclusive_travel_api/';
  final String normalPayment = 'mobile_app_pay_normal_travel_api/';
  final String loadPayment = 'mobile_app_pay_load_api/';
  final String loadApi = 'mobile_app_passenger_load_api/';
  final String loadInfoApi = 'load_info_api/';
  final String homeData = 'mobile_app_passenger_home_page_api/';
  final String splashData = 'mobile_app_splash_screen_data_api/';
  final String normalTravelInfo = "normal_travel_info_api/";
  final String destinationOfNormalTravel =
      "mobile_app_get_city_line_destinations_by_source_coordinates_api/";
  final String normalTravelRequest = "mobile_app_passenger_normal_travel_api/";
  final String getCarTypeSeats = "get_car_type_seats_api/";
  final String travelTicketAPi = "mobile_app_normal_travel_ticket_api/";
  final String cancelNormalTravel = "mobile_app_cancel_normal_travel_api/";
  final String cancelLoad = "mobile_app_cancel_load_api/";
  final String sendVerificationCode = "send_verification_code_by_sms_api/";
  final String smsCodeVerificationCode = "sms_code_verification_api/";
  final String appUserProfileApi = "mobile_app_user_profile_api/";
  final String refreshToken = "token/refresh/";
  final String driverScore = "driver_score_api/";
  final String checkApkVersion = "mobile_app_passenger_apk_version_status_api/";
  final String mobileAppGetSupportinfoApi = "mobile_app_get_support_info_api/";
}