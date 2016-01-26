From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: skcipher - Add helper to retrieve driver name
Date: Tue, 26 Jan 2016 22:14:36 +0800
Message-ID: <20160126141436.GB22685@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43040 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbcAZOOk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 09:14:40 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helper crypto_skcipher_driver_name which returns
the driver name of the alg object for a given tfm.  This is needed by
ecryptfs.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index f7a03a1..5bb7056 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -231,6 +231,12 @@ static inline int crypto_has_skcipher(const char *alg_name, u32 type,
 			      crypto_skcipher_mask(mask));
 }
 
+static inline const char *crypto_skcipher_driver_name(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
+}
+
 /**
  * crypto_skcipher_ivsize() - obtain IV size
  * @tfm: cipher handle
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
