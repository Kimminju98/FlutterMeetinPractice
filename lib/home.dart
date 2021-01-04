import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("meetIn"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.file_copy),
              onPressed: (){
                _makePDF();
              }
          ),
          IconButton(
              icon: Icon(Icons.alarm),
              onPressed: (){
                Navigator.pushNamed(context, '/notification');
              }
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _ScreenSection(),
            _InputSection(),
          ],
        ),
      ),
    );
  }

  void _makePDF() async{

    final pdf = pw.Document();

    pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),

          build: (pw.Context context){
            return <pw.Widget>  [
              pw.Header(
                  level: 0,
                  child: pw.Text('Easy Approach Document')
              ),
              pw.Paragraph(
                  text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed.'
              ),
              pw.Paragraph(
                  text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed.'
              ),
            ];
          },

        )
    );

    print(pdf);

    final output = await getExternalStorageDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(pdf.save());
    print(file);

    //Send file to Email
    final Email email = Email(
      body: 'Email body',
      subject: 'Email subject',
      recipients: ['21700097@handong.edu'],
      //cc : ['cc@example.com'],
      //bcc: ['bcc@example.com'],
      attachmentPaths: [file.path],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    print(platformResponse);

  }
}

class _ScreenSection extends StatefulWidget {
  @override
  __ScreenSectionState createState() => __ScreenSectionState();
}

class __ScreenSectionState extends State<_ScreenSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      padding: EdgeInsets.all(3),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                imageProfile(
                    'https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F99BC644E5B725CA734'),
                imageProfile(
                    'https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F99BC644E5B725CA734'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: table(),
          ),
          SizedBox(
            width: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: table(),
          ),
        ],
      ),
    );
  }

  Widget table() {
    return Container(
      height: 220,
      width: 50,
      color: Colors.grey,
    );
  }

  Widget imageProfile(String url) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(url),
          )
        ],
      ),
    );
  }
}

class _InputSection extends StatefulWidget {
  @override
  __InputSectionState createState() => __InputSectionState();
}

class __InputSectionState extends State<_InputSection> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter a Message...',
                border: const OutlineInputBorder(),
              ),
              controller: messageController,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: messageController.text.isEmpty ? Colors.grey : Colors.blue,
            ),
            onPressed: () {
              messageController.clear();
            },
          )
        ],
      ),
    );
  }
}
