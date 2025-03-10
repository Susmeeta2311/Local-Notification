import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_notification_demo/services/notification_service.dart';
import 'package:local_notification_demo/widgets/custom_card.dart';
import 'package:local_notification_demo/widgets/header_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    initializeNotification();
  }

  initializeNotification() {
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(),
            Text(
              "Notification Types",
              style: GoogleFonts.aclonica(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            CustomCard(
              title: "Instant Notification",
              description: "Send a notification that appears immediately ",
              onClick: () {
                showNotificationInputDialog();
              },
              iconData: Icons.notifications,
              iconColor: Colors.deepPurple.shade800,
            ),
            SizedBox(height: 16.0),
            CustomCard(
              title: "Schedule Notification",
              description: "Send a notification that appears after given time ",
              onClick: () {
                showNotificationInputDialog();
              },
              iconData: Icons.schedule,
              iconColor: Colors.pinkAccent.shade700,
            ),
          ],
        ),
      ),
    );
  }

  void showNotificationInputDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Send Notification", style: GoogleFonts.aclonica()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Notification Title",
                    suffixStyle: GoogleFonts.aclonica(),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Notification Description",
                    suffixStyle: GoogleFonts.aclonica(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: GoogleFonts.aclonica()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  _notificationService.sendInstanceNotification(
                    title: _titleController.text,
                    description: _descriptionController.text,
                  );
                  _titleController.text = "" ;
                  _descriptionController.text = "";
                },
                child: Text("Send notification", style: GoogleFonts.aclonica()),
              ),
            ],
          ),
    );
  }
}
