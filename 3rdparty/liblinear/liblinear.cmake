# liblinear

include_directories(${CMAKE_CURRENT_LIST_DIR})

set(LIBLINEAR_SRC ${CMAKE_CURRENT_LIST_DIR}/blas/blas.h
                  ${CMAKE_CURRENT_LIST_DIR}/blas/blasp.h
                  ${CMAKE_CURRENT_LIST_DIR}/blas/daxpy.c
                  ${CMAKE_CURRENT_LIST_DIR}/blas/ddot.c
                  ${CMAKE_CURRENT_LIST_DIR}/blas/dnrm2.c
                  ${CMAKE_CURRENT_LIST_DIR}/blas/dscal.c
                  ${CMAKE_CURRENT_LIST_DIR}/linear.h
                  ${CMAKE_CURRENT_LIST_DIR}/tron.h
                  ${CMAKE_CURRENT_LIST_DIR}/linear.cpp
                  ${CMAKE_CURRENT_LIST_DIR}/tron.cpp)

add_library(liblinear STATIC ${LIBLINEAR_SRC})
