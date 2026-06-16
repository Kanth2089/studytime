class BookModel {
  final String id;
  final String title;
  final String author;
  final String category; // Police, Banking, Railway, SSC, Groups, TSPSC, APPSC
  final String pdfUrl;
  final String fileSize;
  final bool isFavorite;
  final bool isDownloaded;
  final String? localPath;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.pdfUrl,
    required this.fileSize,
    this.isFavorite = false,
    this.isDownloaded = false,
    this.localPath,
  });

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? category,
    String? pdfUrl,
    String? fileSize,
    bool? isFavorite,
    bool? isDownloaded,
    String? localPath,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      category: category ?? this.category,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      fileSize: fileSize ?? this.fileSize,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      localPath: localPath ?? this.localPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'pdfUrl': pdfUrl,
      'fileSize': fileSize,
      'isFavorite': isFavorite,
      'isDownloaded': isDownloaded,
      'localPath': localPath,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      category: map['category'] ?? '',
      pdfUrl: map['pdfUrl'] ?? '',
      fileSize: map['fileSize'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      isDownloaded: map['isDownloaded'] ?? false,
      localPath: map['localPath'],
    );
  }
}
