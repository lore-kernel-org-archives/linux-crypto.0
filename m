From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/16] crypto: ixp4xx - Use crypto_aead_maxauthsize
Date: Thu, 21 May 2015 15:11:06 +0800
Message-ID: <E1YvKdG-0005ek-Eu@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56852 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbEUHLK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdG-0002yD-QK
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:06 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the helper crypto_aead_maxauthsize instead of
directly dereferencing aead_alg.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ixp4xx_crypto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 46cd696..7ba495f 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1097,7 +1097,7 @@ static int aead_setup(struct crypto_aead *tfm, unsigned int authsize)
 {
 	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
 	u32 *flags = &tfm->base.crt_flags;
-	unsigned digest_len = crypto_aead_alg(tfm)->maxauthsize;
+	unsigned digest_len = crypto_aead_maxauthsize(tfm);
 	int ret;
 
 	if (!ctx->enckey_len && !ctx->authkey_len)
@@ -1139,7 +1139,7 @@ out:
 
 static int aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
-	int max = crypto_aead_alg(tfm)->maxauthsize >> 2;
+	int max = crypto_aead_maxauthsize(tfm) >> 2;
 
 	if ((authsize>>2) < 1 || (authsize>>2) > max || (authsize & 3))
 		return -EINVAL;
