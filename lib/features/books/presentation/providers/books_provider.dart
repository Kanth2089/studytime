import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/books_service.dart';
import '../../domain/book_model.dart';

class BooksProvider extends ChangeNotifier {
  final BooksService _booksService = BooksService();

  List<BookModel> _allBooks = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filtering and category select
  String _selectedCategory = 'All';
  bool _showFavoritesOnly = false;

  // Track download progress for books: bookId -> progress (0.0 to 1.0)
  final Map<String, double> _downloadProgress = {};

  List<BookModel> get allBooks => _allBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  bool get showFavoritesOnly => _showFavoritesOnly;

  Map<String, double> get downloadProgress => _downloadProgress;

  List<BookModel> get filteredBooks {
    return _allBooks.where((book) {
      final matchesCategory = _selectedCategory == 'All' || book.category == _selectedCategory;
      final matchesFavorite = !_showFavoritesOnly || book.isFavorite;
      return matchesCategory && matchesFavorite;
    }).toList();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleFavoritesOnly(bool value) {
    _showFavoritesOnly = value;
    notifyListeners();
  }

  // Fetch books
  Future<void> fetchBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _allBooks = await _booksService.getBooks();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle Favorite
  Future<void> toggleBookFavorite(String bookId) async {
    final idx = _allBooks.indexWhere((b) => b.id == bookId);
    if (idx != -1) {
      final book = _allBooks[idx];
      final newFavStatus = !book.isFavorite;
      _allBooks[idx] = book.copyWith(isFavorite: newFavStatus);
      notifyListeners();

      try {
        await _booksService.toggleFavorite(bookId, newFavStatus);
      } catch (e) {
        // revert on error
        _allBooks[idx] = book;
        notifyListeners();
      }
    }
  }

  // Simulate Downloading a Book
  Future<void> downloadBook(String bookId) async {
    if (_downloadProgress.containsKey(bookId)) return; // already downloading

    _downloadProgress[bookId] = 0.0;
    notifyListeners();

    double progress = 0.0;
    Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      progress += 0.1;
      if (progress >= 1.0) {
        progress = 1.0;
        _downloadProgress[bookId] = progress;
        timer.cancel();

        // Update download status in service
        final localPath = 'mock_storage/books/$bookId.pdf';
        await _booksService.setDownloadedStatus(bookId, true, localPath);
        
        // Update local list
        final idx = _allBooks.indexWhere((b) => b.id == bookId);
        if (idx != -1) {
          _allBooks[idx] = _allBooks[idx].copyWith(isDownloaded: true, localPath: localPath);
        }
        _downloadProgress.remove(bookId);
        notifyListeners();
      } else {
        _downloadProgress[bookId] = progress;
        notifyListeners();
      }
    });
  }

  // Admin add a book
  Future<void> addNewBook(BookModel book) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _booksService.addBook(book);
      _allBooks.add(book);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
