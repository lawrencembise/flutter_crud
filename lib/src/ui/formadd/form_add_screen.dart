import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/api_service.dart';
import '../../model/country.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Country country;

  FormAddScreen({this.country});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldShortNameValid;
  bool _isFieldAgeValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerShortName = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();

  @override
  void initState() {
    if (widget.country != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.country.name;
      _isFieldShortNameValid = true;
      _controllerShortName.text = widget.country.shortName;
      _isFieldAgeValid = true;
      _controllerAge.text = widget.country.code.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.country == null ? "Ongeza" : "Badili",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldName(),
                _buildTextFieldShortName(),
                _buildTextFieldAge(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    child: Text(
                      widget.country == null
                          ? "Wasilisha".toUpperCase()
                          : "Badilisha".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_isFieldNameValid == null ||
                          _isFieldShortNameValid == null ||
                          _isFieldAgeValid == null ||
                          !_isFieldNameValid ||
                          !_isFieldShortNameValid ||
                          !_isFieldAgeValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Tafadhali jaza sehemu zote"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String name = _controllerName.text.toString();
                      String shortName = _controllerShortName.text.toString();
                      int code = int.parse(_controllerAge.text.toString());
                      Country country =
                          Country(name: name, shortName: shortName, code: code);
                      if (widget.country == null) {
                        _apiService.createCountry(country).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Imeshindwa kuwasilisha"),
                            ));
                          }
                        });
                      } else {
                        country.id = widget.country.id;
                        _apiService.updateCountry(country).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Imeshindwa kubadilisha"),
                            ));
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                    ),
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Jina la nchi",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Jina la nchi linahitajika",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldShortName() {
    return TextField(
      controller: _controllerShortName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Kifupi",
        errorText: _isFieldShortNameValid == null || _isFieldShortNameValid
            ? null
            : "Kifupi kinahitajika",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldShortNameValid) {
          setState(() => _isFieldShortNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldAge() {
    return TextField(
      controller: _controllerAge,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Nambari, mf. 255",
        errorText: _isFieldAgeValid == null || _isFieldAgeValid
            ? null
            : "Nambari inahitajika",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldAgeValid) {
          setState(() => _isFieldAgeValid = isFieldValid);
        }
      },
    );
  }
}
