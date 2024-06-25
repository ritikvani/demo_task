import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:task/auth_page.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage(
      {Key? key,
      required this.token,
      required this.firstName,
      required this.lastName,
      required this.email})
      : super(key: key);
  final String token;
  final String firstName;
  final String lastName;
  final String email;

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  bool isGridView = false;
  List<Map<String, dynamic>> userData = [];
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;
  int perPage = 10;
  bool isLoading = false;
  bool initialLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData({int? page}) async {
    setState(() {
      isLoading = true;
    });

    if (page != null) {
      currentPage = page;
    }

    String apiUrl =
        'https://mmfinfotech.co/machine_test/api/userList?page=$currentPage';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          initialLoading = true;
          if (currentPage == 1) {
            userData = List<Map<String, dynamic>>.from(jsonData['userList']);
          } else {
            userData
                .addAll(List<Map<String, dynamic>>.from(jsonData['userList']));
          }
          currentPage = jsonData['currentPage'];
          lastPage = jsonData['lastPage'];
          total = jsonData['total'];
          perPage = jsonData['perPage'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await fetchData(page: 1);
  }

  void loadMoreData() {
    if (currentPage < lastPage && !isLoading) {
      fetchData(page: currentPage + 1);
    }
  }

  void toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD8F1FE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 75,
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: CircleAvatar(
                  backgroundImage: AssetImage("lib/assets/user_image.png")),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      widget.firstName,
                      style: const TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      widget.lastName,
                      style: const TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.email,
                  style:
                      const TextStyle(color: Color(0xff949BA5), fontSize: 13),
                )
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: const Icon(Icons.logout),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AuthPage(),
                ));
              },
            ),
          ],
        ),
      ),
      body: initialLoading
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'User list',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Image.asset(isGridView
                                  ? "lib/assets/listView_deactivated.png"
                                  : "lib/assets/listView_activated.png"),
                              onPressed: toggleView,
                            ),
                            IconButton(
                              icon: Image.asset(isGridView
                                  ? "lib/assets/grid_view_activated.png"
                                  : "lib/assets/gird_view_deactivated.png"),
                              onPressed: toggleView,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          loadMoreData();
                          setState(() {
                            isLoading = true;
                          });
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        onRefresh: _refreshData,
                        child: isGridView
                            ? GridView.builder(
                                controller: _scrollController,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: userData.length,
                                itemBuilder: (context, index) {
                                  return buildUserCard(index);
                                },
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: userData.length,
                                itemBuilder: (context, index) {
                                  return buildUserCard(index);
                                },
                              ),
                      ),
                    ),
                  ),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildUserCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: isGridView
            ? buildGridViewProfile(index)
            : buildListViewProfile(index),
      ),
    );
  }

  Widget buildGridViewProfile(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'First name : ${userData[index]['first_name']}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500, // Adjusted font weight
            color: const Color(0xff212226),
          ),
        ),
        Text(
          'Last name : ${userData[index]['last_name']}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500, // Adjusted font weight
            color: Color(0xff212226),
          ),
        ),
        Text(
          'Email: ${userData[index]['email']}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500, // Adjusted font weight
            color: const Color(0xff212226),
          ),
        ),
        Text(
          'Phone: ${userData[index]['country_code']} ${userData[index]['phone_no']}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500, // Adjusted font weight
            color: Color(0xff212226),
          ),
        ),
        const SizedBox(height: 8),
        buildProfileButton(),
      ],
    );
  }

  Widget buildListViewProfile(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First name : ${userData[index]['first_name']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // Adjusted font weight
                  color: const Color(0xff212226),
                ),
              ),
              Text(
                'Last name : ${userData[index]['last_name']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // Adjusted font weight
                  color: const Color(0xff212226),
                ),
              ),
              Text(
                'Email : ${userData[index]['email']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // Adjusted font weight
                  color: const Color(0xff212226),
                ),
              ),
              Text(
                'Phone : ${userData[index]['country_code']} ${userData[index]['phone_no']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // Adjusted font weight
                  color: Color(0xff212226),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        buildProfileButton(),
      ],
    );
  }

  Widget buildProfileButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 30,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Colors.blueAccent,
            width: 1.0,
          ),
        ),
        child: const Center(
          child: const Text(
            'View Profile',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
