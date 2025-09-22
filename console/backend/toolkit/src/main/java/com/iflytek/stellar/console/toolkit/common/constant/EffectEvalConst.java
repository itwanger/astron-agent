package com.iflytek.stellar.console.toolkit.common.constant;

import com.alibaba.fastjson2.JSONObject;

/**
 * Constants used for effect evaluation tasks, including dataset templates,
 * file restrictions, evaluation task status, sampling modes, etc.
 *
 * <p>This class is a collection of static constant definitions.
 * It does not contain business logic methods.</p>
 */
public class EffectEvalConst {

    /** Temporary working directory for evaluation tasks */
    public static final String EVAL_TMP_WORK_DIR = CommonConst.LOCAL_TMP_WORK_DIR + "eval/";

    /** Prefix path in S3 for evaluation datasets */
    public static final String SET_S3_PREFIX = "sparkBot/evalSet/";

    /** Template for open fine-tuning dataset JSON */
    public static final JSONObject FINE_TUNE_OPEN_DATASET_TEMPLATE = new JSONObject()
            .fluentPut("input", "input")
            .fluentPut("output", "output")
            .fluentPut("instruction", "");

    /** Minimum required training data size for fine-tuning open model */
    public static final int FINE_TUNE_OPEN_MODEL_TRAIN_DATA_MIN_SIZE = 50;

    /** Supported file suffix for evaluation datasets */
    public static final CharSequence SUPPORT_FILE_SUFFIX = "csv";

    /** Maximum supported file size (20 MB) */
    public static final long SUPPORT_FILE_MAX_SIZE = 20971520L;

    /** Template for function call JSON structure */
    public static final JSONObject FC_TEMPLATE = new JSONObject()
            .fluentPut("name", "name")
            .fluentPut("arguments", new JSONObject().fluentPut("next_inputs", "next_inputs"));

    /**
     * Data acquisition mode.
     * ONLINE = 1, OFFLINE = 2
     */
    public static final class GetDataMode {
        /** Online mode */
        public static final int ONLINE = 1;
        /** Offline mode */
        public static final int OFFLINE = 2;
    }

    /**
     * Data source.
     * OFFLINE = 1, ONLINE = 2
     */
    public static final class DataSource {
        public static final int OFFLINE = 1;
        public static final int ONLINE = 2;
    }

    /**
     * Data report source statuses.
     */
    public static final class DataReportSource {
        /** Already terminated */
        public static final int TERMINATED_ALREADY = -1;
        /** To be rated */
        public static final int ToBeRated = 0;
        /** Rating failed */
        public static final int RateFailed = -2;
        /** Missing parameter */
        public static final int MissParameter = -3;
        /** Missing score reason for intelligent evaluation; please edit in dataset management */
        public static final int MissParameterScoreReason = -4;
    }

    /**
     * Evaluation task status values.
     */
    public static final class EvalTaskStatus {
        /** Evaluating, batch processing in progress */
        public static final int DATA_RUNNING = 0;
        /** Evaluation completed */
        public static final int EVALUATED = 1;
        /** Evaluation failed */
        public static final int FAIL = 2;
        /** Marked */
        public static final int MARKED = 3;
        /** Evaluating, batch processing completed but not scored */
        public static final int DATA_NOT_SCORED = 4;
        /** Paused */
        public static final int PAUSE = 5;
        /** Terminating */
        public static final int TERMINATED = 6;
        /** Stopped due to server shutdown */
        public static final int SERVER_SHUTDOWN = -1;
        /** Being created */
        public static final int STORE_TEMPORARY = 8;
        /** Already terminated */
        public static final int TERMINATED_ALREADY = 9;
        /** Scoring in progress */
        public static final int DATA_SCORED = 10;
    }

    /**
     * Spark evaluation task status values.
     */
    public static final class SparkEvaluateTaskStatus {
        public static final int RUNNING = 0;
        public static final int SUCCEED = 1;
        public static final int FAIL = 2;
    }

    /**
     * Optimization task status values.
     */
    public static final class OptimizeTaskStatus {
        public static final int INIT = 0;
        public static final int RUNNING = 1;
        public static final int SUCCEED = 2;
        public static final int FAIL = 3;
        public static final int PENDING = 4;
        public static final int STOPPED = 5;
    }

    /**
     * Scheme type definitions.
     */
    public static final class Scheme {
        /** Element pick-up scheme */
        public static final int ELEMENT_PICK_UP = 1;
        /** String matching scheme */
        public static final int STRING_MATCHING = 2;
    }

    /**
     * Report data status values.
     */
    public static final class ReportDataStatus {
        /** Unmarked */
        public static final int UN_MARKED = 0;
        /** Marked */
        public static final int MARKED = 1;
    }

    /**
     * Sampling mode for evaluation tasks.
     */
    public static final class SampleMode {
        /** Sequential sampling */
        public static final int SEQUENTIAL = 1;
        /** Random sampling */
        public static final int RANDOM = 2;
        /** Feedback (like/dislike) based sampling */
        public static final int FEEDBACK = 3;
    }

    /**
     * Task mode definitions.
     */
    public static final class TaskMode {
        /** Batch data testing */
        public static final int ONLY_DATA_BATCH = 1;
        /** Manual evaluation */
        public static final int MANUAL_EVALUATE = 2;
        /** Automatic evaluation */
        public static final int AUTO_EVALUATE = 3;
    }

    /**
     * Model server deployment status values.
     * 0 = not deployed, 1 = deploying, 2 = deploy failed, 3 = deploy successful.
     * The enumeration is consistent with the fine-tuning side.
     */
    public static final class ModelServerStatus {
        public static final int UNDEPLOY = 0;
        public static final int DEPLOYING = 1;
        public static final int DEPLOY_FAILED = 2;
        public static final int DEPLOY_SUCCESS = 3;
    }
}