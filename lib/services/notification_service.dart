import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 알림 ID를 관리하는 변수
  int _notificationId = 0;

  // 앱 시작 시 TimeZone 초기화 및 알림 초기화
  Future<void> initialize(BuildContext context) async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationClick(context, response.payload);
      },
    );

    // Android 13 이상에서 알림 권한 요청
    final androidPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  // 알림 클릭 시 처리
  void _handleNotificationClick(BuildContext context, String? payload) {
    if (payload != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('알림 클릭'),
          content: Text('Payload: $payload'),
        ),
      );
    }
  }

  // 알림 ID 생성기
  int generateNotificationId() {
    return _notificationId++;
  }

  // 매일 반복되는 텍스트 알림 예약 (시작 날짜, 종료 날짜, 알림 시각, 켜짐/꺼짐 상태 관리)
  Future<void> scheduleRepeatingTextNotification(
      String title,
      String body,
      DateTime startDate,
      DateTime endDate,
      TimeOfDay notificationTime,
      int notificationId,
      {String? payload}) async {
    final now = DateTime.now();

    // 알림이 종료 날짜를 초과한 경우 알림을 취소
    if (now.isAfter(endDate)) {
      await cancelNotification(notificationId);
      return;
    }

    // 알림 시각에 맞춘 DateTime 계산
    DateTime scheduledDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    // 알림이 시작 날짜보다 현재 시간이 늦으면 그 다음 날로 예약
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        notificationTime.hour,
        notificationTime.minute,
      );
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'text_channel_id',
      'Text Notifications',
      channelDescription: 'Channel for text notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // 매일 반복되는 알림 스케줄 설정
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local), // 첫 번째 알림 시간
      platformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 같은 시간에 반복
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 매일 반복되는 이미지 알림 예약 (시작 날짜, 종료 날짜, 알림 시각, 켜짐/꺼짐 상태 관리)
  Future<void> scheduleRepeatingNotificationWithAssetImage(
      String title,
      String body,
      DateTime startDate,
      DateTime endDate,
      TimeOfDay notificationTime,
      String assetImagePath, // 애셋 경로
      {String? payload}) async {
    final notificationId = generateNotificationId();

    final now = DateTime.now();

    // 알림이 종료 날짜를 초과한 경우 알림을 취소
    if (now.isAfter(endDate)) {
      await cancelNotification(notificationId);
      return;
    }

    // 알림 시각에 맞춘 DateTime 계산
    DateTime scheduledDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    // 현재 시간이 이미 지난 경우 다음 날 알림으로 예약
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        notificationTime.hour,
        notificationTime.minute,
      );
    }

    // 애셋 파일을 로컬 파일 시스템으로 복사
    final String localImagePath =
        await copyAssetToLocal(assetImagePath, 'notification_image.png');

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(localImagePath), // 로컬 파일 경로 사용
      contentTitle: title,
      summaryText: body,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'image_channel_id',
      'Image Notifications',
      channelDescription: 'Channel for image notifications',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // 매일 반복되는 이미지 알림 스케줄 설정
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local), // 첫 번째 알림 시간
      platformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 같은 시간에 반복
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 알림 취소
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // 애셋 파일을 로컬 파일로 복사
  Future<String> copyAssetToLocal(String assetPath, String filename) async {
    try {
      final ByteData byteData = await rootBundle.load(assetPath);
      final Directory directory = await getTemporaryDirectory();
      final String filePath = '${directory.path}/$filename';
      final File file = File(filePath);

      // 파일이 이미 존재하는지 확인하고 없으면 생성
      if (!await file.exists()) {
        await file.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      }

      return filePath; // 로컬 파일 경로 반환
    } catch (e) {
      print('Error loading asset: $e');
      throw Exception('Failed to load asset');
    }
  }
}
