class Observable {
  List<Observer> _observers;

  Observable() {
    _observers = [];
  }

  void registerObserver(Observer observer) {
    _observers.add(observer);
  }

  void notify_observers() {
    for (var observer in _observers) {
      observer.notify();
    }
  }
}

class Observer {
  String name;

  Observer(this.name);

  void notify() {
    // print("[${notification.timestamp.toIso8601String()}] Hey $name, ${notification.message}!");
  }
}
