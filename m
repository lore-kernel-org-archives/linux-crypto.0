Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DE3C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A68BC21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JN9Jgah2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfGBTml (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:41 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41957 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfGBTml (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:41 -0400
Received: by mail-lf1-f66.google.com with SMTP id 62so2219768lfa.8
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bK4LustB8GmckyS2nPrFKDpnC0XD07k3hKGC7VgrKjI=;
        b=JN9Jgah2WGcVN504HWo6oO8sZaZHO954dgn+nY0MTg68xJHIiFTw5pIg31ihwH3nD8
         Tb5T03mnm7Kn8YEhiFhsMMDyDBZR97UFbmZnULjgrlbst1/4ag0p/7H+/fAKNrEEsKm8
         f4kIb8f8YWRYaWdQivY7rIL20c1D1mJWMp39+izc17g1wa4KhAy7TkWRANkk9NQF/8am
         a1+VyrIoJ41DDSneKIWXBVI5fk2aWyDEaFYuNnGeBHCWHgHyhYEaTyV/pEH/NN966972
         aVAlA72NPTCdQakDc9IIXh7YQJ3jvmMVWmf8siUWfWuUXLMr87EbcVk9vg9a4cQ633hB
         8Zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bK4LustB8GmckyS2nPrFKDpnC0XD07k3hKGC7VgrKjI=;
        b=kN/+3vRIrU0f9q+hN/46ySYqPpj23Wo8ybPS5w+OrcIAKB8+7hID76IkLh7GyPfMvl
         U1dkiTd40BQ43JFNEog+NtnnsNIo8IslQ8229ip96J0tdVNckcXqKbHmSa46ZiVsH5ge
         8x0B8Ao9hiRZ4blIpoNPGbwEvJnwx7jIvWgeN+humVZldkMDUMTg8nfa8d1v2bm4Ryce
         n/OYOqQe3F12/acfri7Ag9AlFZb4l7dNHNdMDYH8x8mJ/UWaQDOk+qrJ6mSbaE9gFcjN
         wIy4c2OY33jv/exjkb/rPLSb/7n/ayYRaTw7TlXNkNcgRRwSk+F996EWwHjjy5xcZoh7
         qN4w==
X-Gm-Message-State: APjAAAVQq3Lip6aK7E3ztT2rH40SU6BzbZfEkx+8xfOdlop4Ryv7ujsR
        m2qthOJoUbRdUbFfFYblTL5PVaaLkYGAEEK+
X-Google-Smtp-Source: APXvYqw+y7neGtiKBmjeXYIYfiygRoJTckzZ00cCkks9eF1ri5QEmmWSgsHGNqPN1Axm3onldotXZA==
X-Received: by 2002:a19:41cc:: with SMTP id o195mr14128017lfa.166.1562096558298;
        Tue, 02 Jul 2019 12:42:38 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:37 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 21/32] crypto: arm/aes-neonbs - provide a synchronous version of ctr(aes)
Date:   Tue,  2 Jul 2019 21:41:39 +0200
Message-Id: <20190702194150.10405-22-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
index f43c9365b6a9..6eecdbb7e9b6 100644
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
+	 * cachelines are evicted when the CPU is interrupted
+	 * to do something else.
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
2.17.1

