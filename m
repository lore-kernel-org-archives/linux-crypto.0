Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76526C352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3149621D80
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i07ParzK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfJBORx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:17:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44302 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfJBORx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id z9so6742989wrl.11
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gHZGL+RN2oWzjPqulY+KkZbyfPGdppAbxiMEvhApVKA=;
        b=i07ParzKuYtAi9FsL/Vhamr3Rh1ZKjQH26TnH0Nu7786cztUYDlTbF0pKHsuVIf/si
         QKMJPdiT34XtoTHQyNXtnGykN3sBm84ietTUp7j5gtElPVsvoyTU6w+piRKIitNbENkG
         QrPoRcliNWEL4eDGP7IGc2+u7J3ezHWDJO7gRj5eW2RTEsdQEwxOAQxkVAijBnADOfs/
         zkKKy6x7XS93H5+d/J4r6MownEDnlJAnHvvyZFZdub6G/hY+HAsNuswKUFRrhmxHWCm/
         1Gy5f5QjbjQpoQXO2HnMrXV6gE4mPHVZdyEPlof9D35WDnQy8T+/HoghdycZXxYH4Bqm
         iezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gHZGL+RN2oWzjPqulY+KkZbyfPGdppAbxiMEvhApVKA=;
        b=hslKh3xXfT1NB/nxFFp3ftV2qzCV9mMg0vY6N9Sd8m4/OJHfuyhOErILWE+AKqaxKk
         e/yvuQxq/32n39XI4UvEIR7afYZmAC+6yWXY01Ajn+SY8sx3rQuDswxz2vqa1NyPNFTG
         qMK0p6GT/eb1/ghgX5I7wa1app6X/IyaSFUBsZdgZKDnFdgc3xtyG9zSb8Hjm/Wgihpf
         +Ns3MtmnEwFdZjSUZrJ+oHNfk/93SlIaqOYr0Mjf7nJEv/wmUmEhVf8yHtQTggJnC6on
         ZZajR4HeQq9CiZVgK47n008fKRlNSeIIB2lCpbo0VSSMV/JiWREYMA+QYGNP3VTxFw0U
         2iBw==
X-Gm-Message-State: APjAAAVH0PtnPknp1kUh5EYtU3vrOM7Fk8PkyL1dVK344/wQgLUD8kdg
        KlzO0aBPtdPD/91DBXfoJHuItn4Sms6fTHV2
X-Google-Smtp-Source: APXvYqxinlBzErgsweC+iPbfeUoRAABWiFTS0JzWZa02rZM/hMouKqVW7pWLim7d6LA7oT9nij4yvQ==
X-Received: by 2002:a5d:6647:: with SMTP id f7mr3024768wrw.170.1570025867224;
        Wed, 02 Oct 2019 07:17:47 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 06/20] crypto: poly1305 - move into lib/crypto and refactor into library
Date:   Wed,  2 Oct 2019 16:16:59 +0200
Message-Id: <20191002141713.31189-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move the core Poly1305 transformation into a separate library in
lib/crypto so it can be used by other subsystems without going
through the entire crypto API. Also, expose the usual init, update
and final routines as library functions so that the transformation
can be invoked without going through the crypto API.

Also, add the plumbing that permits the library routine entrypoints to
be superseded by per-arch accelerated versions. This will be used in
subsequent patches to expose the crypto API implementations via the
library interface as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/poly1305_glue.c    |  90 +++----
 crypto/Kconfig                     |  11 +
 crypto/adiantum.c                  |   5 +-
 crypto/nhpoly1305.c                |   3 +-
 crypto/poly1305_generic.c          | 196 +---------------
 include/crypto/internal/poly1305.h |  45 ++++
 include/crypto/poly1305.h          |  43 +---
 lib/crypto/Makefile                |   3 +
 lib/crypto/poly1305.c              | 248 ++++++++++++++++++++
 9 files changed, 368 insertions(+), 276 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 4a1c05dce950..b43b93c95e79 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -7,47 +7,21 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/poly1305.h>
 #include <crypto/internal/simd.h>
-#include <crypto/poly1305.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
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
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 43e94ac5d117..88b1d0d20090 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -682,9 +682,20 @@ config CRYPTO_GHASH
 	  GHASH is the hash function used in GCM (Galois/Counter Mode).
 	  It is not a general-purpose cryptographic hash function.
 
+config CRYPTO_ARCH_HAVE_LIB_POLY1305
+	bool
+
+config CRYPTO_LIB_POLY1305_RSIZE
+	int
+	default 1
+
+config CRYPTO_LIB_POLY1305
+	tristate
+
 config CRYPTO_POLY1305
 	tristate "Poly1305 authenticator algorithm"
 	select CRYPTO_HASH
+	select CRYPTO_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm, RFC7539.
 
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 395a3ddd3707..aded26092268 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -33,6 +33,7 @@
 #include <crypto/b128ops.h>
 #include <crypto/chacha.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/poly1305.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/nhpoly1305.h>
 #include <crypto/scatterwalk.h>
@@ -242,11 +243,11 @@ static void adiantum_hash_header(struct skcipher_request *req)
 
 	BUILD_BUG_ON(sizeof(header) % POLY1305_BLOCK_SIZE != 0);
 	poly1305_core_blocks(&state, &tctx->header_hash_key,
-			     &header, sizeof(header) / POLY1305_BLOCK_SIZE);
+			     &header, sizeof(header) / POLY1305_BLOCK_SIZE, 1);
 
 	BUILD_BUG_ON(TWEAK_SIZE % POLY1305_BLOCK_SIZE != 0);
 	poly1305_core_blocks(&state, &tctx->header_hash_key, req->iv,
-			     TWEAK_SIZE / POLY1305_BLOCK_SIZE);
+			     TWEAK_SIZE / POLY1305_BLOCK_SIZE, 1);
 
 	poly1305_core_emit(&state, &rctx->header_hash);
 }
diff --git a/crypto/nhpoly1305.c b/crypto/nhpoly1305.c
index 9ab4e07cde4d..f6b6a52092b4 100644
--- a/crypto/nhpoly1305.c
+++ b/crypto/nhpoly1305.c
@@ -33,6 +33,7 @@
 #include <asm/unaligned.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/poly1305.h>
 #include <crypto/nhpoly1305.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
@@ -78,7 +79,7 @@ static void process_nh_hash_value(struct nhpoly1305_state *state,
 	BUILD_BUG_ON(NH_HASH_BYTES % POLY1305_BLOCK_SIZE != 0);
 
 	poly1305_core_blocks(&state->poly_state, &key->poly_key, state->nh_hash,
-			     NH_HASH_BYTES / POLY1305_BLOCK_SIZE);
+			     NH_HASH_BYTES / POLY1305_BLOCK_SIZE, 1);
 }
 
 /*
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index adc40298c749..35fdb35c1188 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -13,51 +13,25 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
-#include <crypto/poly1305.h>
+#include <crypto/internal/poly1305.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/unaligned.h>
 
-static inline u64 mlt(u64 a, u64 b)
-{
-	return a * b;
-}
-
-static inline u32 sr(u64 v, u_char n)
-{
-	return v >> n;
-}
-
-static inline u32 and(u32 v, u32 mask)
-{
-	return v & mask;
-}
-
 int crypto_poly1305_init(struct shash_desc *desc)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
 	poly1305_core_init(&dctx->h);
 	dctx->buflen = 0;
-	dctx->rset = false;
+	dctx->rset = 0;
 	dctx->sset = false;
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_poly1305_init);
 
-void poly1305_core_setkey(struct poly1305_key *key, const u8 *raw_key)
-{
-	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
-	key->r[0] = (get_unaligned_le32(raw_key +  0) >> 0) & 0x3ffffff;
-	key->r[1] = (get_unaligned_le32(raw_key +  3) >> 2) & 0x3ffff03;
-	key->r[2] = (get_unaligned_le32(raw_key +  6) >> 4) & 0x3ffc0ff;
-	key->r[3] = (get_unaligned_le32(raw_key +  9) >> 6) & 0x3f03fff;
-	key->r[4] = (get_unaligned_le32(raw_key + 12) >> 8) & 0x00fffff;
-}
-EXPORT_SYMBOL_GPL(poly1305_core_setkey);
-
 /*
  * Poly1305 requires a unique key for each tag, which implies that we can't set
  * it on the tfm that gets accessed by multiple users simultaneously. Instead we
@@ -68,10 +42,10 @@ unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
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
@@ -87,84 +61,8 @@ unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
 }
 EXPORT_SYMBOL_GPL(crypto_poly1305_setdesckey);
 
-static void poly1305_blocks_internal(struct poly1305_state *state,
-				     const struct poly1305_key *key,
-				     const void *src, unsigned int nblocks,
-				     u32 hibit)
-{
-	u32 r0, r1, r2, r3, r4;
-	u32 s1, s2, s3, s4;
-	u32 h0, h1, h2, h3, h4;
-	u64 d0, d1, d2, d3, d4;
-
-	if (!nblocks)
-		return;
-
-	r0 = key->r[0];
-	r1 = key->r[1];
-	r2 = key->r[2];
-	r3 = key->r[3];
-	r4 = key->r[4];
-
-	s1 = r1 * 5;
-	s2 = r2 * 5;
-	s3 = r3 * 5;
-	s4 = r4 * 5;
-
-	h0 = state->h[0];
-	h1 = state->h[1];
-	h2 = state->h[2];
-	h3 = state->h[3];
-	h4 = state->h[4];
-
-	do {
-		/* h += m[i] */
-		h0 += (get_unaligned_le32(src +  0) >> 0) & 0x3ffffff;
-		h1 += (get_unaligned_le32(src +  3) >> 2) & 0x3ffffff;
-		h2 += (get_unaligned_le32(src +  6) >> 4) & 0x3ffffff;
-		h3 += (get_unaligned_le32(src +  9) >> 6) & 0x3ffffff;
-		h4 += (get_unaligned_le32(src + 12) >> 8) | hibit;
-
-		/* h *= r */
-		d0 = mlt(h0, r0) + mlt(h1, s4) + mlt(h2, s3) +
-		     mlt(h3, s2) + mlt(h4, s1);
-		d1 = mlt(h0, r1) + mlt(h1, r0) + mlt(h2, s4) +
-		     mlt(h3, s3) + mlt(h4, s2);
-		d2 = mlt(h0, r2) + mlt(h1, r1) + mlt(h2, r0) +
-		     mlt(h3, s4) + mlt(h4, s3);
-		d3 = mlt(h0, r3) + mlt(h1, r2) + mlt(h2, r1) +
-		     mlt(h3, r0) + mlt(h4, s4);
-		d4 = mlt(h0, r4) + mlt(h1, r3) + mlt(h2, r2) +
-		     mlt(h3, r1) + mlt(h4, r0);
-
-		/* (partial) h %= p */
-		d1 += sr(d0, 26);     h0 = and(d0, 0x3ffffff);
-		d2 += sr(d1, 26);     h1 = and(d1, 0x3ffffff);
-		d3 += sr(d2, 26);     h2 = and(d2, 0x3ffffff);
-		d4 += sr(d3, 26);     h3 = and(d3, 0x3ffffff);
-		h0 += sr(d4, 26) * 5; h4 = and(d4, 0x3ffffff);
-		h1 += h0 >> 26;       h0 = h0 & 0x3ffffff;
-
-		src += POLY1305_BLOCK_SIZE;
-	} while (--nblocks);
-
-	state->h[0] = h0;
-	state->h[1] = h1;
-	state->h[2] = h2;
-	state->h[3] = h3;
-	state->h[4] = h4;
-}
-
-void poly1305_core_blocks(struct poly1305_state *state,
-			  const struct poly1305_key *key,
-			  const void *src, unsigned int nblocks)
-{
-	poly1305_blocks_internal(state, key, src, nblocks, 1 << 24);
-}
-EXPORT_SYMBOL_GPL(poly1305_core_blocks);
-
-static void poly1305_blocks(struct poly1305_desc_ctx *dctx,
-			    const u8 *src, unsigned int srclen, u32 hibit)
+static void poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
+			    unsigned int srclen)
 {
 	unsigned int datalen;
 
@@ -174,14 +72,14 @@ static void poly1305_blocks(struct poly1305_desc_ctx *dctx,
 		srclen = datalen;
 	}
 
-	poly1305_blocks_internal(&dctx->h, &dctx->r,
-				 src, srclen / POLY1305_BLOCK_SIZE, hibit);
+	poly1305_core_blocks(&dctx->h, dctx->r, src,
+			     srclen / POLY1305_BLOCK_SIZE, 1);
 }
 
-int crypto_poly1305_update(struct shash_desc *desc,
+int crypto_poly1305_update(struct shash_desc *shash_desc,
 			   const u8 *src, unsigned int srclen)
 {
-	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(shash_desc);
 	unsigned int bytes;
 
 	if (unlikely(dctx->buflen)) {
@@ -193,13 +91,13 @@ int crypto_poly1305_update(struct shash_desc *desc,
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
 			poly1305_blocks(dctx, dctx->buf,
-					POLY1305_BLOCK_SIZE, 1 << 24);
+					POLY1305_BLOCK_SIZE);
 			dctx->buflen = 0;
 		}
 	}
 
 	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		poly1305_blocks(dctx, src, srclen, 1 << 24);
+		poly1305_blocks(dctx, src, srclen);
 		src += srclen - (srclen % POLY1305_BLOCK_SIZE);
 		srclen %= POLY1305_BLOCK_SIZE;
 	}
@@ -213,82 +111,14 @@ int crypto_poly1305_update(struct shash_desc *desc,
 }
 EXPORT_SYMBOL_GPL(crypto_poly1305_update);
 
-void poly1305_core_emit(const struct poly1305_state *state, void *dst)
-{
-	u32 h0, h1, h2, h3, h4;
-	u32 g0, g1, g2, g3, g4;
-	u32 mask;
-
-	/* fully carry h */
-	h0 = state->h[0];
-	h1 = state->h[1];
-	h2 = state->h[2];
-	h3 = state->h[3];
-	h4 = state->h[4];
-
-	h2 += (h1 >> 26);     h1 = h1 & 0x3ffffff;
-	h3 += (h2 >> 26);     h2 = h2 & 0x3ffffff;
-	h4 += (h3 >> 26);     h3 = h3 & 0x3ffffff;
-	h0 += (h4 >> 26) * 5; h4 = h4 & 0x3ffffff;
-	h1 += (h0 >> 26);     h0 = h0 & 0x3ffffff;
-
-	/* compute h + -p */
-	g0 = h0 + 5;
-	g1 = h1 + (g0 >> 26);             g0 &= 0x3ffffff;
-	g2 = h2 + (g1 >> 26);             g1 &= 0x3ffffff;
-	g3 = h3 + (g2 >> 26);             g2 &= 0x3ffffff;
-	g4 = h4 + (g3 >> 26) - (1 << 26); g3 &= 0x3ffffff;
-
-	/* select h if h < p, or h + -p if h >= p */
-	mask = (g4 >> ((sizeof(u32) * 8) - 1)) - 1;
-	g0 &= mask;
-	g1 &= mask;
-	g2 &= mask;
-	g3 &= mask;
-	g4 &= mask;
-	mask = ~mask;
-	h0 = (h0 & mask) | g0;
-	h1 = (h1 & mask) | g1;
-	h2 = (h2 & mask) | g2;
-	h3 = (h3 & mask) | g3;
-	h4 = (h4 & mask) | g4;
-
-	/* h = h % (2^128) */
-	put_unaligned_le32((h0 >>  0) | (h1 << 26), dst +  0);
-	put_unaligned_le32((h1 >>  6) | (h2 << 20), dst +  4);
-	put_unaligned_le32((h2 >> 12) | (h3 << 14), dst +  8);
-	put_unaligned_le32((h3 >> 18) | (h4 <<  8), dst + 12);
-}
-EXPORT_SYMBOL_GPL(poly1305_core_emit);
-
 int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	__le32 digest[4];
-	u64 f = 0;
 
 	if (unlikely(!dctx->sset))
 		return -ENOKEY;
 
-	if (unlikely(dctx->buflen)) {
-		dctx->buf[dctx->buflen++] = 1;
-		memset(dctx->buf + dctx->buflen, 0,
-		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks(dctx, dctx->buf, POLY1305_BLOCK_SIZE, 0);
-	}
-
-	poly1305_core_emit(&dctx->h, digest);
-
-	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + le32_to_cpu(digest[0]) + dctx->s[0];
-	put_unaligned_le32(f, dst + 0);
-	f = (f >> 32) + le32_to_cpu(digest[1]) + dctx->s[1];
-	put_unaligned_le32(f, dst + 4);
-	f = (f >> 32) + le32_to_cpu(digest[2]) + dctx->s[2];
-	put_unaligned_le32(f, dst + 8);
-	f = (f >> 32) + le32_to_cpu(digest[3]) + dctx->s[3];
-	put_unaligned_le32(f, dst + 12);
-
+	poly1305_final_generic(dctx, dst);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_poly1305_final);
diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
new file mode 100644
index 000000000000..e819df14bb78
--- /dev/null
+++ b/include/crypto/internal/poly1305.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common values for the Poly1305 algorithm
+ */
+
+#ifndef _CRYPTO_INTERNAL_POLY1305_H
+#define _CRYPTO_INTERNAL_POLY1305_H
+
+#include <linux/types.h>
+#include <crypto/poly1305.h>
+
+struct shash_desc;
+
+/*
+ * Poly1305 core functions.  These implement the ε-almost-∆-universal hash
+ * function underlying the Poly1305 MAC, i.e. they don't add an encrypted nonce
+ * ("s key") at the end.  They also only support block-aligned inputs.
+ */
+void poly1305_core_setkey(struct poly1305_key *key, const u8 *raw_key);
+static inline void poly1305_core_init(struct poly1305_state *state)
+{
+	*state = (struct poly1305_state){};
+}
+
+void poly1305_core_blocks(struct poly1305_state *state,
+			  const struct poly1305_key *key, const void *src,
+			  unsigned int nblocks, u32 hibit);
+void poly1305_core_emit(const struct poly1305_state *state, void *dst);
+
+void poly1305_init_generic(struct poly1305_desc_ctx *desc, const u8 *key);
+
+void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
+			     unsigned int nbytes);
+
+void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *digest);
+
+/* Crypto API helper functions for the Poly1305 MAC */
+int crypto_poly1305_init(struct shash_desc *desc);
+unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
+					const u8 *src, unsigned int srclen);
+int crypto_poly1305_update(struct shash_desc *desc,
+			   const u8 *src, unsigned int srclen);
+int crypto_poly1305_final(struct shash_desc *desc, u8 *dst);
+
+#endif
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index 34317ed2071e..39afea016ac3 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -22,43 +22,26 @@ struct poly1305_state {
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
+	struct poly1305_key r[CONFIG_CRYPTO_LIB_POLY1305_RSIZE];
 };
 
-/*
- * Poly1305 core functions.  These implement the ε-almost-∆-universal hash
- * function underlying the Poly1305 MAC, i.e. they don't add an encrypted nonce
- * ("s key") at the end.  They also only support block-aligned inputs.
- */
-void poly1305_core_setkey(struct poly1305_key *key, const u8 *raw_key);
-static inline void poly1305_core_init(struct poly1305_state *state)
-{
-	memset(state->h, 0, sizeof(state->h));
-}
-void poly1305_core_blocks(struct poly1305_state *state,
-			  const struct poly1305_key *key,
-			  const void *src, unsigned int nblocks);
-void poly1305_core_emit(const struct poly1305_state *state, void *dst);
+void poly1305_init(struct poly1305_desc_ctx *desc, const u8 *key);
 
-/* Crypto API helper functions for the Poly1305 MAC */
-int crypto_poly1305_init(struct shash_desc *desc);
-unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
-					const u8 *src, unsigned int srclen);
-int crypto_poly1305_update(struct shash_desc *desc,
-			   const u8 *src, unsigned int srclen);
-int crypto_poly1305_final(struct shash_desc *desc, u8 *dst);
+void poly1305_update(struct poly1305_desc_ctx *desc, const u8 *src,
+		     unsigned int nbytes);
+void poly1305_final(struct poly1305_desc_ctx *desc, u8 *digest);
 
 #endif
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index e5c131bc75cc..97450d92a899 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -13,5 +13,8 @@ libarc4-y					:= arc4.o
 obj-$(CONFIG_CRYPTO_LIB_DES)			+= libdes.o
 libdes-y					:= des.o
 
+obj-$(CONFIG_CRYPTO_LIB_POLY1305)		+= libpoly1305.o
+libpoly1305-y					:= poly1305.o
+
 obj-$(CONFIG_CRYPTO_LIB_SHA256)			+= libsha256.o
 libsha256-y					:= sha256.o
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
new file mode 100644
index 000000000000..b2fd5e5ba72e
--- /dev/null
+++ b/lib/crypto/poly1305.c
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Poly1305 authenticator algorithm, RFC7539
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * Based on public domain code by Andrew Moon and Daniel J. Bernstein.
+ */
+
+#include <crypto/internal/poly1305.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/unaligned.h>
+
+static inline u64 mlt(u64 a, u64 b)
+{
+	return a * b;
+}
+
+static inline u32 sr(u64 v, u_char n)
+{
+	return v >> n;
+}
+
+static inline u32 and(u32 v, u32 mask)
+{
+	return v & mask;
+}
+
+void poly1305_core_setkey(struct poly1305_key *key, const u8 *raw_key)
+{
+	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
+	key->r[0] = (get_unaligned_le32(raw_key +  0) >> 0) & 0x3ffffff;
+	key->r[1] = (get_unaligned_le32(raw_key +  3) >> 2) & 0x3ffff03;
+	key->r[2] = (get_unaligned_le32(raw_key +  6) >> 4) & 0x3ffc0ff;
+	key->r[3] = (get_unaligned_le32(raw_key +  9) >> 6) & 0x3f03fff;
+	key->r[4] = (get_unaligned_le32(raw_key + 12) >> 8) & 0x00fffff;
+}
+EXPORT_SYMBOL_GPL(poly1305_core_setkey);
+
+void poly1305_core_blocks(struct poly1305_state *state,
+			  const struct poly1305_key *key, const void *src,
+			  unsigned int nblocks, u32 hibit)
+{
+	u32 r0, r1, r2, r3, r4;
+	u32 s1, s2, s3, s4;
+	u32 h0, h1, h2, h3, h4;
+	u64 d0, d1, d2, d3, d4;
+
+	if (!nblocks)
+		return;
+
+	r0 = key->r[0];
+	r1 = key->r[1];
+	r2 = key->r[2];
+	r3 = key->r[3];
+	r4 = key->r[4];
+
+	s1 = r1 * 5;
+	s2 = r2 * 5;
+	s3 = r3 * 5;
+	s4 = r4 * 5;
+
+	h0 = state->h[0];
+	h1 = state->h[1];
+	h2 = state->h[2];
+	h3 = state->h[3];
+	h4 = state->h[4];
+
+	do {
+		/* h += m[i] */
+		h0 += (get_unaligned_le32(src +  0) >> 0) & 0x3ffffff;
+		h1 += (get_unaligned_le32(src +  3) >> 2) & 0x3ffffff;
+		h2 += (get_unaligned_le32(src +  6) >> 4) & 0x3ffffff;
+		h3 += (get_unaligned_le32(src +  9) >> 6) & 0x3ffffff;
+		h4 += (get_unaligned_le32(src + 12) >> 8) | (hibit << 24);
+
+		/* h *= r */
+		d0 = mlt(h0, r0) + mlt(h1, s4) + mlt(h2, s3) +
+		     mlt(h3, s2) + mlt(h4, s1);
+		d1 = mlt(h0, r1) + mlt(h1, r0) + mlt(h2, s4) +
+		     mlt(h3, s3) + mlt(h4, s2);
+		d2 = mlt(h0, r2) + mlt(h1, r1) + mlt(h2, r0) +
+		     mlt(h3, s4) + mlt(h4, s3);
+		d3 = mlt(h0, r3) + mlt(h1, r2) + mlt(h2, r1) +
+		     mlt(h3, r0) + mlt(h4, s4);
+		d4 = mlt(h0, r4) + mlt(h1, r3) + mlt(h2, r2) +
+		     mlt(h3, r1) + mlt(h4, r0);
+
+		/* (partial) h %= p */
+		d1 += sr(d0, 26);     h0 = and(d0, 0x3ffffff);
+		d2 += sr(d1, 26);     h1 = and(d1, 0x3ffffff);
+		d3 += sr(d2, 26);     h2 = and(d2, 0x3ffffff);
+		d4 += sr(d3, 26);     h3 = and(d3, 0x3ffffff);
+		h0 += sr(d4, 26) * 5; h4 = and(d4, 0x3ffffff);
+		h1 += h0 >> 26;       h0 = h0 & 0x3ffffff;
+
+		src += POLY1305_BLOCK_SIZE;
+	} while (--nblocks);
+
+	state->h[0] = h0;
+	state->h[1] = h1;
+	state->h[2] = h2;
+	state->h[3] = h3;
+	state->h[4] = h4;
+}
+EXPORT_SYMBOL_GPL(poly1305_core_blocks);
+
+void poly1305_core_emit(const struct poly1305_state *state, void *dst)
+{
+	u32 h0, h1, h2, h3, h4;
+	u32 g0, g1, g2, g3, g4;
+	u32 mask;
+
+	/* fully carry h */
+	h0 = state->h[0];
+	h1 = state->h[1];
+	h2 = state->h[2];
+	h3 = state->h[3];
+	h4 = state->h[4];
+
+	h2 += (h1 >> 26);     h1 = h1 & 0x3ffffff;
+	h3 += (h2 >> 26);     h2 = h2 & 0x3ffffff;
+	h4 += (h3 >> 26);     h3 = h3 & 0x3ffffff;
+	h0 += (h4 >> 26) * 5; h4 = h4 & 0x3ffffff;
+	h1 += (h0 >> 26);     h0 = h0 & 0x3ffffff;
+
+	/* compute h + -p */
+	g0 = h0 + 5;
+	g1 = h1 + (g0 >> 26);             g0 &= 0x3ffffff;
+	g2 = h2 + (g1 >> 26);             g1 &= 0x3ffffff;
+	g3 = h3 + (g2 >> 26);             g2 &= 0x3ffffff;
+	g4 = h4 + (g3 >> 26) - (1 << 26); g3 &= 0x3ffffff;
+
+	/* select h if h < p, or h + -p if h >= p */
+	mask = (g4 >> ((sizeof(u32) * 8) - 1)) - 1;
+	g0 &= mask;
+	g1 &= mask;
+	g2 &= mask;
+	g3 &= mask;
+	g4 &= mask;
+	mask = ~mask;
+	h0 = (h0 & mask) | g0;
+	h1 = (h1 & mask) | g1;
+	h2 = (h2 & mask) | g2;
+	h3 = (h3 & mask) | g3;
+	h4 = (h4 & mask) | g4;
+
+	/* h = h % (2^128) */
+	put_unaligned_le32((h0 >>  0) | (h1 << 26), dst +  0);
+	put_unaligned_le32((h1 >>  6) | (h2 << 20), dst +  4);
+	put_unaligned_le32((h2 >> 12) | (h3 << 14), dst +  8);
+	put_unaligned_le32((h3 >> 18) | (h4 <<  8), dst + 12);
+}
+EXPORT_SYMBOL_GPL(poly1305_core_emit);
+
+void poly1305_init_generic(struct poly1305_desc_ctx *desc, const u8 *key)
+{
+	poly1305_core_setkey(desc->r, key);
+	desc->s[0] = get_unaligned_le32(key + 16);
+	desc->s[1] = get_unaligned_le32(key + 20);
+	desc->s[2] = get_unaligned_le32(key + 24);
+	desc->s[3] = get_unaligned_le32(key + 28);
+	poly1305_core_init(&desc->h);
+	desc->buflen = 0;
+	desc->sset = true;
+	desc->rset = 1;
+}
+EXPORT_SYMBOL_GPL(poly1305_init_generic);
+
+void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
+			     unsigned int nbytes)
+{
+	unsigned int bytes;
+
+	if (unlikely(desc->buflen)) {
+		bytes = min(nbytes, POLY1305_BLOCK_SIZE - desc->buflen);
+		memcpy(desc->buf + desc->buflen, src, bytes);
+		src += bytes;
+		nbytes -= bytes;
+		desc->buflen += bytes;
+
+		if (desc->buflen == POLY1305_BLOCK_SIZE) {
+			poly1305_core_blocks(&desc->h, desc->r, desc->buf, 1, 1);
+			desc->buflen = 0;
+		}
+	}
+
+	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
+		poly1305_core_blocks(&desc->h, desc->r, src,
+				     nbytes / POLY1305_BLOCK_SIZE, 1);
+		src += nbytes - (nbytes % POLY1305_BLOCK_SIZE);
+		nbytes %= POLY1305_BLOCK_SIZE;
+	}
+
+	if (unlikely(nbytes)) {
+		desc->buflen = nbytes;
+		memcpy(desc->buf, src, nbytes);
+	}
+}
+EXPORT_SYMBOL_GPL(poly1305_update_generic);
+
+void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *dst)
+{
+	__le32 digest[4];
+	u64 f = 0;
+
+	if (unlikely(desc->buflen)) {
+		desc->buf[desc->buflen++] = 1;
+		memset(desc->buf + desc->buflen, 0,
+		       POLY1305_BLOCK_SIZE - desc->buflen);
+		poly1305_core_blocks(&desc->h, desc->r, desc->buf, 1, 0);
+	}
+
+	poly1305_core_emit(&desc->h, digest);
+
+	/* mac = (h + s) % (2^128) */
+	f = (f >> 32) + le32_to_cpu(digest[0]) + desc->s[0];
+	put_unaligned_le32(f, dst + 0);
+	f = (f >> 32) + le32_to_cpu(digest[1]) + desc->s[1];
+	put_unaligned_le32(f, dst + 4);
+	f = (f >> 32) + le32_to_cpu(digest[2]) + desc->s[2];
+	put_unaligned_le32(f, dst + 8);
+	f = (f >> 32) + le32_to_cpu(digest[3]) + desc->s[3];
+	put_unaligned_le32(f, dst + 12);
+
+	*desc = (struct poly1305_desc_ctx){};
+}
+EXPORT_SYMBOL_GPL(poly1305_final_generic);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
+
+extern void poly1305_init(struct poly1305_desc_ctx *desc, const u8 *key)
+	__weak __alias(poly1305_init_generic);
+
+extern void poly1305_update(struct poly1305_desc_ctx *desc, const u8 *src,
+			    unsigned int nbytes)
+	__weak __alias(poly1305_update_generic);
+
+extern void poly1305_final(struct poly1305_desc_ctx *desc, u8 *dst)
+	__weak __alias(poly1305_final_generic);
+
+#ifndef CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305
+EXPORT_SYMBOL_GPL(poly1305_init);
+EXPORT_SYMBOL_GPL(poly1305_update);
+EXPORT_SYMBOL_GPL(poly1305_final);
+#endif
-- 
2.20.1

