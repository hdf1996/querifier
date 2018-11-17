describe Dummy::Queries::BookWithWhere do
  it_behaves_like 'a base query', Book.all
  it_behaves_like 'a where query'
end
