From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/15] crypto: pcomp - Use crypto_alg_extsize helper
Date: Mon, 20 Apr 2015 13:39:02 +0800
Message-ID: <E1Yk4QA-0004pB-Cc@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47673 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbbDTFjF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:05 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4QA-0003CZ-MQ
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:02 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces crypto_pcomp_extsize function with
crypto_alg_extsize.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/pcompress.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/crypto/pcompress.c b/crypto/pcompress.c
index 7140fe7..7a13b40 100644
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -38,11 +38,6 @@ static int crypto_pcomp_init(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
-static unsigned int crypto_pcomp_extsize(struct crypto_alg *alg)
-{
-	return alg->cra_ctxsize;
-}
-
 static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm)
 {
 	return 0;
@@ -77,7 +72,7 @@ static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
 }
 
 static const struct crypto_type crypto_pcomp_type = {
-	.extsize	= crypto_pcomp_extsize,
+	.extsize	= crypto_alg_extsize,
 	.init		= crypto_pcomp_init,
 	.init_tfm	= crypto_pcomp_init_tfm,
 #ifdef CONFIG_PROC_FS
