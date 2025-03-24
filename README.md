Bu proje, temel aritmetik işlemleri, değişken atamaları ve kullanıcıdan gelen "exit" komutunu işleyebilen bir hesap makinesi uygulamasıdır. Lex ve Yacc kullanarak yazılmıştır. Program, kullanıcının girdiği aritmetik ifadeleri yapar ve sonuçları yazdırır.

- calculator.l: Lex dosyası. Girdi ifadelerini tanımlar ve uygun token'lara böler.
- calculator.y: Yacc dosyası. Aritmetik işlemleri çözmek için gerekli kurallar.
- README.md: Proje açıklaması ve derleme komutları.

### `flex calculator.l`
### `yacc -d calculator.y`
### `gcc y.tab.c lex.yy.c -o calculator -lm`
### `./calculator`

Program Özellikleri:
Aritmetik İşlemler
Değişken Atamaları
Sıfıra Bölme
Hatalı İfadeler
Çıkış Komutu


