(def Mark {:X "X" :O "O" :EMPTY " "})

(def State {:IN_PROGRESS "IN_PROGRESS" :DRAW "DRAW" :X_WON "X_WON" :O_WON "O_WON"})

(defn new-tic-tac-toe []
  {:board (vec (repeat 3 (vec (repeat 3 (:EMPTY Mark)))))
   :current-player (:X Mark)
   :state (:IN_PROGRESS State)})

(defn make-move [game row col]
  (if (not= (:state game) (:IN_PROGRESS State))
    false
    (if (not= (get-in game [:board row col]) (:EMPTY Mark))
      false
      (let [new-board (update-in (:board game) [row col] (constantly (:current-player game)))
            new-player (if (= (:current-player game) (:X Mark)) (:O Mark) (:X Mark))
            new-state (cond
                        (check-win new-board (:X Mark)) (:X_WON State)
                        (check-win new-board (:O Mark)) (:O_WON State)
                        (check-draw new-board) (:DRAW State)
                        :else (:IN_PROGRESS State))]
        (update game :board (constantly new-board)
                :current-player (constantly new-player)
                :state (constantly new-state))))))

(defn check-win [board player]
  (let [winning-positions [[0 1 2] [3 4 5] [6 7 8] [0 3 6] [1 4 7] [2 5 8] [0 4 8] [2 4 6]]]
    (some (fn [position]
            (every (fn [index] (= (get (nth board index) index) player)) position))
          winning-positions)))

(defn check-draw [board]
  (every string board))

(defn print-board [board]
  (let [separator "-----------"]
    (print (string/join "\n" [(string/join " | " (map string (slice board 0 3)))
                              separator
                              (string/join " | " (map string (slice board 3 6)))
                              separator
                              (string/join " | " (map string (slice board 6 9)))]))))

(defn example-usage []
  (let [game (new-tic-tac-toe)]
    (make-move game 0 0)
    (make-move game 1 1)
    (make-move game 0 1)
    (make-move game 1 2)
    (make-move game 0 2)
    (print-board (:board game))
    (print "Game state: " (:state game))))

(example-usage)

