Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05974ECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C192921835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LnioOcr6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503385AbfJQTKD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34318 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503322AbfJQTKC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id y135so7687262wmc.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qyjxSoOsrtkveMGZvvVvh95Ig0Ac1iUrc5H2Pfhe3Lo=;
        b=LnioOcr6/1Ohlx1IwJKR9zyc394ywB4z4Dg/3ad5Rm5VVq56yD2LJB7bdz/lgq0iPn
         UnXo66v6B/1Wu0WjkBbWv7FQgnpiYSNn7jWP2Qgp/YyJ0GwJA0NNenf5bpItHhqCQeen
         4E36ZrpS66Zbjk5Mbn9wyEmWAcHllSNdwBIYv4s45R5VpnM91AkGunRT6mLa5f60U47v
         E/5LrDKm/1qBJp5KbAY07AxSpjXYHtaegG/i710hWg/IKfw9BTh19bP4f4AjQHDaadWr
         V3B4jVM806tzR04FkqbV4NRWUnlxV7Ky3It7bfszuC8fS5e6f1fbvr4k0Hwom+uLlxIq
         Iu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qyjxSoOsrtkveMGZvvVvh95Ig0Ac1iUrc5H2Pfhe3Lo=;
        b=kpec+5qsZY5zwKnxG396vu/jYWIsPlrZ7Z0vcF70zQR6ObAiVHJhpU301k8Kslu39E
         N/FX7PVFxfzBFBKQJrG1u8CVgzgdBtd/TQtfr345HmH0lxMxWoalLqrgdXDWL9f6OM65
         svj7HJsuYzx97VkUwH7olTnBO4yJ1wNITVQb8ASEUEYtTT+XJCDB3CxFMX2fDAkfthQm
         lughF6yKeQpsjIwrqnK0FdWe5D1tFG3HJDjaOsRHouxPhPiotluGiZKd9ipILDfKSoKH
         sdq6dhfzDNg9+T5R2uwXMJvBwICbwwJmUtrGWyYifNQd1U+Yxm9EDNssOUP/auybeuBH
         pZvg==
X-Gm-Message-State: APjAAAUDy+hLn2sFp22hQGAeHL78QpbNUb6/cXwXFjMRsHKZkQdWG0nW
        t8QZfD3OSD5kxc0diedWVNcrlHwlRI3LnfsX
X-Google-Smtp-Source: APXvYqxYWP+MlBN7eY9lZlr2Qma3yV9RGUKKjYifSJAYYpBmJsT8FB1WRL0Y/O+fMsU2KLeniCz4sw==
X-Received: by 2002:a1c:444:: with SMTP id 65mr4181826wme.73.1571339399406;
        Thu, 17 Oct 2019 12:09:59 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.09.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:09:58 -0700 (PDT)
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
Subject: [PATCH v4 06/35] crypto: arm64/chacha - expose arm64 ChaCha routine as library function
Date:   Thu, 17 Oct 2019 21:09:03 +0200
Message-Id: <20191017190932.1947-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose the accelerated NEON ChaCha routine directly as a symbol
export so that users of the ChaCha library API can use it directly.

Given that calls into the library API will always go through the
routines in this module if it is enabled, switch to static keys
to select the optimal implementation available (which may be none
at all, in which case we defer to the generic implementation for
all invocations).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig            |  1 +
 arch/arm64/crypto/chacha-neon-glue.c | 46 ++++++++++++++++++--
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index fdf52d5f18f9..17bada4b9dd2 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -104,6 +104,7 @@ config CRYPTO_CHACHA20_NEON
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_LIB_CHACHA_GENERIC
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_NHPOLY1305_NEON
 	tristate "NHPoly1305 hash function using NEON instructions (for Adiantum)"
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index 36189514a616..d1310389cf87 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -23,6 +23,7 @@
 #include <crypto/internal/chacha.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -36,6 +37,8 @@ asmlinkage void chacha_4block_xor_neon(u32 *state, u8 *dst, const u8 *src,
 				       int nrounds, int bytes);
 asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
+
 static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 			  int bytes, int nrounds)
 {
@@ -59,6 +62,37 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
+void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
+{
+	if (!static_branch_likely(&have_neon) || !crypto_simd_usable()) {
+		hchacha_block_generic(state, stream, nrounds);
+	} else {
+		kernel_neon_begin();
+		hchacha_block_neon(state, stream, nrounds);
+		kernel_neon_end();
+	}
+}
+EXPORT_SYMBOL(hchacha_block_arch);
+
+void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
+{
+	chacha_init_generic(state, key, iv);
+}
+EXPORT_SYMBOL(chacha_init_arch);
+
+void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
+		       int nrounds)
+{
+	if (!static_branch_likely(&have_neon) || bytes <= CHACHA_BLOCK_SIZE ||
+	    !crypto_simd_usable())
+		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
+
+	kernel_neon_begin();
+	chacha_doneon(state, dst, src, bytes, nrounds);
+	kernel_neon_end();
+}
+EXPORT_SYMBOL(chacha_crypt_arch);
+
 static int chacha_neon_stream_xor(struct skcipher_request *req,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
@@ -76,7 +110,8 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = rounddown(nbytes, walk.stride);
 
-		if (!crypto_simd_usable()) {
+		if (!static_branch_likely(&have_neon) ||
+		    !crypto_simd_usable()) {
 			chacha_crypt_generic(state, walk.dst.virt.addr,
 					     walk.src.virt.addr, nbytes,
 					     ctx->nrounds);
@@ -110,7 +145,7 @@ static int xchacha_neon(struct skcipher_request *req)
 
 	chacha_init_generic(state, ctx->key, req->iv);
 
-	if (crypto_simd_usable()) {
+	if (static_branch_likely(&have_neon) && crypto_simd_usable()) {
 		kernel_neon_begin();
 		hchacha_block_neon(state, subctx.key, ctx->nrounds);
 		kernel_neon_end();
@@ -191,14 +226,17 @@ static struct skcipher_alg algs[] = {
 static int __init chacha_simd_mod_init(void)
 {
 	if (!cpu_have_named_feature(ASIMD))
-		return -ENODEV;
+		return 0;
+
+	static_branch_enable(&have_neon);
 
 	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit chacha_simd_mod_fini(void)
 {
-	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
+	if (cpu_have_named_feature(ASIMD))
+		crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 module_init(chacha_simd_mod_init);
-- 
2.20.1

