import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/screens/details_screen.dart';
import 'package:push_app/presentation/screens/home_screen.dart';


//Nota cuando se crean las rutas es necesario modificar el main, y a MaterialApp agregarle el ".router"
// quedaria asi: MaterialApp.router()
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/push-details/:messageId',
      //builder: (context, state) => DetailsScreen( pushMessageId: state.params['messageId'] ?? '', ),
    ),

  ]
  
);