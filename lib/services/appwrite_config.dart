import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Initialise et configure le client Appwrite
Client getClient() {
  final client = Client();
  return client
      .setEndpoint(dotenv.env['APPWRITE_ENDPOINT']!) // Endpoint Appwrite
      .setProject(dotenv.env['APPWRITE_PROJECT_ID']!); // Project ID
}

/// Obtenir l'instance Account
Account getAccount(Client client) {
  return Account(client);
}
