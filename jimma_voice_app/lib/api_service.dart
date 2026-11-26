import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class JimmaApiService {
  static const String baseUrl = "https://api.mosabitshob.com";
  static IO.Socket? socket;

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

  static void takeMicSeat(String roomId, int seatIndex, String userId) {
    socket?.emit('take_seat', {'roomId': roomId, 'seatIndex': seatIndex, 'userId': userId});
  }

  static void sendGift(String roomId, String senderId, String receiverId, int giftCost, String giftName) {
    socket?.emit('send_gift', {
      'roomId': roomId,
      'senderId': senderId,
      'receiverId': receiverId,
      'giftCost': giftCost,
      'giftName': giftName,
    });
  }

  static Future<int> getUserCoins(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/api/user/$userId'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['coins'] ?? 0;
    }
    return 0;
  }

  static Future<Map<String, dynamic>> playSlotGame(String userId, int betAmount) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/games/slot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'betAmount': betAmount}),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> verifyShegerPay({
    required String userId,
    required String referenceId,
    required String provider,
    required int coinsToAdd,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/payment/verify-shegerpay'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'referenceId': referenceId,
        'provider': provider,
        'coinsToAdd': coinsToAdd,
      }),
    );
    return jsonDecode(res.body);
  }
}
