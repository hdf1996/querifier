describe Dummy::Queries::BookWithOrder do
  it_behaves_like 'a base query', Book
  it_behaves_like 'a order query'
end
