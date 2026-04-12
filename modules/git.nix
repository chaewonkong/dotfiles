{...}:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "chaewonkong";
      user.email = "chaewonkong@gmail.com";
      credential.helper = "store";
    };
  };
}
