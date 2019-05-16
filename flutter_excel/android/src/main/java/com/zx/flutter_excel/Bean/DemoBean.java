package com.zx.flutter_excel.Bean;

/**
 * @author dmrfcoder
 * @date 2019/2/14
 */

public class DemoBean {
    private String type;
    private String content;
    private String time;

    public DemoBean(String type, String content, String time) {
        this.type = type;
        this.content = content;
        this.time = time;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    @Override
    public String toString() {
        return "DemoBean{" +
                "type='" + type + '\'' +
                ", content='" + content + '\'' +
                ", time='" + time + '\'' +
                '}';
    }
}