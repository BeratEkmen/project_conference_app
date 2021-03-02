import 'package:flutter/material.dart';
import 'package:project_stock_market/helper/helper_functions.dart';
import 'package:project_stock_market/locator.dart';
import 'package:project_stock_market/models/user_model.dart';
import 'package:project_stock_market/screens/login_screen.dart';
import 'package:project_stock_market/services/auth.dart';
import 'package:project_stock_market/utilities/custom_styles.dart';
import 'package:project_stock_market/widgets/build_message_composer.dart';
import 'package:project_stock_market/widgets/build_messages.dart';
import 'package:project_stock_market/widgets/scroll_to_top_widget.dart';

class MainScreen extends StatefulWidget {
  UserModel user;

  MainScreen.withUser(this.user);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _controller = TextEditingController();
  ScrollController _scrollController;
  final AuthMethods authMethods = locator<AuthMethods>();

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildDrawer(BuildContext context, Size size) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: CustomStyles.kMainBoxStyle(),
            accountEmail: Text(
              widget.user.email,
              style: TextStyle(
                  fontFamily: 'OpenSans', fontSize: size.width * 0.04),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                widget.user.email.substring(0, 1).toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.075,
                    fontFamily: 'OpenSans'),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              HelperFunctions.resetUserModel();
              HelperFunctions.resetLoggedIn();
              authMethods.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ), (Route<dynamic> route) => false);
            },
            title: Text(
              "Log out.",
              style: TextStyle(
                  fontFamily: 'OpenSans', fontSize: size.width * 0.04),
            ),
            leading: Icon(
              Icons.exit_to_app,
              color: Color(0xFF398AE5),
              size: size.width * 0.075,
            ),
          )
        ],
      ),
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF73AEF5),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF73AEF5),
        title: Text("Project Alpha"),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context, size),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus.unfocus();
        },
        child: Scrollbar(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    child: Stack(alignment: Alignment.bottomRight,children: [
                      BuildMessages(_scrollController),
                      ScrollToTopWidget(_scrollController),
                    ]),
                  ),
                ),
              ),
              if (widget.user.userId == "u1AoVEBIEfZFjfnLA8VjGbVZn673")
                BuildMessageComposer(_controller),
            ],
          ),
        ),
      ),
    );
  }
}
