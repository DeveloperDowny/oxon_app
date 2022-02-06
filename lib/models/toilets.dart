import 'package:cloud_firestore/cloud_firestore.dart';

class Toilet {
  Map<String, dynamic> location;
  String? referenceId;


  Toilet(this.location,
  {this.referenceId});

  factory Toilet.fromSnapshot(DocumentSnapshot snapshot) {
    final newToilet = Toilet.fromJson(snapshot.data() as Map<String, dynamic>);
    newToilet.referenceId = snapshot.reference.id;
    return newToilet;
  }

  factory Toilet.fromJson(Map<String, dynamic> json) => _ToiletFromJson(json);

  Map<String, dynamic> toJson() => _ToiletToJson(this);

  @override
  String toString() => 'Toilet<$referenceId>';

}

Toilet _ToiletFromJson(Map<String, dynamic> json) {
  return Toilet(
    json['location'] as Map<String, dynamic>);


}


Map<String, dynamic> _ToiletToJson(Toilet instance) => <String, dynamic> {
  'location': instance.location
};

