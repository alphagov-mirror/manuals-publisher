require "spec_helper"
require 'section_reslugger'
require "gds_api/test_helpers/content_store"
require "gds_api/test_helpers/rummager"

describe SectionReslugger do
  include GdsApi::TestHelpers::ContentStore
  include GdsApi::TestHelpers::Organisations
  include GdsApi::TestHelpers::PublishingApiV2
  include GdsApi::TestHelpers::Rummager

  subject {
    described_class.new(
      'manual-slug',
      'current-section-slug',
      'new-section-slug'
    )
  }

  before {
    manual_record = ManualRecord.create!(
      manual_id: 'manual-id',
      slug: 'manual-slug',
      organisation_slug: 'organisation-slug'
    )
    SectionEdition.create!(
      document_id: 'document-id',
      slug: 'manual-slug/current-section-slug',
      title: 'section-edition-title',
      summary: 'section-edition-summary',
      body: 'section-edition-body'
    )
    manual_record.editions.create!(
      document_ids: [
        'document-id'
      ]
    )

    content_store_has_item('/manual-slug/current-section-slug')
    content_store_does_not_have_item('/manual-slug/new-section-slug')

    organisations_api_has_organisation('organisation-slug')

    stub_any_publishing_api_patch_links
    stub_any_publishing_api_put_content
    stub_any_publishing_api_publish

    stub_any_rummager_post
    stub_any_rummager_delete
  }

  it "doesn't raise any exceptions" do
    subject.call
  end
end