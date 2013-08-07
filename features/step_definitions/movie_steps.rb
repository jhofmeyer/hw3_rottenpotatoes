# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.

    # One may output content to the console for debugging as follows:
    #   puts movie.to_s
    #   puts movie[:title] 
    Movie.create(movie)
  end
  #  flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(%r{,\s*}).each do |rating|
    page_element = page.find_by_id("ratings_#{rating}")
    if uncheck == nil
      if !page_element.checked?
        page.check("ratings_#{rating}")
      end
    else
      if page_element.checked?
        page.uncheck("ratings_#{rating}")
      end
    end
  end
end

And /^I click on the "(.*?)" submit button$/ do |button|
  page_element = page.find_by_id("#{button}_submit")
  page_element.click
end

Then /^on the (.*) page I should (not )?see movies with ratings: (.*)/ do |page_name, exclude, rating_list|
  visit path_to(page_name)
  rating_list.split(%r{,\s*}).each do |rating|
    page_element = page.find_by_id("ratings_#{rating}")
    if exclude == nil
      if !page_element.checked?
        flunk "Invalid check state for rating"
      end
    else
      if page_element.checked?
        flunk "Invalid check state for excluded rating"
      end
    end
  end
end

Then /^I should see all of the movies/ do
  # Select all the movies.
  movies     = Movie.all
  # Select all of the TR tags associated with the list of movies.
  movie_rows = page.all(:xpath, '//tbody/tr')
  if movies.length() != movie_rows.length()
    flunk "Not all movies are on the page"
  end
end
