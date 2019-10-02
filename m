Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E766C35280
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04FD6222C5
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fe5auRYx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfJBORx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:17:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45616 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727647AbfJBORx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so19823627wrm.12
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vSkye5wE8tJn+3G+EFVZxDgh4uLAU2Tkn17iZamCDM0=;
        b=Fe5auRYxATXKlY0TBNM65R6YXERNjOZbdgVh84tkuH5252Q0Vw5AQIYAQZhcs9R4+a
         lareIdk8yIVquZ6VBb0UJtdBOqIAusdt56NAp8U2bzo9qzantUdS0nt838V0TNfVLIq0
         qnyUvkThYtK2EbtDM6H/0WgNZO2tjvHDDQafQ2R2xSBbPON5nU/voTUerSjqwWNiS3rS
         ROMIrbBHvyAMMosIm+XBOoBIhQK4Y6bETeD93XgPGbumxE6yBczvSX3F5FG39s86GKGD
         218A4msrTzD2exObRq3VlK7YDP69Fk755jM/2y7bDz63dZJRo9ZaSwPBaTv1janKfD8n
         gW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSkye5wE8tJn+3G+EFVZxDgh4uLAU2Tkn17iZamCDM0=;
        b=H7/kxU8Be5d4gOgH15J+/xYghdicfM36bbwGT530ROFU+4KQJmK3u86S4Uey4svqLk
         5+6oQpeiK1tzMZZwD+q2mY7D00YRcg+Us6a+mHPMytUDpvhfzgohezW5m0MQSc3HOMr7
         TyTj6grtOmHzQjVi6COa06htjQKlo7Ra63WFcrmXyxobreSNGKx7QvwtVV18UHjghYO0
         kEFqEGRiFut7nkckgm7kA2LhwMdRSVrHayNKNe9iTIesv1vgjWDXieQPq1656v/aX4/N
         5gu6KtrrcXe4XFnv/M9lT0toTynb3kvfd45OH0c5vaeGmcECSXvwGJ9uqn++6zwNN9Uv
         Q63Q==
X-Gm-Message-State: APjAAAWxBUbMTd1hDNap0crRSFgvQcOWPxZECPufiqvYiKQlc6wwV6DK
        rD4k32WENnDU8N4j7vVR73fqRCwt8NBQCzC+
X-Google-Smtp-Source: APXvYqyUMVmH+rG1/dBRGFqA9DONdK/iSuJeQrrRytZ1ptgySbOYnrCV9qM4eKzPpfrdtgkkowOy1w==
X-Received: by 2002:adf:b60b:: with SMTP id f11mr2791678wre.95.1570025868838;
        Wed, 02 Oct 2019 07:17:48 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:47 -0700 (PDT)
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
Subject: [PATCH v2 07/20] crypto: x86/poly1305 - expose existing driver as poly1305 library
Date:   Wed,  2 Oct 2019 16:17:00 +0200
Message-Id: <20191002141713.31189-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement the init/update/final Poly1305 library routines in the
accelerated SIMD driver for x86 so they are accessible to users of
the Poly1305 library interface.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/poly1305_glue.c | 57 +++++++++++++++-----
 crypto/Kconfig                  |  2 +
 2 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index b43b93c95e79..05f87535d41e 100644
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
@@ -151,9 +183,6 @@ static int __init poly1305_simd_mod_init(void)
 			    boot_cpu_has(X86_FEATURE_AVX) &&
 			    boot_cpu_has(X86_FEATURE_AVX2) &&
 			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
-	alg.descsize = sizeof(struct poly1305_desc_ctx) + 5 * sizeof(u32);
-	if (poly1305_use_avx2)
-		alg.descsize += 10 * sizeof(u32);
 
 	return crypto_register_shash(&alg);
 }
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 88b1d0d20090..8aae0907ca4e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -687,6 +687,7 @@ config CRYPTO_ARCH_HAVE_LIB_POLY1305
 
 config CRYPTO_LIB_POLY1305_RSIZE
 	int
+	default 4 if X86_64
 	default 1
 
 config CRYPTO_LIB_POLY1305
@@ -707,6 +708,7 @@ config CRYPTO_POLY1305_X86_64
 	tristate "Poly1305 authenticator algorithm (x86_64/SSE2/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_POLY1305
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm, RFC7539.
 
-- 
2.20.1

