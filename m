Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC087C432C2
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76AC321D7F
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CAnW7qsq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388052AbfIYQOF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:14:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38807 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388006AbfIYQOE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so5623041wmi.3
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xpVJhurqboKmy8zjq8NwWmF/2cOoT7sCwN/7BICzDQc=;
        b=CAnW7qsqfrk5KFVvsKsDcgra7HlMJjjL2tpzu+fodKYoLQDhcCrInovzV4qj/eASai
         ROhGsosp9+zoYMmAiL7lA45JmrJWYK0TqGMRZDRBciGaidScg1iKhQdEAmgkieeDIWXZ
         JL5s8XsQU42tg8wpyuiAuFAEcuyVWFjAy3leU5/kX/IyBF4sAvKQtp3CHt5B7ZvnBQUs
         7y1XO507W5aBNQo46ccGXQBjrrDCJ3LNHNF3QTG3Ham4ymf4ixhVpKQYRB0gVwJuOMgL
         1us8T+MeoWba7+PVMVgfW7xU+5siLN0AeEAhvisjNVnnslWCJPlLqKgFgIjK4Ajsf4Fh
         YFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xpVJhurqboKmy8zjq8NwWmF/2cOoT7sCwN/7BICzDQc=;
        b=p+Jg/R7HF6pn7DQ1RSxHFF6YqH+xdB3uu+9Wv3nyw45OJnMAORsUXsnyQmAezO2er4
         L67RWVQjR+eLYeFCUwx1DsqrDj+KypOQp/5HJOdLeTWTwCdnFQJgu0MBsVE0J4SO9xhp
         hCixALqsIH3zaQ/Q3XwnkPTtmyCzgkXF+fnFPniHL6c4fXMNOoSCPrYVrhDXfG2OEHE3
         4Ah4BJUR2PGB0jI6fmJP+FmuNoPs110Y5sKcps9DSujyLq1SriUSlI2TCZk+FpmbyVJl
         x/zmYd7A5LTBzDk+VrN8d7QE02kZe0TtIncWj02N5x5SKQtWNVu8knXVujBVHTr0+hHo
         hL1w==
X-Gm-Message-State: APjAAAW5v4tLWSJ2buxymxGCGTTQSkGkQ5C9NDyV/HOLIlBtEqfvxgWo
        VB2To64M2VKd/RZ1GNlWhM0GzHAsCxyQd1Wx
X-Google-Smtp-Source: APXvYqzjKIx5BU0X+hSOnuLm57ITShsKdJWzENe3xNpvJbLScKbHsUEDABMKZdHgw9OoOMLqLWiLEw==
X-Received: by 2002:a7b:cb8b:: with SMTP id m11mr3358192wmi.145.1569428041353;
        Wed, 25 Sep 2019 09:14:01 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:14:00 -0700 (PDT)
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
Subject: [RFC PATCH 10/18] crypto: poly1305 - add init/update/final library routines
Date:   Wed, 25 Sep 2019 18:12:47 +0200
Message-Id: <20190925161255.1871-11-ard.biesheuvel@linaro.org>
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

Add the usual init/update/final library routines for the Poly1305
keyed hash library. Since this will be the external interface of
the library, move the poly1305_core_* routines to the internal
header (and update the users to refer to it where needed)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/adiantum.c                  |  1 +
 crypto/nhpoly1305.c                |  1 +
 crypto/poly1305_generic.c          | 57 +++++++------------
 include/crypto/internal/poly1305.h | 16 ++----
 include/crypto/poly1305.h          | 34 ++++++++++--
 lib/crypto/poly1305.c              | 58 ++++++++++++++++++++
 6 files changed, 115 insertions(+), 52 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 775ed1418e2b..aded26092268 100644
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
diff --git a/crypto/nhpoly1305.c b/crypto/nhpoly1305.c
index b88a6a71e3e2..f6b6a52092b4 100644
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
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index 46a2da1abac7..69241e7e85be 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -23,8 +23,8 @@ int crypto_poly1305_init(struct shash_desc *desc)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	poly1305_core_init(&dctx->h);
-	dctx->buflen = 0;
+	poly1305_core_init(&dctx->desc.h);
+	dctx->desc.buflen = 0;
 	dctx->rset = false;
 	dctx->sset = false;
 
@@ -42,16 +42,16 @@ unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
 {
 	if (!dctx->sset) {
 		if (!dctx->rset && srclen >= POLY1305_BLOCK_SIZE) {
-			poly1305_core_setkey(&dctx->r, src);
+			poly1305_core_setkey(&dctx->desc.r, src);
 			src += POLY1305_BLOCK_SIZE;
 			srclen -= POLY1305_BLOCK_SIZE;
 			dctx->rset = true;
 		}
 		if (srclen >= POLY1305_BLOCK_SIZE) {
-			dctx->s[0] = get_unaligned_le32(src +  0);
-			dctx->s[1] = get_unaligned_le32(src +  4);
-			dctx->s[2] = get_unaligned_le32(src +  8);
-			dctx->s[3] = get_unaligned_le32(src + 12);
+			dctx->desc.s[0] = get_unaligned_le32(src +  0);
+			dctx->desc.s[1] = get_unaligned_le32(src +  4);
+			dctx->desc.s[2] = get_unaligned_le32(src +  8);
+			dctx->desc.s[3] = get_unaligned_le32(src + 12);
 			src += POLY1305_BLOCK_SIZE;
 			srclen -= POLY1305_BLOCK_SIZE;
 			dctx->sset = true;
@@ -72,7 +72,7 @@ static void poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
 		srclen = datalen;
 	}
 
-	poly1305_core_blocks(&dctx->h, &dctx->r, src,
+	poly1305_core_blocks(&dctx->desc.h, &dctx->desc.r, src,
 			     srclen / POLY1305_BLOCK_SIZE, 1);
 }
 
@@ -82,16 +82,17 @@ int crypto_poly1305_update(struct shash_desc *desc,
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 	unsigned int bytes;
 
-	if (unlikely(dctx->buflen)) {
-		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->buflen);
-		memcpy(dctx->buf + dctx->buflen, src, bytes);
+	if (unlikely(dctx->desc.buflen)) {
+		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->desc.buflen);
+		memcpy(dctx->desc.buf + dctx->desc.buflen, src, bytes);
 		src += bytes;
 		srclen -= bytes;
-		dctx->buflen += bytes;
+		dctx->desc.buflen += bytes;
 
-		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks(dctx, dctx->buf, POLY1305_BLOCK_SIZE);
-			dctx->buflen = 0;
+		if (dctx->desc.buflen == POLY1305_BLOCK_SIZE) {
+			poly1305_blocks(dctx, dctx->desc.buf,
+					POLY1305_BLOCK_SIZE);
+			dctx->desc.buflen = 0;
 		}
 	}
 
@@ -102,8 +103,8 @@ int crypto_poly1305_update(struct shash_desc *desc,
 	}
 
 	if (unlikely(srclen)) {
-		dctx->buflen = srclen;
-		memcpy(dctx->buf, src, srclen);
+		dctx->desc.buflen = srclen;
+		memcpy(dctx->desc.buf, src, srclen);
 	}
 
 	return 0;
@@ -113,31 +114,11 @@ EXPORT_SYMBOL_GPL(crypto_poly1305_update);
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
-		poly1305_core_blocks(&dctx->h, &dctx->r, dctx->buf, 1, 0);
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
+	poly1305_final(&dctx->desc, dst);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_poly1305_final);
diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
index ae0466c4ce59..619705200e70 100644
--- a/include/crypto/internal/poly1305.h
+++ b/include/crypto/internal/poly1305.h
@@ -10,22 +10,18 @@
 #include <crypto/poly1305.h>
 
 struct poly1305_desc_ctx {
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
+	struct poly1305_desc desc;
 	/* r key has been set */
 	bool rset;
 	/* s key has been set */
 	bool sset;
 };
 
+void poly1305_core_blocks(struct poly1305_state *state,
+			  const struct poly1305_key *key, const void *src,
+			  unsigned int nblocks, u32 hibit);
+void poly1305_core_emit(const struct poly1305_state *state, void *dst);
+
 /* Crypto API helper functions for the Poly1305 MAC */
 int crypto_poly1305_init(struct shash_desc *desc);
 unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index 83e4b4c69a5a..148d9049b906 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -6,6 +6,7 @@
 #ifndef _CRYPTO_POLY1305_H
 #define _CRYPTO_POLY1305_H
 
+#include <asm/unaligned.h>
 #include <linux/types.h>
 #include <linux/crypto.h>
 
@@ -21,6 +22,19 @@ struct poly1305_state {
 	u32 h[5];	/* accumulator, base 2^26 */
 };
 
+struct poly1305_desc {
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
+};
+
 /*
  * Poly1305 core functions.  These implement the ε-almost-∆-universal hash
  * function underlying the Poly1305 MAC, i.e. they don't add an encrypted nonce
@@ -31,8 +45,20 @@ static inline void poly1305_core_init(struct poly1305_state *state)
 {
 	*state = (struct poly1305_state){};
 }
-void poly1305_core_blocks(struct poly1305_state *state,
-			  const struct poly1305_key *key, const void *src,
-			  unsigned int nblocks, u32 hibit);
-void poly1305_core_emit(const struct poly1305_state *state, void *dst);
+
+static inline void poly1305_init(struct poly1305_desc *desc, const u8 *key)
+{
+	poly1305_core_setkey(&desc->r, key);
+	desc->s[0] = get_unaligned_le32(key + 16);
+	desc->s[1] = get_unaligned_le32(key + 20);
+	desc->s[2] = get_unaligned_le32(key + 24);
+	desc->s[3] = get_unaligned_le32(key + 28);
+	poly1305_core_init(&desc->h);
+	desc->buflen = 0;
+}
+
+void poly1305_update(struct poly1305_desc *desc, const u8 *src,
+		     unsigned int nbytes);
+void poly1305_final(struct poly1305_desc *desc, u8 *digest);
+
 #endif
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index abe6fccf7b9c..9af7cb5364af 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -154,5 +154,63 @@ void poly1305_core_emit(const struct poly1305_state *state, void *dst)
 }
 EXPORT_SYMBOL_GPL(poly1305_core_emit);
 
+void poly1305_update(struct poly1305_desc *desc, const u8 *src,
+		     unsigned int nbytes)
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
+			poly1305_core_blocks(&desc->h, &desc->r, desc->buf, 1, 1);
+			desc->buflen = 0;
+		}
+	}
+
+	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
+		poly1305_core_blocks(&desc->h, &desc->r, src,
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
+EXPORT_SYMBOL_GPL(poly1305_update);
+
+void poly1305_final(struct poly1305_desc *desc, u8 *dst)
+{
+	__le32 digest[4];
+	u64 f = 0;
+
+	if (unlikely(desc->buflen)) {
+		desc->buf[desc->buflen++] = 1;
+		memset(desc->buf + desc->buflen, 0,
+		       POLY1305_BLOCK_SIZE - desc->buflen);
+		poly1305_core_blocks(&desc->h, &desc->r, desc->buf, 1, 0);
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
+}
+EXPORT_SYMBOL_GPL(poly1305_final);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-- 
2.20.1

