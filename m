Return-Path: <SRS0=iH/+=X4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA11C10F14
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 13:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72A120830
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 13:39:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xkn7RH5R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfJCNj2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Oct 2019 09:39:28 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44296 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbfJCNj1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Oct 2019 09:39:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id z9so2889905wrl.11
        for <linux-crypto@vger.kernel.org>; Thu, 03 Oct 2019 06:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PuAzE/Cx1lnwjKknlmPHdUVNf7zejQRyE3iWQZiZpxI=;
        b=xkn7RH5R38BKEcxPfu88NZjwl3QSJopXSwj6IcyOIiHLV4ye80eDbmL5zmlyYfPD4P
         bWW0D1gyh6hW9gd/rMRWTBQDsodH6KOEKEbHkz82lGlYVKmh+eLXysYcCwKHfSSncbfV
         S5YtgYdrUN4KLUGqo8vd7Ha8UlZRjr81nwgGc50zwPV14NcC/bt4xOM2l7vvB790AG59
         dOOdNhpN67xe5a1291xQjfq5LmfTmErVekA63HCcFXd4G9i8I/NPa+J18KN5lz8u86gb
         iSnyS07bk3pT4UFEp7G0hM5xQoMXlbgFCcrY0TUkiJIycMCEUDXKa3O21bVyisvzeatT
         GT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PuAzE/Cx1lnwjKknlmPHdUVNf7zejQRyE3iWQZiZpxI=;
        b=K4fq0gDFYeEu7XnECuJv84pc9DETR9MT+GHpqw5IDMRRFXb1oBO1v4M8eUA33kqwm8
         Hm55l4nsCBSIG3w/VT8PN1RuTcXiJkPF+wi2lRMcmJiPWrPpYFZk7jk2UflNB4iJxc4B
         JOiNskjvnqFyJYHGAds+/wnj5fgJQPoRrksUSIfoQTKJSqTQJpYsxR6HY5GFBo0h1C+M
         BVRqzDDDQAgN7xLZysxXtddMjOWI/FfRm0IKhqWzW87ANbDdm+UicJQtYUV+wo+txynL
         oQYX3XBMGomswfqeh90UtSnf7Qi7BVsgmIu1wkzE1DY1+dfYAlX5H1LcrMbUzxmhflgP
         oWzw==
X-Gm-Message-State: APjAAAW8izaPcuREuimR3kPVg+sW8Yk4TTbgU8OkmxvS8uyK5+3628qZ
        0p9xOl8UmkCzvFFhUO5WG6zpXUbEORtBcVBi
X-Google-Smtp-Source: APXvYqxc8KwlUebaa4vrccEiiIFTztfupPnK1HavydKgwEm9Q+tMSUwgfoUUdCdpl63NKNVaav/JEA==
X-Received: by 2002:adf:db4d:: with SMTP id f13mr7501486wrj.371.1570109964467;
        Thu, 03 Oct 2019 06:39:24 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:9527:da56:7d2e:43f3])
        by smtp.gmail.com with ESMTPSA id a204sm3379927wmh.21.2019.10.03.06.39.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 06:39:23 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Gert Robben <t2@gert.gr>,
        Jelle de Jong <jelledejong@powercraft.nl>
Subject: [PATCH] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
Date:   Thu,  3 Oct 2019 15:39:21 +0200
Message-Id: <20191003133921.29344-1-ard.biesheuvel@linaro.org>
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
the fallback.

Cc: Gert Robben <t2@gert.gr>
Cc: Jelle de Jong <jelledejong@powercraft.nl>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
Gert, Jelle,

If you can, please try this patch and report back to the list if it solves
the Geode issue for you.

-- 
Ard.

 drivers/crypto/geode-aes.c | 45 +++++++++-----------
 drivers/crypto/geode-aes.h |  2 +-
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index d81a1297cb9e..b6c47bbc2c49 100644
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
+	skcipher_request_set_crypt(req, dst, src, nbytes, desc->info);
 
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
+	skcipher_request_set_crypt(req, dst, src, nbytes, desc->info);
 
-	desc->tfm = tfm;
-	return ret;
+	return crypto_skcipher_encrypt(req);
 }
 
 static void
@@ -366,9 +364,8 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
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
@@ -381,7 +378,7 @@ static void fallback_exit_blk(struct crypto_tfm *tfm)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	crypto_free_blkcipher(op->fallback.blk);
+	crypto_free_sync_skcipher(op->fallback.blk);
 	op->fallback.blk = NULL;
 }
 
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

