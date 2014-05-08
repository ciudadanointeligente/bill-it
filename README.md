bill-it
=======

Bill management system for the Poplus project.

##Install

Make sure you have ruby 2.0 and bundler installed. If not visit
https://rvm.io/rvm/install  and http://bundler.io/

Make sure you have mongodb installed
if not follow instructions at http://docs.mongodb.org/manual/tutorial/

Java is needed for Solr. OpenJDK 7 is the recommended package. In Debian / Ubuntu run
```
apt-get install openjdk-7-jdk
```


clone the billit project
```
git clone git@github.com:ciudadanointeligente/bill-it.git
```

go to the bill-it project folder install gems
```
bundle install
```

create all config files, and modify according to server
```
cp config.ru.example config.ru
cp config/sunspot.yml.example config/sunspot.yml
cp config/mongoid.yml.example config/mongoid.yml
cp config/hateoas.yml.example config/hateoas.yml
```

start solr for search indexing
```
bundle exec rake sunspot:solr:start
```

make sure solr is running. Type the following url in your browser:
```
http://localhost:8983
```

run the service:
```
bundle exec rails s
```

If you are running a development environment and you want to monitor file changes and respond immediately, then run this instead:
```
bundle exec guard
```
visit http://localhost:3000 to see billit running

### Deploying to production

#### Tasks using cron

To run tasks like send notifications emails of changes in bills the project use [whenever](https://github.com/javan/whenever), this tool generate cron jobs from the `config/schedule.rb` file.

Add the jobs to crontab:

    bundle exec whenever --update-crontab bill-it

Clear the jobs associated with a app name:

    bundle exec whenever --clear-crontab bill-it

##Usage
###GET bill
* /bills/id.json => bill by id in json format
* /bills/id.json?callback=my_function => bill by id in jsonp format, with my_function as wrapper funcition
* /bills/id.xml => bill by id in xml format
* /bills/new => create a new bill by filling in a form
* /bills/id/edit => edit bill

###GET search
* /bills/search.json?q=term => search for "term" in all fields
* /bills/search.json?q=term&callback=my_function => search for "term" in jsonp format, with my_function as wrapper funcition
* /bills/search.json?title=hello|hola&tags=world => search for bills with title similar to "hello" or "hola" and with the tag "world"

###POST
* /bills => creates new bill

###PUT
* /bills/id => modifies bill

###DELETE
* /bills/id => deletes bill

##ROAR usage (the nice way)
For info of how ROAR works go to https://github.com/apotonick/roar
Essentially, you can work on your application as if you had local objects, when they're really in another server

require gems "billit_representers" and "roar" in your local project, or add them to your gemfile
```
gem 'billit_representers'
gem 'roar'
```

###Bills
extend your local model. Example model:
```
require 'roar/representer/feature/client'
require 'billit_representers/representers/bill_representer'

class Bill
  include Roar::Representer::Feature::HttpVerbs

  def initialize(*)
    extend Billit::BillRepresenter
    extend Roar::Representer::Feature::Client
    # transport_engine = Roar::Representer::Transport::Faraday
    @persisted = true if @persisted.nil?
  end
end
```

GET bill
```
bill = Bill.new
bill.get('http://billit.ciudadanointeligente.org/bills/1-07', 'application/json')
```

POST (create new bill)
```
bill = Bill.new
bill.uid = '0-00'
bill.title = 'new title'
bill.post('http://billit.ciudadanointeligente.org/bills')
```

PUT (modify existing bill)
```
bill = Bill.new
bill.get('http://billit.ciudadanointeligente.org/bills/0-00', 'application/json')
bill.tags.push('tag')
bill.put('http://billit.ciudadanointeligente.org/bills/0-00', 'application/json')
```

###Bill Collections
extend your local page model. Example model:
```
require 'billit_representers/representers/bill_collection_page_representer'

class BillCollectionPage < OpenStruct
  include Roar::Representer::Feature::HttpVerbs

  def initialize
    extend Billit::BillCollectionPageRepresenter
    extend Roar::Representer::Feature::Client
    transport_engine = Roar::Representer::Transport::Faraday
  end

  def self
    links[:self].href if links[:self]
  end

  def next
    links[:next].href if links[:next]
  end

  def previous
    links[:previous].href if links[:previous]
  end
end
```

GET search
```
bill_page = BillCollectionPage.new
bill_page.get('http://billit.ciudadanointeligente.org/bills/search?q=term', 'application/json')
#bill array
bill_array = bill_page.bills
#next page
bill_next_page = BillCollectionPage.new
bill_next_page.get(bill_page.next, 'application/json')
```

### Reindexing
If you add information, like bills, through the post or put method, it gets automatically reindexed. If you add them manually or through the database the indexing has to be done manually. This can be done by executing the rails console
```
bundle exec rails console
```
and then executing the reindex method on your model name, for instance:
```
Sunspot.index! Bills.all 
```

In this method you can actually write any query instead of Bills.all and it will only reindex that query.

There are other commands that perform a reindexing, but they can be resource intensive and not so granular:
```
bundle exec rake sunspot:solr:reindex
```

And

```
Bill.reindex
```

### How to deploy as an permanent service

If you want to configure BillIt as a service, once way of doing it is with nginx and passenger

```
gem install passenger 
```

Follow the instructions here:
http://www.modrails.com/documentation/Users%20guide%20Nginx.html#install_on_debian_ubuntu

Step 2.3 is the only thing needed. Or 2.4 for Fedora.

WARNING: If you have the project installed in it's own user folder (eg: /home/billit) and you have bundles installed in vendor/bundle, then setting a global `passenger_ruby` interpreter in the nginx.conf file will prevent the interpreter from finding the correct bundle. So please comment out the `passenger_ruby` in nginx.conf

Then you need to add the application to nginx, here you have a sample configuration file:
https://gist.github.com/rezzo/9bda60d84eacafc1e39d

