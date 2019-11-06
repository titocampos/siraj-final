const String BACKEND_SERVER_LINK = "http://10.24.24.170:3500/";
const String STRIPE_KEY_PUB = "pk_test_a6Q0SlZO4gB0C9lSQO5l1pnR00XwxOZWfi";

String getUrl(String path) {
  return BACKEND_SERVER_LINK + _createCorrectPath(path);
}

String _createCorrectPath(String path) {
  return path.startsWith("/") ? path.substring(1) : path;
}
