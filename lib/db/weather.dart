import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ynov_weather/models/weather.dart';

class WeatherDatabase {
  static final WeatherDatabase instance = WeatherDatabase._init();

  static Database? _database;

  WeatherDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('weather.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableWeather(
      ${CityFields.id} $idType,
      ${CityFields.name} $textType
    )
    ''');
  }

  Future<City> create(City city) async {
    final db = await instance.database;

    final id = await db.insert(tableWeather, city.toJson());

    return city.copy(id: id);
  }

  Future<City> readCity(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableWeather,
      columns: CityFields.values,
      where: '${CityFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return City.fromJson(maps.first);
    } else {
      throw Exception('ID $id not fount');
    }
  }

  Future<List<City>> readAllNotes() async {
    final db = await instance.database;

    const orderBy = '${CityFields.name} ASC';

    final result = await db.query(tableWeather, orderBy: orderBy);

    return result.map((json) => City.fromJson(json)).toList();
  }

  Future<int> update(City city) async {
    final db = await instance.database;
    return db.update(
      tableWeather,
      city.toJson(),
      where: '${CityFields.id} = ?',
      whereArgs: [city.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(
      tableWeather,
      where: '${CityFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
