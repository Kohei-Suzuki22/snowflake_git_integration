  -- ---------- 5. ファイル参照（Stage 風） ----------

  -- ブランチ指定
  LIST @git_demo.code.snowflake_git_integration/branches/main/;

  -- 別ブランチがあれば
  -- LIST @git_demo.code.snowflake_git_integration/branches/dev/;

  -- タグ指定（バージョン固定）
  -- LIST @git_demo.code.snowflake_git_integration/tags/v1.0.0/;

  -- コミット SHA 指定（特定の時点でピン留め）
  -- LIST @git_demo.code.snowflake_git_integration/commits/<commit_sha>/;


  -- ---------- 6. ブランチ「切り替え」について ----------

  -- Snowflake には git checkout / git switch に相当する状態切り替えコマンドは無い。
  -- 「切り替える」のではなく、参照したいブランチを毎回パスで指定する設計：
  --
  -- main を参照     : @repo/branches/main/foo.sql
  -- dev を参照      : @repo/branches/dev/foo.sql
  -- 特定タグを参照  : @repo/tags/v1.0/foo.sql
  -- 特定コミット参照: @repo/commits/<sha>/foo.sql
  --
  -- → 同一セッションで複数ブランチを同時参照可能（git の作業ツリーの概念がない）


  -- ---------- 7. ファイル実行（SQL ファイル） ----------

  EXECUTE IMMEDIATE FROM @git_demo.code.snowflake_git_integration/branches/main/hello.sql;

  -- 引数渡しも可
  -- EXECUTE IMMEDIATE FROM @git_demo.code.snowflake_git_integration/branches/main/setup.sql
  --   USING (foo => 'bar');
