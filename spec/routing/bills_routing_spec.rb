require "spec_helper"

describe BillsController do
  describe "routing" do

    it "routes to #index" do
      get("/bills").should route_to("bills#index")
    end

    it "routes to #new" do
      get("/bills/new").should route_to("bills#new")
    end

    it "routes to #show" do
      get("/bills/1").should route_to("bills#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bills/1/edit").should route_to("bills#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bills").should route_to("bills#create")
    end

    it "routes to #update" do
      put("/bills/1").should route_to("bills#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bills/1").should route_to("bills#destroy", :id => "1")
    end

  end
end
