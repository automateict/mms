json.extract! work_experience, :id, :person_id, :company, :job_title, :from, :to, :description, :created_at, :updated_at
json.url work_experience_url(work_experience, format: :json)
