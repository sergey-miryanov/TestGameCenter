package;


import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import flash.text.TextField;
import flash.Lib;

import extension.gamecenter.GameCenter;
import extension.gamecenter.GameCenterEvent;


class Main extends Sprite {

  public var authenticate : ColorBtn;
  public var showPlayerName : ColorBtn;
  public var showPlayerID : ColorBtn;
  public var reportAchievement : ColorBtn;
  public var reportScore : ColorBtn;
  public var resetAchievements : ColorBtn;
  public var showAchievements : ColorBtn;
  public var showLeaderboard : ColorBtn;

  public var log : TextArea;

  public function new () {

    super ();

    stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

    GameCenter.addEventListener(GameCenterEvent.AUTH_SUCCESS, onGameCenterEvent);
    GameCenter.addEventListener(GameCenterEvent.AUTH_FAILURE, onGameCenterEvent);
    GameCenter.addEventListener(GameCenterEvent.SCORE_SUCCESS, onGameCenterEvent);
    GameCenter.addEventListener(GameCenterEvent.SCORE_FAILURE, onGameCenterEvent);
    GameCenter.addEventListener(GameCenterEvent.ACHIEVEMENT_SUCCESS, onGameCenterEvent);
    GameCenter.addEventListener(GameCenterEvent.ACHIEVEMENT_FAILURE, onGameCenterEvent);
    GameCenter.addEventListener(GameCenterEvent.ACHIEVEMENT_RESET_SUCCESS, onGameCenterEvent);
    GameCenter.addEventListener(GameCenterEvent.ACHIEVEMENT_RESET_FAILURE, onGameCenterEvent);

    authenticate = new ColorBtn(0x73B5D6, "Authenticate", true);
    showPlayerName = new ColorBtn(0xFF8000, "ShowPlayerName", false);
    showPlayerID = new ColorBtn(0xFF8000, "ShowPlayerID", false);
    reportAchievement = new ColorBtn(0xFF8000, "ReportAchievement", false);
    reportScore = new ColorBtn(0xFF8000, "ReportScore", false);
    resetAchievements = new ColorBtn(0xFF8000, "ResetAchievements", false);
    showAchievements = new ColorBtn(0xFF8000, "ShowAchievements", false);
    showLeaderboard = new ColorBtn(0xFF8000, "ShowLeaderboard", false);

    log = new TextArea("", 354, 64);

    addChild(authenticate);
    addChild(showPlayerName);
    addChild(showPlayerID);
    addChild(reportAchievement);
    addChild(reportScore);
    addChild(resetAchievements);
    addChild(showAchievements);
    addChild(showLeaderboard);

    addChild(log);

    authenticate.x = 20;
    authenticate.y = 20;
    authenticate.addEventListener(MouseEvent.CLICK, onAuthenticateClick);

    showPlayerName.x = 20;
    showPlayerName.y = 140;
    showPlayerName.addEventListener(MouseEvent.CLICK, onShowPlayerNameClick);

    showPlayerID.x = 180;
    showPlayerID.y = 140;
    showPlayerID.addEventListener(MouseEvent.CLICK, onShowPlayerIDClick);

    reportAchievement.x = 20;
    reportAchievement.y = 260;
    reportAchievement.addEventListener(MouseEvent.CLICK, onReportAchievementClick);

    showAchievements.x = 180;
    showAchievements.y = 260;
    showAchievements.addEventListener(MouseEvent.CLICK, onShowAchievementsClick);

    resetAchievements.x = 340;
    resetAchievements.y = 260;
    resetAchievements.addEventListener(MouseEvent.CLICK, onResetAchievementsClick);

    reportScore.x = 20;
    reportScore.y = 380;
    reportScore.addEventListener(MouseEvent.CLICK, onReportScoreClick);

    showLeaderboard.x = 180;
    showLeaderboard.y = 380;
    showLeaderboard.addEventListener(MouseEvent.CLICK, onShowLeaderboardClick);

    log.x = 20;
    log.y = 500;
  }

  function onKeyUp(event : KeyboardEvent)
  {
    if(event.keyCode == Keyboard.ESCAPE)
      Lib.exit();
  }

  function onGameCenterEvent(e : GameCenterEvent)
  {
    log.text.text = "type: " + e.type;
    trace("type: " + e.type);
    if(e.type == GameCenterEvent.AUTH_SUCCESS)
    {
      log.text.text = "SUCCESS: " + e.type;
      trace("SUCCESS: " + e.type);
      authenticate.setEnabled(false);
      showPlayerName.setEnabled(true);
      showPlayerID.setEnabled(true);
      reportAchievement.setEnabled(true);
      showAchievements.setEnabled(true);
      resetAchievements.setEnabled(true);
      reportScore.setEnabled(true);
      showLeaderboard.setEnabled(true);
    }
    else if(e.type == GameCenterEvent.AUTH_FAILURE)
    {
      log.text.text = "FAILED: " + e.type + ": " + e.data;
      trace("FAILED: " + e.type + ": " + e.data);
    }
    else
    {
      log.text.text = "OTHER: " + e.type;
      trace("OTHER: " + e.type);
    }
  }

  function onAuthenticateClick(e : MouseEvent)
  {
    log.text.text = "Authenticating";
    trace("Authenticating");
    GameCenter.authenticate();
    log.text.text = "Authenticated: " + GameCenter.available;
    trace("Authenticated: " + GameCenter.available);
  }

  function onShowPlayerNameClick(e : MouseEvent)
  {
    var name = GameCenter.getPlayerName();
    trace(name);
    log.text.text = name;
  }

  function onShowPlayerIDClick(e : MouseEvent)
  {
    var id = GameCenter.getPlayerID();
    trace(id);
    log.text.text = id;
  }

  function onReportAchievementClick(e : MouseEvent)
  {
    GameCenter.reportAchievement("test.achievement", Std.random(100));
  }

  function onShowAchievementsClick(e : MouseEvent)
  {
    GameCenter.showAchievements();
  }

  function onResetAchievementsClick(e : MouseEvent)
  {
    GameCenter.resetAchievements();
  }

  function onReportScoreClick(e : MouseEvent)
  {
    GameCenter.reportScore("test.leaderboard", Std.random(1000));
  }

  function onShowLeaderboardClick(e : MouseEvent)
  {
    GameCenter.showLeaderboard("test.leaderboard");
  }

}

class ColorBtn extends Sprite
{
  public var enabled : Bool;
  public var label : TextField;
  public var color : Int;

  private static var WIDTH : Int = 140;
  private static var HEIGHT : Int = 64;

  public function new(color : Int, text : String, ?enabled : Bool = true)
  {
    super();

    this.enabled = enabled;
    this.color = color;
    this.label = new TextField();
    this.label.x = 10;
    this.label.y = HEIGHT / 3.0;
    this.label.width = WIDTH;
    this.label.text = text;
    this.label.selectable = false;

    addChild(this.label);
    setEnabled(enabled);
  }

  private function fill(clr : Int)
  {
    graphics.beginFill(clr);
    graphics.drawRect(0, 0, WIDTH, HEIGHT);
    graphics.endFill();
  }

  public function setEnabled(e : Bool)
  {
    this.enabled = e;
    if(this.enabled)
    {
      fill(color);
      this.useHandCursor = true;
      this.mouseEnabled = true;
    }
    else
    {
      fill(0xaaaaaa);
      this.useHandCursor = false;
      this.mouseEnabled = false;
    }
  }

}

class TextArea extends Sprite
{
  var _w : Int;
  var _h : Int;

  public var text : TextField;

  public function new(text : String, w : Int, h : Int)
  {
    super();
    this._w = w;
    this._h = h;

    this.text = new TextField();
    this.text.x = 2;
    this.text.y = 2;
    this.text.width = w;
    this.text.height = h;

    addChild(this.text);
    rect(0xff0000);
  }

  public function rect(color : Int)
  {
    graphics.beginFill(0xdddddd);
    graphics.drawRect(0, 0, _w, _h);
    graphics.endFill();
  }
}

