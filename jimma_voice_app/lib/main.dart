import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

void main() { WidgetsFlutterBinding.ensureInitialized(); runApp(const JimmaApp()); }

class JimmaApp extends StatelessWidget {
  const JimmaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jimma Voice Chat Family',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B894)), scaffoldBackgroundColor: const Color(0xFFF4FBF9)),
      home: const MainNav(),
    );
  }
}

class AppData {
  static int coins = 30000, points = 12500, vip = 2, invited = 18;
  static String uid = "8849201", name = "Jimma VIP King", invite = "JIMMA884";
  static final tickets = <Map<String, dynamic>>[
    {"id": "TCK-1042", "user": "User #492011", "title": "600 ETB -> 40,000 Coins", "msg": "Telebirr +251919108311", "status": "Pending", "coins": 40000},
    {"id": "TCK-1041", "user": "User #773120", "title": "10 USDT -> 100,000 Coins", "msg": "TRC20 TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE", "status": "Resolved", "coins": 100000},
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
        selectedItemColor: const Color(0xFF00B894),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: "Room"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Moment"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Message"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me"),
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
  String country = "All";
  @override
  Widget build(BuildContext context) {
    final rooms = [
      {"id": "602841", "title": "Jimma Voice Chat Family Official", "tag": "Official", "c": "Ethiopia", "u": 148},
      {"id": "889102", "title": "Official Coin Seller & VIP Agency", "tag": "Coin Seller", "c": "International", "u": 94},
      {"id": "334910", "title": "Oromo & Global Music Party", "tag": "Music", "c": "USA & Europe", "u": 76},
      {"id": "551209", "title": "Lucky Island & Royal Spin Arena", "tag": "Games", "c": "Middle East", "u": 112},
    ].where((r) => country == "All" || r["c"] == country).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF00B894), Color(0xFF00CEC9)]), borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Jimma Voice Chat Family", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                Row(children: [
                  IconButton(icon: const Icon(Icons.account_balance_wallet, color: Color(0xFFFFD700)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RechargePage(onUpd: widget.onUpd)))),
                  IconButton(icon: const Icon(Icons.add_circle, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveRoomPage(id: "602841", title: "My Voice Room", host: true, onUpd: widget.onUpd)))),
                ]),
              ]),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpinPage(onUpd: widget.onUpd))),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFB800), Color(0xFFFF8C00)]), borderRadius: BorderRadius.circular(14)),
                  child: const Row(children: [
                    Icon(Icons.casino, color: Colors.white, size: 32),
                    SizedBox(width: 10),
                    Expanded(child: Text("LUCKY ISLAND SPIN • Win up to 100,000 Coins!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
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
              leading: const CircleAvatar(backgroundColor: Color(0xFF00B894), child: Icon(Icons.mic, color: Colors.white)),
              title: Text(r["title"].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("ID: ${r["id"]} • ${r["tag"]} • ${r["c"]}"),
              trailing: Text("${r["u"]} Live", style: const TextStyle(color: Color(0xFF00B894), fontWeight: FontWeight.bold)),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveRoomPage(id: r["id"].toString(), title: r["title"].toString(), host: true, onUpd: widget.onUpd))),
            ),
          )),
        ],
      ),
    );
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
  void gift(String n, int c) {
    if (AppData.coins < c) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Low Coins! Please Recharge."))); return; }
    setState(() { AppData.coins -= c; AppData.points += c ~/ 2; });
    widget.onUpd();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sent $n (-$c Coins)!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.title} (${AppData.coins} Coins)"), backgroundColor: const Color(0xFF062C24), foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(
          child: ZegoUIKitPrebuiltLiveAudioRoom(
            appID: 1984661954,
            appSign: "9622d13c976d8545df95eb0baceb5c540087050f952ddbdb633b35d3199ea2f5",
            userID: AppData.uid,
            userName: AppData.name,
            roomID: widget.id,
            config: widget.host ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host() : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience(),
          ),
        ),
        Container(
          color: const Color(0xFF062C24),
          padding: const EdgeInsets.all(10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(onPressed: () => gift("Coffee", 500), child: const Text("Coffee 500")),
            ElevatedButton(onPressed: () => gift("Lion", 5000), child: const Text("Lion 5000")),
            ElevatedButton(onPressed: () => gift("Car", 15000), child: const Text("Car 15000")),
          ]),
        ),
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
  int sel = 0;
  final amtCtrl = TextEditingController(text: "150");
  final txCtrl = TextEditingController();

  int get coins {
    final v = double.tryParse(amtCtrl.text) ?? 0;
    return cur == "ETB" ? ((v / 150.0) * 10000).round() : (v * 10000).round();
  }

  @override
  Widget build(BuildContext context) {
    final pm = AppData.payments[sel];
    return Scaffold(
      appBar: AppBar(title: const Text("Unlimited Coin Recharge"), backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text("Balance: ${AppData.coins} Coins (150 ETB = 10,000 | 1 USDT = 10,000)", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: ChoiceChip(label: const Text("ETB (Ethiopia)"), selected: cur == "ETB", onSelected: (_) => setState(() { cur = "ETB"; sel = 0; amtCtrl.text = "150"; }))),
          const SizedBox(width: 10),
          Expanded(child: ChoiceChip(label: const Text("Binance USDT"), selected: cur == "USDT", onSelected: (_) => setState(() { cur = "USDT"; sel = 6; amtCtrl.text = "1"; }))),
        ]),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: (cur == "ETB" ? ["150", "300", "600", "1500", "3000"] : ["1", "2", "5", "10", "50"]).map((p) => ActionChip(
          label: Text("$p $cur"),
          onPressed: () => setState(() => amtCtrl.text = p),
        )).toList()),
        const SizedBox(height: 12),
        TextField(
          controller: amtCtrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: "Unlimited Custom Amount ($cur)", suffixText: "= $coins Coins", border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        ...List.generate(AppData.payments.length, (i) {
          final item = AppData.payments[i];
          if (item["cur"] != cur) return const SizedBox.shrink();
          return Card(
            child: RadioListTile(
              value: i,
              groupValue: sel,
              onChanged: (v) => setState(() => sel = v!),
              title: Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item["acc"]!),
              secondary: IconButton(icon: const Icon(Icons.copy), onPressed: () {
                Clipboard.setData(ClipboardData(text: item["acc"]!));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied ${item["acc"]}")));
              }),
            ),
          );
        }),
        const SizedBox(height: 10),
        TextField(controller: txCtrl, decoration: const InputDecoration(labelText: "Transaction ID / Sender Name", border: OutlineInputBorder())),
        const SizedBox(height: 14),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
          onPressed: () {
            AppData.tickets.insert(0, {"id": "TCK-${1043 + AppData.tickets.length}", "user": "User #${AppData.uid}", "title": "${amtCtrl.text} $cur -> $coins Coins", "msg": "${pm["name"]}: ${txCtrl.text}", "status": "Pending", "coins": coins});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Submitted to Support Panel!")));
            Navigator.pop(context);
          },
          child: Text("Confirm Payment ($coins Coins)"),
        ),
      ]),
    );
  }
}

class MomentTab extends StatelessWidget {
  const MomentTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Moments"), backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: const [
        Card(child: ListTile(leading: Icon(Icons.verified, color: Color(0xFF00B894)), title: Text("Jimma Official • VIP 7"), subtitle: Text("Welcome to Jimma Voice Chat Family! Invite friends with code JIMMA884."))),
        Card(child: ListTile(leading: Icon(Icons.star, color: Colors.amber), title: Text("Sara Finfinnee • VIP 4"), subtitle: Text("Join live music room 602841 tonight!"))),
      ]),
    );
  }
}

class MsgTab extends StatelessWidget {
  const MsgTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages"), backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        Card(child: ListTile(leading: const Icon(Icons.support_agent, color: Colors.teal), title: const Text("Customer Support Center"), subtitle: const Text("Report issue or verify payment"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage())))),
        const Card(child: ListTile(leading: Icon(Icons.campaign, color: Colors.orange), title: Text("System Notification"), subtitle: Text("Rate: 150 ETB = 10,000 Coins | 1 USDT = 10,000 Coins"))),
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF00B894), Color(0xFF00897B)]), borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Text(AppData.name, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
            Text("ID: ${AppData.uid} • VIP ${AppData.vip} • Invite Code: ${AppData.invite}", style: const TextStyle(color: Color(0xFFFFD700))),
            const SizedBox(height: 10),
            Text("Coins: ${AppData.coins}  |  Points: ${AppData.points}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
        ),
        const SizedBox(height: 12),
        Card(child: Column(children: [
          ListTile(leading: const Icon(Icons.wallet, color: Colors.orange), title: const Text("Recharge Coins (ETB & USDT)"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RechargePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
          ListTile(leading: const Icon(Icons.workspace_premium, color: Colors.amber), title: const Text("VIP Club (Upgrade VIP 1 - VIP 7)"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VipPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
          ListTile(leading: const Icon(Icons.group_add, color: Colors.teal), title: const Text("Invitation & Referral Rewards"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvitePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
          ListTile(leading: const Icon(Icons.storefront, color: Colors.deepOrange), title: const Text("Official Coin Sellers"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerPage()))),
          ListTile(leading: const Icon(Icons.casino, color: Colors.purple), title: const Text("Lucky Island Spin Game"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpinPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
          ListTile(leading: const Icon(Icons.support_agent, color: Colors.blue), title: const Text("Customer Support Center"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()))),
          ListTile(leading: const Icon(Icons.admin_panel_settings, color: Colors.red), title: const Text("Super Admin Control Panel"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ])),
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
  int sel = 0;
  final amtCtrl = TextEditingController(text: "150");
  final txCtrl = TextEditingController();

  int get coins {
    final v = double.tryParse(amtCtrl.text) ?? 0;
    return cur == "ETB" ? ((v / 150.0) * 10000).round() : (v * 10000).round();
  }

  @override
  Widget build(BuildContext context) {
    final pm = AppData.payments[sel];
    return Scaffold(
      appBar: AppBar(title: const Text("Unlimited Coin Recharge"), backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text("Balance: ${AppData.coins} Coins (150 ETB = 10,000 | 1 USDT = 10,000)", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: ChoiceChip(label: const Text("ETB (Ethiopia)"), selected: cur == "ETB", onSelected: (_) => setState(() { cur = "ETB"; sel = 0; amtCtrl.text = "150"; }))),
          const SizedBox(width: 10),
          Expanded(child: ChoiceChip(label: const Text("Binance USDT"), selected: cur == "USDT", onSelected: (_) => setState(() { cur = "USDT"; sel = 6; amtCtrl.text = "1"; }))),
        ]),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: (cur == "ETB" ? ["150", "300", "600", "1500", "3000"] : ["1", "2", "5", "10", "50"]).map((p) => ActionChip(
          label: Text("$p $cur"),
          onPressed: () => setState(() => amtCtrl.text = p),
        )).toList()),
        const SizedBox(height: 12),
        TextField(
          controller: amtCtrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(labelText: "Unlimited Custom Amount ($cur)", suffixText: "= $coins Coins", border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        ...List.generate(AppData.payments.length, (i) {
          final item = AppData.payments[i];
          if (item["cur"] != cur) return const SizedBox.shrink();
          return Card(
            child: RadioListTile(
              value: i,
              groupValue: sel,
              onChanged: (v) => setState(() => sel = v!),
              title: Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item["acc"]!),
              secondary: IconButton(icon: const Icon(Icons.copy), onPressed: () {
                Clipboard.setData(ClipboardData(text: item["acc"]!));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied ${item["acc"]}")));
              }),
            ),
          );
        }),
        const SizedBox(height: 10),
        TextField(controller: txCtrl, decoration: const InputDecoration(labelText: "Transaction ID / Sender Name", border: OutlineInputBorder())),
        const SizedBox(height: 14),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white, padding: const EdgeInsets.all(14)),
          onPressed: () {
            AppData.tickets.insert(0, {"id": "TCK-${1043 + AppData.tickets.length}", "user": "User #${AppData.uid}", "title": "${amtCtrl.text} $cur -> $coins Coins", "msg": "${pm["name"]}: ${txCtrl.text}", "status": "Pending", "coins": coins});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Submitted to Support Panel!")));
            Navigator.pop(context);
          },
          child: Text("Confirm Payment ($coins Coins)"),
        ),
      ]),
    );
  }
}

class MomentTab extends StatelessWidget {
  const MomentTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Moments"), backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: const [
        Card(child: ListTile(leading: Icon(Icons.verified, color: Color(0xFF00B894)), title: Text("Jimma Official • VIP 7"), subtitle: Text("Welcome to Jimma Voice Chat Family! Invite friends with code JIMMA884."))),
        Card(child: ListTile(leading: Icon(Icons.star, color: Colors.amber), title: Text("Sara Finfinnee • VIP 4"), subtitle: Text("Join live music room 602841 tonight!"))),
      ]),
    );
  }
}

class MsgTab extends StatelessWidget {
  const MsgTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages"), backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        Card(child: ListTile(leading: const Icon(Icons.support_agent, color: Colors.teal), title: const Text("Customer Support Center"), subtitle: const Text("Report issue or verify payment"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage())))),
        const Card(child: ListTile(leading: Icon(Icons.campaign, color: Colors.orange), title: Text("System Notification"), subtitle: Text("Rate: 150 ETB = 10,000 Coins | 1 USDT = 10,000 Coins"))),
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF00B894), Color(0xFF00897B)]), borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Text(AppData.name, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
            Text("ID: ${AppData.uid} • VIP ${AppData.vip} • Invite Code: ${AppData.invite}", style: const TextStyle(color: Color(0xFFFFD700))),
            const SizedBox(height: 10),
            Text("Coins: ${AppData.coins}  |  Points: ${AppData.points}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
        ),
        const SizedBox(height: 12),
        Card(child: Column(children: [
          ListTile(leading: const Icon(Icons.wallet, color: Colors.orange), title: const Text("Recharge Coins (ETB & USDT)"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RechargePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
          ListTile(leading: const Icon(Icons.workspace_premium, color: Colors.amber), title: const Text("VIP Club (Upgrade VIP 1 - VIP 7)"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VipPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
          ListTile(leading: const Icon(Icons.group_add, color: Colors.teal), title: const Text("Invitation & Referral Rewards"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvitePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
          ListTile(leading: const Icon(Icons.storefront, color: Colors.deepOrange), title: const Text("Official Coin Sellers"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerPage()))),
          ListTile(leading: const Icon(Icons.casino, color: Colors.purple), title: const Text("Lucky Island Spin Game"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpinPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
          ListTile(leading: const Icon(Icons.support_agent, color: Colors.blue), title: const Text("Customer Support Center"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()))),
          ListTile(leading: const Icon(Icons.admin_panel_settings, color: Colors.red), title: const Text("Super Admin Control Panel"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ])),
      ]),
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
      appBar: AppBar(title: const Text("VIP Club"), backgroundColor: const Color(0xFFFFB800), foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: 7,
        itemBuilder: (_, i) {
          final lv = i + 1;
          final cost = lv * 10000;
          return Card(child: ListTile(
            title: Text("VIP $lv Royal Package", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Cost: $cost Coins • Golden Frame + Entrance Effect"),
            trailing: ElevatedButton(
              onPressed: AppData.vip >= lv ? null : () {
                if (AppData.coins >= cost) { setState(() { AppData.coins -= cost; AppData.vip = lv; }); widget.onUpd(); }
              },
              child: Text(AppData.vip >= lv ? "Active" : "Upgrade"),
            ),
          ));
        },
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
    return Scaffold(
      appBar: AppBar(title: const Text("Invite & Earn"), backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        Text("Your Invite Code: ${AppData.invite}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text("Invited Friends: ${AppData.invited} (+2,000 Coins/Friend)"),
        const SizedBox(height: 14),
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: "Join Jimma Voice Chat Family! Code: ${AppData.invite}"));
            setState(() { AppData.invited += 1; AppData.coins += 2000; });
            widget.onUpd();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invite Copied & +2,000 Bonus Added!")));
          },
          child: const Text("Copy Invite Link & Claim Bonus"),
        ),
      ])),
    );
  }
}

class SellerPage extends StatelessWidget {
  const SellerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Official Coin Sellers"), backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: const [
        Card(child: ListTile(leading: Icon(Icons.verified, color: Colors.amber), title: Text("Jimma Official Agency #1"), subtitle: Text("Rate: 150 ETB = 10,000 Coins | Instant Transfer"))),
        Card(child: ListTile(leading: Icon(Icons.verified, color: Colors.amber), title: Text("Global USDT Coin Reseller"), subtitle: Text("Rate: 1 USDT = 10,000 Coins | 24/7 Online"))),
      ]),
    );
  }
}

class SpinPage extends StatefulWidget {
  final VoidCallback onUpd;
  const SpinPage({super.key, required this.onUpd});
  @override
  State<SpinPage> createState() => _SpinPageState();
}

class _SpinPageState extends State<SpinPage> {
  String res = "Spin for 1,000 Coins!";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lucky Island Spin"), backgroundColor: const Color(0xFFFFB800), foregroundColor: Colors.white),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.casino, size: 90, color: Color(0xFFFFB800)),
        Text("Coins: ${AppData.coins}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(res, style: const TextStyle(fontSize: 16, color: Color(0xFF00B894))),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (AppData.coins < 1000) return;
            final prizes = List<int>.generate(5, (i) => i * 2500);
            final win = prizes[Random().nextInt(5)];
            setState(() { AppData.coins = AppData.coins - 1000 + win; res = "Won $win Coins!"; });
            widget.onUpd();
          },
          child: const Text("SPIN (1,000 Coins)"),
        ),
      ])),
    );
  }
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final subCtrl = TextEditingController();
  final msgCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Support Center"), backgroundColor: const Color(0xFF00B894), foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(controller: subCtrl, decoration: const InputDecoration(labelText: "Issue Subject", border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: msgCtrl, decoration: const InputDecoration(labelText: "Details / Transaction ID", border: OutlineInputBorder())),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () {
          if (subCtrl.text.isEmpty) return;
          setState(() { AppData.tickets.insert(0, {"id": "TCK-${1043 + AppData.tickets.length}", "user": "User #${AppData.uid}", "title": subCtrl.text, "msg": msgCtrl.text, "status": "Pending", "coins": 0}); subCtrl.clear(); msgCtrl.clear(); });
        }, child: const Text("Send to Admin Support")),
        const Divider(),
        ...AppData.tickets.map((t) => Card(child: ListTile(title: Text("${t["id"]}: ${t["title"]}"), subtitle: Text(t["msg"]), trailing: Text(t["status"])))),
      ]),
    );
  }
}

class AdminPage extends StatefulWidget {
  final VoidCallback onUpd;
  const AdminPage({super.key, required this.onUpd});
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Super Admin Control Panel"), backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: AppData.tickets.length,
        itemBuilder: (_, i) {
          final t = AppData.tickets[i];
          return Card(child: ListTile(
            title: Text("${t["id"]} • ${t["user"]}"),
            subtitle: Text("${t["title"]}\n${t["msg"]}"),
            isThreeLine: true,
            trailing: t["status"] == "Pending" ? ElevatedButton(
              onPressed: () { setState(() { t["status"] = "Resolved"; AppData.coins += (t["coins"] as int); }); widget.onUpd(); },
              child: const Text("Approve"),
            ) : const Icon(Icons.check_circle, color: Colors.green),
          ));
        },
      ),
    );
  }
}
