From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: skcipher - Add helper to zero stack request
Date: Fri, 22 Jan 2016 23:21:10 +0800
Message-ID: <20160122152110.GA18294@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53236 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbcAVPVM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2016 10:21:12 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As the size of an skcipher_request is variable, it's awkward to
zero it explicitly.  This patch adds a helper to do that which
should be used when it is created on the stack.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 2f07b4f..905490c 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -445,6 +451,13 @@ static inline void skcipher_request_free(struct skcipher_request *req)
 	kzfree(req);
 }
 
+static inline void skcipher_request_zero(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	memzero_explicit(req, sizeof(*req) + crypto_skcipher_reqsize(tfm));
+}
+
 /**
  * skcipher_request_set_callback() - set asynchronous callback function
  * @req: request handle
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
