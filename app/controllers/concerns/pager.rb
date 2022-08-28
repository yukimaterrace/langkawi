module Pager

  def set_pager_params
    @page = params.required(:page).to_i
    @page_size = params.required(:page_size).to_i
  end

  def pager_response(condition, &customizer)
    list = condition.limit(@page_size).offset(@page_size * @page)
    {
      list: list.map(&customizer),
      page_size: @page_size,
      count: list.count,
      total: condition.count
    }
  end
end
