<div class="layui-fluid layui-anim febs-anim" id="${className}-list" lay-title="${tableComment}">
    <div class="layui-row febs-container">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body febs-table-full">
                    <form class="layui-form layui-table-form" lay-filter="${className}-table-form">
                        <div class="layui-row">
                            <div class="layui-col-md10">
                                <div class="layui-form-item">

                                    <#if columns??>
                                        <#list columns as column>
                                            <#if (column.type = 'varchar' || column.type = 'uniqueidentifier'
                                                || column.type = 'varchar2' || column.type = 'nvarchar' || column.type = 'VARCHAR2'
                                                || column.type = 'VARCHAR' || column.type = 'char')>
                                    <div class="layui-inline">
                                        <label class="layui-form-label layui-form-label-sm">${column.remark}</label>
                                        <div class="layui-input-inline">
                                            <input type="text" autocomplete="off" name="${column.field?uncap_first}" class="layui-input">
                                        </div>
                                    </div>
                                            </#if>

                                            <#if column.type = 'timestamp' || column.type = 'date' || column.type = 'datetime'||column.type = 'TIMESTAMP' || column.type = 'DATE' || column.type = 'DATETIME'
                                                || column.field = 'createTime' || column.field = 'updateTime' >
                                    <div class="layui-inline">
                                        <label class="layui-form-label layui-form-label-sm">${column.remark}</label>
                                        <div class="layui-input-inline">
                                            <input type="text" autocomplete="off" name="${column.field?uncap_first}" class="layui-input">
                                        </div>
                                    </div>
                                            </#if>

                                            <#if column.field = 'delFlag' >
                                    <div class="layui-inline">
                                        <label class="layui-form-label layui-form-label-sm">状态</label>
                                        <div class="layui-input-inline">
                                            <select name="${column.field?uncap_first}">
                                                <option value=""></option>
                                                <option value="1">有效</option>
                                                <option value="0">禁用</option>
                                            </select>
                                        </div>
                                    </div>
                                            </#if>
                                        </#list>
                                    </#if>

                                </div>
                            </div>
                            <div class="layui-col-md2 layui-col-sm12 layui-col-xs12 table-action-area">
                                <div class="layui-btn layui-btn-sm layui-btn-primary table-action" id="query">
                                    <i class="layui-icon">&#xe848;</i>
                                </div>
                                <div class="layui-btn layui-btn-sm layui-btn-primary table-action" id="reset">
                                    <i class="layui-icon">&#xe79b;</i>
                                </div>
                                <div class="layui-btn layui-btn-sm layui-btn-primary table-action action-more"
                                     shiro:hasAnyPermissions="${className?uncap_first}:add,${className?uncap_first}:delete,${className?uncap_first}:import,${className?uncap_first}:export">
                                    <i class="layui-icon">&#xe875;</i>
                                </div>
                            </div>
                        </div>
                    </form>
                    <table lay-filter="${className}Table" lay-data="{id: '${className}Table'}"></table>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/html" id="${className}-status">
    {{#
    var status = {
    1: {title: '有效', color: 'green'},
    0: {title: '禁用', color: 'volcano'}
    }[d.delFlag];
    }}
    <span class="layui-badge febs-tag-{{status.color}}">{{ status.title }}</span>
</script>
<script type="text/html" id="${className}-option">
    <span shiro:lacksPermission="${className?uncap_first}:view,${className?uncap_first}:update,${className?uncap_first}:delete">
        <span class="layui-badge-dot febs-bg-orange"></span> 无权限
    </span>
    <a lay-event="detail" shiro:hasPermission="${className?uncap_first}:view"><i
            class="layui-icon febs-edit-area febs-green">&#xe7a5;</i></a>
    <a lay-event="edit" shiro:hasPermission="${className?uncap_first}:update"><i
            class="layui-icon febs-edit-area febs-blue">&#xe7a4;</i></a>
    <a lay-event="del" shiro:hasPermission="${className?uncap_first}:delete"><i class="layui-icon febs-edit-area febs-red">&#xe7f9;</i></a>
</script>
<script data-th-inline="none" type="text/javascript">
    layui.use(['dropdown', 'jquery', 'laydate', 'form', 'table', 'febs', 'treeSelect','element','upload'], function () {
        var $ = layui.jquery,
            laydate = layui.laydate,
            febs = layui.febs,
            form = layui.form,
            table = layui.table,
            treeSelect = layui.treeSelect,
            dropdown = layui.dropdown,
            $view = $('#${className}-list'),
            $query = $view.find('#query'),
            $reset = $view.find('#reset'),
            $searchForm = $view.find('form'),
            sortObject = {field: 'createTime', type: null},
            upload = layui.upload,
            element = layui.element,
            tableIns;

        //初始化表单
        form.render();

        //初始化表格
        initTable();

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


        dropdown.render({
            elem: $view.find('.action-more'),
            click: function (name, elem, event) {
                var checkStatus = table.checkStatus('${className}Table');
                if (name === 'add') {
                    febs.modal.view('新增${tableComment}', '${className?uncap_first}/add', {
                        btn: ['提交', '重置'],
                        yes: function (index, layero) {
                            $('#${className}-add').find('#submit').trigger('click');
                        },
                        btn2: function () {
                            $('#${className}-add').find('#reset').trigger('click');
                            return false;
                        }
                    });
                }
                if (name === 'delete') {
                    if (!checkStatus.data.length) {
                        febs.alert.warn('请选择需要删除的${tableComment}');
                    } else {
                        febs.modal.confirm('删除', '确定删除该${tableComment}？', function () {
                            var ${className}Ids = [];
                            layui.each(checkStatus.data, function (key, item) {
                                ${className}Ids.push(item.id)
                            });
                            deleteCompositions(${className}Ids.join(','));
                        });
                    }
                }

                if (name === 'export') {
                    var params = $.extend(getQueryParams(), {field: sortObject.field, order: sortObject.type});
                    params.pageSize = $view.find(".layui-laypage-limits option:selected").val();
                    params.pageNum = $view.find(".layui-laypage-em").next().html();
                    febs.download(ctx + '${className?uncap_first}/excel', params, '${tableComment}-导出.xlsx');
                }
            },
            options: [{
                name: 'add',
                title: '新增${tableComment}',
                perms: '${className?uncap_first}:add'
            }, {
                name: 'delete',
                title: '删除${tableComment}',
                perms: '${className?uncap_first}:delete'
            }, {
                name: 'export',
                title: '导出Excel',
                perms: '${className?uncap_first}:export'
            }]
        });

        table.on('tool(${className}Table)', function (obj) {
            var data = obj.data,
                layEvent = obj.event;
            if (layEvent === 'detail') {
                febs.modal.view('查看${tableComment}', '${className?uncap_first}/' + data.id, {

                });
            }
            if (layEvent === 'del') {
                febs.modal.confirm('删除${tableComment}', '确定删除该${tableComment}？', function () {
                    deleteCompositions(data.id);
                });
            }
            if (layEvent === 'edit') {
                febs.modal.view('修改${tableComment}', '${className?uncap_first}/update/' + data.id, {
                    btn: ['提交', '重置'],
                    yes: function (index, layero) {
                        $('#${className}-update').find('#submit').trigger('click');
                    },
                    btn2: function () {
                        layer.closeAll();
                    }
                });
            }
        });

        table.on('sort(${className}Table)', function (obj) {
            sortObject = obj;
            tableIns.reload({
                initSort: obj,
                where: $.extend(getQueryParams(), {
                    field: obj.field,
                    order: obj.type
                })
            });
        });

        $query.on('click', function () {
            var params = $.extend(getQueryParams(), {field: sortObject.field, order: sortObject.type});
            tableIns.reload({where: params, page: {curr: 1}});
        });

        $reset.on('click', function () {
            $searchForm[0].reset();
            sortObject.type = 'null';
            tableIns.reload({where: getQueryParams(), page: {curr: 1}, initSort: sortObject});
        });

        //初始化表格
        function initTable() {
            tableIns = febs.table.init({
                elem: $view.find('table'),
                id: '${className}Table',
                url: ctx + '${className?uncap_first}/list',
                cols: [[
                    {type: 'checkbox'},
                    <#if columns??>
                        <#list columns as column>
                            <#if column.field = 'createTime' >
                    {field: 'createTimeStr', title: '创建时间',minWidth: 170, sort: true},
                            <#elseif column.field = 'updateTime' >
                    {field: 'updateTimeStr', title: '修改时间',minWidth: 170, sort: true},
                            <#elseif column.field = 'delFlag' >
                    {field: 'delFlag', title: '状态', templet: '#${className}-status'},
                            <#else>
                    {field: '${column.field}', title: '${column.remark}'},
                            </#if>
                        </#list>
                    </#if>
                    {title: '操作', toolbar: '#${className}-option', minWidth: 140}
                ]]
            });
        }

        function getQueryParams() {
            <#if columns??>
                <#list columns as column>
                    <#if column.field = 'createTime' >
            var createTimeFrom,
                createTimeTo,
                createTime = $searchForm.find('input[name="createTime"]').val();
            if (createTime) {
                createTimeFrom = createTime.split(' - ')[0];
                createTimeTo = createTime.split(' - ')[1];
            }
            if(createTimeFrom){
                createTimeFrom = new Date(createTimeFrom).getTime();
            }
            if(createTimeTo){
                //加一天
                createTimeTo = new Date(createTimeTo).getTime()+86400000;
            }
                    </#if>
                    <#if column.field = 'updateTime' >
            var updateTimeFrom,
                updateTimeTo,
                updateTime = $searchForm.find('input[name="updateTime"]').val();
            if (updateTime) {
                updateTimeFrom = updateTime.split(' - ')[0];
                updateTimeTo = updateTime.split(' - ')[1];
            }
            if(updateTimeFrom){
                updateTimeFrom = new Date(updateTimeFrom).getTime();
            }
            if(updateTimeTo){
                //加一天
                updateTimeTo = new Date(updateTimeTo).getTime()+86400000;
            }
                    </#if>
                </#list>
            </#if>

            return {

                <#if columns??>
                    <#list columns as column>
                        <#if column.field = 'createTime' >
                createTimeFrom: createTimeFrom,
                createTimeTo: createTimeTo,
                        </#if>
                        <#if column.field = 'updateTime' >
                updateTimeFrom: updateTimeFrom,
                updateTimeTo: updateTimeTo,
                        </#if>

                        <#if (column.type = 'varchar' || column.type = 'uniqueidentifier'
                            || column.type = 'varchar2' || column.type = 'nvarchar' || column.type = 'VARCHAR2'
                            || column.type = 'VARCHAR' || column.type = 'char')>
                ${column.field}: $searchForm.find('input[name="${column.field}"]').val().trim(),
                        </#if>
                        <#if column.field = 'delFlag' >
                delFlag: $searchForm.find("select[name='delFlag']").val(),
                        </#if>
                    </#list>
                </#if>
                invalidate_ie_cache: new Date()
            };
        }

        function deleteCompositions(${className}Ids) {
            febs.get(ctx + '${className?uncap_first}/delete/' + ${className}Ids, null, function () {
                febs.alert.success('删除${tableComment}成功');
                $query.click();
            });
        }
    })
</script>