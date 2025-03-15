package model;

public class SmsRecord {

    private int smsId;
    private int userId;
    private String to;
    private String from;
    private String body;
    private String date;
    private boolean inbound;
    private String status;

    public SmsRecord(  int smsId ,int userId, String to, String from, String body, String date, boolean inbound, String status) {
        this.userId = userId;
        this.smsId = smsId;
        this.to = to;
        this.from = from;
        this.body = body;
        this.date = date;
        this.inbound = inbound;
        this.status = status;
    }

    public SmsRecord(  int userId, String to, String from, String body, String date, boolean inbound, String status) {
        this.userId = userId;

        this.to = to;
        this.from = from;
        this.body = body;
        this.date = date;
        this.inbound = inbound;
        this.status = status;
    }



    public SmsRecord(){}

    public int getUserId() { return userId; }
    public String getTo() { return to; }
    public String getFrom() { return from; }
    public String getBody() { return body; }
    public String getDate() { return date; }
    public boolean isInbound() { return inbound; }
    public String getStatus() { return status; }
    public int getSmsId() { return smsId; }

    public void setUserId(int id) {
        this.userId=id;
    }

    public void setBody(String body) {
        this.body=body;
    }

    public void setDate(String timestamp) {
        this.date=timestamp;
    }

    public void setTo(String toNumber) {
        this.to= toNumber;
    }

    public void setFrom(String fromNumber) {
        this.from= fromNumber;
    }

    public void setInbound(boolean inbound) {
        this.inbound=inbound;
    }

    public void setStatus(String s) {
        this.status=s;
    }

    public void  setSmsId(int smsId) {
        this.smsId=smsId;
    }
}
