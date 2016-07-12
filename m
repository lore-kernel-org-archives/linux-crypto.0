From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 26/30] crypto: scatterwalk - Remove unnecessary BUG in scatterwalk_start
Date: Tue, 12 Jul 2016 13:17:59 +0800
Message-ID: <E1bMq51-0007Uu-FS@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51926 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbcGLFSD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:18:03 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq51-0004ho-K5
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:59 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Nothing bad will happen even if sg->length is zero, so there is
no point in keeping this BUG_ON in scatterwalk_start.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 2ec5368..ddffbb3 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -33,9 +33,6 @@ static inline void memcpy_dir(void *buf, void *sgdata, size_t nbytes, int out)
 void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg)
 {
 	walk->sg = sg;
-
-	BUG_ON(!sg->length);
-
 	walk->offset = sg->offset;
 }
 EXPORT_SYMBOL_GPL(scatterwalk_start);
