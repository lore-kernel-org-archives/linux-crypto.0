From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH] crypto: Add a flag allowing the self-tests to be disabled at runtime.
Date: Fri, 29 Apr 2016 11:07:42 +0100
Message-ID: <1461924463-1678-1-git-send-email-rjones@redhat.com>
Cc: corbet@lwn.net, herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I'm trying to reduce the time taken in the kernel in initcalls, with
my aim being to reduce the current ~700ms spent in initcalls before
userspace, down to something like 100ms.  All times on my Broadwell-U
laptop, under virtualization.  The purpose of this is to be able to
launch VMs around containers with minimal overhead, like Intel Clear
Containers, but using standard distro kernels and qemu.

Currently the kernel spends 28ms (on my laptop) running crypto
algorithm self-tests.  Although it's possibe to disable these at
compile time, Fedora kernel maintainers want to maintain a single
kernel image for all uses.

So this commit adds a runtime flag which callers can set to skip the
self-tests in the fast container/virtualization case.

Rich.

