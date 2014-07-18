class SearchCandidates
  attr_accessor :current_user,
                :params,
                :candidates

  def initialize(user, params={})
    self.params = params
    self.current_user = user
  end

  def perform
    if current_user.has_permission?('view_candidates')
      with_permission
    else
      without_permission
    end
  end

  private

  ORDERING = {
    "Candidates Newest -> Oldest" => {created_at: :desc},
    "Candidates Oldest -> Newest" => {created_at: :asc},
    "Candidates A -> Z"           => {created_at: :asc, lname: :asc},
    "Candidates Z -> A"           => {created_at: :asc, lname: :desc}
  }

  def s_key
    @s_key ||= params[:sort].blank? ? "All Candidates" : params[:sort]
  end

  def with_permission
    @candidates = current_user.
      organization.
      candidates.
      where(:is_deleted => false, :is_completed => true).
      order(ordering)
  end

  def ordering
    ORDERING[s_key] || {}
  end

  def without_permission
    @candidates = Candidate.
      joins(:candidate_job, :job_contact).
      where(:job_contact: {user_id: current_user.id}).
      where(candidate_jobs: {job_id: job.id}).
      where(is_deleted:      false,
            is_completed:    true,
            organization_id: current_user.organization_id).
      order(ordering)
  end
end
