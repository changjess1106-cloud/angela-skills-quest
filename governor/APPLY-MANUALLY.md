# Apply Execution Fortress v2.1 Manually

To integrate Execution Fortress v2.1, follow these steps:

## Prompt-Level Integration
1. Merge or copy the contents of `Execution-Fortress-v2.md` v2.1 into your governance prompt.
2. Ensure the newly added rules (“A: 實際輸出”, “B: 禁止樂觀誤判”) are applied.

## Policy-Level Integration
1. Open applicable policy files.
2. Update references to include v2.1’s explicit wording.

## Validation
1. Re-run `test_execution_fortress.ps1` to confirm prompt-level changes.

## Notes
- Integration requires precise wording alignment. If uncertain, seek guidance from the governance manager.