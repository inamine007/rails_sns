require 'rails_helper'

describe 'ユーザー管理機能', type: :system do
    describe '新規登録機能' do
        before do
            visit new_user_path
            fill_in 'お名前', with: user_name
            fill_in 'メールアドレス', with: user_mail
            fill_in 'パスワード', with: user_password
            fill_in 'パスワード（確認）', with: user_password_confirmation
            click_button '登録する'
        end

        context '新規登録画面で全ての項目を入力した時' do
            let(:user_name) { 'テストユーザー１' }
            let(:user_mail) { 'a@example.com' }
            let(:user_password) { 'password' }
            let(:user_password_confirmation) { 'password' }

            it '正常に登録される' do
                expect(page).to have_selector '.alert-info', text: 'テストユーザー１'
            end
        end

        context '新規登録画面で入力漏れがあった時' do
            let(:user_name) { '' }
            let(:user_mail) { '' }
            let(:user_password) { '' }
            let(:user_password_confirmation) { '' }

            it 'エラーとなる' do
                within '#error_explanation' do
                    expect(page).to have_content "パスワードを入力してください\nお名前を入力してください\nメールアドレスを入力してください"
                end
            end
        end
    end

    describe 'ログイン機能' do
        let(:user) { FactoryBot.create(:user) }
        before do
            visit login_path
            fill_in 'メールアドレス', with: user_mail
            fill_in 'パスワード', with: user_password
            click_button 'ログイン'
        end

        context 'ログイン画面で全ての項目を入力した時' do
            let(:user_mail) { user.mail }
            let(:user_password) { user.password }
    
            it '正常にログインされる' do
                within '.alert-info' do
                    expect(page).to have_content "ログインしました。"
                end
            end
        end
        
        context 'ログイン画面で入力漏れがあった時' do
            let(:user_mail) { '' }
            let(:user_password) { '' }

            it 'エラーとなる' do
                within '.alert-danger' do
                    expect(page).to have_content "メールアドレスまたはパスワードが無効です。"
                end
            end
        end
    end

    describe 'ログアウト機能' do
        context 'ログアウトボタンを押した時' do
            before do
                user = FactoryBot.create :user
                visit login_path
                fill_in 'メールアドレス', with: user.mail
                fill_in 'パスワード', with: user.password
                click_button 'ログイン'
                click_on 'ログアウト'
            end
            it 'ログアウトしてトップページにとぶ' do
                expect(page).to have_selector '.alert-info', text: "ログアウトしました"
                expect(page).to have_content "ログイン"
            end
        end
    end

    describe 'ユーザー編集、削除機能' do
        let(:user) { FactoryBot.create(:user) }
        let!(:other_user) { FactoryBot.create(:user, name: 'テストユーザー２', mail: 'demo@mail.com') }
        before do
            visit login_path
            fill_in 'メールアドレス', with: user.mail
            fill_in 'パスワード', with: user.password
            click_button 'ログイン'
        end

        context '認可されたユーザーが編集、削除した時' do
            it '正常に更新される' do
                visit edit_user_path(user)
                fill_in 'お名前', with: 'テストユーザーex'
                fill_in 'メールアドレス', with: 'testex@mail.com'
                attach_file "画像", "spec/files/testex.png"
                fill_in '誕生日', with: '4/16'
                fill_in 'パスワード', with: ''
                fill_in 'パスワード（確認）', with: ''
                click_button '更新する'
                expect(page).to have_selector '.alert-info', text: 'テストユーザーex'
            end
            it '正常に削除される' do
                visit mypage_user_path(user)
                click_on '削除'
                expect {
                expect(page.driver.browser.switch_to.alert.text).to eq "ユーザー「テストユーザー」を削除します。よろしいですか？"
                page.driver.browser.switch_to.alert.accept
                expect(page).to have_content 'ユーザー「テストユーザー」を削除しました'       
                }.to change{ User.count }.by(-1)
            end
        end

        context '認可されていないユーザーが編集、削除しようとした時' do
            it 'トップページにリダイレクトされる' do
                visit edit_user_path(other_user)
                expect(page).to have_selector '.alert-danger', text: "権限がありません"
            end
        end
    end
end
