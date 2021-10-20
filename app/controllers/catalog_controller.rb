# frozen_string_literal: true
class CatalogController < ApplicationController

  include Blacklight::Catalog

  configure_blacklight do |config|
    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response
    #
    ## Should the raw solr document endpoint (e.g. /catalog/:id/raw) be enabled
    config.raw_endpoint.enabled = true

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      rows: 10
    }

    # solr field configuration for search results/index views
    config.index.title_field = 'title_tsim'

    config.add_results_document_tool(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)

    config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_field 'format'

    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'title_tsim', label: 'Title'
    config.add_index_field 'title_vern_ssim', label: 'Title'
    config.add_index_field 'author_tsim', label: 'Author'
    config.add_index_field 'author_vern_ssim', label: 'Author'
    config.add_index_field 'format', label: 'Format'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'title_tsim', label: 'Title'
    config.add_show_field 'title_vern_ssim', label: 'Title'
    config.add_show_field 'subtitle_tsim', label: 'Subtitle'
    config.add_show_field 'subtitle_vern_ssim', label: 'Subtitle'
    config.add_show_field 'author_tsim', label: 'Author'
    config.add_show_field 'author_vern_ssim', label: 'Author'
    config.add_show_field 'format', label: 'Format'
    config.add_show_field 'language_ssim', label: 'Language'
    config.add_show_field 'published_ssim', label: 'Published'
    config.add_show_field 'published_vern_ssim', label: 'Published'
    config.add_show_field 'lc_callnum_ssim', label: 'Call number'
    config.add_show_field 'isbn_ssim', label: 'ISBN'

    config.add_search_field 'all_fields', label: 'All Fields'

    # "sort results by" select (pulldown)
    config.add_sort_field 'relevance', sort: 'score desc, pub_date_si desc, title_si asc', label: 'relevance'
  end
end
