let
  homeDir = "/Users/%SYSTEM_CURRENT_USER%";
in
{
  system.stateVersion = 5;

  users = {
    users."%SYSTEM_CURRENT_USER%" = {
      home = homeDir;
    };
  };
}
