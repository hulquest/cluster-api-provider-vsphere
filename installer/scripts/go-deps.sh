#!/bin/bash
# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Lists the non-standard library Go packages the specified package depends
# on.
#
# Usage: script/go-deps.sh pkg
#
#     pkg       This is github.com/vmware/vic/cmd/imagec for example
#

pkg=$1
flags=$2

if [ -d "$pkg" ]; then
    if [[ "$flags" == *d* ]]
    then
        # Only output if make is given the '-d' flag
        echo "Generating deps for $pkg" >&2
    fi

    go list -f '{{join .Deps "\n"}}' github.com/kubernetes-sigs/cluster-api-provider-vsphere/"$pkg" 2>/dev/null | \
        xargs go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}' 2>/dev/null | \
        sed -e 's:github.com/kubernetes-sigs/cluster-api-provider-vsphere/\(.*\)$:\1/*:'
else
    if [[ "$flags" == *d* ]]
    then
        echo "$0: package '$pkg' does not exist" >&2
    fi
fi
