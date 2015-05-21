From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/16] crypto: nx - Remove unnecessary maxauthsize check
Date: Thu, 21 May 2015 15:11:07 +0800
Message-ID: <E1YvKdH-0005f1-Ll@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42973 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbbEUHLK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdH-0002yi-SR
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:08 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The crypto layer already checks maxauthsize when setauthsize is
called.  So there is no need to check it again within setauthsize.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/nx/nx-aes-gcm.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 88c5624..e4e64f6 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -96,9 +96,6 @@ out:
 static int gcm_aes_nx_setauthsize(struct crypto_aead *tfm,
 				  unsigned int authsize)
 {
-	if (authsize > crypto_aead_alg(tfm)->maxauthsize)
-		return -EINVAL;
-
 	crypto_aead_crt(tfm)->authsize = authsize;
 
 	return 0;
