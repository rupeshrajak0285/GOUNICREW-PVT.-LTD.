import 'common_libraries.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // local storage and dio have to be ready before the first screen
  await Prefs.init();
  await ApiClientService.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // repositories are created once here and read inside the blocs
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(create: (_) => ProductRepository()),
        RepositoryProvider<ProductLocalStorage>(create: (_) => ProductLocalStorage()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.primaryColor,
            primary: AppColor.primaryColor,
          ),
          scaffoldBackgroundColor: AppColor.backgroundColor,
        ),
        home: const ProductListPage(),
      ),
    );
  }
}
