import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Statespage extends StatefulWidget {
  const Statespage({super.key});

  @override
  State<Statespage> createState() => _StatespageState();
}

class _StatespageState extends State<Statespage> {
  final _userID = FirebaseAuth.instance.currentUser!.uid;
  int sportsCount = 0;
  int workCount = 0;
  int studyCount = 0;
  int lifeCount = 0;
  int othersCount = 0;
  int sportsStreak = 0;
  int workStreak = 0;
  int studyStreak = 0;
  int lifeStreak = 0;
  int othersStreak = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('habits')
            .where('uid', isEqualTo: _userID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "There are no states to show right now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            );
          }

          sportsCount = workCount = studyCount = lifeCount = othersCount = 0;
          sportsStreak =
              workStreak = studyStreak = lifeStreak = othersStreak = 0;

          for (final habit in snapshot.data!.docs) {
            final category = habit['category'] as String;
            final streak = habit['streak'] as int;

            switch (category) {
              case 'Sports':
                sportsCount++;
                sportsStreak += streak;
                break;
              case 'Work':
                workCount++;
                workStreak += streak;
                break;
              case 'Study':
                studyCount++;
                studyStreak += streak;
                break;
              case 'Life':
                lifeCount++;
                lifeStreak += streak;
                break;
              default:
                othersCount++;
                othersStreak += streak;
            }
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Habits by Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 300,
                  padding: EdgeInsets.all(16),
                  child: Card(
                    elevation: 5,
                    color: Colors.grey[900],
                    child: _buildPieChart(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Total Streaks by Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 300,
                  padding: EdgeInsets.all(16),
                  child: Card(
                    elevation: 5,
                    color: Colors.grey[900],
                    child: _buildBarChart(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  SfCircularChart _buildPieChart() {
    return SfCircularChart(
      title: ChartTitle(
          text: 'Habit Distribution',
          textStyle: TextStyle(color: Colors.white)),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: TextStyle(color: Colors.white),
      ),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: [
            ChartData('Sports', sportsCount, Colors.blue!),
            ChartData('Work', workCount, Colors.green),
            ChartData('Study', studyCount, Colors.purple),
            ChartData('Life', lifeCount, Colors.orange),
            ChartData('Others', othersCount, Colors.red),
          ],
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          pointColorMapper: (ChartData data, _) => data.color,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
            textStyle: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  SfCartesianChart _buildBarChart() {
    return SfCartesianChart(
      title: ChartTitle(
          text: 'Streak Summary', textStyle: TextStyle(color: Colors.white)),
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: Colors.white),
      ),
      series: <ChartSeries>[
        BarSeries<ChartData, String>(
          dataSource: [
            ChartData('Sports', sportsStreak, Colors.blue),
            ChartData('Work', workStreak, Colors.green),
            ChartData('Study', studyStreak, Colors.purple),
            ChartData('Life', lifeStreak, Colors.orange),
            ChartData('Others', othersStreak, Colors.red),
          ],
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.orange,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.middle,
            textStyle: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class ChartData {
  final String category;
  final int value;
  final Color color;

  ChartData(this.category, this.value, this.color);
}
