Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AF3ECE58E
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E369721835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N24Ec0SK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503394AbfJQTKV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54943 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503322AbfJQTKU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so3663266wmp.4
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y2+LkrQGMGMPQCjNbo6+MpD1xviYkjTcRfX3gLIji14=;
        b=N24Ec0SKqfy198lT3Su8Jqq2RWZYbNcHGStIisw4MZM+wsIQfDXww8zWFd++mVU/Nz
         oINe+geYc+XmkBkSryOfveym48URK63MWulGE22Dxl70ExvevuvSQJaF82iBWWYKMFe2
         nxPYsB0XlctIgIzsSZbSeydzXQFVgU9SoKf2lk2X9sVVYHC4eoZXMRSTbp8vxNK9f/+h
         zyt52BgAlpZQPByjaXw47F4nFIwjg80ERZZKJlrw7pATtsUdTRouTVoi0GGV12o6PNXt
         EIwuCckhNhs0FeyeT7iRHA0KR/wF3yVSXRtXCfdU4vU59Q8f0AqAMZyM6GOvJ4eRYmji
         wS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y2+LkrQGMGMPQCjNbo6+MpD1xviYkjTcRfX3gLIji14=;
        b=t5HWUOXjeWtSjP0Tf5hSpHdjBv+OqQRZTIKI+1meJbNabkVlDXw2mMhb61aOz8J4Mc
         zEBp2Gk1cg6CqwWnzUd1vh7OEJtwGTp9BaK/anSTxy25onhaH6r59bPYQwjapjjM27aq
         zYeYY52X6BmuPUueC2/QVZ+3vjLgqBS34QjG7zACzQPF5pb7kIDneS00esPxKNjjmYIg
         Fr35RaPR4ZdxmKZ5pED/V+6qvPmmY/4qQXSfuXKLiLWBBPSofUYB8PH4AIOelW/siuWG
         hufQeeTNb4MQSg5xvy58DwC2BWHh+cXARGKWFJZyzzH69ibA/Guw6HGzx9AHRH0q0yhh
         +sSQ==
X-Gm-Message-State: APjAAAWqF6+MJRaOCNeP+Nr7TmnEIIdRvBAzbF5ytknqa+R2ApfiQ80L
        u1ayvhs1lUTNkIplq1u3d3/egi/W9Ba/9bNl
X-Google-Smtp-Source: APXvYqwcPsAQqpxYhW4Ie/c27J+rvGAHIpuEhZ79cayHWrWLN/SRf3z+uJJkonR8MPPrwpT0qMnJqQ==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr4275767wml.58.1571339417430;
        Thu, 17 Oct 2019 12:10:17 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:16 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 16/35] crypto: x86/poly1305 - depend on generic library not generic shash
Date:   Thu, 17 Oct 2019 21:09:13 +0200
Message-Id: <20191017190932.1947-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the dependency on the generic Poly1305 driver. Instead, depend
on the generic library so that we only reuse code without pulling in
the generic skcipher implementation as well.

While at it, remove the logic that prefers the non-SIMD path for short
inputs - this is no longer necessary after recent FPU handling changes
on x86.

Since this removes the last remaining user of the routines exported
by the generic shash driver, unexport them and make them static.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/poly1305_glue.c    | 66 ++++++++++++++++----
 crypto/Kconfig                     |  2 +-
 crypto/poly1305_generic.c          | 11 ++--
 include/crypto/internal/poly1305.h |  9 ---
 4 files changed, 60 insertions(+), 28 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index b43b93c95e79..a5b3a054604c 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -34,6 +34,24 @@ static void poly1305_simd_mult(u32 *a, const u32 *b)
 	poly1305_block_sse2(a, m, b, 1);
 }
 
+static unsigned int poly1305_scalar_blocks(struct poly1305_desc_ctx *dctx,
+					   const u8 *src, unsigned int srclen)
+{
+	unsigned int datalen;
+
+	if (unlikely(!dctx->sset)) {
+		datalen = crypto_poly1305_setdesckey(dctx, src, srclen);
+		src += srclen - datalen;
+		srclen = datalen;
+	}
+	if (srclen >= POLY1305_BLOCK_SIZE) {
+		poly1305_core_blocks(&dctx->h, dctx->r, src,
+				     srclen / POLY1305_BLOCK_SIZE, 1);
+		srclen %= POLY1305_BLOCK_SIZE;
+	}
+	return srclen;
+}
+
 static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 					 const u8 *src, unsigned int srclen)
 {
@@ -91,12 +109,6 @@ static int poly1305_simd_update(struct shash_desc *desc,
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 	unsigned int bytes;
 
-	/* kernel_fpu_begin/end is costly, use fallback for small updates */
-	if (srclen <= 288 || !crypto_simd_usable())
-		return crypto_poly1305_update(desc, src, srclen);
-
-	kernel_fpu_begin();
-
 	if (unlikely(dctx->buflen)) {
 		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->buflen);
 		memcpy(dctx->buf + dctx->buflen, src, bytes);
@@ -105,25 +117,57 @@ static int poly1305_simd_update(struct shash_desc *desc,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_simd_blocks(dctx, dctx->buf,
-					     POLY1305_BLOCK_SIZE);
+			if (likely(crypto_simd_usable())) {
+				kernel_fpu_begin();
+				poly1305_simd_blocks(dctx, dctx->buf,
+						     POLY1305_BLOCK_SIZE);
+				kernel_fpu_end();
+			} else {
+				poly1305_scalar_blocks(dctx, dctx->buf,
+						       POLY1305_BLOCK_SIZE);
+			}
 			dctx->buflen = 0;
 		}
 	}
 
 	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		bytes = poly1305_simd_blocks(dctx, src, srclen);
+		if (likely(crypto_simd_usable())) {
+			kernel_fpu_begin();
+			bytes = poly1305_simd_blocks(dctx, src, srclen);
+			kernel_fpu_end();
+		} else {
+			bytes = poly1305_scalar_blocks(dctx, src, srclen);
+		}
 		src += srclen - bytes;
 		srclen = bytes;
 	}
 
-	kernel_fpu_end();
-
 	if (unlikely(srclen)) {
 		dctx->buflen = srclen;
 		memcpy(dctx->buf, src, srclen);
 	}
+}
+
+static int crypto_poly1305_init(struct shash_desc *desc)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	poly1305_core_init(&dctx->h);
+	dctx->buflen = 0;
+	dctx->rset = 0;
+	dctx->sset = false;
+
+	return 0;
+}
+
+static int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	if (unlikely(!dctx->sset))
+		return -ENOKEY;
 
+	poly1305_final_generic(dctx, dst);
 	return 0;
 }
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index d71b8afa01cd..950cf1a8dfc0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -697,7 +697,7 @@ config CRYPTO_POLY1305
 config CRYPTO_POLY1305_X86_64
 	tristate "Poly1305 authenticator algorithm (x86_64/SSE2/AVX2)"
 	depends on X86 && 64BIT
-	select CRYPTO_POLY1305
+	select CRYPTO_LIB_POLY1305_GENERIC
 	help
 	  Poly1305 authenticator algorithm, RFC7539.
 
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index afe9a9e576dd..21edbd8c99fb 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 #include <asm/unaligned.h>
 
-int crypto_poly1305_init(struct shash_desc *desc)
+static int crypto_poly1305_init(struct shash_desc *desc)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
@@ -30,7 +30,6 @@ int crypto_poly1305_init(struct shash_desc *desc)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_poly1305_init);
 
 static void poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
 			    unsigned int srclen)
@@ -47,8 +46,8 @@ static void poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
 			     srclen / POLY1305_BLOCK_SIZE, 1);
 }
 
-int crypto_poly1305_update(struct shash_desc *desc,
-			   const u8 *src, unsigned int srclen)
+static int crypto_poly1305_update(struct shash_desc *desc,
+				  const u8 *src, unsigned int srclen)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 	unsigned int bytes;
@@ -80,9 +79,8 @@ int crypto_poly1305_update(struct shash_desc *desc,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_poly1305_update);
 
-int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
+static int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
@@ -92,7 +90,6 @@ int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 	poly1305_final_generic(dctx, dst);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_poly1305_final);
 
 static struct shash_alg poly1305_alg = {
 	.digestsize	= POLY1305_DIGEST_SIZE,
diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
index 04fa269e5534..479b0cab2a1a 100644
--- a/include/crypto/internal/poly1305.h
+++ b/include/crypto/internal/poly1305.h
@@ -10,8 +10,6 @@
 #include <linux/types.h>
 #include <crypto/poly1305.h>
 
-struct shash_desc;
-
 /*
  * Poly1305 core functions.  These implement the ε-almost-∆-universal hash
  * function underlying the Poly1305 MAC, i.e. they don't add an encrypted nonce
@@ -28,13 +26,6 @@ void poly1305_core_blocks(struct poly1305_state *state,
 			  unsigned int nblocks, u32 hibit);
 void poly1305_core_emit(const struct poly1305_state *state, void *dst);
 
-/* Crypto API helper functions for the Poly1305 MAC */
-int crypto_poly1305_init(struct shash_desc *desc);
-
-int crypto_poly1305_update(struct shash_desc *desc,
-			   const u8 *src, unsigned int srclen);
-int crypto_poly1305_final(struct shash_desc *desc, u8 *dst);
-
 /*
  * Poly1305 requires a unique key for each tag, which implies that we can't set
  * it on the tfm that gets accessed by multiple users simultaneously. Instead we
-- 
2.20.1

