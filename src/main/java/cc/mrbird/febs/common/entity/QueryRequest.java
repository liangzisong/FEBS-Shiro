package cc.mrbird.febs.common.entity;

import lombok.Data;
import lombok.ToString;
import org.apache.commons.lang3.StringUtils;

import java.io.Serializable;

/**
 * @author MrBird
 */
@Data
@ToString
public class QueryRequest implements Serializable {

    private static final long serialVersionUID = -4869594085374385813L;
    // 当前页面数据量
    private int pageSize = 10;
    // 当前页码
    private int pageNum = 1;
    // 排序字段
    private String field;
    // 排序规则，asc升序，desc降序
    private String order;

    public String getField() {
        if(StringUtils.equals(field,"createTimeStr")){
            return "createTime";
        }
        if(StringUtils.equals(field,"updateTimeStr")){
            return "updateTime";
        }
        if(StringUtils.equals(field,"startTimeStr")){
            return "startTime";
        }
        if(StringUtils.equals(field,"endTimeStr")){
            return "endTime";
        }
        return field;
    }
}
