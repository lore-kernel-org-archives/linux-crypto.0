From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/8] [CRYPTO] aead: Fix crypto_aead_setkey on geniv algorithms
Date: Mon, 17 Dec 2007 18:31:17 +0800
Message-ID: <E1J4DFl-00039A-00@gondolin.me.apana.org.au>
References: <20071217103037.GA11988@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4841 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752111AbXLQKbX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 05:31:23 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4DFm-0008VP-U5
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 21:31:19 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead: Fix crypto_aead_setkey on geniv algorithms

We need to call the setkey function with the base pointer.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/crypto.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 4219b48..0aba104 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -778,7 +778,9 @@ static inline void crypto_aead_clear_flags(struct crypto_aead *tfm, u32 flags)
 static inline int crypto_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 				     unsigned int keylen)
 {
-	return crypto_aead_crt(tfm)->setkey(tfm, key, keylen);
+	struct aead_tfm *crt = crypto_aead_crt(tfm);
+
+	return crt->setkey(crt->base, key, keylen);
 }
 
 int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize);
