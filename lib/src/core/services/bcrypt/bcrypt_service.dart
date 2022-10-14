abstract class BCryptService {
  String gerenateHash(String text);
  bool checkHash(String text, String hash);
}
