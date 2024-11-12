import 'package:flutter/material.dart';
import 'package:flutter_application_task1/api/api_services.dart';
import 'package:flutter_application_task1/model/login_model.dart';
import '../ProgressHUD.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  _login_pageState createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late LoginRequestModel loginRequestModel;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    loginRequestModel = LoginRequestModel(email: '', password: '');
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: _uiSetup(context),
    );
  }

  Widget _uiSetup(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.grey[900], // Set dark grey background color
        body: Container(
          color: Colors
              .grey[900], // Dark grey background color for the entire screen
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      margin: const EdgeInsets.symmetric(
                          vertical: 85, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[900],
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.9),
                            offset: const Offset(0, 10),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Form(
                        key: globalFormKey,
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/loogo.png',
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(height: 25),
                            Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            const Text(
                              "Please enter the required details",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (input) => loginRequestModel.email =
                                  input ?? 'customer1@gmail.com',
                              validator: (input) =>
                                  input != null && !input.contains('@')
                                      ? "Email Id should be valid"
                                      : null,
                              decoration: InputDecoration(
                                hintText: "Email Address",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              keyboardType: TextInputType.text,
                              onSaved: (input) => loginRequestModel.password =
                                  input ?? 'Abc123456789@@@',
                              validator: (input) => input != null &&
                                      input.length < 10
                                  ? "Password should be more than 3 characters"
                                  : null,
                              obscureText: hidePassword,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  color: Colors.white.withOpacity(0.4),
                                  icon: Icon(hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 80),
                                backgroundColor: const Color(0xFFFFC491),
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                if (validateAndSave()) {
                                  print(loginRequestModel.toJson());

                                  setState(() {
                                    isApiCallProcess = true;
                                  });

                                  APIService apiService = APIService();
                                  apiService
                                      .login(context, "customer1@gmail.com",
                                          "Abc123456789@@@")
                                      .then((value) {
                                    setState(() {
                                      isApiCallProcess = false;
                                    });
                                  });
                                }
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
