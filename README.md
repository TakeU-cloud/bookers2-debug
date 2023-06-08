# adminユーザー機能の実装過程
rails generate devise Admin  
生成されたadminのmigrateファイルを編集し、rails db:migrate  
生成されたModelファイルadmin.rbを編集  
rails generate controller admins  
application_controller.rbにadminのリダイレクトコードを記述  
.envファイルに最初の登録adminのemail addressを指定  
routes.rbにadminのルーティングを登録  

rails consoleを実行したところ、エラーが出たので、
chmod +x bin/spring  
bin/spring stop
を実行した後、
rails consoleで実行できた。
adminユーザーを登録  

rails generate devise:controllers admins