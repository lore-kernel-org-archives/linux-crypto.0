From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 24/30] crypto: scatterwalk - Fix test in scatterwalk_done
Date: Tue, 12 Jul 2016 13:17:57 +0800
Message-ID: <E1bMq4z-0007UM-8Q@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60421 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbcGLFR7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:59 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4z-0004h2-DP
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:57 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When there is more data to be processed, the current test in
scatterwalk_done may prevent us from calling pagedone even when
we should.

In particular, if we're on an SG entry spanning multiple pages
where the last page is not a full page, we will incorrectly skip
calling pagedone on the second last page.

This patch fixes this by adding a separate test for whether we've
reached the end of a page.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index e124ce2..52aae29 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -72,7 +72,8 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 
 void scatterwalk_done(struct scatter_walk *walk, int out, int more)
 {
-	if (!(scatterwalk_pagelen(walk) & (PAGE_SIZE - 1)) || !more)
+	if (!more || walk->offset >= walk->sg->offset + walk->sg->length ||
+	    !(walk->offset & (PAGE_SIZE - 1)))
 		scatterwalk_pagedone(walk, out, more);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_done);
