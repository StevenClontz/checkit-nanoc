class CnameDataSource < Nanoc::DataSource
  identifier :cname

  def items
    [new_item(
        "checkit.clontz.org",
        {},
        Nanoc::Identifier.new("/CNAME"),
    )]
  end
end
