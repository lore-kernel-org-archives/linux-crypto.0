Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7472ECE58E
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D71220700
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MPcFLXzD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfJGQqn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42530 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbfJGQqn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id n14so16109443wrw.9
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ikSYcC8+v0LxzoXc8o6M9JWNR0RQVpVYxF+OVP8elo=;
        b=MPcFLXzD19fJd/TYvSn0LA6Emj90oxIfYgdZjJmYWcwSeHXz2rpnR95mkTJq4ujQCn
         Zk4FBiU2JVwPmoV9RKcj2UGMJRc9NPx0H46axAzey5WBCu5uwRH+UA078j5Cz84jmkaQ
         Nfl9bytRjogzk/VGVw+cR0ged8d+C35Fi7tecEDrsdwSsrhY2Yik+9SgHzSgJdwZ1QKw
         LsCnnrYlnUUZ9Jp1VN0+w0BIRYwGBFATz1SJ2pTSSEO23N1zoWJ+qR3+uq8IWicM0HLs
         GRhgBrM9uwFfAIkcn8FxdLi2HlP4VpbU6WcxtKUlYSUXOVTngH9dHTdzCj/efxKEm5+/
         EMmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ikSYcC8+v0LxzoXc8o6M9JWNR0RQVpVYxF+OVP8elo=;
        b=D/E8ovowvErcPccNkJFBNj5NmMO4FZgktrImsNHHsIO79ONvrBT7tLlY0gVxb/Kmjh
         uwDG87gEUSN7wkQXRvpTJIn2ywusqCrk1YQrm54bn6vx8Gu2/1Gm6RP3LXXATd44jFwb
         CSjCulLst6npI/nt7FFMSI/cqPe1aaOJ3k9Lx8F77O/9QRpDZiKU4ocK/CLP+vd9SX39
         f+aZvdpUL/52LN+rWyJ4gCsEuIl//jgG7+4fwd1CkolPQlejbWfxeEe4/ojUkBGpNbDc
         5Q/u0i6zahVolmj2f5Ty7TV/lABN/2qcZQBILGI6RjzeNu3pS4QC3Ht+X4Y/0TxX/Oe+
         vIOQ==
X-Gm-Message-State: APjAAAV9j6CxScXo2mt1DybQ5qdRaViy+FGh9vLzzXzueBKxwGsEcPfY
        id0whkoL21sA3g0aO3RhmmCjyEggD8Bzsg==
X-Google-Smtp-Source: APXvYqzpuQ7FhFC10jL6fKv7aN7IxteY6xwK+KReojnJ1oefnrDAPv0VFPfCjfFfUJAdyugujG3XIA==
X-Received: by 2002:adf:82e6:: with SMTP id 93mr12837882wrc.244.1570466800772;
        Mon, 07 Oct 2019 09:46:40 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:39 -0700 (PDT)
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
Subject: [PATCH v3 16/29] crypto: x86/poly1305 - expose existing driver as poly1305 library
Date:   Mon,  7 Oct 2019 18:45:57 +0200
Message-Id: <20191007164610.6881-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement the init/update/final Poly1305 library routines in the
accelerated SIMD driver for x86 so they are accessible to users of
the Poly1305 library interface as well.

Given that calls into the library API will always go through the
routines in this module if it is enabled, switch to static keys
to select the optimal implementation available (which may be none
at all, in which case we defer to the generic implementation for
all invocations).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/poly1305_glue.c | 57 ++++++++++++++------
 crypto/Kconfig                  |  2 +
 2 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index 19d94b63be26..b5160c10e2e8 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -10,6 +10,7 @@
 #include <crypto/internal/poly1305.h>
 #include <crypto/internal/simd.h>
 #include <linux/crypto.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/simd.h>
@@ -21,7 +22,8 @@ asmlinkage void poly1305_2block_sse2(u32 *h, const u8 *src, const u32 *r,
 asmlinkage void poly1305_4block_avx2(u32 *h, const u8 *src, const u32 *r,
 				     unsigned int blocks, const u32 *u);
 
-static bool poly1305_use_avx2 __ro_after_init;
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_simd);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx2);
 
 static void poly1305_simd_mult(u32 *a, const u32 *b)
 {
@@ -64,7 +66,7 @@ static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 	}
 
 	if (IS_ENABLED(CONFIG_AS_AVX2) &&
-	    poly1305_use_avx2 &&
+	    static_branch_likely(&poly1305_use_avx2) &&
 	    srclen >= POLY1305_BLOCK_SIZE * 4) {
 		if (unlikely(dctx->rset < 4)) {
 			if (dctx->rset < 2) {
@@ -103,10 +105,9 @@ static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 	return srclen;
 }
 
-static int poly1305_simd_update(struct shash_desc *desc,
-				const u8 *src, unsigned int srclen)
+void poly1305_update(struct poly1305_desc_ctx *dctx, const u8 *src,
+		     unsigned int srclen)
 {
-	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 	bool do_simd = (srclen > 288) && crypto_simd_usable();
 	unsigned int bytes;
 
@@ -118,7 +119,8 @@ static int poly1305_simd_update(struct shash_desc *desc,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			if (likely(do_simd)) {
+			if (static_branch_likely(&poly1305_use_simd) &&
+			    likely(do_simd)) {
 				kernel_fpu_begin();
 				poly1305_simd_blocks(dctx, dctx->buf,
 						     POLY1305_BLOCK_SIZE);
@@ -132,7 +134,8 @@ static int poly1305_simd_update(struct shash_desc *desc,
 	}
 
 	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		if (likely(do_simd)) {
+		if (static_branch_likely(&poly1305_use_simd) &&
+		    likely(do_simd)) {
 			kernel_fpu_begin();
 			bytes = poly1305_simd_blocks(dctx, src, srclen);
 			kernel_fpu_end();
@@ -148,6 +151,7 @@ static int poly1305_simd_update(struct shash_desc *desc,
 		memcpy(dctx->buf, src, srclen);
 	}
 }
+EXPORT_SYMBOL(poly1305_update);
 
 static int crypto_poly1305_init(struct shash_desc *desc)
 {
@@ -172,6 +176,27 @@ static int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
 	return 0;
 }
 
+static int poly1305_simd_update(struct shash_desc *desc,
+				const u8 *src, unsigned int srclen)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	poly1305_update(dctx, src, srclen);
+	return 0;
+}
+
+void poly1305_init(struct poly1305_desc_ctx *desc, const u8 *key)
+{
+	poly1305_init_generic(desc, key);
+}
+EXPORT_SYMBOL(poly1305_init);
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
@@ -190,15 +215,15 @@ static struct shash_alg alg = {
 static int __init poly1305_simd_mod_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_XMM2))
-		return -ENODEV;
-
-	poly1305_use_avx2 = IS_ENABLED(CONFIG_AS_AVX2) &&
-			    boot_cpu_has(X86_FEATURE_AVX) &&
-			    boot_cpu_has(X86_FEATURE_AVX2) &&
-			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
-	alg.descsize = sizeof(struct poly1305_desc_ctx) + 5 * sizeof(u32);
-	if (poly1305_use_avx2)
-		alg.descsize += 10 * sizeof(u32);
+		return 0;
+
+	static_branch_enable(&poly1305_use_simd);
+
+	if (IS_ENABLED(CONFIG_AS_AVX2) &&
+	    boot_cpu_has(X86_FEATURE_AVX) &&
+	    boot_cpu_has(X86_FEATURE_AVX2) &&
+	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+		static_branch_enable(&poly1305_use_avx2);
 
 	return crypto_register_shash(&alg);
 }
diff --git a/crypto/Kconfig b/crypto/Kconfig
index ae31f8730858..aab1ba4f4df8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -687,6 +687,7 @@ config CRYPTO_ARCH_HAVE_LIB_POLY1305
 
 config CRYPTO_LIB_POLY1305_RSIZE
 	int
+	default 4 if X86_64
 	default 1
 
 config CRYPTO_LIB_POLY1305
@@ -711,6 +712,7 @@ config CRYPTO_POLY1305_X86_64
 	tristate "Poly1305 authenticator algorithm (x86_64/SSE2/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_LIB_POLY1305_GENERIC
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305
 	help
 	  Poly1305 authenticator algorithm, RFC7539.
 
-- 
2.20.1

