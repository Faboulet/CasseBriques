Class=require 'lib/hump/class'
flux = require 'lib/flux'
persistence = require 'lib/persistence'

-- csvfile=require 'lib/tinyCSV'
--require 'lib/StateMachine'
Gamestate = require 'lib/hump/gamestate'
require 'src/parameters/constants'

introGrille = require 'assets/maps/intro'

--require pour les objets globaux
require 'src/parameters/resources'
require 'src/parameters/util'

--require pour les objets
require 'src/objects/Balle'
require 'src/objects/Brique'
require 'src/objects/Item'
require 'src/objects/Jeu'
require 'src/objects/PauseMenu'
require 'src/objects/Player'
require 'src/objects/Vaisseau'

--require pour les differents Etats
require 'src/state/CommandState'
require 'src/state/EnterNameState'
require 'src/state/GameCompleteState'
require 'src/state/GameOverState'
require 'src/state/HighScoreState'
require 'src/state/IntroState'
require 'src/state/JeuState'
require 'src/state/LoadGameState'
require 'src/state/MainMenuState'
require 'src/state/NextLevelState'
require 'src/state/OptionState'