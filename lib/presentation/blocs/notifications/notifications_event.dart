part of 'notifications_bloc.dart';

// en esta calse no se necesita el equatable, para confirmar que dos eventos no son iguales
abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus
      status; //este es el argumento que voy a recibir cuando se dispare el evento, y es del mismo tipo que el que esta en el notification_state
  //la regla recomendada de cleancode es que si vamos a recibir mas de tres argumentos
  // creamos un objeto para ello el constructor quedaria asi
  //NotificationStatusChanged({this.status, this.status2, this.status3});
  //si es menor que tres, entonces se podria poner posicional
  //quedando asi 
  NotificationStatusChanged(this.status);
}

// TODO 2: Creamos el evento que se va a mandar a llamar en el notiications_bloc
//aqui voy a recibir un PushMessage
class NotificationReceived extends NotificationsEvent {
  final PushMessage pushMessage;
  NotificationReceived(this.pushMessage);
}
