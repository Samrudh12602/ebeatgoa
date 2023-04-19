import 'package:flutter/material.dart';
import 'main.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "dashboard",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),

      ),
      body: Container(
        color: Colors.grey.shade300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:<Widget>[
            Expanded(child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                getExpanded('download.png','try','try2'),
                getExpanded('download.png','try','try2'),

              ],
            ),
            ),
            Expanded(child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                getExpanded('download.png','try','try2'),
                getExpanded('download.png','try','try2'),

              ],
            ),
            ),
            Expanded(child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                getExpanded('download.png','try','try2'),
                getExpanded('download.png','try','try2'),

              ],
            ),
            ),
            Expanded(child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                getExpanded('download.png','try','try2'),
                getExpanded('download.png','try','try2'),

              ],
            ),
            ),
          ],
        ),
      ),

    );
  }
  Expanded getExpanded(String image,String mainText,String subText){
    return  Expanded(
      child: Container(
        child:Column(
          children:<Widget> [
            Image.asset('images/$image.png',height: 80.0,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "nike",
              style:TextStyle(
                  fontWeight:FontWeight.bold,
                  fontSize: 20.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "place",
              style: TextStyle(
                  fontSize: 10.0
              ),
            ),

          ],


        ) ,
        margin: EdgeInsets.only(left: 10.0,top:10.0 ,right:10.0 ,bottom:10.0 ),
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight:  Radius.circular(5),
            bottomLeft:  Radius.circular(5),
            bottomRight:  Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(),

          ],
        ),
      ),
    );
  }
}
