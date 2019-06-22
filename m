Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D098AC48BE8
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6CA020657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WhzvsXaM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFVTfF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:35:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46345 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfFVTfE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:35:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so9666050wrw.13
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vL6L5hDUn9mhzlJsgchovHgAG3ROBqwVQK1Apo8D4Bw=;
        b=WhzvsXaMq4jr9ZNdR2e5Z3+WuuVRSfdwgoJWFzepBHWVIFtw4SJFdFc9Zf+Aj8mfOn
         Pyu7trs2uhvrJ5c52amgY4SuY/vAvLezoluLtCgbL9M9Cfxugqey5xvibRK1mL+briPO
         l3BVAOhcl+uSETi8LgvHrawTG5ZOuTAKC7aiMN3OBdpVuQwVgUtbctDkEC4g8SBL5+aH
         XEIpXFC4Mp5xAdftufoqYvrNqSe+F/WMfIYjD2wyp43lQYJ6VQoIzl9NBLsyR8DGUgSY
         Dj4FmqNbysPpblbedgJuwhbMgw89ZZDZSX8KdvfbcwE8o1AOLvV3vfj28tF8/e7//kMd
         Pwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vL6L5hDUn9mhzlJsgchovHgAG3ROBqwVQK1Apo8D4Bw=;
        b=quz+NGwl57wjLmSjE3ibq2YT1TJLYWuvAPm87f+KWsVMVk6rzFxQUiWpFxjdcOiGPq
         OI+Lk1EUJTddmef6MKGofQI6hBbMrXKuc84KpfjNRaL7fGn/t42JRnd+0CuAWibvrKZJ
         x1NBnoxyYsPQEf5HK+soQfM6EbHYzEV+8CzdYsofxZvSbi7trv8DzaE04zERmLBkSv83
         CBs3F3ZoJR9gt9VSkjXOdIiF7JtnB7Pn6cdWYmUZijoNj7lWIT3iaL2ImhGir3spJlxJ
         xB4O4xWwgZawS7ymPTxTTi96Gn2MpMyqnPXnMSgSZ3eQ8wkTp9Ih4PhI8UKNNlju4g3W
         6mww==
X-Gm-Message-State: APjAAAVjtMTg3JhDp2WEudxjTX7YQ/Meh5lL72FSqsrbCJfgi9Dgr9Kn
        Msu7Xhn4i2os4lvFA9e+a00vekR6/bDqRoQ0
X-Google-Smtp-Source: APXvYqxCVPj4deqPAg2vlOfo7mLOXHpc99mFab863X6Ccvs3F53u7lmF5ncYeCQFLAfNSTA7fpOWrw==
X-Received: by 2002:adf:fb81:: with SMTP id a1mr16653991wrr.329.1561232102531;
        Sat, 22 Jun 2019 12:35:02 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.35.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:35:01 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 21/26] crypto: arm/aes-neonbs - provide a synchronous version of ctr(aes)
Date:   Sat, 22 Jun 2019 21:34:22 +0200
Message-Id: <20190622193427.20336-22-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AES in CTR mode is used by modes such as GCM and CCM, which are often
used in contexts where only synchronous ciphers are permitted. So
provide a synchronous version of ctr(aes) based on the existing code.
This requires a non-SIMD fallback to deal with invocations occurring
from a context where SIMD instructions may not be used. We have a
helper for this now in the AES library, so wire that up.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-neonbs-glue.c | 65 ++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index f43c9365b6a9..2f1aa199926c 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -9,8 +9,10 @@
  */
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/aes.h>
 #include <crypto/cbc.h>
+#include <crypto/ctr.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
@@ -57,6 +59,11 @@ struct aesbs_xts_ctx {
 	struct crypto_cipher	*tweak_tfm;
 };
 
+struct aesbs_ctr_ctx {
+	struct aesbs_ctx	key;		/* must be first member */
+	struct crypto_aes_ctx	fallback;
+};
+
 static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
@@ -192,6 +199,25 @@ static void cbc_exit(struct crypto_tfm *tfm)
 	crypto_free_cipher(ctx->enc_tfm);
 }
 
+static int aesbs_ctr_setkey_sync(struct crypto_skcipher *tfm, const u8 *in_key,
+				 unsigned int key_len)
+{
+	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err;
+
+	err = aes_expandkey(&ctx->fallback, in_key, key_len);
+	if (err)
+		return err;
+
+	ctx->key.rounds = 6 + key_len / 4;
+
+	kernel_neon_begin();
+	aesbs_convert_key(ctx->key.rk, ctx->fallback.key_enc, ctx->key.rounds);
+	kernel_neon_end();
+
+	return 0;
+}
+
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -234,6 +260,29 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
+static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
+{
+	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
+	unsigned long flags;
+
+	/*
+	 * Temporarily disable interrupts to avoid races where
+	 * evicted when the CPU is interrupted to do something
+	 * else.
+	 */
+	local_irq_save(flags);
+	aes_encrypt(&ctx->fallback, dst, src);
+	local_irq_restore(flags);
+}
+
+static int ctr_encrypt_sync(struct skcipher_request *req)
+{
+	if (!crypto_simd_usable())
+		return crypto_ctr_encrypt_walk(req, ctr_encrypt_one);
+
+	return ctr_encrypt(req);
+}
+
 static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
@@ -361,6 +410,22 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey			= aesbs_setkey,
 	.encrypt		= ctr_encrypt,
 	.decrypt		= ctr_encrypt,
+}, {
+	.base.cra_name		= "ctr(aes)",
+	.base.cra_driver_name	= "ctr-aes-neonbs-sync",
+	.base.cra_priority	= 250 - 1,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct aesbs_ctr_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.walksize		= 8 * AES_BLOCK_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.setkey			= aesbs_ctr_setkey_sync,
+	.encrypt		= ctr_encrypt_sync,
+	.decrypt		= ctr_encrypt_sync,
 }, {
 	.base.cra_name		= "__xts(aes)",
 	.base.cra_driver_name	= "__xts-aes-neonbs",
-- 
2.20.1

