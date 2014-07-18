class SomeController < ApplicationController
  def show_candidates
    @open_jobs = Job.all_open_new(current_user.organization)
    search = SearchCandidates.new(current_user, params)
    render :partial => "candidates_list",
           :locals => {
             :@candidates => search.candidates,
             :open_jobs   => @open_jobs },
            :layout => false
  end
end
