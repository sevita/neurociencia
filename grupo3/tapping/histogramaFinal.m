tiemposJime = []
tiemposJess = []
tiemposSeba = []
tiemposPablo = []

tiemposJime = load('Jime.mat');
tiemposJess = load('Jess.mat');
todos_los_tiempos = []
todos_los_tiempos=[todos_los_tiempos tiemposJime.tiempos tiemposJess.tiempos]


hist(todos_los_tiempos,50)