import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample_app/src/api/api_service.dart';
import 'package:flutter_crud_api_sample_app/src/model/country.dart';
import 'package:flutter_crud_api_sample_app/src/ui/formadd/form_add_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;
  ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    print(apiService.getCountrys());

    return SafeArea(

      child: FutureBuilder(
        future: apiService.getCountrys(),

          builder: (BuildContext context, AsyncSnapshot<List<Country>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Kuna kitu hakipo sawa: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Country> countrys = snapshot.data;
            return _buildListView(countrys);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<Country> countrys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Country country = countrys[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      country.name,
                    ),
                    Text(country.shortName),
                    Text(country.code.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Tahadhari"),
                                    content: Text("Una uhakika unataka kufuta nchi ${country.name}?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Ndio"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          apiService.deleteCountry(country.id).then((isSuccess) {
                                            if (isSuccess) {
                                              setState(() {});
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Taarifa zimefutika")));
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Taarifa hazijafutika")));
                                            }
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Hapana"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Futa",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return FormAddScreen(country: country);
                            }));
                            if (result != null) {
                              setState(() {});
                            }
                          },
                          child: Text(
                            "Badili",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: countrys.length,
      ),
    );
  }
}
