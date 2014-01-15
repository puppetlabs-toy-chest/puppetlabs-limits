require 'spec_helper'

describe 'limits::fragment' do

  describe 'simple title defined value' do
    let(:title) { 'foo/hard/nproc' }
    let(:params) { {
        :value => '100'
      }}
    it 'should set foo hard nproc 100 in /etc/security/limits.conf' do
      title ='limits_conf/foo/hard/nproc'
      should contain_augeas(title).with('context' => '/files/etc/security/limits.conf')
      changes = catalogue(:define).resource('augeas', title).send(:parameters)[:changes]
      changes.should include "set domain[last()+1] foo",
                             "set domain[last()]/type hard",
                             "set domain[last()]/item nproc",
                             "set domain[last()]/value 100"
    end
  end

  describe 'simple non title defined values' do
    let(:title) { 'my_limits_config' }
    let(:params) { {
        :domain => 'foo',
        :type   => 'hard',
        :item   => 'nproc',
        :value  => '100'
      }}
    it 'should set foo hard nproc 100 in /etc/security/limits.conf' do
      title ='limits_conf/my_limits_config'
      should contain_augeas(title).with('context' => '/files/etc/security/limits.conf')
      changes = catalogue(:define).resource('augeas', title).send(:parameters)[:changes]
      changes.should include "set domain[last()+1] foo",
                             "set domain[last()]/type hard",
                             "set domain[last()]/item nproc",
                             "set domain[last()]/value 100"
    end
  end

  describe 'simple title defined value' do
    let(:title) { 'foo/hard/nproc' }
    let(:params) { {
        :value => '100',
        :file  => '/tmp/limits.conf'
      }}
    it 'should set foo hard nproc 100 in /tmp/limits.conf' do
      title ='limits_conf/foo/hard/nproc'
      should contain_augeas(title).with('context' => '/files/tmp/limits.conf',
                                        'incl'    => '/tmp/limits.conf')
    end
  end

  describe 'remove value' do
    let(:title) { 'my_limits_config' }
    let(:params) { {
        :domain => 'foo',
        :type   => 'hard',
        :item   => 'nproc'
      }}
    it 'should remove the value' do
      title ='limits_conf/my_limits_config'
      should contain_augeas(title).with('context' => '/files/etc/security/limits.conf')
      changes = catalogue(:define).resource('augeas', title).send(:parameters)[:changes]
      changes.should include 'rm domain[.="foo"][./type="hard" and ./item="nproc"]'
    end
  end

  describe 'invalid domain' do
    let(:title) { 'title' }
    let(:params) {{
        :domain => ' '
      }}
    it 'should fail with invalid domain' do
      expect {
        should compile
      }.to raise_error(Puppet::Error)
    end
  end
end
