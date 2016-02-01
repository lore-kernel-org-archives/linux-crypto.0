From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/6] crypto: skcipher - Fix driver name helper
Date: Mon, 01 Feb 2016 21:36:51 +0800
Message-ID: <E1aQEex-0002p6-JC@gondolin.me.apana.org.au>
References: <20160201133405.GA10754@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35520 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbcBANgy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:36:54 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1aQEex-0002IT-My
	for <linux-crypto@vger.kernel.org>; Tue, 02 Feb 2016 00:36:51 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The helper crypto_skcipher_driver_name was returning the alg
name and not the driver name.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/skcipher.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 5bb7056..905490c 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -234,7 +234,7 @@ static inline int crypto_has_skcipher(const char *alg_name, u32 type,
 static inline const char *crypto_skcipher_driver_name(
 	struct crypto_skcipher *tfm)
 {
-	return crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
+	return crypto_tfm_alg_driver_name(crypto_skcipher_tfm(tfm));
 }
 
 /**
