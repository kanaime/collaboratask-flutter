class Constant {
  static const IP = "192.168.1.100";
  static const  API_URL = "http://$IP:8080";
  static const API_URL_PROJECT = "http://$IP:8080/projects";
  static const API_URL_USER = "http://$IP:8080/users";
  static const API_URL_TASK = "http://$IP:8080/tasks";
  static const headers = {'Content-Type': 'application/json'};
}