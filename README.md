# report-ruby-ractor-segmentation-fault

The bootstraptest/test_ractor.rb fails with segmentation fault randomly on Ubuntu jammy arm32.

I faced this issue on Travis.
https://app.travis-ci.com/github/ruby/ruby/jobs/612416587#L2421

## Reproducer

I was able to reproduce the issue with the `test.sh` on RubyCI arm64-neoverse (arm64) server. You can see the `test.log` on this repository.
