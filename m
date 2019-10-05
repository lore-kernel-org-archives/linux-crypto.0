Return-Path: <SRS0=f3/+=X6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2A3C3E8AB
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 09:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B11C1222BE
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 09:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I5Fsf3pq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfJEJLa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 05:11:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39898 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJEJL3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 05:11:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so9798151wrj.6
        for <linux-crypto@vger.kernel.org>; Sat, 05 Oct 2019 02:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8MExDtZbTHuoRXfuTjpXj1T/6yu07A7uSd4e4NkVUZE=;
        b=I5Fsf3pqjBUXxxjyFrIR6XOuOYKC514xbJzc4knZiqh6K5V7sG7E/LNWnmyp/GMjSA
         ar3Tcq5V2NKcBi70q9VvOTOnovW/eZbjQDs4baMyfNrMZmqT4DyKk+PpNW7Nhqe9CMKD
         vzpwUwAiV4toraMIyWo8rvekgZeidz85Jmrkub0iQReyeZWgeTvWAb6vQ42s81pc26+X
         cGwHVRvrLTxC/GLjibeT5+nVTpLcfB4NfDso3N+0AE5kdl1HCSMf33gbcl7k4p9N5dnP
         v58TuT3IbeEQkm8gbCuXCcrYV8V8FL3b+bH7e7sofB6YPcT/NjWrRbo2rxhNFhsIRv6n
         +aNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8MExDtZbTHuoRXfuTjpXj1T/6yu07A7uSd4e4NkVUZE=;
        b=aThjPVlhHHzRLX5TEzed96rBI7civK3/krcGulGadN5FUnCKLVZyqRf5pbDksSit61
         QEyiCGeW5JianC4uCOM6g2MwBdcW5PhJDRFZBvBxKB2YAksiS/+5/9QijGQXUOCpWLDQ
         KqpO485bcooBcTZAHZBgiJnLHuLsT+yw0u1+k0hcjo2zXDw2psr8lVf5/47FzlKj9JwP
         AsKSvlZ+QYXnv3+hY/NsK9KGrolCK4mszFX1uuaYJCr5jUMfKcA+DPnj+zSzFSNBx7A4
         21aRiwl8doubY3jhcnBPTdhN6uLPLpw3XYlNNFhqWXUufqsbw8uKBbIEi16LN6yAiKkx
         E+sg==
X-Gm-Message-State: APjAAAWTCPJzgLLgcXarbSbfv4ZxRdrsLrLVmGP+UHHcO8NavchqY9xW
        bogPdAUOmQSwtumhXVgd33sni/QXS4AQxlMC
X-Google-Smtp-Source: APXvYqw/VX9KXNvJfbEGCSUnbRU4gF2IeI0oChWpGP9dyxzov5IzBayoXDju8w8NyUvFu5Wtpb7wxg==
X-Received: by 2002:adf:f081:: with SMTP id n1mr16059853wro.273.1570266686844;
        Sat, 05 Oct 2019 02:11:26 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:a4e8:d355:14b:3fb7])
        by smtp.gmail.com with ESMTPSA id m7sm5935143wrv.40.2019.10.05.02.11.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 02:11:26 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     t2@gert.gr, jelledejong@powercraft.nl, ebiggers@kernel.org,
        florian@bezdeka.de, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
Date:   Sat,  5 Oct 2019 11:11:10 +0200
Message-Id: <20191005091110.12556-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Cc: <stable@vger.kernel.org> # v4.20+ ONLY
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v2: pass dst and src scatterlist in the right order
    reject inputs that are not a multiple of the block size

 drivers/crypto/geode-aes.c | 57 +++++++++++---------
 drivers/crypto/geode-aes.h |  2 +-
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index d81a1297cb9e..940485112d15 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -10,6 +10,7 @@
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/skcipher.h>
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -166,13 +167,15 @@ static int geode_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_clear_flags(op->fallback.blk, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(op->fallback.blk,
+				       tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_blkcipher_setkey(op->fallback.blk, key, len);
+	ret = crypto_sync_skcipher_setkey(op->fallback.blk, key, len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
+		tfm->crt_flags |= crypto_sync_skcipher_get_flags(op->fallback.blk) &
+				  CRYPTO_TFM_RES_MASK;
 	}
 	return ret;
 }
@@ -181,33 +184,28 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 		struct scatterlist *dst, struct scatterlist *src,
 		unsigned int nbytes)
 {
-	unsigned int ret;
-	struct crypto_blkcipher *tfm;
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = op->fallback.blk;
-
-	ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
+	skcipher_request_set_sync_tfm(req, op->fallback.blk);
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
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, op->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = op->fallback.blk;
-
-	ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
+	skcipher_request_set_sync_tfm(req, op->fallback.blk);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	desc->tfm = tfm;
-	return ret;
+	return crypto_skcipher_encrypt(req);
 }
 
 static void
@@ -307,6 +305,9 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -339,6 +340,9 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
@@ -366,9 +370,8 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
 	const char *name = crypto_tfm_alg_name(tfm);
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	op->fallback.blk = crypto_alloc_blkcipher(name, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
-
+	op->fallback.blk = crypto_alloc_sync_skcipher(name, 0,
+						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(op->fallback.blk)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
 		return PTR_ERR(op->fallback.blk);
@@ -381,7 +384,7 @@ static void fallback_exit_blk(struct crypto_tfm *tfm)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	crypto_free_blkcipher(op->fallback.blk);
+	crypto_free_sync_skcipher(op->fallback.blk);
 	op->fallback.blk = NULL;
 }
 
@@ -420,6 +423,9 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
@@ -450,6 +456,9 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (nbytes % AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index 5c6e131a8f9d..f8a86898ac22 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -60,7 +60,7 @@ struct geode_aes_op {
 	u8 *iv;
 
 	union {
-		struct crypto_blkcipher *blk;
+		struct crypto_sync_skcipher *blk;
 		struct crypto_cipher *cip;
 	} fallback;
 	u32 keylen;
-- 
2.20.1

