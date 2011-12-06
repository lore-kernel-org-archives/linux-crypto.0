From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH 0/3] crypto: Add per-cpu transform helpers
Date: Tue,  6 Dec 2011 16:45:57 -0600
Message-ID: <1323211560-18181-1-git-send-email-sjenning@linux.vnet.ibm.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
	Brian King <brking@linux.vnet.ibm.com>,
	Robert Jennings <rcj@linux.vnet.ibm.com>
To: "David S . Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:43797 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1LFWsN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Dec 2011 17:48:13 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <sjenning@linux.vnet.ibm.com>;
	Tue, 6 Dec 2011 15:48:11 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset includes two new functions for the cryptographic library,
crypto_alloc_percpu_tfms() and crypto_free_percpu_tfms(), which assist users
in allocating and freeing per-cpu transforms.

It also includes typing wrappers for the compression algorithm class.

The reason for this patch is that during my work to enable page compression
via the cryptographic API in the zcache staging driver, and realized that I
had rewritten some per-cpu transform code that already exists in the
xfrm_ipcomp code.

In an effort to avoid duplication, this patchset moves the per-cpu code into
helper functions in the cryptographic library and makes the necessary
modifications to the xfrm_ipcomp code.

After this change is (hopefully) merged, I will submit the zcache driver
changes, which will be the second user of these helpers.

Seth Jennings (3):
  crypto: Add per-cpu transform alloc() and free()
  crypto: Add inline per-cpu wrappers for compression
  xfrm: Modify xfrm_ipcomp code to use new per-cpu helpers

 crypto/api.c           |   62 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/crypto.h |   28 +++++++++++++++++++++
 net/xfrm/xfrm_ipcomp.c |   34 ++++++--------------------
 3 files changed, 98 insertions(+), 26 deletions(-)

-- 
1.7.5.4
