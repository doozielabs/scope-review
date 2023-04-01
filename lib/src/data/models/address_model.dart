class Address {
  late String street;
  late String city;
  late String state;
  late String zipcode;

  Address({
    this.street = "",
    this.city = "",
    this.state = "",
    this.zipcode = "",
  });

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    return data;
  }
}

class Cordinates {
  late double lat;
  late double long;
  late String id;

  Cordinates({this.lat = 0, this.long = 0, this.id = ""});

  Cordinates.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    lat = json['lat'].toDouble();
    long = json['long'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}
