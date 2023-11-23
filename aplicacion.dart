import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u3_productos/baseremota.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'baseremota.dart';
class App34 extends StatefulWidget {
  const App34({super.key});

  @override
  State<App34> createState() => _App34State();
}

class _App34State extends State<App34> {
  @override
  String titulo = "";
  String subtitulo = "";
  final id = TextEditingController();
  final nombre = TextEditingController();
  final clase = TextEditingController();
  final fechaInscripcion = TextEditingController();
  final cobro = TextEditingController();

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Gimnasio"),
              bottom: TabBar(
                tabs: [
                  Text("Alumnos", style: TextStyle(fontSize: 18),),
                  Text("Agregar", style: TextStyle(fontSize: 18),),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                mostrar(),
                insertar(),
              ],
            )
        )
    );
  }
  var basedatos = FirebaseFirestore.instance;
  Widget mostrar(){
    return FutureBuilder(
      future: getAlumno(),
      builder: ((context, snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){

                  showDialog(context: context, builder: (builder){
                    return AlertDialog(
                      title: Text("ATENCIÓN"),
                      content: Text("¿QUE DESEA HACER CON ESTE ALUMNO?"),
                      actions: [
                        TextButton(onPressed: () async{
                          String id = snapshot.data?[index]['id'];
                          actualizar(id);

                          setState(() { });
                        }, child: const Text("ACTUALIZAR")),
                        TextButton(onPressed: () async{
                          await eliminar(snapshot.data?[index]['id']).then((value){
                            setState(() {
                              Navigator.pop(context);
                              App34();
                            });
                          });
                        }, child: const Text("ELIMINAR")),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: const Text("NADA")),
                      ],
                    );
                  });

                },
                child: ListTile(
                  //leading: ,
                  title: Text("${snapshot.data?[index]['nombre']}: ${snapshot.data?[index]['clase']}"),
                  subtitle: Text("De: ${snapshot.data?[index]['fechaInscripcion']} - Cobro: ${snapshot.data?[index]['cobro']}"),
                  trailing:Icon(Icons.library_books_outlined),
                ),
              );
              //Text(snapshot.data?[index]['placa']);
            },
          );
        }else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget insertar(){
    return SingleChildScrollView(
      child: Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "- A G R E G A R -",
              style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 30,),
            TextField(
              controller: id,
              decoration: InputDecoration(
                  labelText: "id:"
              ),
            ),
            SizedBox(height: 20,),
            TextField(
                controller: nombre,
                decoration: InputDecoration(
                    labelText: "Nombre:"
                ),
                keyboardType: TextInputType.number
            ),
            SizedBox(height: 20,),
            TextField(
              controller: clase,
              decoration: InputDecoration(
                  labelText: "Clase:"
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: fechaInscripcion,
              decoration: InputDecoration(
                  labelText: "Fecha de inscripción:"
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: cobro,
              decoration: InputDecoration(
                  labelText: "Cobro:"
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  var basedatos = FirebaseFirestore.instance;

                  basedatos.collection("alumnos").add({
                    'id': id.text,
                    'nombre': nombre.text,
                    'clase':clase.text,
                    'fechaInscripcion': fechaInscripcion.text,
                    'cobro': int.parse(cobro.text)
                  }).then((value){
                    setState(() {
                      ScaffoldMessenger.of(context).
                      showSnackBar(SnackBar(content: Text("Se insertó correctamente")));
                      id.text ="";
                      nombre.text="";
                      clase.text="";
                      fechaInscripcion.text="";
                      cobro.text="";
                    });
                  });
                },
                child: const Text("Aceptar")
            )
          ],
        ),
      ),
    ),
    );
  }


  Future<List> getAlumno() async{
    List alumnos = [];
    CollectionReference coleccionA = baseRemota.collection('alumnos');

    QuerySnapshot queryAlumno = await coleccionA.get();

    for(var doc in queryAlumno.docs){
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final alumno = {
        "nombre": data['nombre'],
        "clase": data['clase'],
        "fechaInscripcion": data['fechaInscripcion'],
        "cobro": data['cobro'],
        "id": doc.id,
      };
      alumnos.add(alumno);
    }
    return alumnos;
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("alumnos").
    doc(id).delete();
  }

  void actualizar(String ID) async{
    final id = TextEditingController(text: "${ID}");
    final nombre = TextEditingController();
    final clase = TextEditingController();
    final fechaInscripcion = TextEditingController();
    final cobro = TextEditingController();
    var data = await DB.mostraralumno('id');
    print('${data["nombre"]}');
    if (data.isNotEmpty) {
      setState(() {
        id.text =  "data['id']";
        nombre.text = data['nombre'];
        clase.text = data['clase'];
        fechaInscripcion.text = data['fechaInscripcion'];
        cobro.text = data['cobro'];
      });
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder){
          return Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom+50
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("id: ${ID}", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                TextField(
                  controller: id,
                  decoration: InputDecoration(
                      labelText: "id:",
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: nombre,
                  decoration: InputDecoration(
                      labelText: "Nombre:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: clase,
                  decoration: InputDecoration(
                      labelText: "Clase:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: fechaInscripcion,
                  decoration: InputDecoration(
                      labelText: "Fecha de inscripcion:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: cobro,
                  decoration: InputDecoration(
                      labelText: "Cobro:"
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          var JSonTemporal={
                            'id': id.text,
                            'nombre':nombre.text,
                            'clase': clase.text,
                            'fechaInscripcion': fechaInscripcion.text,
                            'cobro': cobro.text,
                          };
                          DB.actualizar(JSonTemporal).then((value) {
                            setState(() {
                              titulo = "DATOS DE ALUMNO ACTUALIZADOS";
                              Navigator.pop(context);
                            });
                          });
                          id.clear();
                          nombre.clear();
                          clase.clear();
                          fechaInscripcion.clear();
                          cobro.clear();
                        },
                        child: Text("ACTUALIZAR")
                    ),
                    ElevatedButton(
                        onPressed: (){
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("CANCELAR")
                    ),
                  ],
                )

              ],
            ),
          );
        }
    );
  }
}
