import json
import os
from datetime import datetime

def read_task_file(task_file):
    if not os.path.exists(task_file):
        print(f"MISS: Task file {task_file} not found.")
        exit(1)
    with open(task_file, "r", encoding="utf-8") as f:
        return json.load(f)

def write_report(task, report_dir):
    os.makedirs(report_dir, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_path = os.path.join(report_dir, f"state_report_{timestamp}.txt")
    report_content = [
        "State Prove Report",
        f"Task ID: {task['task_id']}",
        f"Goal: {task['goal']}",
        f"Last Updated: {task['last_update']}",
        f"Next Action: {task['next_action']}",
        "Completed Steps:",
    ] + [f"    {step}" for step in task['done']] + ["---- End of Report ----"]

    with open(report_path, "w", encoding="utf-8") as f:
        f.write("\n".join(report_content))

    print(f"OK: Report saved to {report_path}")

def main():
    task_file = "../runtime/task.current.json"
    report_dir = "../task_scratch"
    task = read_task_file(task_file)
    write_report(task, report_dir)

if __name__ == "__main__":
    main()