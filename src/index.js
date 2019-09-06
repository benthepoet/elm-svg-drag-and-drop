import './main.css';
import { Elm } from './Main.elm';

Elm.Main.init({
  node: document.getElementById('root'),
  flags: { 
    width: 640, 
    height: 480 
  }
});
