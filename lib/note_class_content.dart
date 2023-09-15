import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class noteApp extends StatelessWidget {
  String pathName = "";
  noteApp({required this.pathName});

  @override
  Widget build(BuildContext context) {
    return noteScaffold(path: this.pathName);
  }
}


class noteScaffold extends StatefulWidget {
  String path = "";
  noteScaffold({required this.path});
  @override
  State<noteScaffold> createState() => _noteScaffoldState();
}

class _noteScaffoldState extends State<noteScaffold> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        setState(() {

        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(103, 42, 209, 1),
          toolbarHeight: 70,
          title: Text("Not Oluştur",
            style: TextStyle(
                fontFamily: 'opensansBold'
            ),
          ),
        ),
        body: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black12,
                        width: 1.0,
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("Dosya İsmi",style: TextStyle(
                            fontFamily: 'opensansMedium'
                        ),),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Düzenle",style: TextStyle(
                                fontFamily: 'opensansMedium'
                            ),),
                            SizedBox(width: 20,),
                            Text("Sil",style: TextStyle(
                                fontFamily: 'opensansMedium'
                            ),),
                            SizedBox(width: 15,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(future:listFiles(widget.path), builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }else if(snapshot.hasError){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.4,),
                          Center(child: Text("Hiç Notun yok.Not oluştur.")),
                        ],
                      );
                    }else{
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        // Eğer liste boşsa burada bir metin veya widget döndürebilirsiniz.
                        return ListView(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Burası boş.Biraz not al."),
                              ),
                            )
                          ],
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder:(BuildContext context, index){
                            String fileName = snapshot.data![index].path.split("/").last.split(".").first.toString();
                            return Column(
                              children: [
                                ListTile(
                                  onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder:(BuildContext context){
                                       return NoteContent(fullPath:snapshot.data![index].path,title: fileName,);
                                     }));
                                  },
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(fileName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'opensansMedium'
                                      ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(onPressed:(){
                                            //Düzenleme foksiyonu
                                            showDialog(context: context, builder: (BuildContext context){
                                              return changeNote(path:snapshot.data![index].path,);
                                            });
                                          }, icon:Icon(Icons.edit,
                                          color: Color.fromRGBO(103, 42, 209, 1),
                                          )),
                                          IconButton(onPressed:(){
                                            showDialog(context: context, builder: (BuildContext context){
                                              return DeleteAlert(path: snapshot.data![index].path);
                                            });
                                          }, icon:Icon(Icons.delete,
                                            color: Colors.red,
                                          )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Divider(height: 1.0,color: Colors.black12,),
                              ],
                            );
                          }) ;
                    }
                  },),
                ),
              ],
            ),
          ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(103, 42, 209, 1),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Alert(path: widget.path);
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}


Future<List<FileSystemEntity>> listFiles(pathName) async{
   final dir = await Directory(pathName);
   List<FileSystemEntity> files = await dir.listSync();
   return files;
}



Future<void> newNote(pathName, String fileName, String fileContent) async {
  final dir = await Directory(pathName);
  try {
    final file = File("${dir.path}$fileName");
    if (file.existsSync()) {
       file.writeAsStringSync(fileContent);
    } else {
      file.writeAsStringSync(fileContent);
    }
  } catch (e) {
  }
}


Future<void> deleteNote(fullPathName) async{
  var file = File(fullPathName);
  if(file.existsSync()){
    //Silmek istermi diye sorabilirim
    file.deleteSync();
  }
}


class DeleteAlert extends StatefulWidget {
  String path = "";
  DeleteAlert({required this.path});
  @override
  State<DeleteAlert> createState() => _DeleteAlertState();
}

class _DeleteAlertState extends State<DeleteAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Uyarı"),
      content: Text("Notu silmek istiyormusun ?"),
      actions: [
        ElevatedButton(onPressed:(){
          deleteNote(widget.path);
          Navigator.pop(context);
        }, child:Text("Tamam"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(103, 42, 209, 1),
        ),
        ),

        ElevatedButton(onPressed:(){
          Navigator.pop(context);
        }, child: Text("İptal"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(103, 42, 209, 1),
          ),
        ),
      ],
    );
  }
}








class Alert extends StatefulWidget {
  String path = "";
  Alert({required this.path});
  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  TextEditingController? _controllerFileName = TextEditingController();
  TextEditingController? _controllerFileContent = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Yeni Not Oluştur",
      style: TextStyle(
        fontFamily: 'opensansBold',
      ),
      ),
      content: ListView(
        children: [
          TextField(
            controller:_controllerFileName,
            decoration: InputDecoration(
              hintText: "demo.ext",
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: 1.0,
                  )
              ),
              labelText: "Dosya İsmi",
            ),
          ),
          SizedBox(height: 15,),
          TextField(
            controller: _controllerFileContent,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration:InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                )
              ),
              labelText: "Notun"
            ),
          )
        ],
      ),
      actions: [
        ElevatedButton(onPressed:(){
          Navigator.pop(context);
        }, child: Text("İptal",
         style: TextStyle(
           fontFamily: 'opensansMedium',
         ),
        ), style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(103, 42, 209, 1),
        ),),
        ElevatedButton(onPressed:(){
          //Dosya oluşturma fonksiyonunu çalıştu
           setState(() {
             newNote(widget.path,_controllerFileName!.text , _controllerFileContent!.text);
             Navigator.pop(context);
           });
           }, child: Text("Tamam",
        style: TextStyle(
          fontFamily: 'opensansMedium'
        ),
        ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(103, 42, 209, 1),
          ),
        )
      ],
    );
  }
}


class NoteContent extends StatefulWidget {
  String fullPath = "";
  String title = "";
  NoteContent({required this.fullPath, required this.title});
  @override
  State<NoteContent> createState() => _NoteContentState();
}

class _NoteContentState extends State<NoteContent> {
  String fullPath = "";
  double _font_size = 14;
  Color color = Colors.black;
  FontWeight fontWeight = FontWeight.normal;
  @override
  Widget build(BuildContext context) {
    fullPath = widget.fullPath;
    Future<String> readNote(fullPath) async{
      String content = "";
      var file = File(fullPath);
      if(file.existsSync()){
        content = file.readAsStringSync();
      }
      return content;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          fontFamily: 'opensansBold',
        ),
        ),
        backgroundColor: Color.fromRGBO(103, 42, 209, 1),
        actions: [
          IconButton(onPressed:(){
            showDialog(context: context, builder:(context) {
              return AlertDialog(
                title: Text("Metin Ayarları"),
               content: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   height: MediaQuery.of(context).size.height * 0.3,
                   child: ListView(
                      children: [
                        Text("Yazı Rengi"),
                         SizedBox(height: 5,),
                         Container(
                           margin: EdgeInsets.zero,
                           padding: EdgeInsets.zero,
                           decoration: BoxDecoration(
                             border: Border.all(
                               color: Colors.black12,
                               width: 1.0,
                             ),
                             borderRadius: BorderRadius.circular(10),
                           ),
                           child: DropdownButton(
                             underline: Divider(color: Colors.white,height: 0.0,),
                               hint: Text("Renk Seç"),
                               items:[
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.grey),width: 30,height: 30,),SizedBox(width: 10),Text("Gri",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.grey),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.black,),width: 30,height: 30,),SizedBox(width: 10),Text("Siyah",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.black,),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.redAccent,),width: 30,height: 30,),SizedBox(width: 10),Text("Kırmızı",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.redAccent,),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.blueAccent,),width: 30,height: 30,),SizedBox(width: 10),Text("Mavi",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.blueAccent,),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.yellowAccent,),width: 30,height: 30,),SizedBox(width: 10),Text("Sarı",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.yellowAccent,),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.orangeAccent,),width: 30,height: 30,),SizedBox(width: 10),Text("Turuncu",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.orangeAccent,),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.purpleAccent),width: 30,height: 30,),SizedBox(width: 10),Text("Mor",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.purpleAccent,),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.greenAccent,),width: 30,height: 30,),SizedBox(width: 10),Text("Yeşil",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.greenAccent,),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.pinkAccent),width: 30,height: 30,),SizedBox(width: 10),Text("Pembe",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.pinkAccent,),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.brown),width: 30,height: 30,),SizedBox(width: 10),Text("Kahverengi",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.brown,),
                                 DropdownMenuItem(child: Row(children: [Container(decoration: BoxDecoration(color: Colors.cyanAccent),width: 30,height: 30,),SizedBox(width: 10),Text("Cyan",style: TextStyle(fontWeight: FontWeight.bold),)],),value: Colors.cyanAccent,),
                           ], onChanged: (value){
                               setState(() {
                                  color = value!;
                               });
                           }),
                         ),
                        SizedBox(height: 20,),
                        Text("Kalınlık"),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),borderRadius: BorderRadius.circular(10)
                          ),
                          child: DropdownButton(
                            hint: Text("Kalınlık Seç"),
                              underline: Divider(height: 0,color: Colors.white,),
                              items: [
                                DropdownMenuItem(child: Text("Normal"),value: FontWeight.normal,),
                                DropdownMenuItem(child: Text("Kalın"),value: FontWeight.bold,),
                          ],onChanged: (value){
                            setState(() {
                              fontWeight = value!;
                            });
                          }),
                        ),
                      ],
                   ),
                 ),
               ),
                actions: [
                  ElevatedButton(onPressed:(){
                    Navigator.pop(context);
                  }, child: Text("Tamam"),style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(103, 42, 209, 1),
                  ),)
                ],
              );
            },);
          }, icon: Icon(Icons.settings,color: Colors.white,)),
        ],
      ),
      body:FutureBuilder(future: readNote(fullPath), builder: (context, snapshot) {
        String content = snapshot.data.toString();
        return ListView(
          children: [
            SizedBox(height: 5,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white12,
              ),
              padding: EdgeInsets.all(10),
              child: Text(content,
              style: TextStyle(
                fontWeight: fontWeight,
                color: color,
                fontSize: _font_size,
                fontFamily: 'opensansMedium',
              ),
              ),
            )
          ],
        );
      },),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(103, 42, 209, 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed:(){
              setState(() {
                _font_size--;
              });
            }, child: Text("-",style: TextStyle(
             color: Colors.black,
              fontSize: 20,
            ),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )
            ),
            ),
            Text(_font_size.toInt().toString(),style: TextStyle(
              color: Colors.white,
            ),),
            ElevatedButton(onPressed:(){
              setState(() {
                _font_size++;
              });
            }, child: Text("+",style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )
            ),
            )
          ],
        ),
      ),
    );
  }
}



class changeNote extends StatefulWidget {
  String path = "";
  changeNote({required this.path});

  @override
  State<changeNote> createState() => _changeNoteState();
}

class _changeNoteState extends State<changeNote> {
  TextEditingController _controllerFileName = TextEditingController();
  TextEditingController _controllerFileContent = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFileContent();
  }

  Future<void> loadFileContent() async {
    try {
      var file = File(widget.path);
      if (await file.exists()) {
        String content = await file.readAsString();
        setState(() {
          _controllerFileName.text = file.path.split('/').last;
          _controllerFileContent.text = content;
        });
      }
    } catch (e) {
      print('Dosya okuma hatası: $e');
    }
  }

  Future<void> change() async {
    try {
      var dirPath = widget.path.split("/");
      var oldFileName = dirPath.last;
      var newFileName = _controllerFileName.text;

      if (oldFileName != newFileName) {
        // Dosya adı değişmişse, eski dosyayı sil ve yeni dosya oluştur
        var oldFile = File(widget.path);
        await oldFile.delete();

        var newFile = File("${dirPath.sublist(0, dirPath.length - 1).join("/")}/$newFileName");
        await newFile.create();

        // Dosya içeriğini güncelle
        await newFile.writeAsString(_controllerFileContent.text);
      } else {
        // Dosya adı değişmemişse, sadece dosya içeriğini güncelle
        var file = File(widget.path);
        await file.writeAsString(_controllerFileContent.text);
      }
    } catch (e) {
      print("Dosya değiştirilemedi: $e");
    }
  }



  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.path.split("/").last,
        style: TextStyle(
            fontFamily: 'opensansBold'
        ),
      ),
      content: ListView(
        children: [
          SizedBox(height: 5,),
          TextField(
            controller:_controllerFileName,
            decoration: InputDecoration(
              hintText: "demo.ext",
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: 1.0,
                  ),
              ),
              labelText: "Dosya İsmi",
            ),
          ),
          SizedBox(height: 15,),
          TextField(
            controller: _controllerFileContent,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration:InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                      width: 1.0,
                    ),
                ),
                labelText: "Notun"
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(onPressed:(){
          change();
          Navigator.pop(context);

        }, child: Text("Tamam",style: TextStyle(
            fontFamily: 'opensansMedium'
        ),), style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(103, 42, 209, 1),
        ),),
        ElevatedButton(onPressed:(){
          Navigator.pop(context);
        }, child: Text("İptal",style: TextStyle(
            fontFamily: 'opensansMedium'
        ),), style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(103, 42, 209, 1),
        ),)
      ],
    );
  }
}
