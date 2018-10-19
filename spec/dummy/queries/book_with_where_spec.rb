describe Dummy::Queries::BookWithWhere do
  it_behaves_like 'a base query', Book
  it_behaves_like 'a where query'
end
