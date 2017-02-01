namespace :utils do

  desc "Setup Development"
  task setup_dev: :environment do

    puts "Executando o setup para o desenvolvimento..."
      puts "APAGANDO BANCO DE DADOS... #{%x(rake db:drop)}"
      puts "CRIANDO BANCO DE DADOS... #{%x(rake db:create)}"
      puts %x(rake db:migrate)
      puts %x(rake db:seed)
      puts %x(rake utils:generate_ads)
      puts %x(rake utils:generate_admins)
      puts %x(rake utils:generate_members)
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
      Member.create!(
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
      )
    end
    puts "Cadastrando os MEMBROS FAKES... (OK)"

  end

  # ---------------------------------------------------------

  desc "Criar Anúncios Fake"
  task generate_ads: :environment do

    puts "Cadastrando ANÚNCIOS FAKES..."
    100.times do
      Ad.create!(
        title: Faker::Lorem.sentence([2,3,4,5].sample),
        description: LeroleroGenerator.paragraph(Random.rand(3)),
        member: Member.all.sample,
        category: Category.all.sample,
        price: "#{Random.rand(500)},#{Random.rand(99)}",
        picture: File.new(Rails.root.join('public', 'templates', 'images-for-ads',"#{Random.rand(9)}.jpg"), 'r')
      )
    end
    puts "Cadastrando ANÚNCIOS FAKES... (OK)"

  end
end
