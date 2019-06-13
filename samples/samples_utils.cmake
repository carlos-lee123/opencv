# Utility function: adds sample executable target with name "example_<group>_<file_name>"
# Usage:
#   ocv_define_sample(<output target> <relative filename> <group>)
function(ocv_define_sample out_target source sub)
  get_filename_component(name "${source}" NAME_WE)
  set(the_target "example_${sub}_${name}")
  add_executable(${the_target} "${source}")
  if(TARGET Threads::Threads AND NOT OPENCV_EXAMPLES_DISABLE_THREADS)
    target_link_libraries(${the_target} LINK_PRIVATE Threads::Threads)
  endif()
  set_target_properties(${the_target} PROPERTIES PROJECT_LABEL "(sample) ${name}")
  if(ENABLE_SOLUTION_FOLDERS)
    set_target_properties(${the_target} PROPERTIES FOLDER "samples/${sub}")
  endif()
  if(WIN32 AND MSVC AND NOT BUILD_SHARED_LIBS)
    set_target_properties(${the_target} PROPERTIES LINK_FLAGS "/NODEFAULTLIB:atlthunk.lib /NODEFAULTLIB:atlsd.lib /DEBUG")
  endif()
  if(WIN32)
    install(TARGETS ${the_target} RUNTIME DESTINATION "samples/${sub}" COMPONENT samples)
  endif()
  # Add single target to build all samples in the group: 'make opencv_samples_cpp'
  set(parent_target opencv_samples_${sub})
  if(NOT TARGET ${parent_target})
    add_custom_target(${parent_target})
    if(TARGET opencv_samples)
      add_dependencies(opencv_samples ${parent_target})
    endif()
  endif()
  add_dependencies(${parent_target} ${the_target})
  set(${out_target} ${the_target} PARENT_SCOPE)
endfunction()