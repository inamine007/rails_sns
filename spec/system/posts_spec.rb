require 'rails_helper'

describe '投稿機能', type: :system do
    describe '一覧表示機能' do
        let(:user_a) { FactoryBot.create(:user) }
        let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', mail: 'b@mail.com') }
        before do
            FactoryBot.create(:post, title: '最初のタスク', user: user_a)
            FactoryBot.create(:post, title: '次のタスク', user: user_b)
            visit login_path
            fill_in 'メールアドレス', with: login_user.mail
            fill_in 'パスワード', with: login_user.password
            click_button 'ログイン'
        end

        context 'ユーザーAがログインしている時' do
            let(:login_user) { user_a }
            it '全ての投稿の一覧が表示される' do
                visit posts_path
                expect(page).to have_content "最初のタスク"
                expect(page).to have_content "次のタスク"
            end
        end

        context '検索フォームに入力した時' do
            let(:login_user) { user_a }
            before do
                visit posts_path
                fill_in '名称', with: '最初'
                click_button '検索'
            end

            it '検索した投稿が表示される' do
                expect(page).to have_content "最初のタスク"
            end
        end
    end
            
    describe '投稿作成機能' do
        let(:user) { FactoryBot.create(:user) }
        before do
            visit login_path
            fill_in 'メールアドレス', with: login_user.mail
            fill_in 'パスワード', with: login_user.password
            click_button 'ログイン'
            visit new_post_path
            fill_in 'タイトル', with: post_title
            fill_in '内容', with: post_content
            attach_file "画像", "spec/files/test.png"
            click_button 'つぶやく'
        end

        context 'つぶやく画面で項目を入力した時' do
            let(:login_user) { user }
            let(:post_title) { '最初のタスク' }
            let(:post_content) { 'hogehogehoge' }
            it '正常に投稿される' do
                within '.alert-info' do
                    expect(page).to have_content "「最初のタスク」をつぶやきました。"
                end
            end
        end

        context 'つぶやく画面で入力漏れがあった場合' do
            let(:login_user) { user }
            let(:post_title) { '' }
            let(:post_content) { '' }
            it 'エラーとなる' do
                within '#error_explanation' do
                    expect(page).to have_content "タイトルを入力してください\n内容を入力してください"
                end
            end
        end
    end

    describe '投稿編集、削除機能' do
        let(:user_a) { FactoryBot.create(:user) }
        let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', mail: 'b@mail.com') }
        let(:post_a) { FactoryBot.create(:post, title: '最初のタスク', user: user_a) }
        before do
            visit login_path
            fill_in 'メールアドレス', with: user_a.mail
            fill_in 'パスワード', with: user_a.password
            click_button 'ログイン'
        end

        context '認可されたユーザーが編集、削除した時' do
            it '正常に更新される' do
                visit edit_post_path(post_a)
                fill_in 'タイトル', with: '更新タスク'
                fill_in '内容', with: '内容更新'
                click_button 'つぶやく'
                expect(page).to have_selector '.alert-info', text: "「更新タスク」を更新しました"
            end

            it '正常に削除される' do
                visit post_path(post_a)
                click_on '削除'
                expect {
                expect(page.driver.browser.switch_to.alert.text).to eq "「最初のタスク」を削除します。よろしいですか？"
                page.driver.browser.switch_to.alert.accept
                expect(page).to have_content '「最初のタスク」を削除しました'       
                }.to change{ Post.count }.by(-1)
            end
        end

        context '認可されていないユーザーが編集、削除しようとした時' do
            it 'エラーとなる' do
                post_b = FactoryBot.create(:post, title: '次のタスク', user: user_b)
                visit edit_post_path(post_b)
                expect(page).to have_content "If you are the application owner check the logs for more information"
            end
        end
    end

    describe 'いいね機能' do
        let(:user_a) { FactoryBot.create(:user) }
        let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', mail: 'b@mail.com') }
        let(:post_a) { FactoryBot.create(:post, title: '最初のタスク', user: user_a) }
        let(:post_b) { FactoryBot.create(:post, title: '次のタスク', user: user_b) }
        before do
            visit login_path
            fill_in 'メールアドレス', with: user_a.mail
            fill_in 'パスワード', with: user_a.password
            click_button 'ログイン'
        end

        context '自分の投稿ページの時' do
            it 'いいねボタンが表示されない' do
                visit post_path(post_a)
                expect(page).to have_no_content "いいね!"
            end
        end

        context '他のユーザーの投稿ページでいいねボタンを押した時' do
            it 'いいねされいいね解除ボタンに変わる' do
                visit post_path(post_b)
                click_on 'いいね!'
                expect(page).to have_button 'いいね解除'
            end
        end
        
        context '他のユーザーの投稿ページでいいね解除ボタンを押した時' do

            before do
                visit post_path(post_b)
                click_on 'いいね!'
            end

            it 'いいねが解除されいいねボタンに変わる' do
                click_on 'いいね解除'
                expect(page).to have_button 'いいね!'
            end
        end
    end

    describe 'コメント機能' do
        let(:user_a) { FactoryBot.create(:user) }
        let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', mail: 'b@mail.com') }
        let(:post_b) { FactoryBot.create(:post, title: '最初のタスク', user: user_b) }
        before do
            visit login_path
            fill_in 'メールアドレス', with: user_a.mail
            fill_in 'パスワード', with: user_a.password
            click_button 'ログイン'
        end

        context 'コメント欄に入力しコメントボタンを押した時' do
            it '画面下にコメントが表示される' do
                visit post_path(post_b)
                fill_in 'textarea1', with: 'hello!!'
                click_button 'コメント'
                within all('.list-group-item').last do
                    expect(page).to have_content 'hello!!'
                end
            end
        end

        context 'コメント欄に入力せずにコメントボタンを押した時' do
            it 'エラーとなる' do
                visit post_path(post_b)
                fill_in 'textarea1', with: ''
                click_button 'コメント'
                expect(page).to have_selector '.alert-danger', text: 'コメントできませんでした'
            end
        end
    end
end
