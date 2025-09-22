package com.iflytek.astra.console.toolkit.service.database;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.iflytek.astra.console.commons.constant.ResponseEnum;
import com.iflytek.astra.console.commons.exception.BusinessException;
import com.iflytek.astra.console.toolkit.common.constant.CommonConst;
import com.iflytek.astra.console.toolkit.entity.table.database.DbTableField;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Excel Reader Listener.
 * <p>
 * Responsibilities:
 * <ul>
 *   <li>Read Excel and produce structured row data (each row as {@code Map<columnName, value>})</li>
 *   <li>Validate headers and required fields</li>
 *   <li>Empty cells fallback to field default value or type default value</li>
 *   <li>Support maximum row limit</li>
 * </ul>
 */
public class DBExcelReadListener extends AnalysisEventListener<Map<Integer, String>> {

    private static final String[] SYSTEM_FIELDS = {"id", "uid", "create_time"};
    private static final DateTimeFormatter TS = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final List<DbTableField> tableFields;
    private final List<Map<String, Object>> rowsSink; // container for parsed rows
    private final String uid; // automatically add uid for each row
    private final int maxRows; // row limit (safety guard)

    private List<String> expectedHeaders;
    private List<String> notNullFieldsList;

    private int accepted = 0;
    private boolean headerValidated = false;

    /**
     * Recommended usage: load rows into {@code rowsSink} once.
     *
     * @param tableFields table field metadata
     * @param rowsSink    container to store parsed rows
     * @param uid         uid to be filled in each row
     * @param maxRows     maximum number of rows to read
     */
    public DBExcelReadListener(List<DbTableField> tableFields,
                               List<Map<String, Object>> rowsSink,
                               String uid,
                               int maxRows) {
        this.tableFields = Objects.requireNonNull(tableFields);
        this.rowsSink = Objects.requireNonNull(rowsSink);
        this.uid = uid;
        this.maxRows = Math.max(1, maxRows);
    }

    /**
     * Validate Excel header row.
     *
     * @param headMap header row from Excel
     * @param context analysis context
     * @throws IllegalArgumentException if header does not match expected headers
     */
    @Override
    public void invokeHeadMap(Map<Integer, String> headMap, AnalysisContext context) {
        List<String> actualHeaders = new ArrayList<>(headMap.values());

        expectedHeaders = tableFields.stream()
                .map(DbTableField::getName)
                .filter(n -> !Arrays.asList(SYSTEM_FIELDS).contains(n))
                .collect(Collectors.toList());

        notNullFieldsList = tableFields.stream()
                .filter(f -> !Arrays.asList(SYSTEM_FIELDS).contains(f.getName()))
                .filter(DbTableField::getIsRequired)
                .map(DbTableField::getName)
                .collect(Collectors.toList());

        // Require strict order consistency with original logic
        if (!CollectionUtils.isEqualCollection(expectedHeaders, actualHeaders)) {
            throw new IllegalArgumentException("Header mismatch! Expected: " + expectedHeaders + ", Actual: " + actualHeaders);
        } else {
            expectedHeaders = actualHeaders;
        }
        headerValidated = true;
    }

    /**
     * Parse a single Excel row.
     *
     * @param row     the row data (index -> cell value)
     * @param context analysis context
     * @throws BusinessException if header is not validated or field does not exist
     */
    @Override
    public void invoke(Map<Integer, String> row, AnalysisContext context) {
        if (!headerValidated) {
            throw new BusinessException(ResponseEnum.RESPONSE_FAILED, "Header not validated, please check Excel file.");
        }
        if (accepted >= maxRows) {
            return; // ignore rows beyond limit to ensure availability
        }

        Map<String, Object> out = new LinkedHashMap<>();
        out.put("uid", uid);

        for (int i = 0; i < expectedHeaders.size(); i++) {
            String header = expectedHeaders.get(i);
            String raw = row.get(i); // raw cell value (may be null)
            DbTableField meta = tableFields.stream()
                    .filter(f -> f.getName().equals(header))
                    .findFirst()
                    .orElseThrow(() -> new BusinessException(ResponseEnum.RESPONSE_FAILED, "Field " + header + " does not exist!"));

            Object v;
            if (StringUtils.isBlank(raw)) {
                // Empty value: required -> use field default; optional -> type default (or null)
                v = chooseDefault(meta, notNullFieldsList.contains(header));
            } else {
                v = parseByType(raw, meta.getType());
            }
            out.put(header, v);
        }

        rowsSink.add(out);
        accepted++;
    }

    /**
     * Callback after all rows are analyzed.
     *
     * @param analysisContext analysis context
     * @throws IllegalArgumentException if no valid rows are parsed
     */
    @Override
    public void doAfterAllAnalysed(AnalysisContext analysisContext) {
        if (accepted == 0) {
            throw new IllegalArgumentException("No valid data found in file, please check the Excel data.");
        }
    }

    // —— Helper methods: parsing and default values —— //

    /**
     * Parse string value according to field type.
     *
     * @param s    input string
     * @param type field type
     * @return parsed value
     * @throws IllegalArgumentException if parsing fails for unsupported types
     */
    private Object parseByType(String s, String type) {
        String t = StringUtils.lowerCase(type);
        switch (t) {
            case CommonConst.DBFieldType.INTEGER:
                return Long.parseLong(s.trim());
            case CommonConst.DBFieldType.NUMBER:
                return new BigDecimal(s.trim());
            case CommonConst.DBFieldType.BOOLEAN:
                return parseBoolean(s);
            case CommonConst.DBFieldType.TIME:
                // Require standard format to avoid ambiguity
                return LocalDateTime.parse(s.trim(), TS);
            default:
                return s; // raw string
        }
    }

    /**
     * Choose default value for field when input is empty.
     *
     * @param f        field metadata
     * @param required whether the field is required
     * @return default value according to field configuration and type
     */
    private Object chooseDefault(DbTableField f, boolean required) {
        String t = StringUtils.lowerCase(f.getType());
        String def = f.getDefaultValue();

        if (StringUtils.isNotBlank(def)) {
            // Field has configured default value: try to parse by type
            try {
                return parseByType(def, t);
            } catch (Exception ignore) {
                // Fallback: return as string
                return def;
            }
        }

        // No configured default value
        if (required) {
            // Required but empty: provide type default value
            switch (t) {
                case CommonConst.DBFieldType.INTEGER:
                    return 0L;
                case CommonConst.DBFieldType.NUMBER:
                    return BigDecimal.ZERO;
                case CommonConst.DBFieldType.BOOLEAN:
                    return Boolean.FALSE;
                case CommonConst.DBFieldType.TIME:
                    return LocalDateTime.now();
                default:
                    return ""; // empty string for text
            }
        } else {
            // Optional: allow null (write layer decides if allowed)
            switch (t) {
                case CommonConst.DBFieldType.INTEGER:
                case CommonConst.DBFieldType.NUMBER:
                case CommonConst.DBFieldType.BOOLEAN:
                case CommonConst.DBFieldType.TIME:
                    return null;
                default:
                    return ""; // more user-friendly to return empty string
            }
        }
    }

    /**
     * Parse boolean string.
     *
     * @param s string to parse
     * @return parsed boolean value
     * @throws IllegalArgumentException if input cannot be parsed as boolean
     */
    private Boolean parseBoolean(String s) {
        String x = s.trim().toLowerCase(Locale.ROOT);
        if (x.equals("1") || x.equals("true") || x.equals("t") || x.equals("yes") || x.equals("y"))
            return Boolean.TRUE;
        if (x.equals("0") || x.equals("false") || x.equals("f") || x.equals("no") || x.equals("n"))
            return Boolean.FALSE;
        throw new IllegalArgumentException("Unable to parse boolean value: " + s);
    }
}