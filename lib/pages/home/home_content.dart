import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_agenda/helpers/contact_helper.dart';
import 'package:flutter_agenda/pages/contact/contact_page.dart';
import 'package:flutter_agenda/pages/home/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeContent extends StatelessWidget {
  final ContactHelper repository;
  HomeContent({@required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.loading) return Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: state.contactList.length,
            itemBuilder: (context, index) {
              Contact contact = state.contactList[index];

              return GestureDetector(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: contact.img == null
                                ? Text(
                                    contact.name[0].toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: Image(
                                      image: FileImage(File(contact.img)),
                                      fit: BoxFit.cover,
                                      width: 64,
                                      height: 64,
                                    ),
                                  ),
                            radius: 32,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  contact.name,
                                  style: TextStyle(fontSize: 22),
                                ),
                                Text(contact.phone),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                  ],
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToContact(context, Contact()),
      ),
    );
  }

  Future _navigateToContact(BuildContext context, Contact contact) async {
    final bool contactSaved = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          repository: repository,
          contact: contact,
        ),
      ),
    );

    if (contactSaved == null) return;
    if (contactSaved) context.bloc<HomeBloc>().add(GetContacts());
  }
}
