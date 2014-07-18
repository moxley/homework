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

  def s_key
    @s_key ||= params[:sort].blank? ? "All Candidates" : params[:sort]
  end

  def with_permission
    @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true)

    if s_key == "Candidates Newest -> Oldest"
      @candidates = @candidates.order(created_at: :desc)
    elsif s_key == "Candidates Oldest -> Newest"
      @candidates = @candidates.order(created_at: :asc)
    elsif s_key == "Candidates A -> Z"
      @candidates = @candidates.order(created_at: :asc, lname: :asc)
    elsif s_key == "Candidates Z -> A"
      @candidates = @candidates.order(created_at: :asc, lname: :desc)
    end
  end

  def without_permission
    @candidates = Candidate.
      joins(:candidate_job, :job_contact).
      where(:job_contact: {user_id: current_user.id}).
      where(candidate_jobs: {job_id: job.id}).
      where(is_deleted:      false,
            is_completed:    true,
            organization_id: current_user.organization_id)

    if s_key == "Candidates Newest -> Oldest"
      @candidates = @candidates.sort_by { |c| c.created_at }
    elsif s_key == "Candidates Oldest -> Newest"
      @candidates = @candidates.sort_by { |c| c.created_at }.reverse
    elsif s_key == "Candidates A -> Z"
      @candidates = @candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }
    elsif s_key == "Candidates Z -> A"
      @candidates = @candidates.sort_by { |c| c.created_at }.sort! { |a, b| a.last_name <=> b.last_name }.reverse
    end
  end
end
