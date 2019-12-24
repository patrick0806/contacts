
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum OrderOptions{orderAZ, orderZA}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts=list;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getAllContacts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem(child: Text("A-Z Sort"), value: OrderOptions.orderAZ,),
              const PopupMenuItem(child: Text("Z-A Sort"), value: OrderOptions.orderZA,),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding:EdgeInsets.all(10) ,
          itemCount: contacts.length,
          itemBuilder: (context,index){
              return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child:Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: contacts[index].img !=null ? FileImage(File(contacts[index].img)) : AssetImage("images/person.png"),fit: BoxFit.cover),
                ),
              ),
              Padding(padding:  EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18,),
                    ),
                    Text(contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 18,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context,index);
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(context: context, builder: (context){
      return BottomSheet(
        onClosing: (){},
        builder: (context){
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child:FlatButton(
                    child:  Text("Call",
                      style: TextStyle(color:Colors.red, fontSize: 20),),
                    onPressed: (){
                      launch("tel:${contacts[index].phone}");
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child:FlatButton(
                    child:  Text("Edit",
                      style: TextStyle(color:Colors.red, fontSize: 20),),
                    onPressed: (){
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child:FlatButton(
                    child:  Text("Delete",
                      style: TextStyle(color:Colors.red, fontSize: 20),),
                    onPressed: (){
                      helper.deleteContact(contacts[index].id);
                      setState(() {
                        contacts.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(context,MaterialPageRoute(builder: (context)=> ContactPage(contact: contact,)));
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }

  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderAZ:
        contacts.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        contacts.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }
}
