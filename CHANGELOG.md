# Changelog

All notable changes to this project will be documented in this file.

## [v3.0.1](https://github.com/voxpupuli/voxpupuli-release/tree/v3.0.1) (2023-10-05)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/v3.0.0...v3.0.1)

**Fixed bugs:**

- Add github\_changelog\_generator & faraday-retry as dependencies [\#60](https://github.com/voxpupuli/voxpupuli-release/pull/60) ([bastelfreak](https://github.com/bastelfreak))
- rake tasks: fix regexp escaping [\#59](https://github.com/voxpupuli/voxpupuli-release/pull/59) ([kenyon](https://github.com/kenyon))

**Merged pull requests:**

- voxpupuli-rubocop: Use 2.x [\#61](https://github.com/voxpupuli/voxpupuli-release/pull/61) ([bastelfreak](https://github.com/bastelfreak))
- CI: Run on PRs+merges to master [\#57](https://github.com/voxpupuli/voxpupuli-release/pull/57) ([bastelfreak](https://github.com/bastelfreak))
- Encourage a signed commit [\#56](https://github.com/voxpupuli/voxpupuli-release/pull/56) ([traylenator](https://github.com/traylenator))

## [v3.0.0](https://github.com/voxpupuli/voxpupuli-release/tree/v3.0.0) (2023-05-09)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/v2.0.0...v3.0.0)

**Breaking changes:**

- Drop Ruby 2.5/2.6 support; introduce voxpupuli-rubocop; cleanup CI [\#53](https://github.com/voxpupuli/voxpupuli-release/pull/53) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Avoid producing a backtrace for deprecated tasks [\#52](https://github.com/voxpupuli/voxpupuli-release/pull/52) ([smortex](https://github.com/smortex))

**Merged pull requests:**

- gemspec: Add version constraints for dependencies & build gem with strictness and verbosity [\#54](https://github.com/voxpupuli/voxpupuli-release/pull/54) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/voxpupuli-release/tree/v2.0.0) (2023-02-22)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/v1.3.0...v2.0.0)

**Breaking changes:**

- Drop Ruby 2.4 support [\#46](https://github.com/voxpupuli/voxpupuli-release/pull/46) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Rework release preparation tasks [\#44](https://github.com/voxpupuli/voxpupuli-release/pull/44) ([smortex](https://github.com/smortex))
- Add Ruby 3.1 to CI matrix [\#43](https://github.com/voxpupuli/voxpupuli-release/pull/43) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- README.md: Fix link to LICENSE file [\#42](https://github.com/voxpupuli/voxpupuli-release/pull/42) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- dependabot: check for github actions as well [\#49](https://github.com/voxpupuli/voxpupuli-release/pull/49) ([bastelfreak](https://github.com/bastelfreak))
- Add Ruby 3.2 to CI matrix [\#48](https://github.com/voxpupuli/voxpupuli-release/pull/48) ([bastelfreak](https://github.com/bastelfreak))
- Replace `Depreciated` with `Deprecated` [\#47](https://github.com/voxpupuli/voxpupuli-release/pull/47) ([alexjfisher](https://github.com/alexjfisher))
- Add Test badge [\#45](https://github.com/voxpupuli/voxpupuli-release/pull/45) ([bastelfreak](https://github.com/bastelfreak))

## [v1.3.0](https://github.com/voxpupuli/voxpupuli-release/tree/v1.3.0) (2021-12-08)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/v1.2.1...v1.3.0)

**Implemented enhancements:**

- Allow no 'v' in release version [\#41](https://github.com/voxpupuli/voxpupuli-release/pull/41) ([smortex](https://github.com/smortex))
- Validate REFERENCE.md if it exists [\#39](https://github.com/voxpupuli/voxpupuli-release/pull/39) ([bastelfreak](https://github.com/bastelfreak))

## [v1.2.1](https://github.com/voxpupuli/voxpupuli-release/tree/v1.2.1) (2021-10-29)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/v1.2.0...v1.2.1)

between the 1.2.0 and 1.2.1 release renamed the repository from voxpupuli-release-gem to voxpupuli-release. The previous name was inconsistent with the gem name and that blocked releases to github packages. The 1.2.1 release only happens to get a release to github packages. The code is identical to 1.2.0.

**Closed issues:**

- Rename the repository from voxpupuli-release-gem to voxpupuli-release [\#35](https://github.com/voxpupuli/voxpupuli-release/issues/35)

## [v1.2.0](https://github.com/voxpupuli/voxpupuli-release/tree/v1.2.0) (2021-10-28)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/v1.1.0...v1.2.0)

**Implemented enhancements:**

-  Cleanup references to Travis CI in rake tasks  [\#32](https://github.com/voxpupuli/voxpupuli-release/pull/32) ([genebean](https://github.com/genebean))

**Fixed bugs:**

- Fix syntax highlighting & add warning to travis\_release [\#33](https://github.com/voxpupuli/voxpupuli-release/pull/33) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Enable basic gem testing [\#31](https://github.com/voxpupuli/voxpupuli-release/pull/31) ([bastelfreak](https://github.com/bastelfreak))
- gemspec: switch to https URLs [\#30](https://github.com/voxpupuli/voxpupuli-release/pull/30) ([bastelfreak](https://github.com/bastelfreak))

## [v1.1.0](https://github.com/voxpupuli/voxpupuli-release/tree/v1.1.0) (2021-10-15)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/v1.0.2...v1.1.0)

**Implemented enhancements:**

- Add `github_release` alias for `travis_release` task [\#28](https://github.com/voxpupuli/voxpupuli-release/pull/28) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- fix wrong syntax in GitHub actions [\#27](https://github.com/voxpupuli/voxpupuli-release/pull/27) ([bastelfreak](https://github.com/bastelfreak))

## [v1.0.2](https://github.com/voxpupuli/voxpupuli-release/tree/v1.0.2) (2021-07-30)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/v1.0.1...v1.0.2)

**Fixed bugs:**

- directly load blacksmith rake tasks [\#25](https://github.com/voxpupuli/voxpupuli-release/pull/25) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Update release workflow + docs / Release 1.0.2 [\#26](https://github.com/voxpupuli/voxpupuli-release/pull/26) ([bastelfreak](https://github.com/bastelfreak))
- Convert from Travis to Github Actions [\#24](https://github.com/voxpupuli/voxpupuli-release/pull/24) ([ekohl](https://github.com/ekohl))

## [v1.0.1](https://github.com/voxpupuli/voxpupuli-release/tree/v1.0.1) (2019-09-02)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/v1.0.0...v1.0.1)

**Fixed bugs:**

- set a message pattern for new releases [\#22](https://github.com/voxpupuli/voxpupuli-release/pull/22) ([bastelfreak](https://github.com/bastelfreak))

## [v1.0.0](https://github.com/voxpupuli/voxpupuli-release/tree/v1.0.0) (2019-08-31)

[Full Changelog](https://github.com/voxpupuli/voxpupuli-release/compare/f45adfe1cdb31bcc289fa4b80ac392235a00ffc6...v1.0.0)

**Implemented enhancements:**

- sign tags with gpg [\#20](https://github.com/voxpupuli/voxpupuli-release/pull/20) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- expand travis\_release [\#2](https://github.com/voxpupuli/voxpupuli-release/issues/2)
- this gem should be renamed [\#1](https://github.com/voxpupuli/voxpupuli-release/issues/1)

**Merged pull requests:**

- Use has\_version\_tag? from puppet-blacksmith [\#16](https://github.com/voxpupuli/voxpupuli-release/pull/16) ([ekohl](https://github.com/ekohl))
- Proper pre-release version string [\#15](https://github.com/voxpupuli/voxpupuli-release/pull/15) ([rnelson0](https://github.com/rnelson0))
- Release candidate 0.4.0-rc0 [\#14](https://github.com/voxpupuli/voxpupuli-release/pull/14) ([rnelson0](https://github.com/rnelson0))
- Expand acceptable changelog release format [\#12](https://github.com/voxpupuli/voxpupuli-release/pull/12) ([rnelson0](https://github.com/rnelson0))
- dont expect whitespace before release number [\#10](https://github.com/voxpupuli/voxpupuli-release/pull/10) ([bastelfreak](https://github.com/bastelfreak))
- Describe how to cut a release [\#9](https://github.com/voxpupuli/voxpupuli-release/pull/9) ([rnelson0](https://github.com/rnelson0))
- fix\(changelog\) make changelog checking more flexible [\#8](https://github.com/voxpupuli/voxpupuli-release/pull/8) ([igalic](https://github.com/igalic))
- fix\(loading\) complete renaming by correctly moving files into subdirs [\#7](https://github.com/voxpupuli/voxpupuli-release/pull/7) ([igalic](https://github.com/igalic))
- feat\(release\) bump RC version rather than patch [\#6](https://github.com/voxpupuli/voxpupuli-release/pull/6) ([igalic](https://github.com/igalic))
- chore \(rename\) Give our gem a more sensible name [\#5](https://github.com/voxpupuli/voxpupuli-release/pull/5) ([igalic](https://github.com/igalic))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
