import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_notification_demo/auth_page.dart';
import 'package:local_notification_demo/services/auth_service.dart';
import 'package:local_notification_demo/services/firebase_message_service.dart';
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
  AuthService _authService = AuthService();
  DateTime? date;
  TimeOfDay? time;

  @override
  void initState() {
    super.initState();
    initializeNotification();

    FirebaseMessageService().subscribeToTopic("pune");
  }

  initializeNotification() {
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await _authService.logOutUser();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                  (route) => false,
                );
              } catch (ex) {
                //SHOW SNACKBAR

              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
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
                showNotificationInputDialog(isScheduled: false);
              },
              iconData: Icons.notifications,
              iconColor: Colors.deepPurple.shade800,
            ),
            SizedBox(height: 16.0),
            CustomCard(
              title: "Schedule Notification",
              description: "Send a notification that appears after given time ",
              onClick: () {
                showNotificationInputDialog(isScheduled: true);
              },
              iconData: Icons.schedule,
              iconColor: Colors.pinkAccent.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Future showNotificationInputDialog({required bool isScheduled}) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Send Notification", style: GoogleFonts.aclonica()),
              content: SingleChildScrollView(
                child: Column(
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
                    SizedBox(height: 20.0),
                    if (isScheduled)
                      ElevatedButton.icon(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 2)),
                          );

                          if (picked != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              setDialogState(() {
                                date = picked;
                                time = pickedTime;
                              });
                            }
                          }
                        },
                        label: Text("Select Date and Time"),
                        icon: Icon(Icons.timer_outlined),
                      ),
                    if (isScheduled)
                      Text(
                        date != null && time != null
                            ? "Selected: ${date!.day}-${date!.month}-${date!.year} ${time!.format(context)}"
                            : "No date and time selected",
                        style: GoogleFonts.aclonica(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
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
                    if (isScheduled && date != null && time != null) {
                      Navigator.pop(context);
                      _notificationService.sendScheduleNotification(
                        title: _titleController.text,
                        body: _descriptionController.text,
                        dateTime: DateTime(
                          date!.year,
                          date!.month,
                          date!.day,
                          time!.hour,
                          time!.minute,
                        ),
                      );
                    } else if (!isScheduled) {
                      Navigator.pop(context);
                      _notificationService.sendInstanceNotification(
                        title: _titleController.text,
                        description: _descriptionController.text,
                      );
                    }

                    _titleController.text = "";
                    _descriptionController.text = "";
                  },
                  child: Text(
                    "Send notification",
                    style: GoogleFonts.aclonica(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
