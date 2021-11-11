import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  final String _apiKey = 'a52176c20646bf8eb49ca023d86fe00e';
  final String _url = 'api.themoviedb.org';
  final String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;
  final List<Pelicula> _populares = [];

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> getEnCines() async {
    const endpoint = '3/movie/now_playing';
    final Uri url =
        Uri.https(_url, endpoint, {'api_key': _apiKey, 'language': _language});
    return await getDataFromURL(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;
    const endpoint = '3/movie/popular';
    final Uri url = Uri.https(_url, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await getDataFromURL(url);
    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final endpoint = '3/movie/$peliId/credits';
    final url =
        Uri.https(_url, endpoint, {'api_key': _apiKey, 'language': _language});
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> getDataFromURL(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    const endpoint = '3/search/movie';
    final url = Uri.https(_url, endpoint,
        {'api_key': _apiKey, 'language': _language, 'query': query});

    return await getDataFromURL(url);
  }

  Future<ActorDetalle> getActorInfo(String actorId) async {
    final endpoint = '3/person/$actorId';
    final url =
        Uri.https(_url, endpoint, {'api_key': _apiKey, 'language': _language});
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    return ActorDetalle.fromJsonMap(decodedData);
  }
}
