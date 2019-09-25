Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E14C4360D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B17B32146E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z8OuhkVl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbfIYQOF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:14:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37516 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387965AbfIYQOE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so7651833wro.4
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kSUfY6BEXBgm8PBl4NM38bq4FokXR/M8kMBF5SPnY6c=;
        b=z8OuhkVl6QAmyOjrvoADZg2g8ZZ/bTV/zZe0uz6H2zCwTuGSqzGinURbhc7gN4Qt6U
         EJXwo/vv7zQXtQT11EqcMj9fP2tIJC7yywEbI9J3SLLnBcdthlZxVl8BuaIlWbm6THek
         mIGaCgC7gh7xHoTZqmPirRtsSEVK65aMj76fLUXOUq1RiSMqMoaXtFGzl3barUwM845R
         4Ruc+RDx+ppcOWzR4e5DRfpVb4ixuwEOsvI9Kl2dl91jQ5rTWDsgUBK7xDuolrh9Mokc
         1cZ/4G/MxxVDzbEmSPxWXdsP1EMCdMHeHHrWJn/fAPiz22Uj7v0QRDdzR9QfthDOXmbU
         1OKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kSUfY6BEXBgm8PBl4NM38bq4FokXR/M8kMBF5SPnY6c=;
        b=tEN2Iqb/a+AjeiszXPGs3oclW+nAV1bhsCMndnqGXw5k3EE8cHLTau0kVqo6wLd1uL
         KwcoYG1SHP56Fx853vdbgXqMcJiC9C9OzE4y3mQyTSfpMW0Eqgq7RwvuNN52eDhnAB+H
         QtDUPl5Ijxl5tEr0PRw2uu8OLgWSjaKmcTDxFHoafagRJ7Try62a1XxW+7kunTT07MVP
         9++l4aakgMiCBwB/gooWUXkFBnzZncJWYlKOnCXjKmJ+lj8TQsIeyZbkqS6fp3Py61gu
         COW3YMIQBBznmIXYHKmrlwr8Ra3ibwdc8ldjW3ABgdu0cGbxh5LbJ/C02Ynbr0lmyuqf
         qrOw==
X-Gm-Message-State: APjAAAW3gLOkqk++mUXq/If5JhrYy3bRy5mOEc7BZ5v76q6saYq9+9YY
        E/Qci/rdopDEoqFapblWrvlxS8WTH4b8wrpt
X-Google-Smtp-Source: APXvYqyQZoCaMaVbtnCPbJVIleM5/XJDZjTPa6qND3Axok+ArgSJ7mXujP2VX/FI5Q6b+r/K1Ww8QQ==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr10339744wrv.248.1569428039638;
        Wed, 25 Sep 2019 09:13:59 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:13:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH 09/18] crypto: poly1305 - move core algorithm into lib/crypto
Date:   Wed, 25 Sep 2019 18:12:46 +0200
Message-Id: <20190925161255.1871-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move the core Poly1305 transformation into a separate library in
lib/crypto so it can be used by other subsystems without going
through the entire crypto API.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/poly1305_glue.c    |   2 +-
 crypto/Kconfig                     |   4 +
 crypto/adiantum.c                  |   4 +-
 crypto/nhpoly1305.c                |   2 +-
 crypto/poly1305_generic.c          | 167 +-------------------
 include/crypto/internal/poly1305.h |  37 +++++
 include/crypto/poly1305.h          |  32 +---
 lib/crypto/Makefile                |   3 +
 lib/crypto/poly1305.c              | 158 ++++++++++++++++++
 9 files changed, 217 insertions(+), 192 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index f2afaa8e23c2..9291cfea799d 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -7,8 +7,8 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/poly1305.h>
 #include <crypto/internal/simd.h>
-#include <crypto/poly1305.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 25a06cf49a5d..45589110bf80 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -654,9 +654,13 @@ config CRYPTO_GHASH
 	  GHASH is the hash function used in GCM (Galois/Counter Mode).
 	  It is not a general-purpose cryptographic hash function.
 
+config CRYPTO_LIB_POLY1305
+	tristate "Poly1305 authenticator library"
+
 config CRYPTO_POLY1305
 	tristate "Poly1305 authenticator algorithm"
 	select CRYPTO_HASH
+	select CRYPTO_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm, RFC7539.
 
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 395a3ddd3707..775ed1418e2b 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -242,11 +242,11 @@ static void adiantum_hash_header(struct skcipher_request *req)
 
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
index 9ab4e07cde4d..b88a6a71e3e2 100644
--- a/crypto/nhpoly1305.c
+++ b/crypto/nhpoly1305.c
@@ -78,7 +78,7 @@ static void process_nh_hash_value(struct nhpoly1305_state *state,
 	BUILD_BUG_ON(NH_HASH_BYTES % POLY1305_BLOCK_SIZE != 0);
 
 	poly1305_core_blocks(&state->poly_state, &key->poly_key, state->nh_hash,
-			     NH_HASH_BYTES / POLY1305_BLOCK_SIZE);
+			     NH_HASH_BYTES / POLY1305_BLOCK_SIZE, 1);
 }
 
 /*
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index adc40298c749..46a2da1abac7 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -13,27 +13,12 @@
 
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
@@ -47,17 +32,6 @@ int crypto_poly1305_init(struct shash_desc *desc)
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
 
@@ -174,8 +72,8 @@ static void poly1305_blocks(struct poly1305_desc_ctx *dctx,
 		srclen = datalen;
 	}
 
-	poly1305_blocks_internal(&dctx->h, &dctx->r,
-				 src, srclen / POLY1305_BLOCK_SIZE, hibit);
+	poly1305_core_blocks(&dctx->h, &dctx->r, src,
+			     srclen / POLY1305_BLOCK_SIZE, 1);
 }
 
 int crypto_poly1305_update(struct shash_desc *desc,
@@ -192,14 +90,13 @@ int crypto_poly1305_update(struct shash_desc *desc,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks(dctx, dctx->buf,
-					POLY1305_BLOCK_SIZE, 1 << 24);
+			poly1305_blocks(dctx, dctx->buf, POLY1305_BLOCK_SIZE);
 			dctx->buflen = 0;
 		}
 	}
 
 	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		poly1305_blocks(dctx, src, srclen, 1 << 24);
+		poly1305_blocks(dctx, src, srclen);
 		src += srclen - (srclen % POLY1305_BLOCK_SIZE);
 		srclen %= POLY1305_BLOCK_SIZE;
 	}
@@ -213,54 +110,6 @@ int crypto_poly1305_update(struct shash_desc *desc,
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
@@ -274,7 +123,7 @@ int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
 		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks(dctx, dctx->buf, POLY1305_BLOCK_SIZE, 0);
+		poly1305_core_blocks(&dctx->h, &dctx->r, dctx->buf, 1, 0);
 	}
 
 	poly1305_core_emit(&dctx->h, digest);
diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
new file mode 100644
index 000000000000..ae0466c4ce59
--- /dev/null
+++ b/include/crypto/internal/poly1305.h
@@ -0,0 +1,37 @@
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
+struct poly1305_desc_ctx {
+	/* key */
+	struct poly1305_key r;
+	/* finalize key */
+	u32 s[4];
+	/* accumulator */
+	struct poly1305_state h;
+	/* partial buffer */
+	u8 buf[POLY1305_BLOCK_SIZE];
+	/* bytes used in partial buffer */
+	unsigned int buflen;
+	/* r key has been set */
+	bool rset;
+	/* s key has been set */
+	bool sset;
+};
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
index 34317ed2071e..83e4b4c69a5a 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -21,23 +21,6 @@ struct poly1305_state {
 	u32 h[5];	/* accumulator, base 2^26 */
 };
 
-struct poly1305_desc_ctx {
-	/* key */
-	struct poly1305_key r;
-	/* finalize key */
-	u32 s[4];
-	/* accumulator */
-	struct poly1305_state h;
-	/* partial buffer */
-	u8 buf[POLY1305_BLOCK_SIZE];
-	/* bytes used in partial buffer */
-	unsigned int buflen;
-	/* r key has been set */
-	bool rset;
-	/* s key has been set */
-	bool sset;
-};
-
 /*
  * Poly1305 core functions.  These implement the ε-almost-∆-universal hash
  * function underlying the Poly1305 MAC, i.e. they don't add an encrypted nonce
@@ -46,19 +29,10 @@ struct poly1305_desc_ctx {
 void poly1305_core_setkey(struct poly1305_key *key, const u8 *raw_key);
 static inline void poly1305_core_init(struct poly1305_state *state)
 {
-	memset(state->h, 0, sizeof(state->h));
+	*state = (struct poly1305_state){};
 }
 void poly1305_core_blocks(struct poly1305_state *state,
-			  const struct poly1305_key *key,
-			  const void *src, unsigned int nblocks);
+			  const struct poly1305_key *key, const void *src,
+			  unsigned int nblocks, u32 hibit);
 void poly1305_core_emit(const struct poly1305_state *state, void *dst);
-
-/* Crypto API helper functions for the Poly1305 MAC */
-int crypto_poly1305_init(struct shash_desc *desc);
-unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
-					const u8 *src, unsigned int srclen);
-int crypto_poly1305_update(struct shash_desc *desc,
-			   const u8 *src, unsigned int srclen);
-int crypto_poly1305_final(struct shash_desc *desc, u8 *dst);
-
 #endif
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 24dad058f2ae..6bf8a0a4ee0e 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -12,5 +12,8 @@ libarc4-y					:= arc4.o
 obj-$(CONFIG_CRYPTO_LIB_DES)			+= libdes.o
 libdes-y					:= des.o
 
+obj-$(CONFIG_CRYPTO_LIB_POLY1305)		+= libpoly1305.o
+libpoly1305-y					:= poly1305.o
+
 obj-$(CONFIG_CRYPTO_LIB_SHA256)			+= libsha256.o
 libsha256-y					:= sha256.o
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
new file mode 100644
index 000000000000..abe6fccf7b9c
--- /dev/null
+++ b/lib/crypto/poly1305.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Poly1305 authenticator algorithm, RFC7539
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * Based on public domain code by Andrew Moon and Daniel J. Bernstein.
+ */
+
+#include <crypto/poly1305.h>
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
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-- 
2.20.1

