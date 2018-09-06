module SuspiciousLogin
  module Schema
    # # For a new resource migration:
    # create_table :the_resource do |t|
    #   t.login_token
    # end

    # # For existing resource, define a migration and add the following:
    # change_table :the_resource do |t|
    #   t.string login_token
    #   t.datetime :login_token_sent_at
    # end

    def login_token
      apply_devise_schema :login_token, String
      apply_devise_schema :login_token_sent_at, DateTime
    end
  end
end