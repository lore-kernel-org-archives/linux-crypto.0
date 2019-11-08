Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C55C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B147D22478
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215823;
	bh=T4heEJPa2ou6OJjGCekV+cvo56zfsPJAVYukw/5c0YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lcE+qYUkmpDw4hbrHhZ3eb7t0vzH8eFWeHCa2xYBN2JADhrYvh5/rafQQQFZ3MdiX
	 VKNCkEgFRP60A7H/qKsFbwuUiejdgTu+3m5WuisW/s3uDje/xi00p5aQs5VGtOwJtm
	 GQO2VyEVQi1P9+l8sQp5B7WZUlfpZb2tpJwJlx7I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbfKHMXn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKHMXn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:43 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C98422475;
        Fri,  8 Nov 2019 12:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215821;
        bh=T4heEJPa2ou6OJjGCekV+cvo56zfsPJAVYukw/5c0YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YN8XBJ0VrV48U9L7v+r8kDFY928hVtW+1ND1+nkJGgMJDXCo+XycKvA1dnImJcG/1
         ITyPaTnP3niGNjWIioJMDxua1u9C0nb9+YgO2riIOUKypzhuqlwTROZNnIDLOaJ1Ne
         TbB6uhC/WE2imtXgg9pObyu+R9uKjCv0ZkJmMpBI=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 14/34] crypto: x86/poly1305 - unify Poly1305 state struct with generic code
Date:   Fri,  8 Nov 2019 13:22:20 +0100
Message-Id: <20191108122240.28479-15-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation of exposing a Poly1305 library interface directly from
the accelerated x86 driver, align the state descriptor of the x86 code
with the one used by the generic driver. This is needed to make the
library interface unified between all implementations.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/poly1305_glue.c    | 88 +++++++-------------
 crypto/poly1305_generic.c          |  6 +-
 include/crypto/internal/poly1305.h |  4 +-
 include/crypto/poly1305.h          | 18 ++--
 4 files changed, 43 insertions(+), 73 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 6ccf8eb26324..b43b93c95e79 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -14,40 +14,14 @@
 #include <linux/module.h>
 #include <asm/simd.h>
 
-struct poly1305_simd_desc_ctx {
-	struct poly1305_desc_ctx base;
-	/* derived key u set? */
-	bool uset;
-#ifdef CONFIG_AS_AVX2
-	/* derived keys r^3, r^4 set? */
-	bool wset;
-#endif
-	/* derived Poly1305 key r^2 */
-	u32 u[5];
-	/* ... silently appended r^3 and r^4 when using AVX2 */
-};
-
 asmlinkage void poly1305_block_sse2(u32 *h, const u8 *src,
 				    const u32 *r, unsigned int blocks);
 asmlinkage void poly1305_2block_sse2(u32 *h, const u8 *src, const u32 *r,
 				     unsigned int blocks, const u32 *u);
-#ifdef CONFIG_AS_AVX2
 asmlinkage void poly1305_4block_avx2(u32 *h, const u8 *src, const u32 *r,
 				     unsigned int blocks, const u32 *u);
-static bool poly1305_use_avx2;
-#endif
 
-static int poly1305_simd_init(struct shash_desc *desc)
-{
-	struct poly1305_simd_desc_ctx *sctx = shash_desc_ctx(desc);
-
-	sctx->uset = false;
-#ifdef CONFIG_AS_AVX2
-	sctx->wset = false;
-#endif
-
-	return crypto_poly1305_init(desc);
-}
+static bool poly1305_use_avx2 __ro_after_init;
 
 static void poly1305_simd_mult(u32 *a, const u32 *b)
 {
@@ -63,53 +37,49 @@ static void poly1305_simd_mult(u32 *a, const u32 *b)
 static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 					 const u8 *src, unsigned int srclen)
 {
-	struct poly1305_simd_desc_ctx *sctx;
 	unsigned int blocks, datalen;
 
-	BUILD_BUG_ON(offsetof(struct poly1305_simd_desc_ctx, base));
-	sctx = container_of(dctx, struct poly1305_simd_desc_ctx, base);
-
 	if (unlikely(!dctx->sset)) {
 		datalen = crypto_poly1305_setdesckey(dctx, src, srclen);
 		src += srclen - datalen;
 		srclen = datalen;
 	}
 
-#ifdef CONFIG_AS_AVX2
-	if (poly1305_use_avx2 && srclen >= POLY1305_BLOCK_SIZE * 4) {
-		if (unlikely(!sctx->wset)) {
-			if (!sctx->uset) {
-				memcpy(sctx->u, dctx->r.r, sizeof(sctx->u));
-				poly1305_simd_mult(sctx->u, dctx->r.r);
-				sctx->uset = true;
+	if (IS_ENABLED(CONFIG_AS_AVX2) &&
+	    poly1305_use_avx2 &&
+	    srclen >= POLY1305_BLOCK_SIZE * 4) {
+		if (unlikely(dctx->rset < 4)) {
+			if (dctx->rset < 2) {
+				dctx->r[1] = dctx->r[0];
+				poly1305_simd_mult(dctx->r[1].r, dctx->r[0].r);
 			}
-			memcpy(sctx->u + 5, sctx->u, sizeof(sctx->u));
-			poly1305_simd_mult(sctx->u + 5, dctx->r.r);
-			memcpy(sctx->u + 10, sctx->u + 5, sizeof(sctx->u));
-			poly1305_simd_mult(sctx->u + 10, dctx->r.r);
-			sctx->wset = true;
+			dctx->r[2] = dctx->r[1];
+			poly1305_simd_mult(dctx->r[2].r, dctx->r[0].r);
+			dctx->r[3] = dctx->r[2];
+			poly1305_simd_mult(dctx->r[3].r, dctx->r[0].r);
+			dctx->rset = 4;
 		}
 		blocks = srclen / (POLY1305_BLOCK_SIZE * 4);
-		poly1305_4block_avx2(dctx->h.h, src, dctx->r.r, blocks,
-				     sctx->u);
+		poly1305_4block_avx2(dctx->h.h, src, dctx->r[0].r, blocks,
+				     dctx->r[1].r);
 		src += POLY1305_BLOCK_SIZE * 4 * blocks;
 		srclen -= POLY1305_BLOCK_SIZE * 4 * blocks;
 	}
-#endif
+
 	if (likely(srclen >= POLY1305_BLOCK_SIZE * 2)) {
-		if (unlikely(!sctx->uset)) {
-			memcpy(sctx->u, dctx->r.r, sizeof(sctx->u));
-			poly1305_simd_mult(sctx->u, dctx->r.r);
-			sctx->uset = true;
+		if (unlikely(dctx->rset < 2)) {
+			dctx->r[1] = dctx->r[0];
+			poly1305_simd_mult(dctx->r[1].r, dctx->r[0].r);
+			dctx->rset = 2;
 		}
 		blocks = srclen / (POLY1305_BLOCK_SIZE * 2);
-		poly1305_2block_sse2(dctx->h.h, src, dctx->r.r, blocks,
-				     sctx->u);
+		poly1305_2block_sse2(dctx->h.h, src, dctx->r[0].r,
+				     blocks, dctx->r[1].r);
 		src += POLY1305_BLOCK_SIZE * 2 * blocks;
 		srclen -= POLY1305_BLOCK_SIZE * 2 * blocks;
 	}
 	if (srclen >= POLY1305_BLOCK_SIZE) {
-		poly1305_block_sse2(dctx->h.h, src, dctx->r.r, 1);
+		poly1305_block_sse2(dctx->h.h, src, dctx->r[0].r, 1);
 		srclen -= POLY1305_BLOCK_SIZE;
 	}
 	return srclen;
@@ -159,10 +129,10 @@ static int poly1305_simd_update(struct shash_desc *desc,
 
 static struct shash_alg alg = {
 	.digestsize	= POLY1305_DIGEST_SIZE,
-	.init		= poly1305_simd_init,
+	.init		= crypto_poly1305_init,
 	.update		= poly1305_simd_update,
 	.final		= crypto_poly1305_final,
-	.descsize	= sizeof(struct poly1305_simd_desc_ctx),
+	.descsize	= sizeof(struct poly1305_desc_ctx),
 	.base		= {
 		.cra_name		= "poly1305",
 		.cra_driver_name	= "poly1305-simd",
@@ -177,14 +147,14 @@ static int __init poly1305_simd_mod_init(void)
 	if (!boot_cpu_has(X86_FEATURE_XMM2))
 		return -ENODEV;
 
-#ifdef CONFIG_AS_AVX2
-	poly1305_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
+	poly1305_use_avx2 = IS_ENABLED(CONFIG_AS_AVX2) &&
+			    boot_cpu_has(X86_FEATURE_AVX) &&
 			    boot_cpu_has(X86_FEATURE_AVX2) &&
 			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
-	alg.descsize = sizeof(struct poly1305_simd_desc_ctx);
+	alg.descsize = sizeof(struct poly1305_desc_ctx) + 5 * sizeof(u32);
 	if (poly1305_use_avx2)
 		alg.descsize += 10 * sizeof(u32);
-#endif
+
 	return crypto_register_shash(&alg);
 }
 
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index 067f493c2504..f3fcd9578a47 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -25,7 +25,7 @@ int crypto_poly1305_init(struct shash_desc *desc)
 
 	poly1305_core_init(&dctx->h);
 	dctx->buflen = 0;
-	dctx->rset = false;
+	dctx->rset = 0;
 	dctx->sset = false;
 
 	return 0;
@@ -43,7 +43,7 @@ static void poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
 		srclen = datalen;
 	}
 
-	poly1305_core_blocks(&dctx->h, &dctx->r, src,
+	poly1305_core_blocks(&dctx->h, dctx->r, src,
 			     srclen / POLY1305_BLOCK_SIZE, 1);
 }
 
@@ -95,7 +95,7 @@ int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
 		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_core_blocks(&dctx->h, &dctx->r, dctx->buf, 1, 0);
+		poly1305_core_blocks(&dctx->h, dctx->r, dctx->buf, 1, 0);
 	}
 
 	poly1305_core_emit(&dctx->h, digest);
diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
index cb58e61f73a7..04fa269e5534 100644
--- a/include/crypto/internal/poly1305.h
+++ b/include/crypto/internal/poly1305.h
@@ -46,10 +46,10 @@ unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
 {
 	if (!dctx->sset) {
 		if (!dctx->rset && srclen >= POLY1305_BLOCK_SIZE) {
-			poly1305_core_setkey(&dctx->r, src);
+			poly1305_core_setkey(dctx->r, src);
 			src += POLY1305_BLOCK_SIZE;
 			srclen -= POLY1305_BLOCK_SIZE;
-			dctx->rset = true;
+			dctx->rset = 1;
 		}
 		if (srclen >= POLY1305_BLOCK_SIZE) {
 			dctx->s[0] = get_unaligned_le32(src +  0);
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index f5a4319c2a1f..36b5886cb50c 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -22,20 +22,20 @@ struct poly1305_state {
 };
 
 struct poly1305_desc_ctx {
-	/* key */
-	struct poly1305_key r;
-	/* finalize key */
-	u32 s[4];
-	/* accumulator */
-	struct poly1305_state h;
 	/* partial buffer */
 	u8 buf[POLY1305_BLOCK_SIZE];
 	/* bytes used in partial buffer */
 	unsigned int buflen;
-	/* r key has been set */
-	bool rset;
-	/* s key has been set */
+	/* how many keys have been set in r[] */
+	unsigned short rset;
+	/* whether s[] has been set */
 	bool sset;
+	/* finalize key */
+	u32 s[4];
+	/* accumulator */
+	struct poly1305_state h;
+	/* key */
+	struct poly1305_key r[1];
 };
 
 #endif
-- 
2.20.1

