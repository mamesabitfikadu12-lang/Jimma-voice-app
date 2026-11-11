import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JimmaVoiceChatFamilyApp());
}

class JimmaVoiceChatFamilyApp extends StatelessWidget {
  const JimmaVoiceChatFamilyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jimma Voice Chat Family',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008F6B)),
        scaffoldBackgroundColor: const Color(0xFFF1F9F6),
      ),
      home: const MainNav(),
    );
  }
}

class AppData {
  static int coins = 102500;
  static double points = 116813.52;
  static double frozenPoints = 0.0;
  static int vip = 3, wealthLv = 32, charmLv = 25, activeLv = 23;
  static int followed = 83, following = 188, friends = 13, invited = 18;
  static bool isCoinSeller = true;
  static String uid = "3712956";
  static String name = "MohammedsabitF";
  static String bio = "Land of Coffee & Hospitality • Jimma Voice Chat Family";
  static String familyName = "Abbaa Jifar Royal Family";
  static String invite = "JIMMA884";
  static String adminPin = "2026";
  static String adminWhatsapp = "+251919108311";
  static String adminTelegram = "@JimmaVoiceAdmin";
  static String equippedFrame = "Jimma Golden Coffee Crown";
  static String equippedEntry = "Shark Moto";
  static final List<String> ownedItems = ["Jimma Golden Coffee Crown", "Star of Fortune", "Shark Moto"];
  static final List<String> badges = ["Jimma Founder", "Official Coin Seller", "Top VIP Host"];

  static final List<Map<String, dynamic>> agencyRequests = [
    {
      "id": "AG-501",
      "agencyName": "Jimma Royal Agency",
      "ownerName": "Abebe Kebede",
      "nationalId": "ET-992837461",
      "idPhoto": "National_ID_Front_Back.jpg",
      "whatsapp": "+251911223344",
      "telegram": "@AbebeAgency",
      "hosts": "12 Hosts",
      "status": "Pending"
    }
  ];

  static final List<Map<String, dynamic>> chatMessages = [
    {"sender": "user", "text": "Please deposit my coin (5 USDT TRC20)", "img": "Receipt_Binance_5USDT.jpg", "time": "10:05"},
    {"sender": "admin", "text": "Welcome to Jimma Voice Chat Family Support! Verifying your 5 USDT (50,000 Coins) deposit.", "img": "", "time": "10:06"},
  ];

  static final tickets = <Map<String, dynamic>>[
    {"id": "TCK-1042", "user": "User #492011", "title": "900 ETB -> 50,000 Coins (Regular 180/10k)", "msg": "Paid via Telebirr +251919108311", "status": "Pending", "coins": 50000},
    {"id": "TCK-1041", "user": "Seller #773120", "title": "5 USDT -> 60,000 Coins (Seller 20% Bonus)", "msg": "Paid to TRC20 TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE", "status": "Resolved", "coins": 60000},
  ];

  static final payments = [
    {"name": "Telebirr", "acc": "+251919108311", "cur": "ETB"},
    {"name": "CBEBirr", "acc": "+251919108311", "cur": "ETB"},
    {"name": "Siinqee Plus Wallet", "acc": "+251919108311", "cur": "ETB"},
    {"name": "CBE Bank", "acc": "1000273060937", "cur": "ETB"},
    {"name": "Awash Bank", "acc": "014251157710000", "cur": "ETB"},
    {"name": "Dashen Bank", "acc": "2952945930711", "cur": "ETB"},
    {"name": "Binance USDT (TRC20)", "acc": "TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE", "cur": "USDT"},
  ];
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int idx = 0;
  void upd() => setState(() {});
  @override
  Widget build(BuildContext context) {
    final pages = [RoomTab(onUpd: upd), const MomentTab(), const MsgTab(), MeTab(onUpd: upd)];
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i) => setState(() => idx = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF008F6B),
        unselectedItemColor: Colors.grey.shade500,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq_rounded), label: "Room"),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: "Moment"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: "Message"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Me"),
        ],
      ),
    );
  }
}
class RoomTab extends StatefulWidget {
  final VoidCallback onUpd;
  const RoomTab({super.key, required this.onUpd});
  @override
  State<RoomTab> createState() => _RoomTabState();
}

class _RoomTabState extends State<RoomTab> {
  String tab = "Party", country = "All";
  @override
  Widget build(BuildContext context) {
    final rooms = [
      {"id": "602841", "title": "Jimma Coffee & Cultural Lounge", "tag": "Official", "c": "Ethiopia", "u": 248},
      {"id": "889102", "title": "Abbaa Jifar Royal Palace VIP", "tag": "Family", "c": "Ethiopia", "u": 194},
      {"id": "334910", "title": "Official Coin Seller & Agency", "tag": "Seller", "c": "International", "u": 142},
      {"id": "551209", "title": "Lucky Island 20 Games Arena", "tag": "Games", "c": "Middle East", "u": 176},
      {"id": "774120", "title": "Oromo & Global Music Party", "tag": "Music", "c": "USA & Europe", "u": 115},
    ].where((r) => country == "All" || r["c"] == country).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: ["Follow", "Party", "Games"].map((t) => GestureDetector(
              onTap: () => t == "Games" ? Navigator.push(context, MaterialPageRoute(builder: (_) => GamesHubPage(onUpd: widget.onUpd))) : setState(() => tab = t),
              child: Padding(padding: const EdgeInsets.only(right: 16), child: Text(t, style: TextStyle(fontSize: tab == t ? 21 : 16, fontWeight: FontWeight.bold, color: tab == t ? const Color(0xFF008F6B) : Colors.grey))),
            )).toList()),
            Row(children: [
              IconButton(icon: const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFB800)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventCenterPage(onUpd: widget.onUpd)))),
              IconButton(icon: const Icon(Icons.add_circle_rounded, color: Color(0xFF008F6B), size: 28), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveRoomPage(id: "602841", title: "My Jimma Voice Room", host: true, onUpd: widget.onUpd)))),
            ]),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF006B4F), Color(0xFF00A87E)]), borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.local_cafe_rounded, color: Color(0xFFFFD700), size: 28),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Jimma Voice Chat Family", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  Text("Land of Coffee & Royal Hospitality", style: TextStyle(color: Color(0xFFFFE082), fontSize: 12)),
                ])),
                IconButton(icon: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFFFFD700), size: 28), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RechargePage(onUpd: widget.onUpd)))),
              ]),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GamesHubPage(onUpd: widget.onUpd))),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFB800), Color(0xFFFF7B00)]), borderRadius: BorderRadius.circular(14)),
                  child: const Row(children: [
                    Icon(Icons.sports_esports_rounded, color: Colors.white, size: 30),
                    SizedBox(width: 10),
                    Expanded(child: Text("LUCKY ISLAND • 20 Animated Games! Win Big!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                  ]),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: ["All", "Ethiopia", "International", "Middle East", "USA & Europe"].map((c) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(label: Text(c), selected: country == c, onSelected: (_) => setState(() => country = c)),
            )).toList()),
          ),
          const SizedBox(height: 10),
          ...rooms.map((r) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: const Color(0xFF008F6B), child: Icon(r["tag"] == "Official" ? Icons.local_cafe : Icons.mic_rounded, color: Colors.white)),
              title: Text(r["title"].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text("ID: ${r["id"]} • ${r["tag"]} • ${r["c"]}"),
              trailing: Text("${r["u"]} Live", style: const TextStyle(color: Color(0xFF008F6B), fontWeight: FontWeight.bold)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveRoomPage(id: r["id"].toString(), title: r["title"].toString(), host: true, onUpd: widget.onUpd))),
            ),
          )),
        ],
      ),
    );
  }
}
class PlayAnimatedGamePage extends StatefulWidget {
  final String gameName;
  final int c1, c2;
  final IconData icon;
  final VoidCallback onUpd;
  const PlayAnimatedGamePage({super.key, required this.gameName, required this.c1, required this.c2, required this.icon, required this.onUpd});
  @override
  State<PlayAnimatedGamePage> createState() => _PlayAnimatedGamePageState();
}

class _PlayAnimatedGamePageState extends State<PlayAnimatedGamePage> with SingleTickerProviderStateMixin {
  late AnimationController _spinCtrl;
  bool spinning = false;
  int bet = 1000;
  String msg = "Tap SPIN to win up to 100,000 Coins!";

  @override
  void initState() { super.initState(); _spinCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)); }
  @override
  void dispose() { _spinCtrl.dispose(); super.dispose(); }

  void play() {
    if (spinning || AppData.coins < bet) return;
    setState(() { spinning = true; AppData.coins -= bet; msg = "Spinning..."; });
    widget.onUpd();
    _spinCtrl.forward(from: 0).then((_) {
      final mults = List<int>.generate(6, (i) => i == 0 ? 0 : i * 2);
      final win = bet * mults[Random().nextInt(6)];
      setState(() {
        spinning = false;
        AppData.coins += win;
        AppData.points += win * 0.25;
        msg = win > 0 ? "JACKPOT! Won $win Coins (+${(win * 0.25).round()} Points)!" : "Try Again! Good Luck!";
      });
      widget.onUpd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071D18),
      appBar: AppBar(title: Text(widget.gameName), backgroundColor: Color(widget.c1), foregroundColor: Colors.white),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Coins: ${AppData.coins} | Points: ${AppData.points.toStringAsFixed(0)}", style: const TextStyle(color: Color(0xFFFFD700), fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          RotationTransition(
            turns: CurvedAnimation(parent: _spinCtrl, curve: Curves.easeOutBack),
            child: Container(
              width: 170, height: 170,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: SweepGradient(colors: [Color(widget.c1), const Color(0xFFFFD700), Color(widget.c2), const Color(0xFF00B894), Color(widget.c1)]), border: Border.all(color: Colors.white, width: 4)),
              child: Center(child: Icon(widget.icon, size: 70, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 20),
          Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List<int>.generate(4, (i) => (i + 1) * 1000).map((b) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(label: Text("$b"), selected: bet == b, onSelected: (_) => setState(() => bet = b)),
          )).toList()),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB800), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
            onPressed: play,
            child: Text(spinning ? "SPINNING..." : "SPIN ($bet Coins)", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }
}
class PointsWalletPage extends StatefulWidget {
  final VoidCallback onUpd;
  const PointsWalletPage({super.key, required this.onUpd});
  @override
  State<PointsWalletPage> createState() => _PointsWalletPageState();
}

class _PointsWalletPageState extends State<PointsWalletPage> {
  String mode = "Cash Out", currency = "Ethiopia (ETB)";
  final ptsCtrl = TextEditingController(text: "100000"), accCtrl = TextEditingController(), targetIdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pts = double.tryParse(ptsCtrl.text) ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text("Points / Blue Diamonds"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF008F6B), Color(0xFF00B894)]), borderRadius: BorderRadius.circular(18)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Available Points Balance", style: TextStyle(color: Colors.white70)),
            Text(AppData.points.toStringAsFixed(2), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            Text("Frozen: ${AppData.frozenPoints.toStringAsFixed(2)} • 100,000 Points = \$10", style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: ["Cash Out", "Exchange", "Transfer"].map((m) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: ChoiceChip(label: Text(m), selected: mode == m, onSelected: (_) => setState(() => mode = m))))).toList()),
        const SizedBox(height: 12),
        TextField(controller: ptsCtrl, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: "Points Amount (Min 100,000)", border: OutlineInputBorder())),
        const SizedBox(height: 10),
        if (mode == "Cash Out") ...[
          DropdownButtonFormField<String>(value: currency, items: ["Ethiopia (ETB)", "BINANCE-USDT", "Kenya (KES)", "UAE (AED)", "Germany (EUR)", "USA (USD)"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => currency = v!), decoration: const InputDecoration(labelText: "Currency Type", border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: accCtrl, decoration: const InputDecoration(labelText: "Telebirr / Bank / Binance TRC20 Address", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
            onPressed: () {
              if (pts < 100000 || pts > AppData.points) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Minimum 100,000 Points required!"))); return; }
              setState(() { AppData.points -= pts; AppData.frozenPoints += pts; });
              AppData.tickets.insert(0, {"id": "WDR-${100 + AppData.tickets.length}", "user": "User #${AppData.uid}", "title": "Cash Out ${pts.round()} Pts ($currency)", "msg": "Pay to: ${accCtrl.text}", "status": "Pending", "coins": 0});
              widget.onUpd();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Withdrawal Sent to Admin!")));
            },
            child: Text("Withdraw (\$${(pts / 10000).toStringAsFixed(2)})"),
          ),
        ] else if (mode == "Exchange") ...[
          Text("Rate: 10,000 Points = 9,000 Coins (${(pts * 0.9).round()} Coins)", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () { if (pts < 1000 || pts > AppData.points) return; setState(() { AppData.points -= pts; AppData.coins += (pts * 0.9).round(); }); widget.onUpd(); }, child: const Text("Exchange to Coins Now")),
        ] else ...[
          TextField(controller: targetIdCtrl, decoration: const InputDecoration(labelText: "Agency ID or User ID", border: OutlineInputBorder())),
          const SizedBox(height: 8),
          Text("Transfer Fee: 2% • Recipient gets ${(pts * 0.98).round()} Points", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () { if (pts < 100000 || pts > AppData.points || targetIdCtrl.text.isEmpty) return; setState(() { AppData.points -= pts; }); widget.onUpd(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Transferred to ${targetIdCtrl.text}!"))); }, child: const Text("Transfer Points")),
        ],
      ]),
    );
  }
}
class MomentTab extends StatelessWidget {
  const MomentTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jimma Moments"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: const [
        Card(child: ListTile(leading: Icon(Icons.local_cafe, color: Color(0xFF008F6B)), title: Text("Jimma Official • VIP 7"), subtitle: Text("Welcome to Jimma Voice Chat Family! Share your Invite Link & earn +2,000 Coins/friend."))),
        Card(child: ListTile(leading: Icon(Icons.star, color: Colors.amber), title: Text("Abbaa Jifar Royal • VIP 5"), subtitle: Text("Join Jimma Coffee & Cultural Lounge (Room 602841) tonight!"))),
      ]),
    );
  }
}

class MsgTab extends StatelessWidget {
  const MsgTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        Card(child: ListTile(leading: const Icon(Icons.support_agent, color: Color(0xFF008F6B)), title: const Text("Live Customer Support Center"), subtitle: const Text("Send receipt photo or deposit query"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveSupportChatPage())))),
        const Card(child: ListTile(leading: Icon(Icons.campaign, color: Colors.orange), title: Text("Official Rate Notice"), subtitle: Text("Regular: 180 ETB=10k | Seller/Bulk: 150 ETB=10k | Min USDT: \$5 (50k)"))),
      ]),
    );
  }
}

class MeTab extends StatefulWidget {
  final VoidCallback onUpd;
  const MeTab({super.key, required this.onUpd});
  @override
  State<MeTab> createState() => _MeTabState();
}

class _MeTabState extends State<MeTab> {
  void refresh() { setState(() {}); widget.onUpd(); }

  @override
  Widget build(BuildContext context) {
    final gridItems = [
      {"t": "Recharge", "i": Icons.account_balance_wallet_rounded, "c": Colors.orange, "p": RechargePage(onUpd: refresh)},
      {"t": "Points", "i": Icons.diamond_rounded, "c": Colors.blue, "p": PointsWalletPage(onUpd: refresh)},
      {"t": "Store", "i": Icons.store_mall_directory_rounded, "c": Colors.purple, "p": StorePage(onUpd: refresh)},
      {"t": "Backpack", "i": Icons.backpack_rounded, "c": Colors.teal, "p": BackpackPage(onUpd: refresh)},
      {"t": "Invitation", "i": Icons.share_rounded, "c": Colors.green, "p": InvitePage(onUpd: refresh)},
      {"t": "Lucky Island", "i": Icons.sports_esports_rounded, "c": Colors.deepOrange, "p": GamesHubPage(onUpd: refresh)},
      {"t": "Host Center", "i": Icons.mic_external_on_rounded, "c": Colors.pink, "p": const HostCenterPage()},
      {"t": "Agency", "i": Icons.business_center_rounded, "c": Colors.indigo, "p": const AgencyCenterPage()},
      {"t": "Coin Seller", "i": Icons.verified_user_rounded, "c": Colors.amber.shade800, "p": RechargePage(onUpd: refresh)},
      {"t": "VIP Club", "i": Icons.workspace_premium_rounded, "c": Colors.amber, "p": VipPage(onUpd: refresh)},
      {"t": "Badge Wall", "i": Icons.military_tech_rounded, "c": Colors.redAccent, "p": const BadgeWallPage()},
      {"t": "Support", "i": Icons.support_agent_rounded, "c": const Color(0xFF008F6B), "p": const LiveSupportChatPage()},
    ];

    return SafeArea(
      child: ListView(padding: const EdgeInsets.all(14), children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF006B4F), Color(0xFF00A87E)]), borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Row(children: [
              CircleAvatar(radius: 30, backgroundColor: const Color(0xFFFFD700), child: Text(AppData.name[0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF006B4F)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(AppData.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("ID: ${AppData.uid} • VIP ${AppData.vip} • ${AppData.familyName}", style: const TextStyle(color: Color(0xFFFFE082), fontSize: 12)),
                Text(AppData.bio, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ])),
            ]),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Text("${AppData.followed}\nFollowed", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12)),
              Text("${AppData.following}\nFollowing", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12)),
              Text("${AppData.friends}\nFriends", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12)),
              Text("Lv.${AppData.wealthLv}\nWealth", textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.bold)),
            ]),
            const Divider(color: Colors.white24, height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RechargePage(onUpd: refresh))), child: Text("Coins: ${AppData.coins}", style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 15))),
              InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointsWalletPage(onUpd: refresh))), child: Text("Points: ${AppData.points.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.9, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: gridItems.length,
            itemBuilder: (_, i) {
              final g = gridItems[i];
              return InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => g["p"] as Widget)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CircleAvatar(backgroundColor: (g["c"] as Color).withOpacity(0.15), child: Icon(g["i"] as IconData, color: g["c"] as Color)),
                  const SizedBox(height: 4),
                  Text(g["t"] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.admin_panel_settings_rounded, color: Colors.redAccent),
            title: const Text("Super Admin Control Panel", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("PIN Protected (Deposits, Withdrawals, Agencies)"),
            trailing: const Icon(Icons.lock_rounded, color: Colors.redAccent),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminPinGatePage(onUpd: refresh))),
          ),
        ),
      ]),
    );
  }
}
class StorePage extends StatefulWidget {
  final VoidCallback onUpd;
  const StorePage({super.key, required this.onUpd});
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final items = [
    {"name": "Jimma Golden Coffee Crown", "type": "Frame", "cost": 15000},
    {"name": "Shark Moto", "type": "Entry", "cost": 30000},
    {"name": "Ice-Fire Soul", "type": "Entry", "cost": 50000},
    {"name": "Star of Fortune", "type": "Frame", "cost": 20000},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Jimma Luxury Store (${AppData.coins})"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final it = items[i];
          final owned = AppData.ownedItems.contains(it["name"]);
          return Card(
            child: ListTile(
              leading: Icon(it["type"] == "Entry" ? Icons.two_wheeler : Icons.workspace_premium, color: const Color(0xFFFFB800)),
              title: Text("${it["name"]} (${it["type"]})", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${it["cost"]} Coins"),
              trailing: ElevatedButton(
                onPressed: owned ? null : () {
                  final c = it["cost"] as int;
                  if (AppData.coins >= c) { setState(() { AppData.coins -= c; AppData.ownedItems.add(it["name"] as String); }); widget.onUpd(); }
                },
                child: Text(owned ? "Owned" : "Buy"),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BackpackPage extends StatefulWidget {
  final VoidCallback onUpd;
  const BackpackPage({super.key, required this.onUpd});
  @override
  State<BackpackPage> createState() => _BackpackPageState();
}

class _BackpackPageState extends State<BackpackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Backpack"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: AppData.ownedItems.map((name) => Card(
          child: ListTile(
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text((AppData.equippedFrame == name || AppData.equippedEntry == name) ? "Currently Equipped" : "In Backpack"),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() { if (name.contains("Moto") || name.contains("Soul")) { AppData.equippedEntry = name; } else { AppData.equippedFrame = name; } });
                widget.onUpd();
              },
              child: const Text("Equip"),
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class InvitePage extends StatefulWidget {
  final VoidCallback onUpd;
  const InvitePage({super.key, required this.onUpd});
  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    final link = "https://jimmavoice.app{AppData.invite}";
    return Scaffold(
      appBar: AppBar(title: const Text("Invite Friends & Earn"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Text("Personal Invite Code: ${AppData.invite}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF008F6B))),
                const SizedBox(height: 6),
                Text(link, style: const TextStyle(color: Colors.blue, fontSize: 12)),
                const SizedBox(height: 8),
                Text("Total Invited: ${AppData.invited} Friends (+2,000 Coins/Friend)"),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
            icon: const Icon(Icons.share),
            label: const Text("Copy Personal Invite Link & Share"),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: "Join Jimma Voice Chat Family! Use my link: $link"));
              setState(() { AppData.invited += 1; AppData.coins += 2000; });
              widget.onUpd();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Personal Invite Link Copied! (+2,000 Bonus)")));
            },
          ),
        ]),
      ),
    );
  }
}

class VipPage extends StatefulWidget {
  final VoidCallback onUpd;
  const VipPage({super.key, required this.onUpd});
  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Royal VIP Club"), backgroundColor: const Color(0xFFFFB800), foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: 7,
        itemBuilder: (_, i) {
          final lv = i + 1;
          final cost = lv * 10000;
          return Card(child: ListTile(
            title: Text("VIP $lv Package", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("$cost Coins • Golden Crown + Entry Effect"),
            trailing: ElevatedButton(
              onPressed: AppData.vip >= lv ? null : () { if (AppData.coins >= cost) { setState(() { AppData.coins -= cost; AppData.vip = lv; }); widget.onUpd(); } },
              child: Text(AppData.vip >= lv ? "Active" : "Upgrade"),
            ),
          ));
        },
      ),
    );
  }
}

class HostCenterPage extends StatelessWidget {
  const HostCenterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Host Center"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: ListTile(title: const Text("Current Agency"), subtitle: Text("${AppData.familyName} (Code: ${AppData.invite})"))),
        Card(child: ListTile(title: const Text("Gift & Hourly Points"), subtitle: Text("${AppData.points.toStringAsFixed(2)} Points Ready to Cash Out"))),
      ]),
    );
  }
}

class BadgeWallPage extends StatelessWidget {
  const BadgeWallPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Badge Wall"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: AppData.badges.map((b) => Card(child: ListTile(leading: const Icon(Icons.military_tech, color: Color(0xFFFFB800)), title: Text(b)))).toList()),
    );
  }
}

class EventCenterPage extends StatelessWidget {
  final VoidCallback onUpd;
  EventCenterPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jimma Event Center"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        Card(child: ListTile(leading: const Icon(Icons.local_cafe, color: Color(0xFF008F6B)), title: const Text("Jimma Grand Launch Festival"), subtitle: const Text("Regular: 180 ETB=10k | Seller: 150 ETB=10k | Min USDT: \$5"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RechargePage(onUpd: onUpd))))),
        Card(child: ListTile(leading: const Icon(Icons.group_add, color: Colors.orange), title: const Text("Invite Friends Generous Reward"), subtitle: const Text("Share your link & earn +2,000 Coins per friend"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvitePage(onUpd: onUpd))))),
      ]),
    );
  }
}
class AgencyCenterPage extends StatefulWidget {
  const AgencyCenterPage({super.key});
  @override
  State<AgencyCenterPage> createState() => _AgencyCenterPageState();
}

class _AgencyCenterPageState extends State<AgencyCenterPage> {
  final agCtrl = TextEditingController(), owCtrl = TextEditingController(), nidCtrl = TextEditingController(), waCtrl = TextEditingController(), tgCtrl = TextEditingController();
  String idImg = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agency Verification"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(color: const Color(0xFFE6F7F2), child: ListTile(title: const Text("Admin Approval Contact"), subtitle: Text("WA: ${AppData.adminWhatsapp} | TG: ${AppData.adminTelegram}"))),
        TextField(controller: agCtrl, decoration: const InputDecoration(labelText: "Agency Name")),
        TextField(controller: owCtrl, decoration: const InputDecoration(labelText: "Owner Full Name")),
        TextField(controller: nidCtrl, decoration: const InputDecoration(labelText: "National ID / Passport Number")),
        TextField(controller: waCtrl, decoration: const InputDecoration(labelText: "Agency WhatsApp")),
        TextField(controller: tgCtrl, decoration: const InputDecoration(labelText: "Agency Telegram")),
        OutlinedButton.icon(icon: const Icon(Icons.badge), label: Text(idImg.isEmpty ? "Upload National ID Photo" : "Attached: $idImg"), onPressed: () => setState(() => idImg = "National_ID.jpg")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
          onPressed: () {
            if (agCtrl.text.isEmpty || nidCtrl.text.isEmpty) return;
            AppData.agencyRequests.insert(0, {"id": "AG-502", "agencyName": agCtrl.text, "ownerName": owCtrl.text, "nationalId": nidCtrl.text, "idPhoto": "National_ID.jpg", "whatsapp": waCtrl.text, "telegram": tgCtrl.text, "status": "Pending"});
            Clipboard.setData(ClipboardData(text: "Agency Apply: ${agCtrl.text} | ID: ${nidCtrl.text} | WA: ${waCtrl.text}"));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sent to Admin Panel & Copied for WhatsApp/TG!")));
            Navigator.pop(context);
          },
          child: const Text("Submit & Send to Admin WhatsApp/TG"),
        ),
      ]),
    );
  }
}

class LiveSupportChatPage extends StatefulWidget {
  const LiveSupportChatPage({super.key});
  @override
  State<LiveSupportChatPage> createState() => _LiveSupportChatPageState();
}

class _LiveSupportChatPageState extends State<LiveSupportChatPage> {
  final msgCtrl = TextEditingController();
  String img = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Support Chat"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: AppData.chatMessages.length, itemBuilder: (_, i) {
          final m = AppData.chatMessages[i];
          return Card(child: ListTile(title: Text(m["text"]), subtitle: (m["img"] as String).isNotEmpty ? Text("Photo: ${m["img"]}") : null));
        })),
        Row(children: [
          IconButton(icon: const Icon(Icons.add_photo_alternate, color: Color(0xFF008F6B)), onPressed: () => setState(() => img = "Receipt_${DateTime.now().millisecond}.jpg")),
          Expanded(child: TextField(controller: msgCtrl, decoration: InputDecoration(hintText: img.isEmpty ? "Message or attach receipt..." : "Attached: $img"))),
          IconButton(icon: const Icon(Icons.send, color: Color(0xFF008F6B)), onPressed: () {
            if (msgCtrl.text.isEmpty && img.isEmpty) return;
            setState(() { AppData.chatMessages.add({"sender": "user", "text": msgCtrl.text.isEmpty ? "Receipt Sent" : msgCtrl.text, "img": img, "time": "Now"}); msgCtrl.clear(); img = ""; });
          }),
        ]),
      ]),
    );
  }
}

class AdminPinGatePage extends StatefulWidget {
  final VoidCallback onUpd;
  const AdminPinGatePage({super.key, required this.onUpd});
  @override
  State<AdminPinGatePage> createState() => _AdminPinGatePageState();
}

class _AdminPinGatePageState extends State<AdminPinGatePage> {
  final pinCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Security Check"), backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.lock_person, size: 64, color: Colors.redAccent),
        TextField(controller: pinCtrl, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Enter Admin PIN (2026)")),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: () {
          if (pinCtrl.text == AppData.adminPin) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SuperAdminPanelPage(onUpd: widget.onUpd)));
        }, child: const Text("Unlock Admin Panel")),
      ])),
    );
  }
}

class SuperAdminPanelPage extends StatefulWidget {
  final VoidCallback onUpd;
  const SuperAdminPanelPage({super.key, required this.onUpd});
  @override
  State<SuperAdminPanelPage> createState() => _SuperAdminPanelPageState();
}

class _SuperAdminPanelPageState extends State<SuperAdminPanelPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(title: const Text("Super Admin Panel"), backgroundColor: Colors.redAccent, foregroundColor: Colors.white, bottom: const TabBar(tabs: [Tab(text: "Deposits/Withdraw"), Tab(text: "Agency IDs")])),
      body: TabBarView(children: [
        ListView.builder(itemCount: AppData.tickets.length, itemBuilder: (_, i) {
          final t = AppData.tickets[i];
          return Card(child: ListTile(title: Text("${t["id"]}: ${t["title"]}"), subtitle: Text(t["msg"]), trailing: t["status"] == "Pending" ? ElevatedButton(onPressed: () { setState(() { t["status"] = "Resolved"; AppData.coins += (t["coins"] as int); }); widget.onUpd(); }, child: const Text("Approve")) : const Icon(Icons.check, color: Colors.green)));
        }),
        ListView.builder(itemCount: AppData.agencyRequests.length, itemBuilder: (_, i) {
          final a = AppData.agencyRequests[i];
          return Card(child: ListTile(title: Text("${a["agencyName"]} (${a["nationalId"]})"), subtitle: Text("WA: ${a["whatsapp"]} | TG: ${a["telegram"]}"), trailing: a["status"] == "Pending" ? ElevatedButton(onPressed: () => setState(() => a["status"] = "Approved"), child: const Text("Approve")) : const Icon(Icons.verified, color: Colors.green)));
        }),
      ]),
    ));
  }
}
class LiveRoomPage extends StatefulWidget {
  final String id, title;
  final bool host;
  final VoidCallback onUpd;
  const LiveRoomPage({super.key, required this.id, required this.title, required this.host, required this.onUpd});
  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  String activeGift = "";
  void sendGift(String n, int c) {
    if (AppData.coins < c) return;
    setState(() { AppData.coins -= c; AppData.points += c * 0.8; activeGift = "$n (-$c Coins)"; });
    widget.onUpd();
    Future.delayed(const Duration(seconds: 3), () { if (mounted) setState(() => activeGift = ""); });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.title} (${AppData.coins})"), backgroundColor: const Color(0xFF052E24), foregroundColor: Colors.white),
      body: Stack(children: [
        Column(children: [
          Container(color: const Color(0xFF083D30), padding: const EdgeInsets.all(6), child: Text("${AppData.name} entered on ${AppData.equippedEntry}", style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12))),
          Expanded(child: ZegoUIKitPrebuiltLiveAudioRoom(appID: 1984661954, appSign: "9622d13c976d8545df95eb0baceb5c540087050f952ddbdb633b35d3199ea2f5", userID: AppData.uid, userName: AppData.name, roomID: widget.id, config: widget.host ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host() : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())),
          Container(color: const Color(0xFF052E24), padding: const EdgeInsets.all(10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(onPressed: () => sendGift("Jimma Coffee", 500), child: const Text("Coffee 500")),
            ElevatedButton(onPressed: () => sendGift("Golden Lion", 5000), child: const Text("Lion 5k")),
            ElevatedButton(onPressed: () => sendGift("Shark Moto", 15000), child: const Text("Moto 15k")),
          ])),
        ]),
        if (activeGift.isNotEmpty) Center(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.amber.shade800, borderRadius: BorderRadius.circular(20)), child: Text("GIFT SENT!\n$activeGift", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
      ]),
    );
  }
}

class GamesHubPage extends StatefulWidget {
  final VoidCallback onUpd;
  const GamesHubPage({super.key, required this.onUpd});
  @override
  State<GamesHubPage> createState() => _GamesHubPageState();
}

class _GamesHubPageState extends State<GamesHubPage> {
  String cat = "Hot";
  final games = [
    {"name": "Golden Lion Spin", "cat": "Slot", "hot": true, "icon": Icons.casino_rounded, "c1": 0xFFFFB800, "c2": 0xFFFF6F00},
    {"name": "Jimma Ocean Hunt", "cat": "Fishing", "hot": true, "icon": Icons.scuba_diving_rounded, "c1": 0xFF00B4DB, "c2": 0xFF0083B0},
    {"name": "Oromo Jungle Hunt", "cat": "Hot", "hot": true, "icon": Icons.forest_rounded, "c1": 0xFF11998E, "c2": 0xFF38EF7D},
    {"name": "Royal Coin Rain", "cat": "Slot", "hot": true, "icon": Icons.monetization_on_rounded, "c1": 0xFFF7971E, "c2": 0xFFFFD200},
    {"name": "Emerald Diamond III", "cat": "Slot", "hot": false, "icon": Icons.diamond_rounded, "c1": 0xFF008F6B, "c2": 0xFF00CEC9},
    {"name": "Coffee & Fruit Spin", "cat": "Slot", "hot": true, "icon": Icons.local_cafe_rounded, "c1": 0xFFEB3349, "c2": 0xFFF45C43},
    {"name": "Royal Ludo", "cat": "Multi Player", "hot": true, "icon": Icons.grid_view_rounded, "c1": 0xFF6A11CB, "c2": 0xFF2575FC},
    {"name": "Teen Patti Cards", "cat": "Multi Player", "hot": true, "icon": Icons.style_rounded, "c1": 0xFFCB2D3E, "c2": 0xFFEF473A},
    {"name": "Chicken Road Run", "cat": "Latest", "hot": true, "icon": Icons.directions_run_rounded, "c1": 0xFFFF9966, "c2": 0xFFFF5E62},
    {"name": "CosmoX Space Jet", "cat": "Latest", "hot": true, "icon": Icons.rocket_launch_rounded, "c1": 0xFF141E30, "c2": 0xFF243B55},
    {"name": "Dragon Power", "cat": "Slot", "hot": false, "icon": Icons.whatshot_rounded, "c1": 0xFFD31027, "c2": 0xFFEA384D},
    {"name": "Super Ace", "cat": "Slot", "hot": true, "icon": Icons.workspace_premium_rounded, "c1": 0xFFDA22FF, "c2": 0xFF9733EE},
    {"name": "Sweet Bonanza", "cat": "Latest", "hot": true, "icon": Icons.cake_rounded, "c1": 0xFFFF512F, "c2": 0xFFDD2476},
    {"name": "World Goal Penalty", "cat": "Multi Player", "hot": false, "icon": Icons.sports_soccer_rounded, "c1": 0xFF1D976C, "c2": 0xFF93F9B9},
    {"name": "DJ Live Rhythm", "cat": "Multi Player", "hot": false, "icon": Icons.headphones_rounded, "c1": 0xFF4776E6, "c2": 0xFF8E54E9},
    {"name": "Fishing Star", "cat": "Fishing", "hot": true, "icon": Icons.sailing_rounded, "c1": 0xFF2193B0, "c2": 0xFF6DD5ED},
    {"name": "Kraken Treasure III", "cat": "Fishing", "hot": false, "icon": Icons.anchor_rounded, "c1": 0xFF0F2027, "c2": 0xFF2C5364},
    {"name": "Royal Roulette", "cat": "Slot", "hot": false, "icon": Icons.track_changes_rounded, "c1": 0xFF8E0E00, "c2": 0xFF1F1C18},
    {"name": "The Monkey King", "cat": "Hot", "hot": true, "icon": Icons.emoji_nature_rounded, "c1": 0xFFF2994A, "c2": 0xFFF2C94C},
    {"name": "Royal Battle", "cat": "Multi Player", "hot": false, "icon": Icons.shield_rounded, "c1": 0xFF3A7BD5, "c2": 0xFF3A6073},
  ];
  @override
  Widget build(BuildContext context) {
    final list = games.where((g) => cat == "Hot" ? g["hot"] == true : g["cat"] == cat).toList();
    return Scaffold(
      backgroundColor: const Color(0xFF0A241E),
      appBar: AppBar(title: Text("Lucky Island Games (${AppData.coins})"), backgroundColor: const Color(0xFF061A15), foregroundColor: Colors.white),
      body: Column(children: [
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(10), child: Row(children: ["Latest", "Hot", "Slot", "Fishing", "Multi Player"].map((c) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(c), selected: cat == c, onSelected: (_) => setState(() => cat = c)))).toList())),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.1, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final g = list[i];
            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayAnimatedGamePage(gameName: g["name"] as String, c1: g["c1"] as int, c2: g["c2"] as int, icon: g["icon"] as IconData, onUpd: () { setState(() {}); widget.onUpd(); }))),
              child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(g["c1"] as int), Color(g["c2"] as int)]), borderRadius: BorderRadius.circular(18)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(g["icon"] as IconData, size: 48, color: Colors.white),
                Text(g["name"] as String, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ])),
            );
          },
        )),
      ]),
    );
  }
}
class RechargePage extends StatefulWidget {
  final VoidCallback onUpd;
  const RechargePage({super.key, required this.onUpd});
  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  String cur = "ETB";
  bool bulkSeller = false;
  int sel = 0;
  final amtCtrl = TextEditingController(text: "180"), txCtrl = TextEditingController();

  int get coins {
    final v = double.tryParse(amtCtrl.text) ?? 0;
    if (cur == "ETB") {
      final rate = (bulkSeller || AppData.isCoinSeller) ? 150.0 : 180.0;
      return ((v / rate) * 10000).round();
    } else {
      final base = (v * 10000).round();
      return (bulkSeller || AppData.isCoinSeller) ? (base * 1.2).round() : base;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pm = AppData.payments[sel];
    return Scaffold(
      appBar: AppBar(title: const Text("Recharge Coins (Jimma Official)"), backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text("Coins: ${AppData.coins} • Regular: 180 ETB=10k | Seller: 150 ETB=10k", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: ChoiceChip(label: const Text("ETB (Ethiopia)"), selected: cur == "ETB", onSelected: (_) => setState(() { cur = "ETB"; sel = 0; amtCtrl.text = "180"; }))),
          const SizedBox(width: 8),
          Expanded(child: ChoiceChip(label: const Text("Binance USDT (Min \$5)"), selected: cur == "USDT", onSelected: (_) => setState(() { cur = "USDT"; sel = 6; amtCtrl.text = "5"; }))),
        ]),
        SwitchListTile(
          title: const Text("Coin Seller / Bulk Discount Mode", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: const Text("150 ETB = 10k Coins or +20% USDT Bonus"),
          value: bulkSeller,
          onChanged: (v) => setState(() => bulkSeller = v),
        ),
        Wrap(spacing: 8, children: (cur == "ETB" ? ["180", "360", "900", "1500", "3000"] : ["5", "10", "20", "50", "100"]).map((p) => ActionChip(label: Text("$p $cur"), onPressed: () => setState(() => amtCtrl.text = p))).toList()),
        const SizedBox(height: 10),
        TextField(controller: amtCtrl, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: InputDecoration(labelText: "Custom Amount ($cur)", suffixText: "= $coins Coins", border: const OutlineInputBorder())),
        const SizedBox(height: 10),
        ...List.generate(AppData.payments.length, (i) {
          final item = AppData.payments[i];
          if (item["cur"] != cur) return const SizedBox.shrink();
          return Card(child: RadioListTile(
            value: i, groupValue: sel, onChanged: (v) => setState(() => sel = v!),
            title: Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item["acc"]!),
            secondary: IconButton(icon: const Icon(Icons.copy), onPressed: () { Clipboard.setData(ClipboardData(text: item["acc"]!)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied ${item["acc"]}"))); }),
          ));
        }),
        TextField(controller: txCtrl, decoration: const InputDecoration(labelText: "Transaction ID / Receipt Note", border: OutlineInputBorder())),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008F6B), foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
          onPressed: () {
            final val = double.tryParse(amtCtrl.text) ?? 0;
            if (cur == "USDT" && val < 5) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Minimum USDT recharge is \$5 (50,000 Coins)!"))); return; }
            AppData.tickets.insert(0, {"id": "TCK-${1043 + AppData.tickets.length}", "user": "User #${AppData.uid}", "title": "${amtCtrl.text} $cur -> $coins Coins", "msg": "${pm["name"]}: ${txCtrl.text}", "status": "Pending", "coins": coins});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Receipt Sent to Admin Support!")));
            Navigator.pop(context);
          },
          child: Text("Submit Deposit ($coins Coins)"),
        ),
      ]),
    );
  }
}
