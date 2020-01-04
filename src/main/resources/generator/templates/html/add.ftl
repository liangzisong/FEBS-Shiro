<style>
    #${className}-add {
        padding: 20px 25px 25px 0;
    }
    #${className}-add .layui-treeSelect .ztree li a, .ztree li span {
        margin: 0 0 2px 3px !important;
    }
</style>
<div class="layui-fluid" id="${className}-add">
    <form class="layui-form" action="" lay-filter="${className}-add-form">
        <#if columns??>
            <#list columns as column>
                <#if column.field = 'delFlag' >
        <div class="layui-form-item">
            <label class="layui-form-label">状态</label>
            <div class="layui-input-inline">
                <select name="${column.field?uncap_first}">
                    <option value=""></option>
                    <option value="1">有效</option>
                    <option value="0">禁用</option>
                </select>
            </div>
        </div>
                <#elseif column.type = 'timestamp' || column.type = 'date' || column.type = 'datetime'||column.type = 'TIMESTAMP' || column.type = 'DATE' || column.type = 'DATETIME'
                || column.field = 'createTime' || column.field = 'updateTime'>
        <div class="layui-inline">
            <label class="layui-form-label layui-form-label-sm">${column.remark}</label>
            <div class="layui-input-inline">
                <input type="text" autocomplete="off" name="${column.field?uncap_first}" class="layui-input">
            </div>
        </div>
                <#else>
        <div class="layui-form-item">
            <label class="layui-form-label layui-form-label-sm">${column.remark}</label>
            <div class="layui-input-inline">
                <input type="text" autocomplete="off" name="${column.field?uncap_first}" class="layui-input">
            </div>
        </div>
                </#if>
            </#list>
        </#if>

        <div class="layui-form-item febs-hide">
            <button class="layui-btn" lay-submit="" lay-filter="${className}-add-form-submit" id="submit"></button>
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
            $view = $('#${className}-add'),
            validate = layui.validate,
            layedit = layui.layedit;

        form.verify(validate);
        form.render();

        formSelects.render();

        <#if columns??>
        <#list columns as column>
        <#if column.type = 'timestamp' || column.type = 'date' || column.type = 'datetime'||column.type = 'TIMESTAMP' || column.type = 'DATE' || column.type = 'DATETIME'
            || column.field = 'createTime' || column.field = 'updateTime' >
        //初始化时间组件
        laydate.render({
            elem: "#${className}-list input[name='${column.field}']",
            range: true,
            trigger: 'click'
        });
        </#if>
        </#list>
        </#if>


        form.on('submit(${className}-add-form-submit)', function (data) {
            let field = data.field;
            $.ajax({
                type: "POST",
                url: ctx + '${className}',
                data: field,
                dataType: "json",
                contentType : 'application/json;charset=utf-8', //设置请求头信息
                success: function(result){
                    console.log(result);
                    if(result.code==200){
                        layer.closeAll();
                        febs.alert.success('添加成功');
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