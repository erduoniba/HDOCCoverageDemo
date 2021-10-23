platform :ios,'10.0'
use_frameworks!
inhibit_all_warnings!

target 'HDCoverageDemo' do
     pod 'HDBaseProject', :git => 'https://github.com/erduoniba/HDBaseProject.git'
     pod 'HDCoverage'
    # pod 'XcodeCoverage'
end

# 实现post_install Hooks
post_install do |installer|
  # 1. 遍历项目中所有target
  installer.pods_project.targets.each do |target|
    # 2. 遍历build_configurations
    target.build_configurations.each do |config|
      # 3. 修改build_settings中的GCC_GENERATE_TEST_COVERAGE_FILES和GCC_INSTRUMENT_PROGRAM_FLOW_ARCS
      config.build_settings['GCC_GENERATE_TEST_COVERAGE_FILES'] = 'YES'
      config.build_settings['GCC_INSTRUMENT_PROGRAM_FLOW_ARCS'] = 'YES'
    end
  end
end
