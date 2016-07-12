From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 22/30] crypto: scatterwalk - Add no-copy support to copychunks
Date: Tue, 12 Jul 2016 13:17:55 +0800
Message-ID: <E1bMq4x-0007To-2W@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59173 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbcGLFSM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:18:12 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4x-0004g2-9M
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:55 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function ablkcipher_done_slow is pretty much identical to
scatterwalk_copychunks except that it doesn't actually copy as
the processing hasn't been completed yet.

This patch allows scatterwalk_copychunks to be used in this case
by specifying out == 2.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 03ca4ae..e124ce2 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -87,9 +87,11 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 		if (len_this_page > nbytes)
 			len_this_page = nbytes;
 
-		vaddr = scatterwalk_map(walk);
-		memcpy_dir(buf, vaddr, len_this_page, out);
-		scatterwalk_unmap(vaddr);
+		if (out != 2) {
+			vaddr = scatterwalk_map(walk);
+			memcpy_dir(buf, vaddr, len_this_page, out);
+			scatterwalk_unmap(vaddr);
+		}
 
 		scatterwalk_advance(walk, len_this_page);
 
@@ -99,7 +101,7 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 		buf += len_this_page;
 		nbytes -= len_this_page;
 
-		scatterwalk_pagedone(walk, out, 1);
+		scatterwalk_pagedone(walk, out & 1, 1);
 	}
 }
 EXPORT_SYMBOL_GPL(scatterwalk_copychunks);
