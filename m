Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFE8C06511
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE3D121850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gubS8BLH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfGBTmm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:42 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40428 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGBTmm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:42 -0400
Received: by mail-lj1-f196.google.com with SMTP id a21so18169330ljh.7
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VA1NX4OTJyuJ+sHjTv3EgQQCR56i+Qi8C4n3+5icP3I=;
        b=gubS8BLHsB5NbC39fRYRNOlmUqVxLMuCXolIY+O+z7WZMFn4CibcpVlUlw0snTj7hC
         S1MHCspjJWaQXoACWaw1T4lBLRAJyvLX55lbQcIwcU0Ji1DMdw32MZ5u3L4APxZICP5g
         bWQ2CklluUVYKdYfJTOWou+0m7mp/aM38Fs29RdRaooiO2geHajp2L7lIVdKXlIbnAg5
         sc9XlEZtoLMcsSi3QfBSYo7cUNvGn5PFmB6Tu1eb+TLp1Fl5Y2T/kyIcFpkQYC6Pxkjv
         MMBA6H8Ebzxxj1uqw7SBZnDjXmYmsYF6eSSnJPMzA/UOl65abwHf8fjQ+Gu2Xjbx/Ac9
         X5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VA1NX4OTJyuJ+sHjTv3EgQQCR56i+Qi8C4n3+5icP3I=;
        b=YjCHgmK2C1ePflwAxnfBw8aD0wDrUIpvT/wNbb/Kgbsr+SXC77n7yfIs6uYxjie//F
         rlcux5rzH8JM1ZDo/RB7cKutbiDpOQW/EIwtkWjYIKuvnn3Q6ayHbsk54032smkk7LWr
         5Ph+aNzVWalYZ8UGIunWFkO+CirjnO4Y5iuwaL2pjO24lYC06mM8aOxVMxHLAbUk+wcN
         bLF/1eUo6KbHPVkfLhz+s+jvBBRiYS1TjtUm3W5GL0O0TXU+LGiFXXt6DBmlrL5iZevm
         MEuWfwT6O6N7vsop7J9rFtH8sgmgUwOkaGrb7d4MWas5EM82bk1aLtbNqFTm1hMexhTW
         otRA==
X-Gm-Message-State: APjAAAXpZZcoKrm6X8sGCObcemXVpuGfLck8MpR/lpRU/0Bsjx+RUjZU
        4mROwLKTK16vhan8LCdiLUgWsXYusvA++b1D
X-Google-Smtp-Source: APXvYqzdgImVlrBqvJ1vOmmzyjkJ950xdrhvE7HMYshLLb1AlXMNnRVkQSqcrZ72csGuW/LPDyLh+A==
X-Received: by 2002:a2e:5d46:: with SMTP id r67mr17553560ljb.187.1562096559561;
        Tue, 02 Jul 2019 12:42:39 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:38 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 22/32] crypto: arm/ghash - provide a synchronous version
Date:   Tue,  2 Jul 2019 21:41:40 +0200
Message-Id: <20190702194150.10405-23-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

GHASH is used by the GCM mode, which is often used in contexts where
only synchronous ciphers are permitted. So provide a synchronous version
of GHASH based on the existing code. This requires a non-SIMD fallback
to deal with invocations occurring from a context where SIMD instructions
may not be used.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/ghash-ce-glue.c | 78 +++++++++++++-------
 1 file changed, 52 insertions(+), 26 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 39d1ccec1aab..ebb237ca874b 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -12,6 +12,7 @@
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <asm/unaligned.h>
+#include <crypto/b128ops.h>
 #include <crypto/cryptd.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
@@ -33,6 +34,8 @@ struct ghash_key {
 	u64	h2[2];
 	u64	h3[2];
 	u64	h4[2];
+
+	be128	k;
 };
 
 struct ghash_desc_ctx {
@@ -65,6 +68,36 @@ static int ghash_init(struct shash_desc *desc)
 	return 0;
 }
 
+static void ghash_do_update(int blocks, u64 dg[], const char *src,
+			    struct ghash_key *key, const char *head)
+{
+	if (likely(crypto_simd_usable())) {
+		kernel_neon_begin();
+		pmull_ghash_update(blocks, dg, src, key, head);
+		kernel_neon_end();
+	} else {
+		be128 dst = { cpu_to_be64(dg[1]), cpu_to_be64(dg[0]) };
+
+		do {
+			const u8 *in = src;
+
+			if (head) {
+				in = head;
+				blocks++;
+				head = NULL;
+			} else {
+				src += GHASH_BLOCK_SIZE;
+			}
+
+			crypto_xor((u8 *)&dst, in, GHASH_BLOCK_SIZE);
+			gf128mul_lle(&dst, &key->k);
+		} while (--blocks);
+
+		dg[0] = be64_to_cpu(dst.b);
+		dg[1] = be64_to_cpu(dst.a);
+	}
+}
+
 static int ghash_update(struct shash_desc *desc, const u8 *src,
 			unsigned int len)
 {
@@ -88,10 +121,8 @@ static int ghash_update(struct shash_desc *desc, const u8 *src,
 		blocks = len / GHASH_BLOCK_SIZE;
 		len %= GHASH_BLOCK_SIZE;
 
-		kernel_neon_begin();
-		pmull_ghash_update(blocks, ctx->digest, src, key,
-				   partial ? ctx->buf : NULL);
-		kernel_neon_end();
+		ghash_do_update(blocks, ctx->digest, src, key,
+				partial ? ctx->buf : NULL);
 		src += blocks * GHASH_BLOCK_SIZE;
 		partial = 0;
 	}
@@ -109,9 +140,7 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
 		struct ghash_key *key = crypto_shash_ctx(desc->tfm);
 
 		memset(ctx->buf + partial, 0, GHASH_BLOCK_SIZE - partial);
-		kernel_neon_begin();
-		pmull_ghash_update(1, ctx->digest, ctx->buf, key, NULL);
-		kernel_neon_end();
+		ghash_do_update(1, ctx->digest, ctx->buf, key, NULL);
 	}
 	put_unaligned_be64(ctx->digest[1], dst);
 	put_unaligned_be64(ctx->digest[0], dst + 8);
@@ -135,24 +164,25 @@ static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *inkey, unsigned int keylen)
 {
 	struct ghash_key *key = crypto_shash_ctx(tfm);
-	be128 h, k;
+	be128 h;
 
 	if (keylen != GHASH_BLOCK_SIZE) {
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	memcpy(&k, inkey, GHASH_BLOCK_SIZE);
-	ghash_reflect(key->h, &k);
+	/* needed for the fallback */
+	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
+	ghash_reflect(key->h, &key->k);
 
-	h = k;
-	gf128mul_lle(&h, &k);
+	h = key->k;
+	gf128mul_lle(&h, &key->k);
 	ghash_reflect(key->h2, &h);
 
-	gf128mul_lle(&h, &k);
+	gf128mul_lle(&h, &key->k);
 	ghash_reflect(key->h3, &h);
 
-	gf128mul_lle(&h, &k);
+	gf128mul_lle(&h, &key->k);
 	ghash_reflect(key->h4, &h);
 
 	return 0;
@@ -165,15 +195,13 @@ static struct shash_alg ghash_alg = {
 	.final			= ghash_final,
 	.setkey			= ghash_setkey,
 	.descsize		= sizeof(struct ghash_desc_ctx),
-	.base			= {
-		.cra_name	= "__ghash",
-		.cra_driver_name = "__driver-ghash-ce",
-		.cra_priority	= 0,
-		.cra_flags	= CRYPTO_ALG_INTERNAL,
-		.cra_blocksize	= GHASH_BLOCK_SIZE,
-		.cra_ctxsize	= sizeof(struct ghash_key),
-		.cra_module	= THIS_MODULE,
-	},
+
+	.base.cra_name		= "ghash",
+	.base.cra_driver_name	= "ghash-ce-sync",
+	.base.cra_priority	= 300 - 1,
+	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct ghash_key),
+	.base.cra_module	= THIS_MODULE,
 };
 
 static int ghash_async_init(struct ahash_request *req)
@@ -288,9 +316,7 @@ static int ghash_async_init_tfm(struct crypto_tfm *tfm)
 	struct cryptd_ahash *cryptd_tfm;
 	struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	cryptd_tfm = cryptd_alloc_ahash("__driver-ghash-ce",
-					CRYPTO_ALG_INTERNAL,
-					CRYPTO_ALG_INTERNAL);
+	cryptd_tfm = cryptd_alloc_ahash("ghash-ce-sync", 0, 0);
 	if (IS_ERR(cryptd_tfm))
 		return PTR_ERR(cryptd_tfm);
 	ctx->cryptd_tfm = cryptd_tfm;
-- 
2.17.1

