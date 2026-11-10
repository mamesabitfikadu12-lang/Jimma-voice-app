import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jimma Voice Party',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101411),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFB7F36B),
          secondary: Color(0xFFFFC56D),
          surface: Color(0xFF1A201C),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const VoiceRoomScreen(),
    );
  }
}

class VoiceRoomScreen extends StatefulWidget {
  const VoiceRoomScreen({super.key});

  @override
  State<VoiceRoomScreen> createState() => _VoiceRoomScreenState();
}

class _VoiceRoomScreenState extends State<VoiceRoomScreen> {
  static const _accent = Color(0xFFB7F36B);
  static const _muted = Color(0xFF939B93);
  static const _etbPerUsd = 150.0;
  static const _packagePricesEtb = {10000: 10, 30000: 25, 60000: 50};
  static const _zegoAppId = 1984661954;
  static const _zegoAppSign = '9622d13c976d8545df95eb0baceb5c540087050f952ddbdb633b35d3199ea2f5';
  static const _roomId = '602841';

  int _coins = 30000;
  int _diamonds = 0;
  late final String _userID;
  late final String _userName;
  bool _isRoomJoined = false;
  bool _isHost = false;

  @override
  void initState() {
    super.initState();
    final guestId = DateTime.now().microsecondsSinceEpoch;
    _userID = 'guest_$guestId';
    _userName = 'Guest${guestId % 100000}';
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRoomOptions());
  }

  Future<void> _showRoomOptions() async {
    final action = await showDialog<_RoomAction>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isRoomJoined ? 'Room options' : 'Join Jimma Voice Party'),
        content: Text(
          _isRoomJoined
              ? 'Change your room role or leave the room.'
              : 'Start the room as its host, or join as an audience member.',
        ),
        actions: [
          if (_isRoomJoined)
            TextButton(
              onPressed: () => Navigator.pop(context, _RoomAction.leave),
              child: const Text('Leave room'),
            )
          else
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Not now'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context, _RoomAction.audience),
            child: const Text('Join as audience'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, _RoomAction.host),
            child: const Text('Start as host'),
          ),
        ],
      ),
    );

    if (!mounted || action == null) return;
    if (action == _RoomAction.leave) {
      setState(() => _isRoomJoined = false);
      return;
    }

    final isHost = action == _RoomAction.host;
    if (_isRoomJoined && isHost == _isHost) return;

    if (_isRoomJoined) {
      setState(() => _isRoomJoined = false);
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
    }

    setState(() {
      _isHost = isHost;
      _isRoomJoined = true;
    });
  }

  Widget _buildZegoRoom() {
    final config = _isHost
        ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
        : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience();
    config.background = const ColoredBox(color: Color(0xFF101411));
    config.seat.closeWhenJoining = false;
    config.seat.soundWaveColor = _accent;
    config.topMenuBar.buttons = const [];
    config.duration.isVisible = false;

    return ZegoUIKitPrebuiltLiveAudioRoom(
      key: ValueKey('$_roomId-$_userID-$_isHost'),
      appID: 1984661954,
      appSign: "9622d13c976d8545df95eb0baceb5c540087050f952ddbdb633b35d3199ea2f5",
      userID: _userID,
      userName: _userName,
      roomID: _roomId,
      config: config,
      events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
        onError: (error) {
          debugPrint('ZEGOCLOUD live room error: $error');
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('ZEGOCLOUD connection error: $error')),
            );
        },
      ),
    );
  }

  String _formatBalance(int value) => value.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => ',',
      );

  String _formatPackagePrice(int amount, {required bool international}) {
    final priceEtb = _packagePricesEtb[amount]!;
    if (!international) return '$priceEtb ETB';
    return '\$${(priceEtb / _etbPerUsd).toStringAsFixed(2)}';
  }

  void _sendGift(String name, int cost) {
    if (_coins < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins. Top up to send this gift.')),
      );
      return;
    }
    setState(() {
      _coins -= cost;
      _diamonds += (cost * 0.7).round();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name sent. ${_formatBalance((cost * 0.7).round())} diamonds earned.')),
    );
  }

  void _showTopUpSheet() {
    const packages = [10000, 30000, 60000];
    const methods = [
      _PaymentMethod('Telebirr', 'Mobile money', Icons.phone_android, Color(0xFF7EE3C1)),
      _PaymentMethod('M-Pesa', 'Mobile money', Icons.phone_android, Color(0xFF72D58B)),
      _PaymentMethod('CBE', 'Ethiopian bank', Icons.account_balance, Color(0xFF77A8FF)),
      _PaymentMethod('Awash', 'Ethiopian bank', Icons.account_balance, Color(0xFFFFA96D)),
      _PaymentMethod('Abyssinia', 'Ethiopian bank', Icons.account_balance, Color(0xFFE9C65F)),
      _PaymentMethod('USDT', 'Crypto', Icons.currency_exchange, Color(0xFF69C9A8)),
      _PaymentMethod('Visa', 'Card', Icons.credit_card, Color(0xFF8FA9FF)),
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        var selectedPackage = 30000;
        var selectedMethod = 'Telebirr';
        var isInternational = false;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final screenHeight = MediaQuery.sizeOf(context).height;
            return Container(
              constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
              decoration: const BoxDecoration(
                color: Color(0xFF171D19),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 12, 10),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const Spacer(),
                          const Text('Top up coins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Close',
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, size: 20),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SegmentedButton<bool>(
                              segments: const [
                                ButtonSegment(value: false, label: Text('Ethiopia')),
                                ButtonSegment(value: true, label: Text('International')),
                              ],
                              selected: {isInternational},
                              showSelectedIcon: false,
                              onSelectionChanged: (selection) {
                                setSheetState(() {
                                  isInternational = selection.first;
                                  selectedMethod = isInternational ? 'USDT' : 'Telebirr';
                                });
                              },
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isInternational ? 'Prices in USD / USDT' : 'Prices in ETB',
                              style: const TextStyle(fontSize: 11, color: _muted),
                            ),
                            const SizedBox(height: 14),
                            const Text('Choose a coin pack', style: TextStyle(fontSize: 13, color: _muted)),
                            const SizedBox(height: 10),
                            Row(
                              children: packages.map((amount) {
                                final selected = selectedPackage == amount;
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: amount == packages.last ? 0 : 8),
                                    child: _PackageOption(
                                      amount: amount,
                                      price: _formatPackagePrice(amount, international: isInternational),
                                      selected: selected,
                                      onTap: () => setSheetState(() => selectedPackage = amount),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 22),
                            const Text('Payment method', style: TextStyle(fontSize: 13, color: _muted)),
                            const SizedBox(height: 10),
                            for (final section in isInternational ? ['International'] : ['Mobile money', 'Ethiopian banks', 'Other']) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 8),
                                child: Text(
                                  section,
                                  style: const TextStyle(fontSize: 11, color: _muted, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: methods.where((method) {
                                  if (isInternational) return method.name == 'USDT' || method.name == 'Visa';
                                  if (section == 'Mobile money') return method.name == 'Telebirr' || method.name == 'M-Pesa';
                                  if (section == 'Ethiopian banks') return ['CBE', 'Awash', 'Abyssinia'].contains(method.name);
                                  return method.name == 'USDT' || method.name == 'Visa';
                                }).map((method) {
                                  return _PaymentOption(
                                    method: method,
                                    selected: selectedMethod == method.name,
                                    onTap: () => setSheetState(() => selectedMethod = method.name),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(content: Text('$selectedMethod payment is not connected yet.')),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: const Color(0xFF172012),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text('Continue with $selectedMethod', style: const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildRoomHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 9),
              child: Row(
                children: [
                  const Text('MIC SEATS', style: TextStyle(fontSize: 11, letterSpacing: 1.2, color: _muted, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Icon(Icons.graphic_eq, size: 15, color: _accent),
                  const SizedBox(width: 5),
                  Text(
                    !_isRoomJoined
                        ? 'Not connected'
                        : true || _zegoAppSign == '9622d13c976d8545df95eb0baceb5c540087050f952ddbdb633b35d3199ea2f5'
                            ? 'Live Voice Connected'
                            : _isHost
                                ? 'Hosting'
                                : 'Listening',
                    style: const TextStyle(fontSize: 11, color: _muted),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isRoomJoined
                  ? _buildZegoRoom()
                  : const Center(
                      child: Text(
                        'Choose a room role to connect.',
                        style: TextStyle(color: _muted),
                      ),
                    ),
            ),
            _buildWalletAndGifts(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 16, 0),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            IconButton(
              tooltip: _isRoomJoined ? 'Room options' : 'Join room',
              onPressed: _showRoomOptions,
              icon: const Icon(Icons.arrow_back_ios_new, size: 19),
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Room options',
              onPressed: _showRoomOptions,
              icon: const Icon(Icons.more_horiz, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF738D48), Color(0xFF283A2A), Color(0xFF202720)],
              ),
            ),
            child: const Icon(Icons.graphic_eq, color: _accent, size: 30),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Flexible(
                      child: Text('Jimma Voice Party', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFF522E2A), borderRadius: BorderRadius.circular(5)),
                      child: const Text('LIVE', style: TextStyle(color: Color(0xFFFF8978), fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Room  •  $_roomId', style: TextStyle(color: _muted, fontSize: 11)),
                    const SizedBox(width: 9),
                    Icon(_isHost ? Icons.mic : Icons.headphones, size: 13, color: _muted),
                    const SizedBox(width: 4),
                    Text(_isHost ? 'Host' : 'Audience', style: const TextStyle(color: _muted, fontSize: 11)),
                    const SizedBox(width: 8),
                    Icon(Icons.circle, size: 6, color: _accent),
                    const SizedBox(width: 4),
                    const Text('Open', style: TextStyle(color: _muted, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletAndGifts() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF171D19),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _BalanceChip(icon: Icons.monetization_on, color: const Color(0xFFFFC56D), value: _formatBalance(_coins)),
              const SizedBox(width: 8),
              _BalanceChip(icon: Icons.diamond, color: const Color(0xFF8FD9FF), value: _formatBalance(_diamonds)),
              const Spacer(),
              SizedBox(
                height: 36,
                child: FilledButton.tonalIcon(
                  onPressed: _showTopUpSheet,
                  icon: const Icon(Icons.add, size: 17),
                  label: const Text('Top up', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF293523),
                    foregroundColor: _accent,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _GiftButton(
                  title: 'Coffee',
                  detail: '5,000 coins',
                  icon: Icons.coffee,
                  color: const Color(0xFFC78958),
                  onTap: () => _sendGift('Coffee', 5000),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _GiftButton(
                  title: 'Lion',
                  detail: '25,000 coins',
                  icon: Icons.workspace_premium,
                  color: const Color(0xFFF0C45F),
                  onTap: () => _sendGift('Lion', 25000),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _RoomAction { host, audience, leave }

class _PaymentMethod {
  const _PaymentMethod(this.name, this.category, this.icon, this.color);

  final String name;
  final String category;
  final IconData icon;
  final Color color;
}

class _BalanceChip extends StatelessWidget {
  const _BalanceChip({required this.icon, required this.color, required this.value});

  final IconData icon;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: const Color(0xFF252C27), borderRadius: BorderRadius.circular(11)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _GiftButton extends StatelessWidget {
  const _GiftButton({required this.title, required this.detail, required this.icon, required this.color, required this.onTap});

  final String title;
  final String detail;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF242A25),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(detail, style: const TextStyle(fontSize: 10, color: Color(0xFFADB4AD))),
                  ],
                ),
              ),
              Icon(Icons.send_rounded, size: 14, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _PackageOption extends StatelessWidget {
  const _PackageOption({required this.amount, required this.price, required this.selected, required this.onTap});

  final int amount;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = amount == 10000 ? '10,000' : amount == 30000 ? '30,000' : '60,000';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2A3824) : const Color(0xFF222823),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFF8DBB54) : Colors.white10),
        ),
        child: Column(
          children: [
            const Icon(Icons.monetization_on, size: 17, color: Color(0xFFFFC56D)),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: selected ? const Color(0xFFCBF99B) : Colors.white)),
            const SizedBox(height: 3),
            Text(price, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: selected ? const Color(0xFFCBF99B) : const Color(0xFFADB4AD))),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({required this.method, required this.selected, required this.onTap});

  final _PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.sizeOf(context).width - 48) / 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2A3824) : const Color(0xFF222823),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? const Color(0xFF8DBB54) : Colors.white10),
          ),
          child: Row(
            children: [
              Icon(method.icon, size: 18, color: method.color),
              const SizedBox(width: 8),
              Expanded(child: Text(method.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              if (selected) const Icon(Icons.check_circle, size: 15, color: Color(0xFFB7F36B)),
            ],
          ),
        ),
      ),
    );
  }
}