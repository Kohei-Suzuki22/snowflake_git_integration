
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

-- llama3.1-70b に質問を投げる
 SELECT AI_COMPLETE(
    'llama3.1-70b',
    '日本の四季を 1 行で説明してください。'
  ) AS answer;


  -- 利用可能モデルの取得
SHOW PARAMETERS LIKE 'CORTEX_ENABLED_CROSS_REGION' IN ACCOUNT;


 -- ポジティブ/ネガティブを -1.0 〜 +1.0 のスコアで返す
SELECT
    AI_SENTIMENT('この商品最高でした！また買います。') AS product_review,
    AI_SENTIMENT('期待外れで時間の無駄だった。') AS product_rewview;


  ├─────────────────────────┼────────────────────────────────────────────────────────┤
  │ 似ている OSS は?        │ MLflow Tracking                                        │
  └─────────────────────────┴────────────────────────────────────────────────────────┘

  ---
  これでヨシ。Step 5 のメニュー全部カバーしたので、次は Step 6: Cortex AI 関数のハンズオン に進みます。

✻ Sautéed for 38s

❯ 要するに、実験の条件と、経過の実績(メトリクス)と、成果物 を、 繰り返しの数だけ保存してくれるものって感じか。

⏺ はい、その通りです。完璧な理解。

  1回の Run = { 実験条件(parameters) + 経過実績(metrics) + 成果物(artifacts) }
  Experiments = Run × 繰り返し回数 の保管庫

  これで Step 5 完了。次は Step 6: Cortex AI 関数のハンズオン に進みます。OK?

✻ Brewed for 8s

❯ おっけいです。

⏺ Step 6. Cortex AI 関数のハンズオン

  Snowsight の Worksheet を開いて、上から順にコピペ実行してください。

  ---
  0. 前提：ロール

  ACCOUNTADMIN で実行してください（CORTEX_USER の database role が付いている）。

  USE ROLE ACCOUNTADMIN;
  USE WAREHOUSE COMPUTE_WH;

  ---
  1. もっとも基本：AI_COMPLETE（LLM 呼び出し）

  -- claude-3-5-sonnet に質問を投げる
  SELECT AI_COMPLETE(
    'claude-3-5-sonnet',
    '日本の四季を 1 行で説明してください。'
  ) AS answer;

  → 結果カラムに LLM の応答テキスト が返ってくることを確認。

  ---
  2. AI_SENTIMENT：感情分析

  -- ポジティブ/ネガティブを -1.0 〜 +1.0 のスコアで返す
  SELECT
    AI_SENTIMENT('この商品最高でした！また買います。') AS positive_review,
    AI_SENTIMENT('期待外れで時間の無駄だった。')         AS negative_review;


  -- 日本語 → 英語
  SELECT AI_TRANSLATE(
    '私は機械学習を学んでいます。',
    'ja',      -- source language
    'en'       -- target language
  ) AS translated;



-- テーブル作成
CREATE OR REPLACE TABLE product_reviews (
    review_id INT,
    review_text VARCHAR
);

-- データ挿入
INSERT INTO product_reviews VALUES
    (1, '配送が早くて最高でした'),
    (2, '商品が壊れて届きました。最悪。'),
    (3, '値段の割に品質はまあまあ'),
    (4, 'リピート決定！家族にも勧めます'),
    (5, '使いにくくて返品しました');

  -- 全件に感情分析を実行
SELECT
    review_id,
    review_text,
    AI_SENTIMENT(review_text) AS sentiment_score
FROM product_reviews
ORDER BY sentiment_score DESC;


  精度を上げた版

  SELECT
    review_id,
    review_text,
    AI_CLASSIFY(
      review_text,
      [
        {'label': '配送', 'description': '配送速度・梱包・到着状態など物流に関する内容'},
        {'label': '品質', 'description': '商品自体の品質・使い勝手・耐久性・故障など'},
        {'label': '価格', 'description': '値段・コスパ・割高/割安などお金に関する内容'}
      ],
      {'task_description': 'ECサイトのレビュー本文を、最も主要な観点で 3 カテゴリに分類する'}
    ):labels[0]::STRING AS category
  FROM product_reviews;
  

DROP TABLE product_reviews;