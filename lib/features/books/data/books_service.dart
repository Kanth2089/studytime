import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/firebase_config.dart';
import '../domain/book_model.dart';

class BooksService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Preseeded books in case database is empty or offline
  static final List<BookModel> _defaultBooks = [
    BookModel(id: 'b1', title: 'Police SI Complete Guide', author: 'Vijeta Competitions', category: 'Police', pdfUrl: 'https://example.com/books/si_guide.pdf', fileSize: '12.5 MB'),
    BookModel(id: 'b2', title: 'AP Police SI Paper 1 (Telugu)', author: 'Ramesh Publications', category: 'Police', pdfUrl: 'https://example.com/books/ap_si.pdf', fileSize: '9.8 MB'),
    BookModel(id: 'b3', title: 'Bank PO Quantitative Aptitude', author: 'R.S. Aggarwal', category: 'Banking', pdfUrl: 'https://example.com/books/quant.pdf', fileSize: '18.2 MB'),
    BookModel(id: 'b4', title: 'Banking Awareness Special', author: 'Arihant Experts', category: 'Banking', pdfUrl: 'https://example.com/books/banking_awareness.pdf', fileSize: '8.4 MB'),
    BookModel(id: 'b5', title: 'Railway RRB NTPC General Studies', author: 'Speedy Publications', category: 'Railway', pdfUrl: 'https://example.com/books/rrb_gs.pdf', fileSize: '14.1 MB'),
    BookModel(id: 'b6', title: 'Railway Arithmetic Special', author: 'S. Chand', category: 'Railway', pdfUrl: 'https://example.com/books/rrb_math.pdf', fileSize: '11.0 MB'),
    BookModel(id: 'b7', title: 'SSC CGL Advanced Mathematics', author: 'Kiran Publications', category: 'SSC', pdfUrl: 'https://example.com/books/ssc_math.pdf', fileSize: '22.4 MB'),
    BookModel(id: 'b8', title: 'SSC General Intelligence & Reasoning', author: 'R.S. Aggarwal', category: 'SSC', pdfUrl: 'https://example.com/books/ssc_reasoning.pdf', fileSize: '15.6 MB'),
    BookModel(id: 'b9', title: 'Groups Paper 1 General Studies (Telugu)', author: 'Telugu Academy', category: 'Groups', pdfUrl: 'https://example.com/books/groups_p1.pdf', fileSize: '16.8 MB'),
    BookModel(id: 'b10', title: 'Indian Constitution & Polity', author: 'M. Laxmikanth', category: 'Groups', pdfUrl: 'https://example.com/books/laxmikanth.pdf', fileSize: '34.5 MB'),
    BookModel(id: 'b11', title: 'Telangana History & Movement', author: 'Telugu Academy', category: 'TSPSC', pdfUrl: 'https://example.com/books/ts_history.pdf', fileSize: '19.2 MB'),
    BookModel(id: 'b12', title: 'AP History & Economy Guide', author: 'Prasanna Publications', category: 'APPSC', pdfUrl: 'https://example.com/books/ap_history.pdf', fileSize: '17.4 MB'),
  ];

  // Initialize books in SharedPreferences/Firestore if not present
  Future<void> initializeBooks() async {
    if (FirebaseConfig.isFirebaseAvailable) {
      try {
        final collection = _firestore.collection('books');
        final query = await collection.limit(1).get();
        if (query.docs.isEmpty) {
          for (var book in _defaultBooks) {
            await collection.doc(book.id).set(book.toMap());
          }
        }
      } catch (e) {
        print("Error initializing books in Firestore: $e");
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? booksJson = prefs.getString('mock_books');
      if (booksJson == null) {
        final booksMapList = _defaultBooks.map((e) => e.toMap()).toList();
        await prefs.setString('mock_books', jsonEncode(booksMapList));
      }
    }
  }

  // Fetch all books
  Future<List<BookModel>> getBooks() async {
    await initializeBooks();
    if (FirebaseConfig.isFirebaseAvailable) {
      try {
        final query = await _firestore.collection('books').get();
        return query.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
      } catch (e) {
        print("Error fetching books from Firestore: $e");
      }
    }
    
    // Fallback to local mock data
    final prefs = await SharedPreferences.getInstance();
    final String? booksJson = prefs.getString('mock_books');
    if (booksJson != null) {
      final List<dynamic> list = jsonDecode(booksJson);
      return list.map((item) => BookModel.fromMap(Map<String, dynamic>.from(item))).toList();
    }
    return _defaultBooks;
  }

  // Toggle favorite
  Future<void> toggleFavorite(String bookId, bool isFavorite) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firestore.collection('books').doc(bookId).update({'isFavorite': isFavorite});
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? booksJson = prefs.getString('mock_books');
      if (booksJson != null) {
        final List<dynamic> list = jsonDecode(booksJson);
        final updatedList = list.map((item) {
          final map = Map<String, dynamic>.from(item);
          if (map['id'] == bookId) {
            map['isFavorite'] = isFavorite;
          }
          return map;
        }).toList();
        await prefs.setString('mock_books', jsonEncode(updatedList));
      }
    }
  }

  // Simulate download (or actual download if we want to hook it to storage path)
  Future<void> setDownloadedStatus(String bookId, bool isDownloaded, String? localPath) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firestore.collection('books').doc(bookId).update({
        'isDownloaded': isDownloaded,
        'localPath': localPath,
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? booksJson = prefs.getString('mock_books');
      if (booksJson != null) {
        final List<dynamic> list = jsonDecode(booksJson);
        final updatedList = list.map((item) {
          final map = Map<String, dynamic>.from(item);
          if (map['id'] == bookId) {
            map['isDownloaded'] = isDownloaded;
            map['localPath'] = localPath;
          }
          return map;
        }).toList();
        await prefs.setString('mock_books', jsonEncode(updatedList));
      }
    }
  }

  // Admin: Add a new book
  Future<void> addBook(BookModel book) async {
    if (FirebaseConfig.isFirebaseAvailable) {
      await _firestore.collection('books').doc(book.id).set(book.toMap());
    } else {
      final prefs = await SharedPreferences.getInstance();
      final String? booksJson = prefs.getString('mock_books');
      final List<dynamic> list = booksJson != null ? jsonDecode(booksJson) : [];
      list.add(book.toMap());
      await prefs.setString('mock_books', jsonEncode(list));
    }
  }
}
