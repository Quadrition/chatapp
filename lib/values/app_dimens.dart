
/// App Colors Class - Resource class for storing app level color constants
class AppDimens {

  //main menu button dimensions
  static const double MAIN_BUTTON_RADIUS = 10.0;
  static const double MAIN_BUTTON_BORDER_WIDTH = 3.0;
  static const double MAIN_BUTTON_PADDING = 5.0;
  static const double MAIN_BUTTON_HEIGHT = 80.0;
  static const double MAIN_BUTTON_SIDE_MARGIN = 20.0;
  static const double MAIN_BUTTON_TOP_MARGIN = 10.0;
  static const double MAIN_BUTTON_IMAGE_WIDTH = 100.0;
  static const double MAIN_BUTTON_CIRCLE_WIDTH = 25.0;
  static const double MAIN_BUTTON_CIRCLE_TEXT_SIZE = MAIN_BUTTON_CIRCLE_WIDTH -5.0;


  //pop menu
  static const double POP_MENU_ITEM_TEXT_SIZE = 18.0;

  //navigation drawer
  static const double NAVIGATION_TITLE_SIZE = 25.0;
  static const double NAVIGATION_LAST_SYNC_SIZE = NAVIGATION_TITLE_SIZE/8*5;
  static const double NAVIGATION_LIST_TEXT_SIZE = NAVIGATION_TITLE_SIZE;

  //login and registration screens
  static const double LOGIN_BUTTON_SIDE_MARGIN = MAIN_BUTTON_SIDE_MARGIN;
  static const double LOGIN_BUTTON_TEXT_SIZE = LOGIN_BUTTON_HEIGHT/2;
  static const double LOGIN_BUTTON_CIRCULAR_BORDER_RADIUS = 30.0;
  static const double LOGIN_BUTTON_HEIGHT = 50.0;
  static const double LOGIN_BUTTON_PADDING = MAIN_BUTTON_PADDING+8;
  static const double LOGIN_FORGOT_PASSWORD_TEXT_SIZE = 20;
  static const double LOGIN_REGISTER_TEXT_SIZE = LOGIN_FORGOT_PASSWORD_TEXT_SIZE + 5;
  static const double LOGIN_SUCCESS_TEXT_SIZE = 30;
  static const double LOGIN_FIELD_TEXT_SIZE = LOGIN_REGISTER_TEXT_SIZE;
  static const double LOGIN_ERROR_TEXT_SIZE = LOGIN_FIELD_TEXT_SIZE/2;
  static const double FORGET_PASSWORD_TITLE_SIZE = 30;
  static const double FORGET_PASSWORD_TEXT_SIZE = FORGET_PASSWORD_TITLE_SIZE - 8;
  static const double FORGET_PASSWORD_BUTTON_WIDTH = 120;

  //error dialog
  static const double ERROR_DIALOG_TITLE_SIZE = FORGET_PASSWORD_TITLE_SIZE;
  static const double ERROR_DIALOG_TEXT_SIZE = FORGET_PASSWORD_TEXT_SIZE;
  static const double ERROR_DIALOG_BUTTON_WIDTH = FORGET_PASSWORD_BUTTON_WIDTH;
  static const double ERROR_DIALOG_ICON_SIZE = 70;

  //news tile
  static const double NEWS_TILE_CIRCULAR_BORDER_RADIUS = 15.0;
  static const double NEWS_TILE_ICON_SIZE = 30.0;
  static const double NEWS_TILE_COMPANY_TEXT_SIZE = 22.0;
  static const double NEWS_TILE_DESCRIPTION_TEXT_SIZE = 20.0;
  static const double NEWS_TILE_TIME_TEXT_SIZE = 14.0;
  static const double NEWS_TILE_TIME_ICON_SIZE = 18.0;
  static const double NEWS_TILE_TEXT_PADDING_SIZE = 8.0;

  //deadline tile
  static const double DEADLINE_TILE_CIRCULAR_BORDER_RADIUS = NEWS_TILE_CIRCULAR_BORDER_RADIUS;
  static const double DEADLINE_TILE_ICON_SIZE = NEWS_TILE_ICON_SIZE;
  static const double DEADLINE_TILE_COMPANY_TEXT_SIZE = NEWS_TILE_COMPANY_TEXT_SIZE;
  static const double DEADLINE_TILE_DESCRIPTION_TEXT_SIZE = NEWS_TILE_DESCRIPTION_TEXT_SIZE;
  static const double DEADLINE_TILE_TIME_TEXT_SIZE = NEWS_TILE_TIME_TEXT_SIZE;
  static const double DEADLINE_TILE_TIME_ICON_SIZE = NEWS_TILE_TIME_ICON_SIZE;
  static const double DEADLINE_TILE_TEXT_PADDING_SIZE = NEWS_TILE_TEXT_PADDING_SIZE;

  //document tile
  static const double DOCUMENT_TILE_CIRCULAR_BORDER_RADIUS = NEWS_TILE_CIRCULAR_BORDER_RADIUS;
  static const double DOCUMENT_TILE_ICON_SIZE = NEWS_TILE_ICON_SIZE;
  static const double DOCUMENT_TILE_COMPANY_TEXT_SIZE = NEWS_TILE_COMPANY_TEXT_SIZE;
  static const double DOCUMENT_TILE_DESCRIPTION_TEXT_SIZE = NEWS_TILE_DESCRIPTION_TEXT_SIZE;
  static const double DOCUMENT_TILE_TIME_TEXT_SIZE = NEWS_TILE_TIME_TEXT_SIZE;
  static const double DOCUMENT_TILE_TIME_ICON_SIZE = NEWS_TILE_TIME_ICON_SIZE;
  static const double DOCUMENT_TILE_TEXT_PADDING_SIZE = NEWS_TILE_TEXT_PADDING_SIZE;

  //subject tile
  static const double SUBJECT_TILE_CIRCULAR_BORDER_RADIUS = NEWS_TILE_CIRCULAR_BORDER_RADIUS;
  static const double SUBJECT_TILE_ICON_SIZE = NEWS_TILE_ICON_SIZE;
  static const double SUBJECT_TILE_COMPANY_TEXT_SIZE = NEWS_TILE_COMPANY_TEXT_SIZE;
  static const double SUBJECT_TILE_DESCRIPTION_TEXT_SIZE = NEWS_TILE_DESCRIPTION_TEXT_SIZE;
  static const double SUBJECT_TILE_TIME_TEXT_SIZE = NEWS_TILE_TIME_TEXT_SIZE;
  static const double SUBJECT_TILE_TIME_ICON_SIZE = NEWS_TILE_TIME_ICON_SIZE;
  static const double SUBJECT_TILE_TEXT_PADDING_SIZE = NEWS_TILE_TEXT_PADDING_SIZE;

  //floating action button
  static const double FAB_ICON_SIZE = 35;

  //add_subject
  static const double ADD_SUBJECT_TOP_PADDING = 30;
  static const double ADD_SUBJECT_SIDE_PADDING = MAIN_BUTTON_SIDE_MARGIN;
  static const double ADD_SUBJECT_TITLE_SIZE = 20;
  static const double ADD_SUBJECT_HINT_TEXT_SIZE = ADD_SUBJECT_TITLE_SIZE - 2;
  static const double ADD_SUBJECT_BUTTON_WIDTH = 200;
  static const double ADD_SUBJECT_BUTTON_RADIUS = 10.0;

  //deadline tile
  static const double COURT_TILE_CIRCULAR_BORDER_RADIUS = NEWS_TILE_CIRCULAR_BORDER_RADIUS;
  static const double COURT_TILE_ICON_SIZE = NEWS_TILE_ICON_SIZE;
  static const double COURT_TILE_COURT_TEXT_SIZE = 26;
  static const double COURT_TILE_OTHER_TEXT_SIZE = 16;
  static const double COURT_TILE_TEXT_PADDING_SIZE = 8;
  static const double COURT_TILE_LINE_SPACING = 8;

  //deadline tile
  static const double COURT_PROCESS_TILE_CIRCULAR_BORDER_RADIUS = COURT_TILE_CIRCULAR_BORDER_RADIUS;
  static const double COURT_PROCESS_TILE_CIRCLE_SIZE = NEWS_TILE_ICON_SIZE;
  static const double COURT_PROCESS_TILE_COURT_PROCESS_TEXT_SIZE = 22;
  static const double COURT_PROCESS_TILE_OTHER_TEXT_SIZE = 20;
  static const double COURT_PROCESS_DATE_TEXT_SIZE = 18;
  static const double COURT_PROCESS_TILE_TEXT_PADDING_SIZE = 10;
  static const double COURT_PROCESS_TILE_LINE_SPACING = 8;

  //settings screen
  static const double SETTINGS_SCREEN_TEXT_SIZE = 22;
  static const double SETTINGS_SCREEN_MEDIUM_TEXT_WEIGHT = 600;

//subscription tile
  static const double SUBSCRIPTION_TILE_CIRCULAR_BORDER_RADIUS = 15.0;
  static const double SUBSCRIPTION_TILE_TITLE_TEXT_SIZE = 22.0;
  static const double SUBSCRIPTION_TILE_DESCRIPTION_TEXT_SIZE = 28.0;
  static const double SUBSCRIPTION_TILE_TEXT_PADDING_SIZE = 8.0;
}