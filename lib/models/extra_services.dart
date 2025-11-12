import 'package:ndege/models/trip_details.dart';

class ExtraServices {
  final List<BaggageOption> baggage;

  ExtraServices({required this.baggage});

  factory ExtraServices.fromJson(Map<String, dynamic> json) {
    final dynamicBaggage =
        json['ExtraServicesResponse']['ExtraServicesResult']['ExtraServicesData']['DynamicBaggage'][0];
    final services = dynamicBaggage['Services'][0] as List;

    return ExtraServices(
      baggage: services.map((e) => BaggageOption.fromJson(e)).toList(),
    );
  }
}
