namespace :dev do

  desc "Setup Development"
  task setup: :environment do

    puts "Executando o setup para o desenvolvimento..."
      images_path = Rails.root.join('public','system')
      puts "APAGANDO DIRETÓRIO PUBLIC/SYSTEM... #{%x(rm -rf #{images_path})}"
      puts "APAGANDO BANCO DE DADOS... #{%x(rake db:drop)}"
      puts "CRIANDO BANCO DE DADOS... #{%x(rake db:create)}"
      puts %x(rake db:migrate)
      puts %x(rake db:seed)
      puts %x(rake dev:generate_admins)
      puts %x(rake dev:generate_members)
      puts %x(rake dev:generate_ads)
      puts %x(rake dev:generate_comments)
    puts "Executando o setup para o desenvolvimento... (OK)"

  end

  # ---------------------------------------------------------

  desc "Cria adminstradores Fake"
  task generate_admins: :environment do

    puts "Cadastrando os ADMINISTRADORES FAKES..."
    10.times do
      Admin.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
        role: [0,1, 1, 1].sample
      )
    end
    puts "Cadastrando os ADMINISTRADORES FAKES... (OK)"

  end

  # ---------------------------------------------------------

  desc "Cria membros Fake"
  task generate_members: :environment do

    puts "Cadastrando os MEMBROS FAKES..."
    100.times do
      member = Member.new(
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
      )
      member.build_profile_member
      member.profile_member.first_name = Faker::Name.first_name
      member.profile_member.second_name = Faker::Name.last_name
      member.save!
    end
    puts "Cadastrando os MEMBROS FAKES... (OK)"

  end

  # ---------------------------------------------------------

  desc "Criar Anúncios Fake"
  task generate_ads: :environment do

    puts "Cadastrando ANÚNCIOS FAKES..."
    5.times do
      Ad.create!(
        title: Faker::Lorem.sentence([2,3,4,5].sample),
        description_md: markdown_fake,
        description_short: LeroleroGenerator.sentence,
        member: Member.first,
        category: Category.all.sample,
        price: "#{Random.rand(500)},#{Random.rand(99)}",
        picture: File.new(Rails.root.join('public', 'templates', 'images-for-ads',"#{Random.rand(9)}.jpg"), 'r'),
        finish_date: Date.today + Random.rand(90)
      )
    end

    100.times do
      Ad.create!(
        title: Faker::Lorem.sentence([2,3,4,5].sample),
        description_md: markdown_fake,
        description_short: LeroleroGenerator.sentence,
        member: Member.all.sample,
        category: Category.all.sample,
        price: "#{Random.rand(500)},#{Random.rand(99)}",
        picture: File.new(Rails.root.join('public', 'templates', 'images-for-ads',"#{Random.rand(9)}.jpg"), 'r'),
        finish_date: Date.today + Random.rand(90)
      )
    end
    puts "Cadastrando ANÚNCIOS FAKES... (OK)"

  end

# ---------------------------------------------------------

    desc "Cria Comentários Fake"
    task generate_comments: :environment do

      puts "Cadastrando os COMENTÁRIOS FAKES..."
      Ad.all.each do |ad|
        (Random.rand(9)).times do
          Comment.create!(
            body: Faker::Lorem.paragraph([1,2,3].sample),
            member: Member.all.sample,
            ad: ad
          )
        end
      end
      puts "Cadastrando os COMENTÁRIOS FAKES... (OK)"

    end

  def markdown_fake
    %x(ruby -e "require 'doctor_ipsum'; puts DoctorIpsum::Markdown.entry")
  end
end
