function(cat_files IN_FILE OUT_FILE)
  file(READ ${IN_FILE} CONTENTS)
  file(APPEND ${OUT_FILE} "${CONTENTS}\n")
endfunction()

if(EXISTS ${DBSRC_FULL})
  file(REMOVE ${DBSRC_FULL})
endif()

cat_files(${DBSRC_HEAD} ${DBSRC_FULL})
foreach(F IN LISTS DBSRC_BODY)
  cat_files(${F} ${DBSRC_FULL})
endforeach()
cat_files(${DBSRC_FOOT} ${DBSRC_FULL})
