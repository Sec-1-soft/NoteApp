import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notlarim/note_class_content.dart';
import 'package:path_provider/path_provider.dart';


void main()=>runApp(NotesApp());


class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoteScaffold(),
    );
  }
}


class NoteScaffold extends StatefulWidget {
  const NoteScaffold({super.key});

  @override
  State<NoteScaffold> createState() => _NoteScaffoldState();
}

class _NoteScaffoldState extends State<NoteScaffold> {
  @override

  void initState(){
    super.initState();
    hideSystem();
  }

  Future<String> createAndGetPath(classDirName) async {
    final dir = await getExternalStorageDirectory();
    String dirPath = "${dir!.path}/$classDirName/";
    Directory classDir = Directory(dirPath);

    if (!await classDir.exists()) {
      await classDir.create(recursive: true);
    }

    return classDir.path;
  }

  void hideSystem() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,overlays:[
      SystemUiOverlay.top,
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(103, 42, 209, 1),
        toolbarHeight: 70,
        title: Text("Notlarım",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'opensansBold',
          fontSize: 24,
          shadows: [
            Shadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(1, 1),
            )
          ]
        ),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
           return [
             PopupMenuItem(child: Text("Sürüm"),value: "sürüm",),
             PopupMenuItem(child: Text("Açıklama"),value: "Açıklama",),
           ];
          },
          onSelected: (value){
            if(value == "sürüm"){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return AppDriv();
              },));
            }else if(value == "Açıklama"){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return Description();
              }));
            }
          },
          )
        ],
      ),
      body:ListView.builder(
          itemCount: note_class_list.length,
          itemBuilder:(BuildContext context, index){
            NoteClass _noteclass = note_class_list[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async{
                  String path = await createAndGetPath(_noteclass.directoryName);
                  Navigator.push(context, MaterialPageRoute(builder:(BuildContext context){
                    return noteApp(pathName:path);
                  }));
                },
                child:Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(153, 136, 184, 1),
                    border: Border.all(
                      color: Colors.black26,
                      width: 1.0,
                    )
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(_noteclass.title,
                         style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                             fontFamily: 'opensansBold'
                         ),
                        ),
                      ),
                      Container(
                        child: _noteclass.image,
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(_noteclass.description,
                        style: TextStyle(
                            fontFamily: 'opensansMedium',
                            fontSize: 18,
                        ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
      })
    );
  }
}


class NoteClass{
  final String title;
  final Image image;
  final String description;
  final String directoryName;

  NoteClass({
    required this.title,
    required this.image,
    required this.description,
    required this.directoryName,
});
}

List<NoteClass> note_class_list = [
  NoteClass(title: "Flutter Notları", image:Image.asset("lib/assets/flutter.jpg"), description: "Benim flutter notlarım",directoryName: "flutter"),
  NoteClass(title: "Kali Linux Notları", image: Image.asset("lib/assets/kali_linux.jpg"), description: "Kali linux ve siber güvenlik hakkındaki notlarım.", directoryName: "kali"),
  NoteClass(title: "Python Notları", image: Image.asset("lib/assets/python.jpg"), description: "Python programlama dili notlarım",directoryName: "python"),
  NoteClass(title: "Bilgisayar Donanımı Notları", image: Image.asset("lib/assets/donanim.jpg"), description: "Bilgisayar donanımı hakkında ders notlarım.",directoryName: "donanim"),
  NoteClass(title: "Web Notları", image: Image.asset("lib/assets/web.jpg"), description: "Web programlama dili ders notlarım",directoryName: "web"),
];





class AppDriv extends StatelessWidget {
  const AppDriv({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sürüm"),
         backgroundColor: Color.fromRGBO(103, 42, 209, 1),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text("Bu uygulamanın geliştiricisi Hüseyin ŞAHAN'dır.Bu uygulamanın bütün hakları ve sorumluluğu Hüseyin ŞAHAN'a aittir.Uygulama hiçbir şekilde kopyalanamaz ve çoğaltılamaz !",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'opensansBold',
                color: Colors.redAccent,
              ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text("Uygulama sürümü:1.0.0"),
            ),
          ),
        ],
      ),
    );
  }
}



class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Açıklama"),
        backgroundColor: Color.fromRGBO(103, 42, 209, 1),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text("Bu uygulama kariyerimin başlangıcı olabilir.Eğer birgün bu uygulamayı açıp biraz not okursan yada biraz geçmişe gitmek istersen unutma bu uygulamayı yazarken hiçkimse yanında olmadı.Bu yüzden kimse için üzülme.Yalnızca sen ve yaptıkların.Seni umursamayanlar için endişeye kapılma.Onların seni umursaması seni daha iyi yada daha gelişmiş yapmaz.Seni geliştirecek olan yalnızca emeklerin,aklının ve bileğinin kuvveti.Eğer bunu yıllar sonra okursan şunu bilki eski sen asla vazgeçmedi ve onu kimse yıkamadı sende asla vazgeçme bu uygulamaya o notu bu yüzden koydum.Kendini üzme çünkü kendini bir sen birde yaratan bilir.Eğer birgün birisi için üzülecek olursan şunu bilki üzüldüğün birşeyden sonra daha hayırlısı vardır.Sağlıkla kal.",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'opensansMedium'
              ),
              )
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

