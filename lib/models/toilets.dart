import 'package:cloud_firestore/cloud_firestore.dart';

class Toilet {
  GeoPoint location;
  String? referenceId;


  Toilet(this.location,
  {this.referenceId});

  factory Toilet.fromSnapshot(DocumentSnapshot snapshot) {
    final newToilet = Toilet.fromJson(snapshot.data() as Map<String, GeoPoint>);
    newToilet.referenceId = snapshot.reference.id;
    return newToilet;
  }

  factory Toilet.fromJson(Map<String, GeoPoint> json) => _ToiletFromJson(json);

  Map<String, dynamic> toJson() => _ToiletToJson(this);

  @override
  String toString() => 'Toilet<$referenceId>';

}

Toilet _ToiletFromJson(Map<String, GeoPoint> json) {
  return Toilet(json['location']!);
}


Map<String, dynamic> _ToiletToJson(Toilet instance) => <String, dynamic> {
  'location': instance.location    };

