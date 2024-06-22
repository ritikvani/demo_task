import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:task/auth_page.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage(
      {Key? key,
        required this.token,
        required this.firstName,
        required this.lastName})
      : super(key: key);
  final String token;
  final String firstName;
  final String lastName;

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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 75,
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Row(
          children: [
            const Text(
              'Welcome , ',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              widget.firstName,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.lastName,
              style: const TextStyle(color: Colors.black, fontSize: 18),
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
        child: RefreshIndicator(
          onRefresh: _refreshData,
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
                  IconButton(
                    icon: Icon(isGridView ? Icons.list : Icons.grid_view),
                    onPressed: toggleView,
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
                  child: isGridView
                      ? GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
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
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'First name: ${userData[index]['first_name']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff212226),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Last name: ${userData[index]['last_name']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff212226),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Email: ${userData[index]['email']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff212226),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Phone: ${userData[index]['country_code']} ${userData[index]['phone_no']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff212226),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('View Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
