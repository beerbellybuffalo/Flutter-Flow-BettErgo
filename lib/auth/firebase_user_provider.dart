import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class BetterSittFirebaseUser {
  BetterSittFirebaseUser(this.user);
  final User user;
  bool get loggedIn => user != null;
}

BetterSittFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<BetterSittFirebaseUser> betterSittFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<BetterSittFirebaseUser>(
            (user) => currentUser = BetterSittFirebaseUser(user));
