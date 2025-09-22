package com.iflytek.astra.console.toolkit.service.database;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.iflytek.astra.console.commons.constant.ResponseEnum;
import com.iflytek.astra.console.commons.exception.BusinessException;
import com.iflytek.astra.console.toolkit.entity.dto.database.DbTableFieldDto;
import com.iflytek.astra.console.toolkit.handler.language.LanguageContext;
import org.apache.commons.lang3.StringUtils;

import java.util.*;

/**
 * Excel read listener for importing database table fields.
 * <p>
 * It validates headers according to the language context (Chinese or English),
 * validates each row of field metadata, and converts them into
 * {@link DbTableFieldDto} objects.
 */
public class DBTableExcelReadListener extends AnalysisEventListener<Map<Integer, String>> {

    /** Expected headers in Chinese format. */
    private static final List<String> expectedHeaders = Arrays.asList(
            "字段名*", "数据类型*", "描述*", "默认值", "是否必填*");

    /** Expected headers in English format. */
    private static final List<String> expectedHeadersEn = Arrays.asList(
            "Field Name*", "Data Type*", "Description*", "Default Value", "Required*");

    /** Allowed field types. */
    private static final List<String> fieldType = Arrays.asList(
            "String", "Integer", "Time", "Number", "Boolean");

    private final List<DbTableFieldDto> tableFields;

    /**
     * Construct a new listener with a sink list for parsed table fields.
     *
     * @param tableFields list to store parsed table fields
     */
    public DBTableExcelReadListener(List<DbTableFieldDto> tableFields) {
        this.tableFields = tableFields;
    }

    /**
     * Validate header row when reading Excel.
     *
     * @param headMap header row map (column index → header name)
     * @param context analysis context
     * @throws BusinessException if header format does not match expectations
     */
    @Override
    public void invokeHeadMap(Map<Integer, String> headMap, AnalysisContext context) {
        List<String> actualHeaders = new ArrayList<>(headMap.values());
        List<String> expectedHeadersFormat;
        if (LanguageContext.isEn()) {
            expectedHeadersFormat = expectedHeadersEn;
        } else {
            expectedHeadersFormat = expectedHeaders;
        }
        if (!expectedHeadersFormat.equals(actualHeaders)) {
            throw new BusinessException(ResponseEnum.DATABASE_TABLE_FIELD_IMPORT_DEFAULT);
        }
    }

    /**
     * Parse and validate a single Excel row representing a table field.
     *
     * @param row     row data (column index → cell value)
     * @param context analysis context
     * @throws BusinessException if required fields are missing, type is invalid,
     *                           or default value format is illegal
     */
    @Override
    public void invoke(Map<Integer, String> row, AnalysisContext context) {
        // Validate required fields are not empty
        DbTableFieldDto dbTableFieldDto = new DbTableFieldDto();
        if (row.get(0) == null || row.get(1) == null || row.get(2) == null || row.get(4) == null) {
            throw new BusinessException(ResponseEnum.DATABASE_CANNOT_EMPTY);
        }
        dbTableFieldDto.setName(row.get(0));
        if (!fieldType.contains(row.get(1))) {
            throw new BusinessException(ResponseEnum.DATABASE_TYPE_ILLEGAL);
        }
        dbTableFieldDto.setType(row.get(1));
        dbTableFieldDto.setDescription(row.get(2));
        if (StringUtils.isNotBlank(row.get(3))) {
            if ("Integer".equalsIgnoreCase(row.get(1))) {
                try {
                    Long.parseLong(row.get(3));
                } catch (NumberFormatException e) {
                    throw new BusinessException(ResponseEnum.DATABASE_TABLE_ILLEGAL_DEFAULT);
                }
            } else if ("Boolean".equalsIgnoreCase(row.get(1))) {
                if (!"true".equalsIgnoreCase(row.get(3)) && !"false".equalsIgnoreCase(row.get(3))) {
                    throw new BusinessException(ResponseEnum.DATABASE_TABLE_ILLEGAL_DEFAULT);
                }
            } else if ("Number".equalsIgnoreCase(row.get(1))) {
                try {
                    Double.parseDouble(row.get(3));
                } catch (NumberFormatException e) {
                    throw new BusinessException(ResponseEnum.DATABASE_TABLE_ILLEGAL_DEFAULT);
                }
            }
        }
        dbTableFieldDto.setDefaultValue(row.get(3));
        dbTableFieldDto.setIsRequired("是".equals(row.get(4)));
        tableFields.add(dbTableFieldDto);
    }

    /**
     * Final callback after all rows are analyzed.
     *
     * @param analysisContext analysis context
     * @throws IllegalArgumentException if no table fields are parsed
     */
    @Override
    public void doAfterAllAnalysed(AnalysisContext analysisContext) {
        if (tableFields.isEmpty()) {
            throw new IllegalArgumentException("No field information found, please check the Excel data!");
        }
    }
}