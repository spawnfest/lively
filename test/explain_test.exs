defmodule Lively.ExplainTest do
  use ExUnit.Case

  alias Lively.Explain
  alias Lively.Explain.Node

  @explain_example [
    %{
      "Plan" => %{
        "Actual Loops" => 1,
        "Actual Rows" => 4,
        "Actual Startup Time" => 0.139,
        "Actual Total Time" => 0.231,
        "Node Type" => "Result",
        "Plan Rows" => 7,
        "Plan Width" => 405,
        "Plans" => [
          %{
            "Actual Loops" => 1,
            "Actual Rows" => 4,
            "Actual Startup Time" => 0.131,
            "Actual Total Time" => 0.218,
            "Node Type" => "Append",
            "Parent Relationship" => "Outer",
            "Plan Rows" => 7,
            "Plan Width" => 405,
            "Plans" => [
              %{
                "Actual Loops" => 1,
                "Actual Rows" => 0,
                "Actual Startup Time" => 0.009,
                "Actual Total Time" => 0.009,
                "Alias" => "paris",
                "Filter" => "(ar_num = 8)",
                "Index Cond" => "(tags ? 'tourism'::text)",
                "Index Name" => "idx_paris_tags",
                "Node Type" => "Index Scan",
                "Parent Relationship" => "Member",
                "Plan Rows" => 1,
                "Plan Width" => 450,
                "Relation Name" => "paris",
                "Scan Direction" => "NoMovement",
                "Startup Cost" => 0.0,
                "Total Cost" => 8.27
              },
              %{
                "Actual Loops" => 1,
                "Actual Rows" => 0,
                "Actual Startup Time" => 0.001,
                "Actual Total Time" => 0.001,
                "Alias" => "paris",
                "Filter" => "((tags ? 'tourism'::text) AND (ar_num = 8))",
                "Node Type" => "Seq Scan",
                "Parent Relationship" => "Member",
                "Plan Rows" => 1,
                "Plan Width" => 450,
                "Relation Name" => "paris_linestrings",
                "Startup Cost" => 0.0,
                "Total Cost" => 11.8
              },
              %{
                "Actual Loops" => 1,
                "Actual Rows" => 0,
                "Actual Startup Time" => 0.003,
                "Actual Total Time" => 0.003,
                "Alias" => "paris",
                "Filter" => "(ar_num = 8)",
                "Index Cond" => "(tags ? 'tourism'::text)",
                "Index Name" => "idx_paris_points_tags",
                "Node Type" => "Index Scan",
                "Parent Relationship" => "Member",
                "Plan Rows" => 1,
                "Plan Width" => 450,
                "Relation Name" => "paris_points",
                "Scan Direction" => "NoMovement",
                "Startup Cost" => 0.0,
                "Total Cost" => 8.27
              },
              %{
                "Actual Loops" => 1,
                "Actual Rows" => 0,
                "Actual Startup Time" => 0.002,
                "Actual Total Time" => 0.002,
                "Alias" => "paris",
                "Filter" => "(ar_num = 8)",
                "Index Cond" => "(tags ? 'tourism'::text)",
                "Index Name" => "idx_paris_polygons_tags",
                "Node Type" => "Index Scan",
                "Parent Relationship" => "Member",
                "Plan Rows" => 1,
                "Plan Width" => 450,
                "Relation Name" => "paris_polygons",
                "Scan Direction" => "NoMovement",
                "Startup Cost" => 0.0,
                "Total Cost" => 8.27
              },
              %{
                "Actual Loops" => 1,
                "Actual Rows" => 0,
                "Actual Startup Time" => 0.103,
                "Actual Total Time" => 0.103,
                "Alias" => "paris",
                "Filter" => "((tags ? 'tourism'::text) AND (ar_num = 8))",
                "Node Type" => "Seq Scan",
                "Parent Relationship" => "Member",
                "Plan Rows" => 1,
                "Plan Width" => 513,
                "Relation Name" => "paris_linestrings_ar_08",
                "Startup Cost" => 0.0,
                "Total Cost" => 7.27
              },
              %{
                "Actual Loops" => 1,
                "Actual Rows" => 4,
                "Actual Startup Time" => 0.009,
                "Actual Total Time" => 0.085,
                "Alias" => "paris",
                "Filter" => "((tags ? 'tourism'::text) AND (ar_num = 8))",
                "Node Type" => "Seq Scan",
                "Parent Relationship" => "Member",
                "Plan Rows" => 1,
                "Plan Width" => 72,
                "Relation Name" => "paris_points_ar_08",
                "Startup Cost" => 0.0,
                "Total Cost" => 5.16
              },
              %{
                "Actual Loops" => 1,
                "Actual Rows" => 0,
                "Actual Startup Time" => 0.007,
                "Actual Total Time" => 0.007,
                "Alias" => "paris",
                "Filter" => "((tags ? 'tourism'::text) AND (ar_num = 8))",
                "Node Type" => "Seq Scan",
                "Parent Relationship" => "Member",
                "Plan Rows" => 1,
                "Plan Width" => 450,
                "Relation Name" => "paris_polygons_ar_08",
                "Startup Cost" => 0.0,
                "Total Cost" => 1.08
              }
            ],
            "Startup Cost" => 0.0,
            "Total Cost" => 50.11
          }
        ],
        "Startup Cost" => 0.0,
        "Total Cost" => 50.13
      },
      "Execution Time" => 1.238,
      "Planning Time" => 0.92,
      "Triggers" => []
    }
  ]

  test "build_tree" do
    plan = List.first(@explain_example)["Plan"]

    assert Explain.build_tree(plan) == %Node{
             cost: nil,
             left: %Node{
               cost: nil,
               left: %Node{
                 cost: nil,
                 left: nil,
                 right: nil,
                 rows: nil,
                 timing: nil,
                 type: "Index Scan"
               },
               right: %Node{
                 type: "Seq Scan",
                 left: nil,
                 right: nil,
                 timing: nil,
                 rows: nil,
                 cost: nil
               },
               rows: nil,
               timing: nil,
               type: "Append"
             },
             right: nil,
             rows: nil,
             timing: nil,
             type: "Result"
           }
  end

  test "render includes execution time" do
    explain = Explain.new(@explain_example)
    {:markdown, content} = Kino.Render.to_livebook(explain)
    assert content =~ "Execution time: 1.238ms"
  end
end