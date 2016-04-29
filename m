From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v2] crypto: Add a flag allowing the self-tests to be disabled at runtime.
Date: Fri, 29 Apr 2016 12:03:03 +0100
Message-ID: <1461927784-19114-1-git-send-email-rjones@redhat.com>
Cc: corbet@lwn.net, herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbcD2LDI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 07:03:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

v1 -> v2:

 - Use printk_once.

Because the serial console is so slow, printing the message multiple
times consumed about 6ms extra later on in the boot.  Printing it only
once is both neater and avoids this extra overhead.

Rich.

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
