const String tableWeather = 'cities';


class CityFields{

  static final List<String> values = [
    id,name
  ];

  static const String id = '_id';
  static const String name = 'name';
}


class City {
  final int? id;
  final String? name;

  const City({
    this.id,
    this.name,
  });

  City copy({
    int? id,
    String? name,
  }) => City(
    id: id ?? this.id,
    name: name ?? this.name
  );

  static City fromJson(Map<String,Object?> json) => City(
    id: json[CityFields.id] as int?,
    name : json[CityFields.name] as String?,
  );


  Map<String,Object?> toJson() => {
    CityFields.id : id,
    CityFields.name : name,
  };

}
