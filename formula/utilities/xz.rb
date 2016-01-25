class Xz < Utility

  desc "General-purpose data compression with high compression ratio"
  homepage "http://tukaani.org/xz/"

  release version: '5.2.2', crystax_version: 1, sha256: { linux_x86_64:   'cfb9bb0b4988a5bdba3ff76aead8ab04db103aba893a0e18d22b6cf66a3878db',
                                                          linux_x86:      '6822c67c53ce2c2742c29ed171c5ba90bd274404a9e65644d44edf462b44b981',
                                                          darwin_x86_64:  'e2a9b93ec1adecbdd6e58ab0175141c66f15efa523f70988dfe834b258a33f39',
                                                          darwin_x86:     'cede694c6d37788e799c819e5418b0d53fe82f0dcf378cf0a990f1cf29654482',
                                                          windows_x86_64: 'c022d9de3c4e258612740f6da35f93b0b502b815f24e7909a632b4f0f9517fa5',
                                                          windows:        '73424dc48553b3f7c59d42ef137b898a2905f2be3c7594841d6ee9617144c802'
                                                         }
end
