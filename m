Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155F6C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9A1020684
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J5DbI/pv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439236AbfFLMtN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:49:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55494 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439231AbfFLMtM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:49:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so6430396wmj.5
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0vLqup8kXDSW4TBicl2CoUwy3k2oxTX/PfRrsOfcNio=;
        b=J5DbI/pva0+dCmUWVpXPhHY0jfiBrCLM4KEPpXNN2Cu51rLrZtYdu4RhvzX3xwY8fn
         VbkNxZuqFCNMler5SD2SFukanJJuSv0ghBfgXYnMs3fmhHnW6qPyJuJO/vrn1qweZVzh
         64WHUwVG7/HOfYwWQgxZ/sFb+t733e16TS/CLti/ZE9f6/RFp8MoZcYr7NZt+0AAfKdw
         IyW4irDY8mD3VgINCyjgrFXgaaMUoMHpRo8+uG33ewigb3TMrf1rN1P6X+9VaJv924UC
         3/ku+qvDm0GtGUhhbIGFeV6JWZSBznWRrimuK37R49ZOwjy53rsJufqcAer7KyajAdgC
         ik6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0vLqup8kXDSW4TBicl2CoUwy3k2oxTX/PfRrsOfcNio=;
        b=N+JSSMn6xHqySztRCW4O9ln4yKPVRsOhk4ZlkuzabUdee8WQKp9VAn03/4IIFpDiFg
         NVUGoMDLqGkEmDWJvFeShGhBks6B2L2+8UUgwwC/9PK30J10KDnstnnUkDwzp03bBRSX
         HCv7b0R/3ibiMt6WM7fQOadox57zTAQ3Kl+pmpHGn2IbEsWo4j/CXEm5lR7Zzx7b4ZF9
         gd7VAGXf8PVgVFqHeKy38bAGggngjpYjxTzzJSFOU+vRtMASh7511vvzJBtDriAqpMu7
         6MKq8Yz/WH/McQbdUN+4SqRo/u1UOQPnsK8SVnB+tXOoyJUyNW6n5qY31iQIvOjTaKfG
         AX1w==
X-Gm-Message-State: APjAAAU7LewYhLLH/T+4mYGTvTWlZvmU6iA00oj/hwyH/PLSkmNIcFYv
        1yhAW8qHkNbYJzq7LHa+s01sQ4eLS22Now==
X-Google-Smtp-Source: APXvYqx9Envz8rgJkYR+dgguiKwX3gKeJmW4O+xI4lQnO9InG/KtPMaQAaZMC40HXdxFA7PCWlmEGQ==
X-Received: by 2002:a05:600c:23d2:: with SMTP id p18mr21442037wmb.108.1560343750560;
        Wed, 12 Jun 2019 05:49:10 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.49.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:49:09 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 20/20] crypto: arm/ghash - provide a synchronous version
Date:   Wed, 12 Jun 2019 14:48:38 +0200
Message-Id: <20190612124838.2492-21-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.20.1

