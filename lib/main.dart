import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraIMC());
}

class CalculadoraIMC extends StatelessWidget {
  const CalculadoraIMC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de IMC',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F4FA),
      ),
      home: const TelaIMC(),
    );
  }
}

class TelaIMC extends StatefulWidget {
  const TelaIMC({super.key});

  @override
  State<TelaIMC> createState() => _TelaIMCState();
}

class _TelaIMCState extends State<TelaIMC> {
  final TextEditingController pesoController =
      TextEditingController();

  final TextEditingController alturaController =
      TextEditingController();

  double? imc;
  String classificacao = '';
  Color corResultado = Colors.purple;
  String mensagem = '';

  @override
  void dispose() {
    pesoController.dispose();
    alturaController.dispose();
    super.dispose();
  }

  void calcularIMC() {
    final peso = double.tryParse(
      pesoController.text.trim().replaceAll(',', '.'),
    );

    final altura = double.tryParse(
      alturaController.text.trim().replaceAll(',', '.'),
    );

    if (peso == null ||
        altura == null ||
        peso <= 0 ||
        altura <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Digite um peso e uma altura válidos.',
          ),
        ),
      );
      return;
    }

    if (peso > 500 || altura > 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Confira os valores informados.',
          ),
        ),
      );
      return;
    }

    final resultado = peso / (altura * altura);

    String categoria;
    String descricao;
    Color cor;

    if (resultado < 20) {
      categoria = 'Abaixo do peso';
      descricao = 'Seu IMC está abaixo da faixa de referência.';
      cor = Colors.blue;
    } else if (resultado < 25) {
      categoria = 'Peso normal';
      descricao = 'Seu IMC está na faixa de referência.';
      cor = Colors.green;
    } else if (resultado < 30) {
      categoria = 'Sobrepeso';
      descricao = 'Seu IMC está acima da faixa de referência.';
      cor = Colors.orange;
    } else if (resultado <= 40) {
      categoria = 'Obeso';
      descricao = 'Procure orientação de um profissional de saúde.';
      cor = Colors.deepOrange;
    } else if (resultado > 40) {
      categoria = 'Obeso Morbido';
      descricao = 'Procure orientação de um profissional de saúde.';
      cor = Colors.red;
    } else {
      categoria = 'Obesidade grau III';
      descricao = 'Procure orientação de um profissional de saúde.';
      cor = Colors.red.shade900;
    }

    setState(() {
      imc = resultado;
      classificacao = categoria;
      mensagem = descricao;
      corResultado = cor;
    });
  }

  void limparCampos() {
    setState(() {
      pesoController.clear();
      alturaController.clear();
      imc = null;
      classificacao = '';
      mensagem = '';
    });
  }

  Widget campoNumerico({
    required String titulo,
    required String dica,
    required IconData icone,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            hintText: dica,
            prefixIcon: Icon(icone),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE5E0EC),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F4FA),
        centerTitle: true,
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF6750A4),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.monitor_weight_outlined,
                      color: Colors.white,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cuide da sua saúde!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Informe seu peso e sua altura para calcular '
                      'seu Índice de Massa Corporal.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              campoNumerico(
                titulo: 'Peso (kg)',
                dica: 'Ex.: 70,5',
                icone: Icons.monitor_weight_outlined,
                controller: pesoController,
              ),

              const SizedBox(height: 20),

              campoNumerico(
                titulo: 'Altura (metros)',
                dica: 'Ex.: 1,75',
                icone: Icons.height,
                controller: alturaController,
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: calcularIMC,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text(
                    'Calcular IMC',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              if (imc != null) ...[
                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: corResultado.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Seu resultado',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        imc!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: corResultado,
                        ),
                      ),

                      const Text(
                        'kg/m²',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: corResultado.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          classificacao,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: corResultado,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        mensagem,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: limparCampos,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Limpar dados'),
              ),

              const SizedBox(height: 24),

              const Text(
                'A classificação apresentada é uma referência para '
                'adultos. O IMC não avalia sozinho o estado de saúde '
                'e deve ser interpretado considerando outros fatores.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}