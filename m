Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E673FC4740C
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 01:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4BB62082C
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 01:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732370AbfIJBmI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 21:42:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33106 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfIJBmI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 21:42:08 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i7VAT-0001FV-Np; Tue, 10 Sep 2019 11:42:06 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Sep 2019 11:42:05 +1000
Date:   Tue, 10 Sep 2019 11:42:05 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: algif_skcipher - Use chunksize instead of blocksize
Message-ID: <20190910014205.GA26506@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When algif_skcipher does a partial operation it always process data
that is a multiple of blocksize.  However, for algorithms such as
CTR this is wrong because even though it can process any number of
bytes overall, the partial block must come at the very end and not
in the middle.

This is exactly what chunksize is meant to describe so this patch
changes blocksize to chunksize.

Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index c1601edd70e3..e2c8ab408bed 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -56,7 +56,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct alg_sock *pask = alg_sk(psk);
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_skcipher *tfm = pask->private;
-	unsigned int bs = crypto_skcipher_blocksize(tfm);
+	unsigned int bs = crypto_skcipher_chunksize(tfm);
 	struct af_alg_async_req *areq;
 	int err = 0;
 	size_t len = 0;
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 734b6f7081b8..3175dfeaed2c 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -205,19 +205,6 @@ static inline unsigned int crypto_skcipher_alg_max_keysize(
 	return alg->max_keysize;
 }
 
-static inline unsigned int crypto_skcipher_alg_chunksize(
-	struct skcipher_alg *alg)
-{
-	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		return alg->base.cra_blocksize;
-
-	if (alg->base.cra_ablkcipher.encrypt)
-		return alg->base.cra_blocksize;
-
-	return alg->chunksize;
-}
-
 static inline unsigned int crypto_skcipher_alg_walksize(
 	struct skcipher_alg *alg)
 {
@@ -231,23 +218,6 @@ static inline unsigned int crypto_skcipher_alg_walksize(
 	return alg->walksize;
 }
 
-/**
- * crypto_skcipher_chunksize() - obtain chunk size
- * @tfm: cipher handle
- *
- * The block size is set to one for ciphers such as CTR.  However,
- * you still need to provide incremental updates in multiples of
- * the underlying block size as the IV does not have sub-block
- * granularity.  This is known in this API as the chunk size.
- *
- * Return: chunk size in bytes
- */
-static inline unsigned int crypto_skcipher_chunksize(
-	struct crypto_skcipher *tfm)
-{
-	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
-}
-
 /**
  * crypto_skcipher_walksize() - obtain walk size
  * @tfm: cipher handle
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 37c164234d97..aada87916918 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -304,6 +304,36 @@ static inline unsigned int crypto_skcipher_blocksize(
 	return crypto_tfm_alg_blocksize(crypto_skcipher_tfm(tfm));
 }
 
+static inline unsigned int crypto_skcipher_alg_chunksize(
+	struct skcipher_alg *alg)
+{
+	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return alg->base.cra_blocksize;
+
+	if (alg->base.cra_ablkcipher.encrypt)
+		return alg->base.cra_blocksize;
+
+	return alg->chunksize;
+}
+
+/**
+ * crypto_skcipher_chunksize() - obtain chunk size
+ * @tfm: cipher handle
+ *
+ * The block size is set to one for ciphers such as CTR.  However,
+ * you still need to provide incremental updates in multiples of
+ * the underlying block size as the IV does not have sub-block
+ * granularity.  This is known in this API as the chunk size.
+ *
+ * Return: chunk size in bytes
+ */
+static inline unsigned int crypto_skcipher_chunksize(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
+}
+
 static inline unsigned int crypto_sync_skcipher_blocksize(
 	struct crypto_sync_skcipher *tfm)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
