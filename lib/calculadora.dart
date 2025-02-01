import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _C = 'Limpar';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _C) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else {
        _expressao += valor;
      }
    });
  }

  void _calcularResultado() {
    try {
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Erro';
    }
  }

  num _avaliarExpressao(String expressao) {
    expressao = expressao.replaceAll('x', '*');
    expressao = expressao.replaceAll('÷', '/');

    // Usando expressão regular para identificar o fatorial
    RegExp fatorialRegEx = RegExp(r'(\d+)!');

    // Substituir todos os fatoriais na expressão
    expressao = expressao.replaceAllMapped(fatorialRegEx, (match) {
      int numero = int.parse(match.group(1)!);
      return _fatorial(numero).toString();
    });

    // Novos códigos, definidos em aula presencial
    if (expressao.contains('√')) {
      debugPrint(expressao);
      return sqrt(_avaliarExpressao(expressao.replaceAll('√', '')));
    } else if (expressao.contains('X²')) {
      return pow(_avaliarExpressao(expressao.replaceAll('^2', '')), 2);
    
    } else if (expressao.contains('%')) {
      // Encontrar o operador que precede o símbolo de porcentagem
      int indexPorcentagem = expressao.indexOf('%');
      int indexOperador = -1;
      for (int i = indexPorcentagem - 1; i >= 0; i--) {
        if (['+', '-', '*', '/'].contains(expressao[i])) {
          indexOperador = i;
          break;
        }
      }

      if (indexOperador != -1) {
        // Extrair o número antes da porcentagem
        num numeroAntesPorcentagem =
            _avaliarExpressao(expressao.substring(0, indexOperador).trim());
        // Calcular a porcentagem
        double porcentagem = numeroAntesPorcentagem *
            (_avaliarExpressao(expressao
                    .substring(indexOperador + 1, indexPorcentagem)
                    .trim()) /
                100);
        return _avaliarExpressao(
            expressao.substring(0, indexOperador + 1).trim() +
                porcentagem.toString());
      }
    }
    ExpressionEvaluator avaliador = const ExpressionEvaluator();
    double resultado =
        avaliador.eval(Expression.parse(expressao), {}) as double;
    return resultado;
  }

  int _fatorial(int n) {
    if (n <= 1) return 1;
    return n * _fatorial(n - 1);
  }

  Widget _botao(String valor) {
    return TextButton(
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            children: [
              _botao('!'),
              _botao('%'),
              _botao('√'),
              _botao('x²'),
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('÷'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('x'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('-'),
              _botao('0'),
              _botao('.'),
              _botao('='),
              _botao('+'),
            ],
          ),
        ),
        Expanded(
          child: _botao(_C),
        ),
      ],
    );
  }
}
