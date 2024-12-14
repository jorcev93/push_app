part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  // AuthorizationStatus lo impoortamos de firebase_messaging.dart
  //aqui no se imprta por qu este este archivo es parte de notification_bloc
  //con esta variable vamos a saber cual es el estado de nuestras notificaciones es decir si esta negado, utilizado etc,
  final AuthorizationStatus status;//con esto sabemos el estado de nuestras notificaciones si esq esta utilizado, negado etc..
  //TODO: crea mi modelo de notificaciones
  //con esta variable mantenemos un listado de nuestras notificaiones push
  final List<dynamic> notifications;//de monento va el tipo de dato va a ser dinamico
  
  // final List<PushMessage> notifications;

  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined, // al estado lo inicializamos como no determinado porque a pesar de que ya lo autorice no sabemos que va  a ser
    this.notifications = const[],//las notificaciones de inicio van a ser un arreglo vacio
  });

  //el copywhit es basicamente para crear copias de un estado
  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notifications,
  }) => NotificationsState(
    status: status ?? this.status, //el estado va a ser igual al que se envia caso contrario va a ser igaul al que se definio en el constructor
    notifications: notifications ?? this.notifications,//la notificaion va a ser la notificacion que recibimos y si no viene va a ser igual a this.notification
  );
  
  @override
  List<Object> get props => [ status, notifications ];
}