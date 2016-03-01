module Misc

  def escape_html_for_set(things)
    new_things = {}
    things.each do |k,v|
      new_things[k] = escape_html(v).strip
    end
    return new_things
  end

  def all_users
    User.all
  end
end
