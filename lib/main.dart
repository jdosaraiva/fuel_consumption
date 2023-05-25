import 'package:flutter/material.dart';
import 'package:fuel_consumption/dao/reabastecimento_dao.dart';
import 'package:fuel_consumption/models/reabastecimento.dart';
import 'package:fuel_consumption/models/registro_abastecimento.dart';
import 'package:fuel_consumption/screens/consumo_widget.dart';
// import 'package:fuel_consumption/screens/listview_widget.dart';
import 'package:fuel_consumption/screens/reabastecimento_form.dart';
import 'package:fuel_consumption/screens/reabastecimento_list.dart';
import 'package:fuel_consumption/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final List<RegistroAbastecimento> dados = await carregarDados();
  runApp(MyApp(dados: dados));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.dados}) : super(key: key);
  final List<RegistroAbastecimento> dados;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumo de Combustível',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.lightBlue, backgroundColor: Colors.white),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Histórico de Reabastecimento', dados: dados),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.dados})
      : super(key: key);
  final String title;
  final List<RegistroAbastecimento> dados;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? selectedItem;
  late final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  List<Widget> _pages = [];

  final _dao = ReabastecimentoDao();

  void onItemSelected(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  @override
  void initState() {
    super.initState();

    // _dao.excluiDatabase();

    _pages = [
      const ConsumoCombustivelWidget(),
      const ReabastecimentoList(),
      const AdicionarReabastecimentoForm(),
    ];
  }

  void initBaseFromDados() {
    widget.dados.reversed.forEach(insereReabastecimento);
  }

  void insereReabastecimento(RegistroAbastecimento ra) {
    Reabastecimento reabastecimento = Reabastecimento(
        dataReabastecimento: ra.dataReabastecimento,
        quantidade: ra.quantidade,
        kilometragem: ra.kilometragem,
        combustivel: ra.combustivel,
        valor: ra.valor);
    _dao.insert(reabastecimento);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.title),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.military_tech_sharp),
            label: 'Consumo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Reabastecimentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Adicionar',
          ),
        ],
      ),
    );
  }
}
