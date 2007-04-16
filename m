From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/6] [CRYPTO] api: Add ablkcipher_request_set_tfm
Date: Mon, 16 Apr 2007 20:52:21 +1000
Message-ID: <E1HdOon-0002uO-00@gondolin.me.apana.org.au>
References: <<20070416105105.GA10188@gondor.apana.org.au>>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4929 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030357AbXDPKwZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 06:52:25 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HdOoo-0004bg-0f
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:22 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HdOon-0002uO-00
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:52:21 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Add ablkcipher_request_set_tfm

This patch adds ablkcipher_request_set_tfm for those users that need
to manage the memory for ablkcipher requests directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/crypto.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -588,6 +588,12 @@ static inline int crypto_ablkcipher_reqs
 	return crypto_ablkcipher_crt(tfm)->reqsize;
 }
 
+static inline void ablkcipher_request_set_tfm(
+	struct ablkcipher_request *req, struct crypto_ablkcipher *tfm)
+{
+	req->base.tfm = crypto_ablkcipher_tfm(tfm);
+}
+
 static inline struct ablkcipher_request *ablkcipher_request_cast(
 	struct crypto_async_request *req)
 {
@@ -603,7 +609,7 @@ static inline struct ablkcipher_request 
 		      crypto_ablkcipher_reqsize(tfm), gfp);
 
 	if (likely(req))
-		req->base.tfm = crypto_ablkcipher_tfm(tfm);
+		ablkcipher_request_set_tfm(req, tfm);
 
 	return req;
 }
