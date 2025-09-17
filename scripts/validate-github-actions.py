import yaml
import sys
import os

def validate_workflow(file_path):
    """Validate GitHub Actions workflow YAML file"""
    try:
        with open(file_path, 'r') as file:
            content = file.read()
            # Handle GitHub Actions specific syntax
            content = content.replace('[' main ']', '[main]')
            workflow = yaml.safe_load(content)
        
        print("✓ YAML syntax is valid")
        
        # Check required top-level keys
        required_keys = ['name', 'on', 'jobs']
        for key in required_keys:
            if key not in workflow:
                raise ValueError(f"Missing required key: {key}")
            print(f"✓ Contains required key: {key}")
        
        # Check jobs structure
        jobs = workflow['jobs']
        if not isinstance(jobs, dict):
            raise ValueError("jobs must be a dictionary")
        print(f"✓ Jobs section is valid ({len(jobs)} jobs found)")
        
        # Check each job
        for job_name, job_details in jobs.items():
            if 'runs-on' not in job_details:
                raise ValueError(f"Job '{job_name}' is missing 'runs-on' key")
            if 'steps' not in job_details:
                raise ValueError(f"Job '{job_name}' is missing 'steps' key")
            print(f"✓ Job '{job_name}' has required structure")
            
            # Check steps
            steps = job_details['steps']
            if not isinstance(steps, list):
                raise ValueError(f"Job '{job_name}' steps must be a list")
            
            for i, step in enumerate(steps):
                if not isinstance(step, dict):
                    raise ValueError(f"Job '{job_name}' step {i} must be a dictionary")
                
                # Each step should have a name or use
                if 'name' not in step and 'uses' not in step and 'run' not in step:
                    raise ValueError(f"Job '{job_name}' step {i} must have 'name', 'uses', or 'run'")
        
        print("✓ All jobs and steps are properly structured")
        
        # Check for our compression step
        web_job = jobs.get('build-web')
        if web_job:
            steps = web_job.get('steps', [])
            compression_found = any(
                'Compress assets' in step.get('name', '') or 
                'compress' in step.get('run', '').lower()
                for step in steps
            )
            if compression_found:
                print("✓ Asset compression step found in workflow")
            else:
                print("⚠ Asset compression step not found (this may be OK)")
        
        return True
        
    except yaml.YAMLError as e:
        print(f"✗ YAML syntax error: {e}")
        return False
    except Exception as e:
        print(f"✗ Validation error: {e}")
        return False

if __name__ == "__main__":
    workflow_path = ".github/workflows/deploy.yml"
    
    if not os.path.exists(workflow_path):
        print(f"✗ Workflow file not found: {workflow_path}")
        sys.exit(1)
    
    print(f"Validating GitHub Actions workflow: {workflow_path}")
    print("=" * 50)
    
    if validate_workflow(workflow_path):
        print("=" * 50)
        print("✅ GitHub Actions workflow validation PASSED")
        print("You can confidently push this workflow to GitHub")
    else:
        print("=" * 50)
        print("❌ GitHub Actions workflow validation FAILED")
        sys.exit(1)