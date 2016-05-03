From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v3] crypto: Add a flag allowing the self-tests to be disabled at runtime.
Date: Tue,  3 May 2016 10:00:16 +0100
Message-ID: <1462266017-28022-1-git-send-email-rjones@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	corbet@lwn.net, herbert@gondor.apana.org.au, davem@davemloft.net,
	sm@eperm.de
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbcECJAX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 05:00:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

v2 -> v3:

 - Ignore the flag if FIPS mode is enabled.

v1 -> v2:

 - Use printk_once.  Because the serial console is so slow, printing
   the message multiple times actually consumed about 6ms extra later
   on during the boot.

- - -

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
