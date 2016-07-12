From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 25/30] crypto: scatterwalk - Remove unnecessary advance in scatterwalk_pagedone
Date: Tue, 12 Jul 2016 13:17:58 +0800
Message-ID: <E1bMq50-0007Ud-Bt@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60768 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbcGLFSC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:18:02 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq50-0004hO-Gv
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:58 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The offset advance in scatterwalk_pagedone not only is unnecessary,
but it was also buggy when it was needed by scatterwalk_copychunks.
As the latter has long ago been fixed to call scatterwalk_advance
directly, we can remove this unnecessary offset adjustment.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 52aae29..2ec5368 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -62,12 +62,8 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 			flush_dcache_page(page);
 	}
 
-	if (more) {
-		walk->offset += PAGE_SIZE - 1;
-		walk->offset &= PAGE_MASK;
-		if (walk->offset >= walk->sg->offset + walk->sg->length)
-			scatterwalk_start(walk, sg_next(walk->sg));
-	}
+	if (more && walk->offset >= walk->sg->offset + walk->sg->length)
+		scatterwalk_start(walk, sg_next(walk->sg));
 }
 
 void scatterwalk_done(struct scatter_walk *walk, int out, int more)
