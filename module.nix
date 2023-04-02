{ environment ? "dev" , ... }:
{
  stringOut = "Welcome to ${environment}";
  enabled = ( environment == "prod");
}
