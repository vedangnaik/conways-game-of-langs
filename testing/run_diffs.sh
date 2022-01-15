#!/usr/bin/bash

passed=0
for image in ./reference_images/*.pbm; do
    if ! diff --strip-trailing-cr $image "./test_images/$(basename $image)"; then
        echo "===> $image does not match reference."
        passed=1
    fi
done
exit $passed