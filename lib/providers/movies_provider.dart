import 'package:cartelera/models/images_response.dart';
import 'package:cartelera/models/upcoming_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cartelera/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  MoviesProvider() {
    this.getOnDisplayMovies();
  }
  final String _apiKey = "d070e0fd80422b7ae7c2736a6da2b92e";
  final String _baseUrl = "api.themoviedb.org";
  final String _language = "es-ES";

  void getNowMovies() async {
    //Llamado al API
    final url = Uri.https(_baseUrl, '3/movie/580489', //'3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language, 'page': '1'});
    final response = await http.get(url);
    print(response.body);
    final movie = Movie.fromJson(response.body);
    print(movie.backdropPath);
    //print(nowPlayingResponse.results[0].title);
    //notifyListeners();
  }

  //Future obtener async
  Future<NowPlayingResponse> getOnDisplayMovies() async {
    //Llamado al API
    final url =
        Uri.https(_baseUrl, '3/movie/now_playing', //'3/movie/580489', //
            {'api_key': _apiKey, 'language': _language, 'page': '1'});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //ok
      return NowPlayingResponse.fromJson(response.body);
    } else {
      print(response.statusCode);
      throw Exception("Fail");
    }
  }

  Future<TopRatedResponse> getOnTopMovies() async {
    //Llamado al API
    final url = Uri.https(_baseUrl, '3/movie/top_rated', //'3/movie/580489', //
        {'api_key': _apiKey, 'language': _language, 'page': '1'});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //ok
      return TopRatedResponse.fromJson(response.body);
    } else {
      print(response.statusCode);
      throw Exception("Fail");
    }
  }

  Future<SimilarMoviesResponse> getSimilarMovie(int index) async {
    //Llamado al API
    final url = Uri.https(
        _baseUrl, '3/movie/$index/similar', //'3/movie/now_playing', //
        {'api_key': _apiKey, 'language': _language, 'page': '1'});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //ok
      return SimilarMoviesResponse.fromJson(response.body);
    } else {
      print(response.statusCode);
      throw Exception("Fail");
    }
  }

  Future<CreditsResponse> getCastingMovie(int index) async {
    //Llamado al API
    final url = Uri.https(
        _baseUrl, '3/movie/$index/credits', //'3/movie/now_playing', //
        {'api_key': _apiKey, 'language': _language, 'page': '1'});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //ok
      return CreditsResponse.fromJson(response.body);
    } else {
      print(response.statusCode);
      throw Exception("Fail");
    }
  }

  Future<ImagesResponse> getImages(int index) async {
    //Llamado al API
    final url =
        Uri.https(_baseUrl, '3/movie/$index/images', //'3/movie/now_playing', //
            {'api_key': _apiKey});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //ok
      return ImagesResponse.fromJson(response.body);
    } else {
      print(response.statusCode);
      throw Exception("Fail");
    }
  }

  void getData() async {
    //Llamado al API
    final url =
        Uri.https(_baseUrl, '3/movie/580489/images', //'3/movie/now_playing',
            {'api_key': _apiKey});
    final response = await http.get(url);
    print(response.body);
    final image = ImagesResponse.fromJson(response.body);
    print(image.backdrops);
    print('Aqui estoy');
    //print(nowPlayingResponse.results[0].title);
    //notifyListeners();
  }

  Future<UpcomingResponse> getUpcomingMovies() async {
    //Llamado al API
    final url = Uri.https(_baseUrl, '3/movie/upcoming', //'3/movie/580489', //
        {'api_key': _apiKey, 'language': _language, 'page': '1'});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //ok
      return UpcomingResponse.fromJson(response.body);
    } else {
      print(response.statusCode);
      throw Exception("Fail");
    }
  }
}
