import 'package:flutter/material.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final _URL_NEWS = 'https://newsapi.org/v2';
final _API_KEY = '9f306dc2b0174f3d9b9cbb825747de85';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business';

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopeHeadline();
    categories.forEach((item) {
      this.categoryArticles[item.name] = [];
    });
  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  List<Article> get getArticulosCategoria => this.categoryArticles[this.selectedCategory];

  getTopeHeadline() async {
    final url = '$_URL_NEWS/top-headlines?apiKey=$_API_KEY&country=co';
    final resp = await http.get(Uri.parse(url));
    final newsResponse = newsResponseFromJson(resp.body);
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (this.categoryArticles[category].length > 0) {
      return this.categoryArticles[category];
    }

    final url = '$_URL_NEWS/top-headlines?apiKey=$_API_KEY&country=co&category=$category';
    final resp = await http.get(Uri.parse(url));
    final newsResponse = newsResponseFromJson(resp.body);
    this.categoryArticles[category].addAll(newsResponse.articles);
    notifyListeners();
  }
}