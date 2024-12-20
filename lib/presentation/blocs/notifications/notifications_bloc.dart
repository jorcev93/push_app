
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:push_app/domain/entities/push_message.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}



class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //la notificationsBloc la vamos a utilizar en toda la aplicacion
  NotificationsBloc() : super( const NotificationsState() ) {

    //el evento que vamos a manejar es el evento que acabamos de crear en el el archivo notification_event.dart
    //que es el NotificationStatusChanged
    on<NotificationStatusChanged>( _notificationStatusChanged );
    //TODO 3: creamos un listener # _onpushMessageReceived
     on<NotificationReceived>( _onPushMessageReceived );

    // Verificar estado de las notificaciones
    _initialStatusCheck();

    // Listener para notificaciones en Foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChanged( NotificationStatusChanged event, Emitter<NotificationsState> emit ) {
    //eminitimos uun nuevo estado
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();//lo mandamos a llamar aqui para tenerlo centralizado cuando cambia el estado
  }
  
  void _onPushMessageReceived( NotificationReceived event, Emitter<NotificationsState> emit ) {
    emit(
      state.copyWith(
        notifications: [ event.pushMessage, ...state.notifications ]
      )
    );
  }

//esto me ayuda a que cuando ya este dado el permiso, el estado no se este 
  void _initialStatusCheck() async {
    // a diferencia del requestPermission este solo obtengo getNotificationSettings y no el requestPermission
    final settings = await messaging.getNotificationSettings();//este setting permite saber el estado actual
    add( NotificationStatusChanged(settings.authorizationStatus) );
  }

  //con esto vamos a obtener el token de la app
  //y va  aser unica cada vez que se instale la app
  //es decir que si ya esta instalada y la borra y la vuelve a instalar se generara un nuevo token
  void _getFCMToken() async {//el significado de FMC es firebase cloud messagin
    //si el estado es autorizado voy a mandar a llamar al token
    if ( state.status != AuthorizationStatus.authorized ) return;
  
    final token = await messaging.getToken();
    print(token);
  }

  //metodo para manejar los mensajes remotos
  void handleRemoteMessage( RemoteMessage message ) {
    if (message.notification == null) return;//si no hay un mensaje simplemente retorna
    
    final notification = PushMessage(
      messageId: message.messageId
        ?.replaceAll(':', '').replaceAll('%', '')//si en el messageId viene con alguna de estas caracteres ":,%" lo limpio
        ?? '',// si no de tiene lo puedo dejar como un string vacio
      title: message.notification!.title ?? '',//si el titulo viene null envio un string vacio
      body: message.notification!.body ?? '',//si el cuerpo viene null envio un string vacio
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
        ? message.notification!.android?.imageUrl
        : message.notification!.apple?.imageUrl
    );
    // TODO 1: add de un nuevo evento
    //antes de añadir un nuevo evento, tengo que definirlo en notifications_event
    add( NotificationReceived(notification) );//disparamos el evento que creamos en otifications_event
    
  }

  void _onForegroundMessage(){ 
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }


  void requestPermission() async {
    //aqui solicito el permiso, y mantengo el estado
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    add( NotificationStatusChanged(settings.authorizationStatus) );
  }

  PushMessage? getMessageById( String pushMessageId ) {
    final exist = state.notifications.any((element) => element.messageId == pushMessageId );
    if ( !exist ) return null;

    return state.notifications.firstWhere((element) => element.messageId == pushMessageId );
  }
}
