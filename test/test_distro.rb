require 'helper'

class TestDistro < Minitest::Test

  def setup
    @original_default_location = Gem2Rpm::Template.default_location
    Gem2Rpm::Template.default_location = File.join(File.dirname(__FILE__), 'templates', 'fake_files')

    @original_release_files = Gem2Rpm::Distro.release_files
  end

  def teardown
    Gem2Rpm::Template.default_location = @original_default_location
    Gem2Rpm::Distro.release_files = @original_release_files
  end

  def test_get_template_for_unavailable_version
    assert_nil Gem2Rpm::Distro.template_by_os_version(Gem2Rpm::Distro::FEDORA, 16)
    assert_nil Gem2Rpm::Distro.template_by_os_version(Gem2Rpm::Distro::FEDORA, 0)
  end

  def test_get_template_for_available_version
    assert Gem2Rpm::Distro.template_by_os_version(Gem2Rpm::Distro::FEDORA, 17)
    assert Gem2Rpm::Distro.template_by_os_version(Gem2Rpm::Distro::FEDORA, 177)
  end

  def test_nature_for_unavailable_template
    Gem2Rpm::Distro.release_files = [File.join(File.dirname(__FILE__), 'templates', 'fake_files', 'fedora-release15')]

    assert "fedora", Gem2Rpm::Distro.nature.to_s
  end

  def test_nature_for_available_template
    Gem2Rpm::Distro.release_files = [File.join(File.dirname(__FILE__), 'templates', 'fake_files', 'fedora-release17')]

    assert "fedora-17-rawhide", Gem2Rpm::Distro.nature.to_s
  end

  def test_nature_for_two_release_files
    Gem2Rpm::Distro.release_files = [
      File.join(File.dirname(__FILE__), 'templates', 'fake_files', 'fedora-release15'),
      File.join(File.dirname(__FILE__), 'templates', 'fake_files', 'fedora-release17')
    ]

    assert "fedora", Gem2Rpm::Distro.nature.to_s
  end

end
