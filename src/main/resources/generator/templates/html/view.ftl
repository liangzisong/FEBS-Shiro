<style>
    #composition-see {
        padding: 20px 25px 25px 0;
    }
    #composition-see .layui-treeSelect .ztree li a, .ztree li span {
        margin: 0 0 2px 3px !important;
    }
</style>
<div class="layui-fluid" id="composition-see">
    <form class="layui-form" th:object="${composition}" action="" lay-filter="composition-see-form">
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
                            <input type="text" autocomplete="off" th:field="${'$'+'*'+'{'+column.field+'}'}" name="${column.field?uncap_first}" class="layui-input">
                        </div>
                    </div>
                </#if>
            </#list>
        </#if>



        <div class="layui-form-item febs-hide">
            <button class="layui-btn" lay-submit="" lay-filter="composition-view-form-submit" id="submit"></button>
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
            $view = $('#composition-see'),
            validate = layui.validate,
            layedit = layui.layedit;

        form.verify(validate);
        form.render();

        formSelects.render();


    });
</script>