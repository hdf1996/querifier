describe Dummy::Queries::BookWithOrder do
  it_behaves_like 'a base query', Book.all
  it_behaves_like 'a order query'
end
