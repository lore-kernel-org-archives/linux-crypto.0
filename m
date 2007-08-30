From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/8] [CRYPTO] api: Fixed crypto_*_reqsize return type
Date: Thu, 30 Aug 2007 16:41:34 +0800
Message-ID: <E1IQfao-0004Bu-00@gondolin.me.apana.org.au>
References: <20070830083900.GA15936@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbgert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1424 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756352AbXH3Ilh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 04:41:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Fixed crypto_*_reqsize return type

This patch changes the return type of crypto_*_reqsize from int to
unsigned int which matches what the underlying type is (and should
be).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/crypto.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b1c7f41..fc32694 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -624,7 +624,8 @@ static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 	return crt->decrypt(req);
 }
 
-static inline int crypto_ablkcipher_reqsize(struct crypto_ablkcipher *tfm)
+static inline unsigned int crypto_ablkcipher_reqsize(
+	struct crypto_ablkcipher *tfm)
 {
 	return crypto_ablkcipher_crt(tfm)->reqsize;
 }
@@ -766,7 +767,7 @@ static inline int crypto_aead_decrypt(struct aead_request *req)
 	return crypto_aead_crt(crypto_aead_reqtfm(req))->decrypt(req);
 }
 
-static inline int crypto_aead_reqsize(struct crypto_aead *tfm)
+static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
 {
 	return crypto_aead_crt(tfm)->reqsize;
 }
