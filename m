Return-Path: <SRS0=FyHQ=TQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D61AC04AAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 15:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B6CC2082E
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 15:40:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="WUKK3v4m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfEPPkI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 May 2019 11:40:08 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39166 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfEPPkH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 May 2019 11:40:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id w22so1748719pgi.6
        for <linux-crypto@vger.kernel.org>; Thu, 16 May 2019 08:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9f6fH4IrINcZqgRS/0x3NP8I07wOU2Zg7QfAKQPxCaM=;
        b=WUKK3v4mZ+HTIk5/Zi0TNhYwJmRvsS4Yg7mL/h86/DNJ7/pqGIer7dqvNQFnrlKlvp
         8SKZQYdZU/4md0nqA8uv/nvBioweZ3dXRZe1BgirSeEeCP5d8nIEkWksEdkJ5zbiKgtW
         9iY7f5/u7jsYHz0MXDUeIYKuyhFqOs+ouOypI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9f6fH4IrINcZqgRS/0x3NP8I07wOU2Zg7QfAKQPxCaM=;
        b=EuC41pqeMygn/ZBGKRP/wUiCRdQJPlaUZwT7d29kL1Zjnh1S15bvlKnY/vlETo6Eh/
         YaHeVZCghyCJbPD3Nd+vXjPkEVEAvqLikaM9E8sXa9QwzGw60C7y+04/2K3rZ2kVDPOs
         VVSHvGM9pdZzC/5BvPyOeng64O27xssa0jhjYHhxFRjZHdwNX6GGd+yWWvsFlbRiYVTb
         gYKrkhtc00YqxmRPmgPwj2+88+Bal1XljUGYwI+cnVOwW9Nj9BhZGkz2gxU7WUz/KimP
         NukIqSxfT40a4QDS3+3Vbg60QHL0RCcTVH0WReO0dcSs4utsQRMZ0cpRdxJeTiGt3/0+
         cA0Q==
X-Gm-Message-State: APjAAAUeqhAzEks4nyE0IJOadpE7JS1GP1Pe3c8ZBDaRfFXs5wlUmte+
        xuZcXtxxkN2KBG43bNHRDO7/pw==
X-Google-Smtp-Source: APXvYqzIGbRhJ1ZUHW9o7BlCAnsGTjrKCu+vzJoDWX3GH4kE4/h/hbWscX+gMkqQKqCaENu3J+6cGQ==
X-Received: by 2002:a65:6688:: with SMTP id b8mr50499274pgw.81.1558021206872;
        Thu, 16 May 2019 08:40:06 -0700 (PDT)
Received: from localhost (dip-220-235-49-186.wa.westnet.com.au. [220.235.49.186])
        by smtp.gmail.com with ESMTPSA id 132sm6311312pga.79.2019.05.16.08.40.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 May 2019 08:40:06 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     mpe@ellerman.id.au, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org,
        gcwilson@linux.ibm.com, omosnacek@gmail.com
Subject: [PATCH] crypto: vmx - ghash: do nosimd fallback manually
Date:   Fri, 17 May 2019 01:40:02 +1000
Message-Id: <20190516154002.26246-1-dja@axtens.net>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VMX ghash was using a fallback that did not support interleaving simd
and nosimd operations, leading to failures in the extended test suite.

If I understood correctly, Eric's suggestion was to use the same
data format that the generic code uses, allowing us to call into it
with the same contexts. I wasn't able to get that to work - I think
there's a very different key structure and data layout being used.

So instead steal the arm64 approach and perform the fallback
operations directly if required.

Reported-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>

---

Tested on BE and LE in qemu-tcg, so more testing would be lovely.
---
 drivers/crypto/vmx/ghash.c | 211 +++++++++++++++----------------------
 1 file changed, 86 insertions(+), 125 deletions(-)

diff --git a/drivers/crypto/vmx/ghash.c b/drivers/crypto/vmx/ghash.c
index b5a6883bb09e..14807ac2e3b9 100644
--- a/drivers/crypto/vmx/ghash.c
+++ b/drivers/crypto/vmx/ghash.c
@@ -1,22 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
 /**
  * GHASH routines supporting VMX instructions on the Power 8
  *
- * Copyright (C) 2015 International Business Machines Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 only.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright (C) 2015, 2019 International Business Machines Inc.
  *
  * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
+ *
+ * Extended by Daniel Axtens <dja@axtens.net> to replace the fallback
+ * mechanism. The new approach is based on arm64 code, which is:
+ *   Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
 #include <linux/types.h>
@@ -38,70 +30,25 @@ void gcm_ghash_p8(u64 Xi[2], const u128 htable[16],
 		  const u8 *in, size_t len);
 
 struct p8_ghash_ctx {
+	/* key used by vector asm */
 	u128 htable[16];
-	struct crypto_shash *fallback;
+	/* key used by software fallback */
+	be128 key;
 };
 
 struct p8_ghash_desc_ctx {
 	u64 shash[2];
 	u8 buffer[GHASH_DIGEST_SIZE];
 	int bytes;
-	struct shash_desc fallback_desc;
 };
 
-static int p8_ghash_init_tfm(struct crypto_tfm *tfm)
-{
-	const char *alg = "ghash-generic";
-	struct crypto_shash *fallback;
-	struct crypto_shash *shash_tfm = __crypto_shash_cast(tfm);
-	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	fallback = crypto_alloc_shash(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(fallback)) {
-		printk(KERN_ERR
-		       "Failed to allocate transformation for '%s': %ld\n",
-		       alg, PTR_ERR(fallback));
-		return PTR_ERR(fallback);
-	}
-
-	crypto_shash_set_flags(fallback,
-			       crypto_shash_get_flags((struct crypto_shash
-						       *) tfm));
-
-	/* Check if the descsize defined in the algorithm is still enough. */
-	if (shash_tfm->descsize < sizeof(struct p8_ghash_desc_ctx)
-	    + crypto_shash_descsize(fallback)) {
-		printk(KERN_ERR
-		       "Desc size of the fallback implementation (%s) does not match the expected value: %lu vs %u\n",
-		       alg,
-		       shash_tfm->descsize - sizeof(struct p8_ghash_desc_ctx),
-		       crypto_shash_descsize(fallback));
-		return -EINVAL;
-	}
-	ctx->fallback = fallback;
-
-	return 0;
-}
-
-static void p8_ghash_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	if (ctx->fallback) {
-		crypto_free_shash(ctx->fallback);
-		ctx->fallback = NULL;
-	}
-}
-
 static int p8_ghash_init(struct shash_desc *desc)
 {
-	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
 	dctx->bytes = 0;
 	memset(dctx->shash, 0, GHASH_DIGEST_SIZE);
-	dctx->fallback_desc.tfm = ctx->fallback;
-	return crypto_shash_init(&dctx->fallback_desc);
+	return 0;
 }
 
 static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
@@ -119,7 +66,51 @@ static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
 	disable_kernel_vsx();
 	pagefault_enable();
 	preempt_enable();
-	return crypto_shash_setkey(ctx->fallback, key, keylen);
+
+	memcpy(&ctx->key, key, GHASH_BLOCK_SIZE);
+
+	return 0;
+}
+
+static inline void __ghash_block(struct p8_ghash_ctx *ctx,
+				 struct p8_ghash_desc_ctx *dctx)
+{
+	if (crypto_simd_usable()) {
+		preempt_disable();
+		pagefault_disable();
+		enable_kernel_vsx();
+		gcm_ghash_p8(dctx->shash, ctx->htable,
+				dctx->buffer, GHASH_DIGEST_SIZE);
+		disable_kernel_vsx();
+		pagefault_enable();
+		preempt_enable();
+	} else {
+		crypto_xor((u8 *)dctx->shash, dctx->buffer, GHASH_BLOCK_SIZE);
+		gf128mul_lle((be128 *)dctx->shash, &ctx->key);
+	}
+}
+
+static inline void __ghash_blocks(struct p8_ghash_ctx *ctx,
+				  struct p8_ghash_desc_ctx *dctx,
+				  const u8 *src, unsigned int srclen)
+{
+	if (crypto_simd_usable()) {
+		preempt_disable();
+		pagefault_disable();
+		enable_kernel_vsx();
+		gcm_ghash_p8(dctx->shash, ctx->htable,
+				src, srclen);
+		disable_kernel_vsx();
+		pagefault_enable();
+		preempt_enable();
+	} else {
+		while (srclen >= GHASH_BLOCK_SIZE) {
+			crypto_xor((u8 *)dctx->shash, src, GHASH_BLOCK_SIZE);
+			gf128mul_lle((be128 *)dctx->shash, &ctx->key);
+			srclen -= GHASH_BLOCK_SIZE;
+			src += GHASH_BLOCK_SIZE;
+		}
+	}
 }
 
 static int p8_ghash_update(struct shash_desc *desc,
@@ -129,49 +120,33 @@ static int p8_ghash_update(struct shash_desc *desc,
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (!crypto_simd_usable()) {
-		return crypto_shash_update(&dctx->fallback_desc, src,
-					   srclen);
-	} else {
-		if (dctx->bytes) {
-			if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
-				memcpy(dctx->buffer + dctx->bytes, src,
-				       srclen);
-				dctx->bytes += srclen;
-				return 0;
-			}
+	if (dctx->bytes) {
+		if (dctx->bytes + srclen < GHASH_DIGEST_SIZE) {
 			memcpy(dctx->buffer + dctx->bytes, src,
-			       GHASH_DIGEST_SIZE - dctx->bytes);
-			preempt_disable();
-			pagefault_disable();
-			enable_kernel_vsx();
-			gcm_ghash_p8(dctx->shash, ctx->htable,
-				     dctx->buffer, GHASH_DIGEST_SIZE);
-			disable_kernel_vsx();
-			pagefault_enable();
-			preempt_enable();
-			src += GHASH_DIGEST_SIZE - dctx->bytes;
-			srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
-			dctx->bytes = 0;
-		}
-		len = srclen & ~(GHASH_DIGEST_SIZE - 1);
-		if (len) {
-			preempt_disable();
-			pagefault_disable();
-			enable_kernel_vsx();
-			gcm_ghash_p8(dctx->shash, ctx->htable, src, len);
-			disable_kernel_vsx();
-			pagefault_enable();
-			preempt_enable();
-			src += len;
-			srclen -= len;
-		}
-		if (srclen) {
-			memcpy(dctx->buffer, src, srclen);
-			dctx->bytes = srclen;
+				srclen);
+			dctx->bytes += srclen;
+			return 0;
 		}
-		return 0;
+		memcpy(dctx->buffer + dctx->bytes, src,
+			GHASH_DIGEST_SIZE - dctx->bytes);
+
+		__ghash_block(ctx, dctx);
+
+		src += GHASH_DIGEST_SIZE - dctx->bytes;
+		srclen -= GHASH_DIGEST_SIZE - dctx->bytes;
+		dctx->bytes = 0;
+	}
+	len = srclen & ~(GHASH_DIGEST_SIZE - 1);
+	if (len) {
+		__ghash_blocks(ctx, dctx, src, len);
+		src += len;
+		srclen -= len;
 	}
+	if (srclen) {
+		memcpy(dctx->buffer, src, srclen);
+		dctx->bytes = srclen;
+	}
+	return 0;
 }
 
 static int p8_ghash_final(struct shash_desc *desc, u8 *out)
@@ -180,25 +155,14 @@ static int p8_ghash_final(struct shash_desc *desc, u8 *out)
 	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
 	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	if (!crypto_simd_usable()) {
-		return crypto_shash_final(&dctx->fallback_desc, out);
-	} else {
-		if (dctx->bytes) {
-			for (i = dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
-				dctx->buffer[i] = 0;
-			preempt_disable();
-			pagefault_disable();
-			enable_kernel_vsx();
-			gcm_ghash_p8(dctx->shash, ctx->htable,
-				     dctx->buffer, GHASH_DIGEST_SIZE);
-			disable_kernel_vsx();
-			pagefault_enable();
-			preempt_enable();
-			dctx->bytes = 0;
-		}
-		memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
-		return 0;
+	if (dctx->bytes) {
+		for (i = dctx->bytes; i < GHASH_DIGEST_SIZE; i++)
+			dctx->buffer[i] = 0;
+		__ghash_block(ctx, dctx);
+		dctx->bytes = 0;
 	}
+	memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
+	return 0;
 }
 
 struct shash_alg p8_ghash_alg = {
@@ -213,11 +177,8 @@ struct shash_alg p8_ghash_alg = {
 		 .cra_name = "ghash",
 		 .cra_driver_name = "p8_ghash",
 		 .cra_priority = 1000,
-		 .cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 		 .cra_blocksize = GHASH_BLOCK_SIZE,
 		 .cra_ctxsize = sizeof(struct p8_ghash_ctx),
 		 .cra_module = THIS_MODULE,
-		 .cra_init = p8_ghash_init_tfm,
-		 .cra_exit = p8_ghash_exit_tfm,
 	},
 };
-- 
2.19.1

