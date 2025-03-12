package model;

public class SmsRecord {
    private int userId;
    private String to;
    private String from;
    private String body;
    private String date;
    private boolean inbound;
    private String status;

    public SmsRecord(int userId, String to, String from, String body, String date, boolean inbound, String status) {
        this.userId = userId;
        this.to = to;
        this.from = from;
        this.body = body;
        this.date = date;
        this.inbound = inbound;
        this.status = status;
    }

    public int getUserId() { return userId; }
    public String getTo() { return to; }
    public String getFrom() { return from; }
    public String getBody() { return body; }
    public String getDate() { return date; }
    public boolean isInbound() { return inbound; }
    public String getStatus() { return status; }
}
