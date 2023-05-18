import 'package:flutter/material.dart';
import 'package:data_project/models/person.dart';
import 'package:data_project/pages/person_details_page.dart';
import 'package:data_project/pages/add_person_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final List<Person> persons = [
    Person(
      id: '1',
      fullName: 'ตรีภัทร เกียรติกมล',
      age: 32,
      province: 'กรุงเทพฯ',
      street: '78 ถ.อ่อนุช แขวงอ่อนนุช เขตสวนหลวง',
      zipCode: '10250',
    ),
    Person(
      id: '2',
      fullName: 'รัศมี ดอกดวง',
      age: 32,
      province: 'กรุงเทพฯ',
      street: '456 ถ.บ้านใหม่ ตำบลบ้านบ่อ อำเภอบ้านแขก',
      zipCode: '30450',
    )
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('กลุ่มรายชื่อบุคคล'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'รายชื่อ'),
            Tab(text: 'รายจังหวัด'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFullListTab(),
          _buildByProvinceTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddPersonPage();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFullListTab() {
    return ListView.builder(
      itemCount: persons.length,
      itemBuilder: (context, index) {
        final person = persons[index];
        return ListTile(
          title: Text(person.fullName),
          subtitle: Text(person.province),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonDetailsPage(person: person),
              ),
            );
          },
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(person);
            },
          ),
        );
      },
    );
  }

  Widget _buildByProvinceTab() {
    // Group persons by province
    final groupedPersons = groupPersonsByProvince();

    return ListView.builder(
      itemCount: groupedPersons.length,
      itemBuilder: (context, index) {
        final province = groupedPersons.keys.toList()[index];
        final personsInProvince = groupedPersons[province]!;

        return ExpansionTile(
          title: Text(province),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: personsInProvince.length,
              itemBuilder: (context, index) {
                final person = personsInProvince[index];
                return ListTile(
                  title: Text(person.fullName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonDetailsPage(person: person),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(person);
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Map<String, List<Person>> groupPersonsByProvince() {
    final groupedPersons = <String, List<Person>>{};

    for (final person in persons) {
      final province = person.province.toLowerCase(); // Convert province to lowercase

      if (!groupedPersons.containsKey(province)) {
        groupedPersons[province] = [];
      }
      groupedPersons[province]!.add(person);
    }

    return groupedPersons;
  }

  void _showDeleteConfirmationDialog(Person person) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการลบชื่อ'),
          content: Text('แน่ใจหรือไม่ว่าต้องการจะลบ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  persons.remove(person);
                });
                Navigator.of(context).pop();
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddPersonPage() async {
    final newPerson = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPersonPage(
          onPersonAdded: _handlePersonAdded,
        ),
      ),
    );

    if (newPerson != null) {
      setState(() {
        persons.add(newPerson);
      });
    }
  }

  void _handlePersonAdded(Person person) {
    setState(() {
      persons.add(person);
    });
  }
}
