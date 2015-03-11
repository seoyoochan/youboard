admin = User.new(name: "서유찬", first_name: "유찬", last_name: "서", username: "supergnee", email: "supergnee@gmail.com", password: "123123", locale: "ko")
admin.skip_confirmation!
admin.add_role :admin
admin.save!(:validate => false)
board1 = Board.create!(name: "루비온 레일스", topic: 29, user_id: admin.id, updated_at: Time.now, created_at: Time.now, description: "루비온레일스를 처음부터 끝까지 배워보자.", publication: 0)
Post.create!(title: "제 1 강 - 설치하기", board_id: board1.id, user_id: admin.id, body: "루비온 레일스를 다양한 플랫폼에 설치해봅니다.", allow_comment: true, publication: 0, updated_at: Time.now, created_at: Time.now)


user1 = User.new(name: "홍길동", first_name: "길동", last_name: "홍", username: "gildong", email: "gildong@gmail.com", password: "123123", locale: "ko")
user1.skip_confirmation!
user1.add_role :basic
user1.save!(:validate => false)


user2 = User.new(name: "Hames", first_name: "Rodriges", last_name: "Hames", username: "hames", email: "hames@gmail.com", password: "123123", locale: "en")
user2.skip_confirmation!
user2.add_role :basic
user2.save!(:validate => false)