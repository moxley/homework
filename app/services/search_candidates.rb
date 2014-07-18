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
    if s_key == "All Candidates"
      @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true)
    elsif s_key == "Candidates Newest -> Oldest"
      @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.desc])
    elsif s_key == "Candidates Oldest -> Newest"
      @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.asc])
    elsif s_key == "Candidates A -> Z"
      @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.asc]).sort! { |a, b| a.last_name <=> b.last_name }
    elsif s_key == "Candidates Z -> A"
      @candidates = current_user.organization.candidates.all(:is_deleted => false, :is_completed => true, :order => [:created_at.asc]).sort! { |a, b| a.last_name <=> b.last_name }.reverse
    end
  end

  def without_permission
    @job_contacts = JobContact.all(:user_id => current_user.id)
    jobs          = []
    @candidates   = []
    return if @job_contacts.present?

    @job_contacts.each do |jobs_contacts|
      @job = Job.first(:id => jobs_contacts.job_id, :is_deleted => false)
      jobs << @job
    end
    jobs.each do |job|
      next if job.blank?

      candidates = Candidate.
        joins(:candidate_job).
        where(candidate_jobs: {job_id: job.id}).
        where(is_deleted:      false,
              is_completed:    true,
              organization_id: current_user.organization_id).
        where("email_address NOT IN (?)", @candidates.map(&:email_address))

      @candidates += candidates
    end

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
