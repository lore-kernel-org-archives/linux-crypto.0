Return-Path: <SRS0=f3/+=X6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB64C3E8AB
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 12:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C13B2133F
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 12:23:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=bezdeka.de header.i=@bezdeka.de header.b="sTTQaKAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfJEMW7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 08:22:59 -0400
Received: from srv1.bezdeka.de ([185.207.107.174]:49908 "EHLO smtp.bezdeka.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726198AbfJEMW7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 08:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bezdeka.de;
         s=mail201812; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Bl730piJwUX7rFpfKnLvzhrCp9q896/LtU2KbxkFjA4=; b=sTTQaKAg8qWSLMT9mkM0IZOMPm
        tO9rZiSum3dZ5wnPO3eFT2jYNAg//0sXO/E+spK3cSVK00UwsgEF9XUYlHWPgX+sa0tJCaDPEsOir
        SGys2hv3wXHtAQFSA732YuI4Ut/HB7zradLXi8WlsWxZOCfBsS8Mgf78IuJRDmQstGJHmJStGpmWg
        uM6abfGZgbS4r0aQtgHu0F7vFep+izgHLcK+yXM7TjjM7g3nQGStMuQefLUEbWKkcJA6PH61hRP/t
        F1F/5xm+TrlzNDZqAeLthD6cLFZYUxvylKlVyktkHTv7WbokYQqbrf0K1JCkRixw8ZQdcrBPjE+PK
        WoZrTGTg==;
Received: from [2a02:810d:8ac0:2dcc:69b2:10b8:f07d:59cd] (helo=flo.suempflein.bezdeka.de)
        by smtp.bezdeka.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <florian@bezdeka.de>)
        id 1iGj5J-0006fX-6e; Sat, 05 Oct 2019 14:22:53 +0200
From:   Florian Bezdeka <florian@bezdeka.de>
To:     linux-crypto@vger.kernel.org
Cc:     Florian Bezdeka <florian@bezdeka.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto: geode-aes - switch to skcipher for cbc(aes) fallback 
Date:   Sat,  5 Oct 2019 14:22:26 +0200
Message-Id: <20191005122226.23552-1-florian@bezdeka.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191005091110.12556-1-ard.biesheuvel@linaro.org>
References: <20191005091110.12556-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: florian@bezdeka.de
X-Authenticator: plain
X-Exim-Version: 4.92.3 (build at 30-Sep-2019 11:50:17)
X-Date: 2019-10-05 14:22:53
X-Connected-IP: 2a02:810d:8ac0:2dcc:69b2:10b8:f07d:59cd:38782
X-Message-Linecount: 194
X-Body-Linecount: 181
X-Message-Size: 6491
X-Body-Size: 5939
X-Received-Count: 1
X-Local-Recipient-Count: 3
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
the generic CBC template wrapper from a blkcipher to a skcipher algo,
to get away from the deprecated blkcipher interface. However, as a side
effect, drivers that instantiate CBC transforms using the blkcipher as
a fallback no longer work, since skciphers can wrap blkciphers but not
the other way around. This broke the geode-aes driver.

So let's fix it by moving to the sync skcipher interface when allocating
the fallback. At the same time, align with the generic API for ECB and
CBC by rejecting inputs that are not a multiple of the AES block size.

Fixes: 79c65d179a40e145 ("crypto: cbc - Convert to skcipher")
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Florian Bezdeka <florian@bezdeka.de>
---

Ard, I just followed your instructions and created this patch 
for usage on an 4.19 kernel. The patch was successfully tested 
on two different Geode systems.

Can you please review again and forward to the stable tree if the patch
looks OK?

 drivers/crypto/geode-aes.c | 57 +++++++++++++++++++++++---------------
 drivers/crypto/geode-aes.h |  2 +-
 2 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index eb2a0a73cbed..cc33354d13c1 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/skcipher.h>
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -170,13 +171,15 @@ static int geode_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_clear_flags(op->fallback.blk, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(op->fallback.blk,
+				  tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_blkcipher_setkey(op->fallback.blk, key, len);
+	ret = crypto_skcipher_setkey(op->fallback.blk, key, len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
+		tfm->crt_flags |= crypto_skcipher_get_flags(op->fallback.blk) &
+				  CRYPTO_TFM_RES_MASK;
 	}
 	return ret;
 }
@@ -185,33 +188,28 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 		struct scatterlist *dst, struct scatterlist *src,
 		unsigned int nbytes)
 {
-	unsigned int ret;
-	struct crypto_blkcipher *tfm;
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
+	SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = op->fallback.blk;
-
-	ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
+	skcipher_request_set_tfm(req, op->fallback.blk);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	desc->tfm = tfm;
-	return ret;
+	return crypto_skcipher_decrypt(req);
 }
+
 static int fallback_blk_enc(struct blkcipher_desc *desc,
 		struct scatterlist *dst, struct scatterlist *src,
 		unsigned int nbytes)
 {
-	unsigned int ret;
-	struct crypto_blkcipher *tfm;
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
+	SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = op->fallback.blk;
-
-	ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
+	skcipher_request_set_tfm(req, op->fallback.blk);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	desc->tfm = tfm;
-	return ret;
+	return crypto_skcipher_encrypt(req);
 }
 
 static void
@@ -311,6 +309,9 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -343,6 +344,9 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
@@ -370,8 +374,9 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
 	const char *name = crypto_tfm_alg_name(tfm);
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	op->fallback.blk = crypto_alloc_blkcipher(name, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	op->fallback.blk = crypto_alloc_skcipher(name, 0,
+						 CRYPTO_ALG_ASYNC | 
+						 CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(op->fallback.blk)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
@@ -385,7 +390,7 @@ static void fallback_exit_blk(struct crypto_tfm *tfm)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	crypto_free_blkcipher(op->fallback.blk);
+	crypto_free_skcipher(op->fallback.blk);
 	op->fallback.blk = NULL;
 }
 
@@ -424,6 +429,9 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -454,6 +462,9 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index f442ca972e3c..c5763a041bb8 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -64,7 +64,7 @@ struct geode_aes_op {
 	u8 *iv;
 
 	union {
-		struct crypto_blkcipher *blk;
+		struct crypto_skcipher *blk;
 		struct crypto_cipher *cip;
 	} fallback;
 	u32 keylen;
-- 
2.21.0

