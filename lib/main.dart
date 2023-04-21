import 'package:crudhive/dbmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'useradd.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerAdapter());
  await Hive.openBox<Customer>('cruddb');
  runApp(const MyApp());
}

class Themebase extends ChangeNotifier {
  bool theme = false;
  void change(val) {
    theme = val;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Themebase(),
      builder: (context, child) {
        return Consumer<Themebase>(builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Crud App',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: value.theme ? ThemeMode.dark : ThemeMode.light,
            home: const MyHomePage(),
          );
        });
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD APP'),
        actions: [
          Consumer<Themebase>(builder: (context, value, child) {
            return IconButton(
                onPressed: () {
                  bool cval = !value.theme;
                  value.change(cval);
                },
                icon: Icon(value.theme ? Icons.light_mode : Icons.dark_mode));
          }),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Customer>('cruddb').listenable(),
          builder: (context, Box<Customer> box, child) {
            if (box.values.isEmpty) {
              return const Center(
                child: Text('Database is empty'),
              );
            }
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, i) {
                  var val = box.getAt(i);
                  return ListTile(
                    title: Text(val!.name.toString()),
                    subtitle: Text(val.phone.toString()),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete'),
                                  content: Text(val.name.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        box.deleteAt(i);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('delete'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('cancel'),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.delete)),
                    onLongPress: () {
                      name.text = val.name.toString();
                      phone.text = val.phone.toString();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Update'),
                              content: SizedBox(
                                height: 120.0,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                      controller: name,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.phone),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      controller: phone,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    box.putAt(
                                        i,
                                        Customer(
                                            name: name.text,
                                            phone: int.parse(phone.text)));
                                    Navigator.pop(context);
                                  },
                                  child: const Text('update'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('cancel'),
                                ),
                              ],
                            );
                          });
                    },
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Add()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
