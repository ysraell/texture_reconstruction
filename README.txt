
Carrega imagem bark  expressao (1) do artigo:
bark.m

Testa o carregamento:
test_bark.m

aplica o patch:
func_Mx.m

"desaplica" o patch:
func_MTz.m   


Relativo a expressao (3), o q será usado é a expressão (5) com os argumentos 
no formato indicado em (6), mas executado como (9).

expressão (3):
func_W.m

expressão (5) com u = x e v = z (e é compatível com (18)):
func_DuW.m 

expressão (17):
func_P.m

A função prox no algoritmo 1 pode ser calculada a partir de (14) com phi = norma L-12, usando a 
toolbox UNLOCBOX:

[sol,info] = prox_l12(x, gamma , param)

sendo o gamma = omega do artigo.

para carregar a toolbox
run {path to toolbox}/init_unlocbox.m;

Para calcular Tx (em (16)), precisa-se, entre outros fatores, o w_ij:
func_wij.m
Obs.: zc1 é o z1 chapéu usado em (8) e pode ser obtida com:
zc1 = imresize(z1,[lx cx],'bicubic'), se z1 tiver dimensoes diferentes de x
que não é o caso do artigo, pois precisamos comparar.

Entretanto, para calcular diretamente w_ij, é necessário calcular (8) para
cada i de w_ij. Para cada i de w_ij, (8) fornece um indice j-barra^i. Para que 
não seja necessário calcular todo o j-barra (nada a ver com j) para cada j 
diferente, se calcula ele antes e entra como argumento na função anterior:
func_jbarra.m

Observações: 
1) O cálculo do j-barra^i (expressão (8)) tem como objetivo utilzar
informação da textura na visinhança do pixel central i. O valor K basicamente
indica quanto patch mais parecidos devem influenciar na reconstrução da textura
final. Na prática, dependendo do valor de delta, o valor é quase nulo para todos 
os K > 1, isso deve-se pelo fato de se ter uma exponencial ao quadrado.
Entretanto, o valor em si não é armazenado, mas a ordem crescente (maior 
similaridade).
2) Na prática, mudar o valor de K não muda a principal complexidade computacional
que é obter o j-barra^i para cada i (pixel de z1). Ao mesmo tempo que é 
impraticável guardar uma matriz NxN (l*c*l*c), para uma imagem 256x256, J poderia
ter 65k x 65k. Os autores usam K = 14, e na prática, para valores muito autos,
ainda que delta tenha valor baixo, não há motivos para um K >20. Para fins 
apenas experimentais, resolvi usar K = 50 para gerar a matriz. Ao rodar a 
otimização, pode-se utilizar K<50 sem problemas, realizar diversos testes sem
ter de calcular j-barra^i novamente.
3) A complexidade computacional de (8) para todos o pixeis da figura de entrada
é alta! Usando pocessamento paralelo (x4) no MATLAB foram necessárias 6 horas.
Penso em usar C++/Eigen3.

Criei a função func_WJcpp em C++/Eigen3 para calcular wij (expressão (9)) completa
sem ter de calcular J. Incluir num só código as expressões (8) e (9) para todos 
os N pixels de z1 e para um dado valor de K. Vai gerar W e J. Lembrando que o K
usado para gerar w_ij não precisa ser o mesmo usado no algoritmo 1 para obter o
 resultado. Na obtenção de J, K não interfere na complexidade computacional, mas
no cálculo de W, a complexidade é O(N*K). Para testar:
test_func_WJcpp.m

criei uma função equivalente em MATLAB puro:
func_WJ.m

Num exemplo: x 64x64, z2 8x8, janela de 3x3 e K = 3, os tempos foram
matlab: 8.205 s
cpp:    0.0205 s


A expressão (16) é obtida com:
func_Tx.m

A exprssão (3) que é a função W_2^2 que está na (19) está em:
func_Wass_dist

Os valores a_s são obtidos para (6) e serão usados na (18). A função que
calcula (18) é:
func_gradf.m

Para implementar a função acima, tem-se que modificar o formato de x e z2. 
Semelhante às funções que fazem M e M^T (aplica e "desaplica" o patch).
Para isso, então, a fim de se implementar as transformações Ls (sec. II-A,
expressão (6)):
func_Ls.m
func_LsT.m

Detalhe importante sobre (3) e (5): Pelo que eu entendi, deve-se buscar obter
o mesmo histograma do patch de alta resolução (z2 ou v). Na Fig. 2 do artigo,
é dito que o resultado a otimização tem por objetivo transferir o histograma
de v para u. Então, é isso que é feito nessa implementação, apesar de se indicar
o contrário no segundo parágrafo sec. II-A. 


SSIM para comparar as figuras, métrica de qualidade usada, disponível no 
MATLAB com ssim. Entretanto, a versão do MATLAB não implementa a versão
clássica do SSIM, mas uma versão (acho que é a WI-SSIM) aplicada a imagens,
realizando uns 4 a 5 filtragens e isso consome muito processamento. Escrevi
em C++/Eigen3 a versão clássica, que é bem mais rápida:
ssimcpp.cpp

