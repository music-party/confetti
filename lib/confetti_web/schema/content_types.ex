defmodule ConfettiWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  object :content_queries do
    @desc "Get a party using criteria"
    field :party, :party do

    end
  end

  @desc "A collaborative listening group"
  object :party do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :privacy, non_null(:privacy)
    field :host, :user
    field :queue, non_null(list_of(non_null(:track)))
    field :tags, non_null(list_of(non_null(:tag)))
  end

  enum :privacy do
    value :public
    value :private
  end

  object :track do
    field :id, non_null(:id), description: "The Spotify ID"
    field :index, non_null(:integer), description: "The track's position in the queue"
  end

  @desc "A metadata tag"
  object :tag do
    field :name, non_null(:string)
    field :weight, non_null(:float)
  end
end
