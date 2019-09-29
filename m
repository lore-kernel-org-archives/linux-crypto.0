Return-Path: <SRS0=xDoY=XY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27DAC32793
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88CA921D7A
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YdD0dwSX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbfI2RjK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:39:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35129 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbfI2RjK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 13:39:10 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so8465478wrt.2
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2019 10:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X/vLL5kgt+leeMxxc/cNujK7VVt1jHGGLQNhA6i9258=;
        b=YdD0dwSXEfmRjBxzhTLjM1ewhfF0rOBkxdm9VQD186pTNSpHTPnlZsmfvX2N45wHXh
         7TIfyUzKkKaMa59tLyegY4yy+fjfKrwAEwUC9scd9Dl2oel72IhYtar9ZyhYWoe804y+
         6pY2K0+CSybGc6Wb/gPBDhxmRkmmRuXlzP1H7Sanvj/mgyQ6fVvpJnZAwp+UmrG6L/Ci
         GKWMmxIRNxs132yh3KsyIsXc1zAB4cN8RtkQmXjF2F6l0wPCYGBrx//9IDU7ksgW6rwy
         I0ceq+4fX/6xC+TmK7EnnPcmUpfus4BcKne0fX7bOap4rv5LuJW7mXjWlhG0a95adhO8
         VmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X/vLL5kgt+leeMxxc/cNujK7VVt1jHGGLQNhA6i9258=;
        b=lXwLJyoNEMkJZcQOqnzquZzOrGQkhO7dE+PJ55bCsJCoWbj2Vk8WOh+m4UFXlPkAge
         fxiLGBZaA99k78jsVzMzOif5lUtqxqGaO/hU6vScnjV3NeFqSb9jW8TO9yM+lJi3Lmg1
         1NqeBF82aiYk3tS+oCDqG8C19drNiLCIZQcvuFwIIPFp/3AuPdTygS8BgzSSivAEwYy/
         JlnvRwKSZ27lCPyKc32tHHY4xAO9OjUNh6bYfX8u8SdPBa2DCv3QCa9f81An/VPrTF+y
         Afg3DcOKLv2pXHF4Z/MyhPBIImEmO5VY4AsOWb0E1INxCk1AF4WVleFgSsu0uRrMAnn1
         shxA==
X-Gm-Message-State: APjAAAX02ihA8NWnH3DwrzuvPhIbyi/DmgteGPeoQDa3KqzBwWt0V0b6
        aUw197kLJAGiqiApIAoHnFKLgnd6QIZGEQms
X-Google-Smtp-Source: APXvYqyUI7Y4iM5nuLvB1G9Yo4MFGA82Kt8p3C8M9GD+cN4Am43n+Seb6gIMwljnPmPg15ZYjCiHXw==
X-Received: by 2002:adf:cf0e:: with SMTP id o14mr10234224wrj.277.1569778748055;
        Sun, 29 Sep 2019 10:39:08 -0700 (PDT)
Received: from e123331-lin.nice.arm.com (bar06-5-82-246-156-241.fbx.proxad.net. [82.246.156.241])
        by smtp.gmail.com with ESMTPSA id q192sm17339779wme.23.2019.09.29.10.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 10:39:07 -0700 (PDT)
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
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>
Subject: [RFC PATCH 06/20] crypto: x86/poly1305 - expose existing driver as poly1305 library
Date:   Sun, 29 Sep 2019 19:38:36 +0200
Message-Id: <20190929173850.26055-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement the init/update/final Poly1305 library routines in the
accelerated SIMD driver for x86 so they are accessible to users of
the Poly1305 library interface.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/poly1305_glue.c | 60 +++++++++++++++-----
 crypto/Kconfig                  |  2 +
 2 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index b43b93c95e79..d3cc92996f58 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -85,18 +85,11 @@ static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 	return srclen;
 }
 
-static int poly1305_simd_update(struct shash_desc *desc,
-				const u8 *src, unsigned int srclen)
+static int poly1305_simd_do_update(struct poly1305_desc_ctx *dctx,
+				   const u8 *src, unsigned int srclen)
 {
-	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
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
@@ -117,8 +110,6 @@ static int poly1305_simd_update(struct shash_desc *desc,
 		srclen = bytes;
 	}
 
-	kernel_fpu_end();
-
 	if (unlikely(srclen)) {
 		dctx->buflen = srclen;
 		memcpy(dctx->buf, src, srclen);
@@ -127,6 +118,47 @@ static int poly1305_simd_update(struct shash_desc *desc,
 	return 0;
 }
 
+static int poly1305_simd_update(struct shash_desc *desc,
+				const u8 *src, unsigned int srclen)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+	int ret;
+
+	/* kernel_fpu_begin/end is costly, use fallback for small updates */
+	if (srclen <= 288 || !crypto_simd_usable())
+		return crypto_poly1305_update(desc, src, srclen);
+
+	kernel_fpu_begin();
+	ret = poly1305_simd_do_update(dctx, src, srclen);
+	kernel_fpu_end();
+
+	return ret;
+}
+
+void poly1305_init(struct poly1305_desc_ctx *desc, const u8 *key)
+{
+	poly1305_init_generic(desc, key);
+}
+EXPORT_SYMBOL(poly1305_init);
+
+void poly1305_update(struct poly1305_desc_ctx *dctx, const u8 *src,
+		     unsigned int nbytes)
+{
+	if (nbytes <= 288 || !crypto_simd_usable())
+		return poly1305_update_generic(dctx, src, nbytes);
+
+	kernel_fpu_begin();
+	poly1305_simd_do_update(dctx, src, nbytes);
+	kernel_fpu_end();
+}
+EXPORT_SYMBOL(poly1305_update);
+
+void poly1305_final(struct poly1305_desc_ctx *desc, u8 *digest)
+{
+	poly1305_final_generic(desc, digest);
+}
+EXPORT_SYMBOL(poly1305_final);
+
 static struct shash_alg alg = {
 	.digestsize	= POLY1305_DIGEST_SIZE,
 	.init		= crypto_poly1305_init,
@@ -151,9 +183,9 @@ static int __init poly1305_simd_mod_init(void)
 			    boot_cpu_has(X86_FEATURE_AVX) &&
 			    boot_cpu_has(X86_FEATURE_AVX2) &&
 			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
-	alg.descsize = sizeof(struct poly1305_desc_ctx) + 5 * sizeof(u32);
-	if (poly1305_use_avx2)
-		alg.descsize += 10 * sizeof(u32);
+	alg.descsize = sizeof(struct poly1305_desc_ctx);
+	if (!poly1305_use_avx2)
+		alg.descsize -= 10 * sizeof(u32);
 
 	return crypto_register_shash(&alg);
 }
diff --git a/crypto/Kconfig b/crypto/Kconfig
index f40e8dca57d1..6a952a61675b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -659,6 +659,7 @@ config CRYPTO_ARCH_HAVE_LIB_POLY1305
 
 config CRYPTO_LIB_POLY1305_RSIZE
 	int
+	default 4 if X86_64
 	default 1
 
 config CRYPTO_LIB_POLY1305
@@ -680,6 +681,7 @@ config CRYPTO_POLY1305_X86_64
 	tristate "Poly1305 authenticator algorithm (x86_64/SSE2/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_POLY1305
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm, RFC7539.
 
-- 
2.17.1

