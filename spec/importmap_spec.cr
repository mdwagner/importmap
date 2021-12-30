require "./spec_helper"

Spectator.describe ImportMap do
  subject do
    ImportMap.draw do |t|
      t.pin "react", to: "https://ga.jspm.io/npm:react@18.0.0-rc.0-next-f2a59df48-20211208/index.js"

      t.scope "https://ga.jspm.io/", {
        "object-assign" => "https://ga.jspm.io/npm:object-assign@4.1.1/index.js"
      }
    end
  end

  it "works" do
    expect(subject.to_importmap_json).to eq({
      "imports" => {
        "react" => "https://ga.jspm.io/npm:react@18.0.0-rc.0-next-f2a59df48-20211208/index.js"
      },
      "scopes" => {
        "https://ga.jspm.io/" => {
          "object-assign" => "https://ga.jspm.io/npm:object-assign@4.1.1/index.js"
        }
      }
    }.to_json)
  end
end
