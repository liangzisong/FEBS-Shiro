<style>
    #${className}-update {
        padding: 20px 25px 25px 0;
    }
    #${className}-update .layui-treeSelect .ztree li a, .ztree li span {
        margin: 0 0 2px 3px !important;
    }
</style>
<html xmlns:th="http://www.thymeleaf.org">
<div class="layui-fluid" id="${className}-update">
    <form class="layui-form" th:object="${'$'+'{'+className+'}'}" action="" lay-filter="${className}-update-form">
        <input type="text" hidden th:value="${'$'+'{'+className.id+'}'}" name="id">
        <#if columns??>
            <#list columns as column>
                <#if column.field = 'delFlag' >
                    <div class="layui-form-item">
                        <label class="layui-form-label">状态</label>
                        <div class="layui-input-inline">
                            <select name="${column.field?uncap_first}">
                                <option th:field="${'*{delFlag}'}" value=""></option>
                                <option th:field="${'*{delFlag}'}" value="1">有效</option>
                                <option th:field="${'*{delFlag}'}" value="0">禁用</option>
                            </select>
                        </div>
                    </div>
                <#elseif column.type = 'timestamp' || column.type = 'date' || column.type = 'datetime'||column.type = 'TIMESTAMP' || column.type = 'DATE' || column.type = 'DATETIME'
                || column.field = 'createTime' || column.field = 'updateTime'>
                    <div class="layui-inline">
                        <label class="layui-form-label layui-form-label-sm">${column.remark}</label>
                        <div class="layui-input-inline">
                            <input type="text" th:field="${'*'+'{'+column.field+'}'}" autocomplete="off" name="${column.field?uncap_first}" class="layui-input">
                        </div>
                    </div>
                <#else>
                    <div class="layui-form-item">
                        <label class="layui-form-label layui-form-label-sm">${column.remark}</label>
                        <div class="layui-input-inline">
                            <input type="text" autocomplete="off" th:field="${'*'+'{'+column.field+'}'}" name="${column.field?uncap_first}" class="layui-input">
                        </div>
                    </div>
                </#if>
            </#list>
        </#if>
        <div class="layui-form-item febs-hide">
            <button class="layui-btn" lay-submit="" lay-filter="${className}-update-form-submit" id="submit"></button>
            <button type="reset" class="layui-btn" id="reset"></button>
        </div>
    </form>
</div>

<script>
    layui.use(['febs', 'form', 'formSelects', 'validate', 'treeSelect','layedit'], function () {
        var $ = layui.$,
            febs = layui.febs,
            layer = layui.layer,
            formSelects = layui.formSelects,
            treeSelect = layui.treeSelect,
            form = layui.form,
            $view = $('#${className}-update'),
            validate = layui.validate,
            layedit = layui.layedit;

        form.verify(validate);
        form.render();

        formSelects.render();

        form.on('submit(${className}-update-form-submit)', function (data) {
            // debugger
            let field = data.field;
            $.ajax({
                type: "POST",
                url: ctx + '${className}/update',
                data: field,
                dataType: "json",
                contentType : 'application/json;charset=utf-8', //设置请求头信息
                success: function(result){
                    console.log(result);
                    if(result.code==200){
                        layer.closeAll();
                        febs.alert.success('修改成功');
                        $('#${className}-list').find('#query').click();
                        return;
                    }
                    febs.alert.error(result.message);
                }
            });
            return false;
        });
    });
</script>