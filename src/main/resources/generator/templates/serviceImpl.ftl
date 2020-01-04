package ${basePackage}.${serviceImplPackage};

import ${basePackage}.${entityPackage}.${className};
import ${basePackage}.${mapperPackage}.${className}Mapper;
import ${basePackage}.${servicePackage}.I${className}Service;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.beans.factory.annotation.Autowired;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

/**
 * ${tableComment} Service实现
 *
 * @author ${author}
 * @date ${date}
 */
@Service
@Transactional(propagation = Propagation.SUPPORTS, readOnly = true, rollbackFor = Exception.class)
public class ${className}ServiceImpl extends ServiceImpl<${className}Mapper, ${className}> implements I${className}Service {

    @Autowired
    private ${className}Mapper ${className?uncap_first}Mapper;

    @Override
    public IPage<${className}> find${className}s(QueryRequest request, ${className} ${className?uncap_first}) {
        QueryWrapper<${className}> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByAsc(StringUtils.equals(request.getOrder(), FebsConstant.ORDER_ASC), FebsUtil.camelToUnderscore(request.getField()));
        queryWrapper.orderByDesc(StringUtils.equals(request.getOrder(), FebsConstant.ORDER_DESC), FebsUtil.camelToUnderscore(request.getField()));

        <#if columns??>
            <#list columns as column>
        queryWrapper.eq(${className?uncap_first}.get${column.field?uncap_first}()!=null,"${column.field?uncap_first}", tbCategory.get${column.field?uncap_first}());
            </#list>
        </#if>

        Page<${className}> page = new Page<>(request.getPageNum(), request.getPageSize());
        return this.page(page, queryWrapper);
    }

    @Override
    public List<${className}> find${className}s(${className} ${className?uncap_first}) {
	    LambdaQueryWrapper<${className}> queryWrapper = new LambdaQueryWrapper<>();
		// TODO 设置查询条件
		return this.baseMapper.selectList(queryWrapper);
    }

    @Override
    @Transactional
    public void create${className}(${className} ${className?uncap_first}) {
        this.save(${className?uncap_first});
    }

    @Override
    @Transactional
    public void update${className}(${className} ${className?uncap_first}) {
        this.saveOrUpdate(${className?uncap_first});
    }

    /**
    * 删除
    *
    * @param List -> id
    */
    void delete${className}ByIds(ArrayList<String> idArray);

    @Override
    @Transactional
    public void delete${className}(${className} ${className?uncap_first}) {
        LambdaQueryWrapper<${className}> wapper = new LambdaQueryWrapper<>();
	    // TODO 设置删除条件
	    this.remove(wapper);
	}

    /**
    * 根据id删除
    *
    * @param idArray
    */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Integer delete${className}ByIds(ArrayList<String> idArray) throws FebsException {
        return baseMapper.deleteBatchIds(idArray)
    }

}
