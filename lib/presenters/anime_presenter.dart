import 'package:flutter_application_1/models/anime_model.dart';
import 'package:flutter_application_1/network/base_network.dart';

abstract class AnimeView {
  void showLoading();
  void hideLoading();
  void showAnimeList(List<Anime> animeList);
  void showError(String message);
}

class AnimePresenter {
  final AnimeView view;

  AnimePresenter(this.view);

  void loadAnimeData(String endpoint) async {
    view.showLoading();
    try {
      final data = await BaseNetwork.getData(endpoint);
      final animeList = data.map<Anime>((item) => Anime.fromJson(item)).toList();
      view.showAnimeList(animeList);
    } catch (e) {
      view.showError(e.toString());
    } finally {
      view.hideLoading();
    }
  }
}
