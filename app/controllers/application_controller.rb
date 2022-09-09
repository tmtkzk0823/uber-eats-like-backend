class ApplicationController < ActionController::API
  before_action :fake_load #本番環境ではしない処理 ローカルでローディングの状態を確認するために記述

  # ローカルでローディングの状態を確認するために記述
  def fake_load
    sleep(1)
  end
end
