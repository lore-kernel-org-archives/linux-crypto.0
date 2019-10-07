Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80800ECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EB1A20700
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZykBqpA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfJGQqm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35774 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbfJGQqm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id v8so16168742wrt.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x1P37i8TFZeljeCct3aguJGm/vnetdGzmXLjLnkbYac=;
        b=ZykBqpA9XoUwzTQpOjewuiMbz8NkkuCUCLQENkf8UWuU+1YX7SR2g+fTpRLwj7m7uw
         yrxoutRRLKOcYCh7Ad+oeo3B5imawrSufVFG2owGfBXwTZyDs0mFxm0tZVTXUR5WtlZN
         3k+1iZnZ8n8/VIZdugKHZsQn9iyWinHufGiVBRik9meSRMbWc/3le1Ny+KhYKLn6EsXJ
         JqJLJjVQ8iegjGH6D128xAMq82z+w3lMfH262goV9N9aIPvgNOkJOZYvMhreB5Vk65tX
         zRJlLjDpmurAehTJTo0sLcu809hcMtp1f1zikjYCBH9JKrnK3T8yKLhN3F/92log+cvn
         KtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x1P37i8TFZeljeCct3aguJGm/vnetdGzmXLjLnkbYac=;
        b=pZ1eYx+pgpFSL6eP3FYZuM63Y643MA+71/zkc4LbQFNrrjQ2suIBbOT50AVMjBIWz4
         lhifT//6t+UBhAzmxb9BMZ94XiGS+YClhDEL5lsBxpoEvgh7DwJunYBDvCBiivGBkwZr
         DNBJJShsJKyWXhdQwdW+Y6mjpUjs6vA+pM9H2nf3GSO139NicuRYNwLDD1LLXHQAVz9y
         TLD1nZKlNDLZDYSjby/htPClhATKE/zTrGbpdKGqwGeb82XdgWr1OB4C9yxPuUyBPiEr
         y97X3ISMXY4iQGftP5PVi9aZnrSTDtcisIAJ9HsK2l7yMxqcft/EPqlA2V9zI7peSlil
         NYYg==
X-Gm-Message-State: APjAAAXF2AGKeCEmsuDTgzKUsiw3s9URmn+A5lIm1VFqe/rndcLS6I11
        F88FF5+GAHn1GIO5GLoULN8by+YxHn85mg==
X-Google-Smtp-Source: APXvYqxou2au4TECmvxDp8ZobGhPZvy7WBWbxRCZZUWykxxJB1ocTg/ce0Kn7iNggpvrQH+PafS5Iw==
X-Received: by 2002:a5d:4bc7:: with SMTP id l7mr16905708wrt.188.1570466799278;
        Mon, 07 Oct 2019 09:46:39 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:38 -0700 (PDT)
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
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 15/29] crypto: x86/poly1305 - depend on generic library not generic shash
Date:   Mon,  7 Oct 2019 18:45:56 +0200
Message-Id: <20191007164610.6881-16-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the dependency on the generic Poly1305 driver. Instead, depend
on the generic library so that we only reuse code without pulling in
the generic skcipher implementation as well.

Since this removes the last remaining user of the routines exported
by the generic shash driver, unexport them and make them static.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/poly1305_glue.c    | 67 ++++++++++++++++----
 crypto/Kconfig                     |  2 +-
 crypto/poly1305_generic.c          | 11 ++--
 include/crypto/internal/poly1305.h |  7 --
 4 files changed, 61 insertions(+), 26 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index b43b93c95e79..19d94b63be26 100644
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
@@ -89,14 +107,9 @@ static int poly1305_simd_update(struct shash_desc *desc,
 				const u8 *src, unsigned int srclen)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+	bool do_simd = (srclen > 288) && crypto_simd_usable();
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
@@ -105,25 +118,57 @@ static int poly1305_simd_update(struct shash_desc *desc,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_simd_blocks(dctx, dctx->buf,
-					     POLY1305_BLOCK_SIZE);
+			if (likely(do_simd)) {
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
+		if (likely(do_simd)) {
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
index ead0c3d15823..ae31f8730858 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -710,7 +710,7 @@ config CRYPTO_POLY1305
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
index 68269f0d0062..50067536def9 100644
--- a/include/crypto/internal/poly1305.h
+++ b/include/crypto/internal/poly1305.h
@@ -35,13 +35,6 @@ void poly1305_update_generic(struct poly1305_desc_ctx *desc, const u8 *src,
 
 void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *digest);
 
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

