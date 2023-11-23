import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseRemota = FirebaseFirestore.instance;
class DB{
  static Future insertar(Map<String, dynamic> alumnos) async{
    return await baseRemota.collection("alumnos").add(alumnos);
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
  static Future eliminar(String clave) async{
    return await baseRemota.collection("alumnos").
    doc(clave).delete();
  }
  static Future actualizar(Map<String, dynamic> alumnos) async{
    String idActualizar = alumnos['id'];
    alumnos.remove('id');
    return await baseRemota.collection("alumnos").
    doc(idActualizar).update(alumnos);
  }
  static Future<Map<String, dynamic>> mostraralumno(String id) async {
    var doc = await baseRemota.collection("alumnos").doc(id).get();
    print(id);
    if (doc.exists) {
      Map<String, dynamic> data = doc.data()!;
      data.addAll({'id': doc.id});
      return data;
    } else {
      return {};
    }
  }
}