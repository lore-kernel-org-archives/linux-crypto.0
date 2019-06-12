Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4BCC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B91D720684
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s+wuB5UF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439233AbfFLMtM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:49:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55492 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439235AbfFLMtL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:49:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so6430333wmj.5
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=80OaoKT+inVFqryUaesnban4gPiDdroPQoZlqPQnBMg=;
        b=s+wuB5UFnOhqXz+mQtE7yzhq5X2+mZ/YAF3O3DEM+El+csWqg8aIFgALkrOWVw6NyM
         C3ciGneUJ589CJvJkA8fbHUB/jnjUlNGD6zGRC/U4JMYv/nTMSDbxqi9HFb2n8xawAIJ
         CSFF/YZKiy8GnsLn/jWHO52iFat6DzOq6o5uf2Csa/OJl2dto1xVyzFG2mLb/qpPxD5m
         S0C4zfGXljSZCXymur9UAJYEYqFlDejE+JR/lM/WWBFsAXScS0WCPWntLGFJ47lN0009
         TsbybyYXVSfwE0bybY0mYx842U/LDK1wUcOa5scCzb5DWsZWcIweYY/S1JhzIbEd7JAJ
         b+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=80OaoKT+inVFqryUaesnban4gPiDdroPQoZlqPQnBMg=;
        b=RAq2eBCM202bmgefGn2dq/IoeUjBSqTu5QuKPF3Hfm1N8jnE7m173+ukkibskD68o+
         J3wtbnIajuOLD2fmNdJwC0kZQ+L4LyY03VAhHXnO9WavOzDIldcCDn9s5a68fhWZBptB
         Q/twMXnAO5tOvJD5aEPjXNh9JkIybUSyrrM5zcWiENBV+QTJ2N1RwxkgA09ylvlgU1cT
         A+2AIavqf51qFacNCizGt2/mmHXTBNx4hDlDZ03cYxTWQ6bKG5WinLKzKlmfsmU9lRPy
         I/LFUZq9FE2DQPibAb+6obBwwuXgLokzU/epxcxMfYVUvkCg1qe7spJ07PndWvxEyfNk
         am1g==
X-Gm-Message-State: APjAAAWucycUKR3n7Uo7yxiHNes+gTp4T4iV7pC59r4umPAsRItCrvip
        4GdHgDKiLa0Rvz/mBIL+D8Mqf18/iQcvxw==
X-Google-Smtp-Source: APXvYqwArKyR47aRZq3Xh6NWiryv7rp0nu8iYrHxe1b5gMntI4PNBNtaljrqoy7XEw7JidHoD4WJAg==
X-Received: by 2002:a1c:48c5:: with SMTP id v188mr21239967wma.175.1560343747741;
        Wed, 12 Jun 2019 05:49:07 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.49.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:49:06 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 19/20] crypto: arm/aes-neonbs - provide a synchronous version of ctr(aes)
Date:   Wed, 12 Jun 2019 14:48:37 +0200
Message-Id: <20190612124838.2492-20-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
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
 arch/arm/crypto/aes-neonbs-glue.c | 58 ++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index f43c9365b6a9..62cadb92379b 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -9,6 +9,7 @@
  */
 
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/aes.h>
 #include <crypto/cbc.h>
 #include <crypto/internal/simd.h>
@@ -57,6 +58,11 @@ struct aesbs_xts_ctx {
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
@@ -192,6 +198,25 @@ static void cbc_exit(struct crypto_tfm *tfm)
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
@@ -234,6 +259,23 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
+static int ctr_encrypt_sync(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (!crypto_simd_usable()) {
+		struct skcipher_walk walk;
+		int err;
+
+		err = skcipher_walk_virt(&walk, req, true);
+		if (err)
+			return err;
+		return skcipher_encrypt_aes_ctr(&walk, &ctx->fallback);
+	}
+	return ctr_encrypt(req);
+}
+
 static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
@@ -361,6 +403,22 @@ static struct skcipher_alg aes_algs[] = { {
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

