import 'package:testapp/fab_with_icons.dart';
import 'package:testapp/fab_bottom_app_bar.dart';
import 'package:testapp/layout.dart';
import 'package:testapp/Vw_Sincronizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new Login(),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Configurar parametros de conexion',
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ConfigurationPage()));
            },
          ),
        ],
      ),
      body: Center(child: LoginForm()),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Container(
        alignment: Alignment(0.0, 0.0),
        constraints: BoxConstraints.expand(width: 290.0, height: 300.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre de Usuario',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                ),
                /*validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor ingrese un usuario valido';
                  }
                },*/
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  /* validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese una contraseña valida';
                    }
                  },*/
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ButtonTheme(
                  minWidth: 200.0,
                  height: 50.0,
                  child: RaisedButton(
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, we want to show a Snackbar
                        /*Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));*/
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new MyHomePage(title: '')));
                      }
                    },
                    child: Text('Iniciar sesion'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _lastSelected = 'TAB: 0';
  bool estadoModal=false;

  @override
  void initState() {
    super.initState();

  }

  void refresh(bool estado) {
    setState(() {
      estadoModal =estado;
    });
  }

  int _selectedIndex = 0;
  bool showFaloating = true;

  Widget _buildWidget(_selectedIndex) {
    switch (_selectedIndex) {
      case 0:
        {
          return new MostrarSincronizacion();
        }
        break;

      case 1:
        {
          return new Sincronizar(notifyParent: refresh);

        }
        break;
      case 2:
        {
          return new BarCodePage(title: 'Aplicacion Demo');
        }
        break;
      case 3:
        {
          return new SecondScreen();
        }
        break;

      default:
        {
          return new  SecondScreen();
        }
        break;
    }
  }

  void _onItemTapped(int index) {
    /*if (index==0) {
      Navigator.push(
          context, new MaterialPageRoute(
          builder: (context) => new BarCodePage(title: 'Aplicacion Demo')));
    }*/
    setState(() {
      _selectedIndex = index;
    });
  }

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _buildWidget(_selectedIndex),
      ),
      bottomNavigationBar: FABBottomAppBar(

        color: Colors.grey,
        selectedColor: Colors.red,

        onTabSelected: _onItemTapped,
        items: [
          FABBottomAppBarItem(iconData: Icons.view_list, text: 'Articulos'),
          FABBottomAppBarItem(iconData: Icons.autorenew, text: 'Actualizar'),
          FABBottomAppBarItem(iconData: Icons.camera , text: 'Escanear'),
          FABBottomAppBarItem(iconData: Icons.build, text: 'Configurar'),
        ],
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floatingActionButton: _buildFab(
      //    context), // This trailing comma makes auto-formatting nicer for build methods.
    );


  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ModalProgressHUD(child: _body(), inAsyncCall: estadoModal),
    );

  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.local_grocery_store, Icons.note, Icons.phone];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 1.0,
      ),
    );
  }
}

class Post {
  //final int userId;
  //final int id;
  final String nombreArticulo;

  //final String body;

  Post({this.nombreArticulo});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      //userId: json['userId'],
      //id: json['id'],
      nombreArticulo: json['NombreArticulo'],
      //body: json['body'],
    );
  }
}

Future<List<Post>> fetchPost() async {
  Map data;
  final response =

      //await http.get('https://jsonplaceholder.typicode.com/posts');
      await http.post(
          'http://192.168.0.93:80/inventario.aspx/consultarArticulosJson',
          headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    data = jsonDecode(response.body);
    List responseJson = json.decode(data['d']);

    return responseJson.map((m) => new Post.fromJson(m)).toList();
    //return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class SecondScreen extends StatefulWidget {
  final Future<List<Post>> post;

  SecondScreen({Key key, this.post}) : super(key: key);

  @override
  SecondScreenState createState() => new SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Post>>(
      future: fetchPost(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            List<Post> posts = snapshot.data;
            return Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.album),
                      title: Text(
                        posts[index].nombreArticulo,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      subtitle: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Precio:'),
                              Text('Strock:'),
                              Text('Estado:'),
                              Text('Codigo de Barraa:'),
                            ]),
                      ),
                    ),
                    ButtonTheme.bar(
                      // make buttons use the appropriate styles for cards
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('REVISAR'),
                            onPressed: () {
                              /* ... */
                            },
                          ),
                          FlatButton(
                            child: const Text('CONTAR'),
                            onPressed: () {
                              /* ... */
                            },
                          ),
                        ],
                      ),
                    ),
                  ])),
            );
          },
        );
      },
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: widget.post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }*/
}

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => new _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  @override
  void initState() {
    super.initState();
    getParametros();
  }

  TextEditingController _servidorController = new TextEditingController();
  SharedPreferences sharedPreferences;

  _conectarServidor(String servidor) async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getString('servidor'));
    await sharedPreferences.setString('servidor', servidor);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new Login()));
  }

  getParametros() async {
    sharedPreferences = await SharedPreferences.getInstance();

    _servidorController.text = sharedPreferences.getString("servidor");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuracion de Conexion"),
      ),
      body: Center(
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Ingrese Direccion del Servidor:',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Direccion IP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  controller: _servidorController,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _conectarServidor(_servidorController.text.toString());
                },
                child: Text("Sincronizar"),
              ),
            ]),
      ),
    );
  }
}

class BarCodePage extends StatefulWidget {
  BarCodePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BarCodePageState createState() => new _BarCodePageState();
}

class _BarCodePageState extends State<BarCodePage> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  initPlatformState();
                },
                child: Text("Start barcode scan"),
              ),
              Text(
                'Scan result : $_scanBarcode\n',
                style: TextStyle(fontSize: 20),
              ),
            ]),
      ),
    );
  }
}
