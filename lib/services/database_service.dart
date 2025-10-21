import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'appwrite_config.dart';

class DatabaseService {
  final Client _client = getClient();
  late final Databases _databases;

  DatabaseService() {
    _databases = Databases(_client);
  }

  Future<List<Document>> listDocuments({List<String>? queries}) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        queries: queries,
      );
      return response.documents;
    } catch (e) {
      print('Error listing documents: $e');
      throw e;
    }
  }

  Future<Document> createDocument(Map<String, dynamic> data) async {
    try {
      return await _databases.createDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: ID.unique(),
        data: data,
      );
    } catch (e) {
      print('Error creating document: $e');
      throw e;
    }
  }

  Future<Document> updateDocument(String documentId, Map<String, dynamic> data) async {
    try {
      return await _databases.updateDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: documentId,
        data: data,
      );
    } catch (e) {
      print('Error updating document: $e');
      throw e;
    }
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      await _databases.deleteDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: documentId,
      );
    } catch (e) {
      print('Error deleting document: $e');
      throw e;
    }
  }
}
