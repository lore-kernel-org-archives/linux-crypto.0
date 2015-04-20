From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/15] crypto: shash - Use crypto_alg_extsize helper
Date: Mon, 20 Apr 2015 13:39:01 +0800
Message-ID: <E1Yk4Q9-0004ou-7S@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37607 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbbDTFjE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4Q9-0003CR-Ev
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:01 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces crypto_shash_extsize function with
crypto_alg_extsize.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 47c7139..ecb1e3d 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -520,11 +520,6 @@ static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static unsigned int crypto_shash_extsize(struct crypto_alg *alg)
-{
-	return alg->cra_ctxsize;
-}
-
 #ifdef CONFIG_NET
 static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -564,7 +559,7 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 
 static const struct crypto_type crypto_shash_type = {
 	.ctxsize = crypto_shash_ctxsize,
-	.extsize = crypto_shash_extsize,
+	.extsize = crypto_alg_extsize,
 	.init = crypto_init_shash_ops,
 	.init_tfm = crypto_shash_init_tfm,
 #ifdef CONFIG_PROC_FS
