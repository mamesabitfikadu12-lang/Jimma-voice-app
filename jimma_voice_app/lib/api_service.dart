import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

class JimmaApiService {
  static const String baseUrl = "https://onrender.com";
  static IO.Socket? socket;

  // 1. Real-Time Socket Walitti Hidhuu (Voice Room & Gifts)
  static void connectSocket(String roomId, String userId, Function(dynamic) onRoomUpdate, Function(dynamic) onGiftReceived) {
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.onConnect((_) {
      socket!.emit('join_room', {'roomId': roomId, 'userId': userId});
    });

    socket!.on('room_update', (data) => onRoomUpdate(data));
    socket!.on('gift_received', (data) => onGiftReceived(data));
  }

  // Teessuma Maayikiroofoonii Qabachuu (Take Mic Seat)
  static void takeMicSeat(String roomId, int seatIndex, String userId) {
    socket?.emit('take_seat', {'roomId': roomId, 'seatIndex': seatIndex, 'userId': userId});
  }

  // Kennaa (Gift) Walii Erguu
  static void sendGift(String roomId, String senderId, String receiverId, int giftCost, String giftName) {
    socket?.emit('send_gift', {
      'roomId': roomId,
      'senderId': senderId,
      'receiverId': receiverId,
      'giftCost': giftCost,
      'giftName': giftName,
    });
  }

  // 2. Coins Fayyadamaa Sarvarii Irraa Fiduu
  static Future<int> getUserCoins(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/api/user/$userId'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['coins'] ?? 0;
    }
    return 0;
  }

  // 3. Tapha Oromia Royal Slot Taphachuu
  static Future<Map<String, dynamic>> playSlotGame(String userId, int betAmount) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/games/slot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'betAmount': betAmount}),
    );
    return jsonDecode(res.body);
  }

  // 4. Kaffaltii Chapa Jalqabuu (Coins Bituuf)
  static Future<void> buyCoinsWithChapa(String userId, int amountETB, String email, String name) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/payment/buy-coins'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'amountETB': amountETB,
        'email': email,
        'firstName': name,
      }),
    );
    final data = jsonDecode(res.body);
    if (data['data'] != null && data['data']['checkout_url'] != null) {
      final Uri url = Uri.parse(data['data']['checkout_url']);
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
