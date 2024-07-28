class EmptyCacheException implements Exception {}

class ServiceException implements Exception {
  final String message;

  ServiceException(this.message);
}
