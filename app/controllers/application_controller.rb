class ApplicationController < ActionController::API

    before_action :snake_case_params 
    before_action :require_logged_in, only: [:logout!]

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def login!(user)
        # debugger
        session[:session_token] = user.reset_session_token!
        @current_user = user
    end

    def logout!(user)
        current_user.reset_session_token! if logged_in?
        session[:session_token] = nil
        @current_user = nil
    end

    def require_logged_in
        unless current_user
            render json: { message: 'Unauthorized' }, status: :unauthorized
        end
    end

    def test
        if params.has_key?(:login)
            login!(User.first)
        elsif params.has_key?(:logout)
            logout!
        end

        if current_user
            render json: { user: current_user.slice('id', 'username', 'session_token') }
        else
            render json: ['No current user']
        end
    end



    private

    def snake_case_params
        params.deep_transform_keys!(&:underscore)
    end
end