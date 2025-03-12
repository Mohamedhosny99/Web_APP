package model;

public class User {
    private int userId;
    private String username;
    private String type;

    public User(int userId, String username) {
        this.userId = userId;
        this.username = username;
    }
    public User(int userId, String username, String type) {
        this.userId = userId;
        this.username = username;
        this.type = type;
    }

    public int getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getType() { return type; }
}
