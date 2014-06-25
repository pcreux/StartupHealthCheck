class Search
  include Service

  attr_reader :params, :query, :tags, :types

  def initialize(params)
    @params = params
    @query = params[:query] || "*"
    @tags = params[:tags] || nil
    @types = params[:types] || nil
  end

  def call
    get_results
  end

  private

  def get_results
    organizations + users
  end

  def organizations
    Organization.search(query, conditions).results
  end

  def users
    User.search(query, conditions).results
  end

  def conditions
    if tags
      {where: {tag_names: tags}}
    elsif types
      {where: {type_ids: types}}
    else
      {}
    end
  end
end
