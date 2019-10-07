Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2962AECE58E
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDCEA20700
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ee7QoeFu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfJGQq2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36234 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfJGQq2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so211915wmc.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JUtSu2dFwCY1DgItWOyayZqegd+iOxLLlyUn/RxwQH4=;
        b=ee7QoeFuMaJ/4z/z0PSsyJNlt6IzvHrCKHoj213MKF7s83aFtpEe8Mm7N79VI+ZLiC
         UKQkKv0T8rUUwtrVJbl7rKR1v+qzYl+EWqbUYtzA60Z5O/mfLO3Zv7GKpdbWYyZObnyP
         F2Plzoo5dpF2cDD686uZBk5j83cnFRxXzuKlOiJp0kw56Jlp5SqU9nNoTGenBl/X6C1j
         xgpus41rLKea/XhYl4YzYqpO+4rArAhEY2GcVH2pAicHWkEsveWS3pN2buAQJ/ACw9+N
         0So+uv3Kc26xVfAnxtT8+jQuwHi93rjAsYrudsa9X3/hQyIkaSTXCW6ZBTH8bFglhS6f
         NGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JUtSu2dFwCY1DgItWOyayZqegd+iOxLLlyUn/RxwQH4=;
        b=DGzDylDpkhzQPx6HA+e46TxOlFZZ8catuCoL8mnB34AG/226yjJ8ZgJ/X8ALra5n+y
         NJMu4uYxhXEwiWZEwg/7iQv4xeQLKI2Wj1hYSpNnwlgBtByvTQiE7ECX6xl9Z8W6415b
         6NghS3ztXpJk5pg2/BNwZut/pgZGf717DbHw/BqMLsAD0mZQb+X1dt+4Gf9YLqFdlJj7
         IkEXXzFTyg9ybaUwbp/HEhXi/xzrPfhHeSisW93xeGbrgIwdnfLcMNdW49AMIHD5pHgz
         HNg9AvJ5upUVLVLsS9JdIHltmrWvO1amVj4PLrcfSnPatKCq4xlUHvO7sj9GgOE2a9z8
         tmsw==
X-Gm-Message-State: APjAAAXfK19Xoe7I0FQoMDUE73Nqhp+AfaqPlMD+r3edvZoki2KU1lVl
        798CoAS5oFr646l0k84WC6WJv555N2Fk5A==
X-Google-Smtp-Source: APXvYqy0yOja1bbKeGW6uZfHZbTEmUfWblTf/nQk2/bvcn9HaIODTFipt7ubcytEGOBW6e+foLw9vQ==
X-Received: by 2002:a1c:6709:: with SMTP id b9mr202093wmc.14.1570466785874;
        Mon, 07 Oct 2019 09:46:25 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:25 -0700 (PDT)
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
Subject: [PATCH v3 05/29] crypto: arm64/chacha - expose arm64 ChaCha routine as library function
Date:   Mon,  7 Oct 2019 18:45:46 +0200
Message-Id: <20191007164610.6881-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/chacha-neon-glue.c | 47 ++++++++++++++++++--
 2 files changed, 44 insertions(+), 4 deletions(-)

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
index 6450bb9f55f4..57e50acf35f8 100644
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
 
+void hchacha_block(const u32 *state, u32 *stream, int nrounds)
+{
+	if (!static_branch_likely(&have_neon) || !crypto_simd_usable()) {
+		hchacha_block_generic(state, stream, nrounds);
+	} else {
+		kernel_neon_begin();
+		hchacha_block_neon(state, stream, nrounds);
+		kernel_neon_end();
+	}
+}
+EXPORT_SYMBOL(hchacha_block);
+
+void chacha_init(u32 *state, const u32 *key, const u8 *iv)
+{
+	chacha_init_generic(state, key, iv);
+}
+EXPORT_SYMBOL(chacha_init);
+
+void chacha_crypt(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
+		  int nrounds)
+{
+	if (!static_branch_likely(&have_neon) || bytes <= CHACHA_BLOCK_SIZE ||
+	    !crypto_simd_usable())
+		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
+
+	kernel_neon_begin();
+	chacha_doneon(state, dst, src, bytes, nrounds);
+	kernel_neon_end();
+}
+EXPORT_SYMBOL(chacha_crypt);
+
 static int chacha_neon_stream_xor(struct skcipher_request *req,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
@@ -78,7 +112,7 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = rounddown(nbytes, walk.stride);
 
-		if (!do_neon) {
+		if (!static_branch_likely(&have_neon) || !do_neon) {
 			chacha_crypt_generic(state, walk.dst.virt.addr,
 					     walk.src.virt.addr, nbytes,
 					     ctx->nrounds);
@@ -112,7 +146,9 @@ static int xchacha_neon(struct skcipher_request *req)
 
 	chacha_init_generic(state, ctx->key, req->iv);
 
-	if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
+	if (static_branch_likely(&have_neon) &&
+	    req->cryptlen > CHACHA_BLOCK_SIZE &&
+	    crypto_simd_usable()) {
 		kernel_neon_begin();
 		hchacha_block_neon(state, subctx.key, ctx->nrounds);
 		kernel_neon_end();
@@ -193,14 +229,17 @@ static struct skcipher_alg algs[] = {
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

