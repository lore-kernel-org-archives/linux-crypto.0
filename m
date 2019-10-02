Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0644ECE58A
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4E1C222BE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dZqM9z9o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfJBORo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:17:44 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39308 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfJBORo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so7189891wml.4
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dBiDjFWbEjDL9fmqhYoLl5QE0ElcIlJwJJ55DmCeUio=;
        b=dZqM9z9ojbji1lntxp0z7Xxr17aFu+8wjFikfVykOhdIBekaGS66SrtzlWKEeXKKGa
         PhXXmdZRZXNxMsoFjLVawAVfXHoE6BeD0FUVt9DZsU0gVbbZBG4AG2FADRttICXc7JrR
         x8HTHeZKyHEqvsXwvH1g2Fd1QeTh4ZaXLmNEBGqirdNY2K8vuqT7i++qvhKHeLVER4Na
         v1jAAUvG0WKETP6hJV6vrOU6dYY7Rwci7ULGpJmV9fNlj1GCuJmTg5zQjlTGwXyaYgW9
         lQ7bv03M8iSVc5smDCNwZGS1SKTauByXk0j3MCt7OenlbjjvFineZzpEJVwq94JX4gfr
         eV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dBiDjFWbEjDL9fmqhYoLl5QE0ElcIlJwJJ55DmCeUio=;
        b=m8fnc35KB2iYrCl0f9HmDE0LMqF1hcUTYMqHPaxt1VeGt9TuwPUplB2bfTocd9QUQ9
         CUMC3R6n2WX+VWghHnfIA37rkgfRHizPS7g7wG7KUJJwe8ntgKgAjoGvQlKop/QCoJ5+
         67LLpYpN+icgmlk6DGmGj1Di/8G9b3IROQynSE1ZxF8eUWjjMX0VFInU6kyPOXK0omx5
         7wHgU/2vSOzUhZyzVxD6jiM5ZA0uDfICH5avMVcuaFQzFyERf7ktPdJxRu/un7m1ggEz
         VNlYUTfpPDa+LcbuA2IWWAgfqiBPWDFO0LACIA9FlrTr/9+kqO0Te/Df8nC//1Bl2fVP
         Kxjw==
X-Gm-Message-State: APjAAAWXmp9/EdTek4S5pyTNs4e5T4UYEmRJO96/wU4bSnD1Kru6vHo/
        bVk/Jo8Kx3h/A8tq5dV18v5h1UILNBIoTUi1
X-Google-Smtp-Source: APXvYqz6iD+t77jQn0iDM8V8Vy9ytWvSiDTk83I8jEvAFKXOZIulgz63hUiWePxqfDX6IX4T2Rl9Bw==
X-Received: by 2002:a1c:a90b:: with SMTP id s11mr3317259wme.92.1570025859794;
        Wed, 02 Oct 2019 07:17:39 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:38 -0700 (PDT)
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
Subject: [PATCH v2 01/20] crypto: chacha - move existing library code into lib/crypto
Date:   Wed,  2 Oct 2019 16:16:54 +0200
Message-Id: <20191002141713.31189-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move the existing shared ChaCha code into lib/crypto, and at the
same time, split the support header into a public version, and an
internal version that is only intended for consumption by crypto
implementations.

At the same time, refactor the generic implementation so it only gets
exposed as the chacha_crypt() library function if the architecture does
not override it with its own implementation, potentially falling back
to the generic routine if needed.

And while at it, tidy up lib/crypto/Makefile a bit so we are ready for
some new arrivals.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/chacha-neon-glue.c   |  2 +-
 arch/arm64/crypto/chacha-neon-glue.c |  2 +-
 arch/x86/crypto/chacha_glue.c        |  2 +-
 crypto/Kconfig                       |  8 +++
 crypto/chacha_generic.c              | 44 ++-----------
 include/crypto/chacha.h              | 30 ++++-----
 include/crypto/internal/chacha.h     | 25 ++++++++
 lib/Makefile                         |  3 +-
 lib/crypto/Makefile                  | 20 +++---
 lib/{ => crypto}/chacha.c            | 25 +++++---
 lib/crypto/libchacha.c               | 67 ++++++++++++++++++++
 11 files changed, 151 insertions(+), 77 deletions(-)

diff --git a/arch/arm/crypto/chacha-neon-glue.c b/arch/arm/crypto/chacha-neon-glue.c
index a8e9b534c8da..26576772f18b 100644
--- a/arch/arm/crypto/chacha-neon-glue.c
+++ b/arch/arm/crypto/chacha-neon-glue.c
@@ -20,7 +20,7 @@
  */
 
 #include <crypto/algapi.h>
-#include <crypto/chacha.h>
+#include <crypto/internal/chacha.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index 1495d2b18518..d4cc61bfe79d 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -20,7 +20,7 @@
  */
 
 #include <crypto/algapi.h>
-#include <crypto/chacha.h>
+#include <crypto/internal/chacha.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index 388f95a4ec24..bc62daa8dafd 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -7,7 +7,7 @@
  */
 
 #include <crypto/algapi.h>
-#include <crypto/chacha.h>
+#include <crypto/internal/chacha.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9e524044d312..074b125819b0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1402,8 +1402,16 @@ config CRYPTO_SALSA20
 	  The Salsa20 stream cipher algorithm is designed by Daniel J.
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
+config CRYPTO_ARCH_HAVE_LIB_CHACHA
+	bool
+
+config CRYPTO_LIB_CHACHA
+	tristate
+	select CRYPTO_ALGAPI
+
 config CRYPTO_CHACHA20
 	tristate "ChaCha stream cipher algorithms"
+	select CRYPTO_LIB_CHACHA
 	select CRYPTO_BLKCIPHER
 	help
 	  The ChaCha20, XChaCha20, and XChaCha12 stream cipher algorithms.
diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index 085d8d219987..15a244e2f410 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -8,29 +8,10 @@
 
 #include <asm/unaligned.h>
 #include <crypto/algapi.h>
-#include <crypto/chacha.h>
+#include <crypto/internal/chacha.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/module.h>
 
-static void chacha_docrypt(u32 *state, u8 *dst, const u8 *src,
-			   unsigned int bytes, int nrounds)
-{
-	/* aligned to potentially speed up crypto_xor() */
-	u8 stream[CHACHA_BLOCK_SIZE] __aligned(sizeof(long));
-
-	while (bytes >= CHACHA_BLOCK_SIZE) {
-		chacha_block(state, stream, nrounds);
-		crypto_xor_cpy(dst, src, stream, CHACHA_BLOCK_SIZE);
-		bytes -= CHACHA_BLOCK_SIZE;
-		dst += CHACHA_BLOCK_SIZE;
-		src += CHACHA_BLOCK_SIZE;
-	}
-	if (bytes) {
-		chacha_block(state, stream, nrounds);
-		crypto_xor_cpy(dst, src, stream, bytes);
-	}
-}
-
 static int chacha_stream_xor(struct skcipher_request *req,
 			     const struct chacha_ctx *ctx, const u8 *iv)
 {
@@ -48,8 +29,8 @@ static int chacha_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, CHACHA_BLOCK_SIZE);
 
-		chacha_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
-			       nbytes, ctx->nrounds);
+		chacha_crypt_generic(state, walk.dst.virt.addr,
+				     walk.src.virt.addr, nbytes, ctx->nrounds);
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
@@ -58,22 +39,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
 
 void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv)
 {
-	state[0]  = 0x61707865; /* "expa" */
-	state[1]  = 0x3320646e; /* "nd 3" */
-	state[2]  = 0x79622d32; /* "2-by" */
-	state[3]  = 0x6b206574; /* "te k" */
-	state[4]  = ctx->key[0];
-	state[5]  = ctx->key[1];
-	state[6]  = ctx->key[2];
-	state[7]  = ctx->key[3];
-	state[8]  = ctx->key[4];
-	state[9]  = ctx->key[5];
-	state[10] = ctx->key[6];
-	state[11] = ctx->key[7];
-	state[12] = get_unaligned_le32(iv +  0);
-	state[13] = get_unaligned_le32(iv +  4);
-	state[14] = get_unaligned_le32(iv +  8);
-	state[15] = get_unaligned_le32(iv + 12);
+	chacha_init_generic(state, ctx->key, iv);
 }
 EXPORT_SYMBOL_GPL(crypto_chacha_init);
 
@@ -126,7 +92,7 @@ int crypto_xchacha_crypt(struct skcipher_request *req)
 
 	/* Compute the subkey given the original key and first 128 nonce bits */
 	crypto_chacha_init(state, ctx, req->iv);
-	hchacha_block(state, subctx.key, ctx->nrounds);
+	hchacha_block_generic(state, subctx.key, ctx->nrounds);
 	subctx.nrounds = ctx->nrounds;
 
 	/* Build the real IV */
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index d1e723c6a37d..95a4a0ff4f7d 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -15,9 +15,8 @@
 #ifndef _CRYPTO_CHACHA_H
 #define _CRYPTO_CHACHA_H
 
-#include <crypto/skcipher.h>
+#include <asm/unaligned.h>
 #include <linux/types.h>
-#include <linux/crypto.h>
 
 /* 32-bit stream position, then 96-bit nonce (RFC7539 convention) */
 #define CHACHA_IV_SIZE		16
@@ -29,26 +28,23 @@
 /* 192-bit nonce, then 64-bit stream position */
 #define XCHACHA_IV_SIZE		32
 
-struct chacha_ctx {
-	u32 key[8];
-	int nrounds;
-};
-
-void chacha_block(u32 *state, u8 *stream, int nrounds);
+void chacha_block_generic(u32 *state, u8 *stream, int nrounds);
 static inline void chacha20_block(u32 *state, u8 *stream)
 {
-	chacha_block(state, stream, 20);
+	chacha_block_generic(state, stream, 20);
 }
-void hchacha_block(const u32 *in, u32 *out, int nrounds);
+void hchacha_block(const u32 *state, u32 *out, int nrounds);
+
+void hchacha_block_generic(const u32 *state, u32 *out, int nrounds);
+
+void chacha_init(u32 *state, const u32 *key, const u8 *iv);
 
-void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv);
+void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv);
 
-int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize);
-int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize);
+void chacha_crypt(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
+		  int nrounds);
 
-int crypto_chacha_crypt(struct skcipher_request *req);
-int crypto_xchacha_crypt(struct skcipher_request *req);
+void chacha_crypt_generic(u32 *state, u8 *dst, const u8 *src,
+			  unsigned int bytes, int nrounds);
 
 #endif /* _CRYPTO_CHACHA_H */
diff --git a/include/crypto/internal/chacha.h b/include/crypto/internal/chacha.h
new file mode 100644
index 000000000000..f7ffe0f3fa47
--- /dev/null
+++ b/include/crypto/internal/chacha.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _CRYPTO_INTERNAL_CHACHA_H
+#define _CRYPTO_INTERNAL_CHACHA_H
+
+#include <crypto/chacha.h>
+#include <crypto/skcipher.h>
+#include <linux/crypto.h>
+
+struct chacha_ctx {
+	u32 key[8];
+	int nrounds;
+};
+
+void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv);
+
+int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			   unsigned int keysize);
+int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			   unsigned int keysize);
+
+int crypto_chacha_crypt(struct skcipher_request *req);
+int crypto_xchacha_crypt(struct skcipher_request *req);
+
+#endif /* _CRYPTO_CHACHA_H */
diff --git a/lib/Makefile b/lib/Makefile
index c5892807e06f..5af38fd5cc60 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -26,8 +26,7 @@ endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o timerqueue.o xarray.o \
-	 idr.o extable.o \
-	 sha1.o chacha.o irq_regs.o argv_split.o \
+	 idr.o extable.o sha1.o irq_regs.o argv_split.o \
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index cbe0b6a6450d..e5c131bc75cc 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -1,13 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_CRYPTO_LIB_AES) += libaes.o
-libaes-y := aes.o
+# chacha is used by the /dev/random driver which is always builtin
+obj-y						+= chacha.o
+obj-$(CONFIG_CRYPTO_LIB_CHACHA)			+= libchacha.o
 
-obj-$(CONFIG_CRYPTO_LIB_ARC4) += libarc4.o
-libarc4-y := arc4.o
+obj-$(CONFIG_CRYPTO_LIB_AES)			+= libaes.o
+libaes-y					:= aes.o
 
-obj-$(CONFIG_CRYPTO_LIB_DES) += libdes.o
-libdes-y := des.o
+obj-$(CONFIG_CRYPTO_LIB_ARC4)			+= libarc4.o
+libarc4-y					:= arc4.o
 
-obj-$(CONFIG_CRYPTO_LIB_SHA256) += libsha256.o
-libsha256-y := sha256.o
+obj-$(CONFIG_CRYPTO_LIB_DES)			+= libdes.o
+libdes-y					:= des.o
+
+obj-$(CONFIG_CRYPTO_LIB_SHA256)			+= libsha256.o
+libsha256-y					:= sha256.o
diff --git a/lib/chacha.c b/lib/crypto/chacha.c
similarity index 84%
rename from lib/chacha.c
rename to lib/crypto/chacha.c
index c7c9826564d3..eb8b7fbb9d7c 100644
--- a/lib/chacha.c
+++ b/lib/crypto/chacha.c
@@ -5,9 +5,11 @@
  * Copyright (C) 2015 Martin Willi
  */
 
+#include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/bitops.h>
+#include <linux/string.h>
 #include <linux/cryptohash.h>
 #include <asm/unaligned.h>
 #include <crypto/chacha.h>
@@ -72,7 +74,7 @@ static void chacha_permute(u32 *x, int nrounds)
  * The caller has already converted the endianness of the input.  This function
  * also handles incrementing the block counter in the input matrix.
  */
-void chacha_block(u32 *state, u8 *stream, int nrounds)
+void chacha_block_generic(u32 *state, u8 *stream, int nrounds)
 {
 	u32 x[16];
 	int i;
@@ -86,11 +88,11 @@ void chacha_block(u32 *state, u8 *stream, int nrounds)
 
 	state[12]++;
 }
-EXPORT_SYMBOL(chacha_block);
+EXPORT_SYMBOL(chacha_block_generic);
 
 /**
- * hchacha_block - abbreviated ChaCha core, for XChaCha
- * @in: input state matrix (16 32-bit words)
+ * hchacha_block_generic - abbreviated ChaCha core, for XChaCha
+ * @state: input state matrix (16 32-bit words)
  * @out: output (8 32-bit words)
  * @nrounds: number of rounds (20 or 12; 20 is recommended)
  *
@@ -99,15 +101,22 @@ EXPORT_SYMBOL(chacha_block);
  * skips the final addition of the initial state, and outputs only certain words
  * of the state.  It should not be used for streaming directly.
  */
-void hchacha_block(const u32 *in, u32 *out, int nrounds)
+void hchacha_block_generic(const u32 *state, u32 *stream, int nrounds)
 {
 	u32 x[16];
 
-	memcpy(x, in, 64);
+	memcpy(x, state, 64);
 
 	chacha_permute(x, nrounds);
 
-	memcpy(&out[0], &x[0], 16);
-	memcpy(&out[4], &x[12], 16);
+	memcpy(&stream[0], &x[0], 16);
+	memcpy(&stream[4], &x[12], 16);
 }
+EXPORT_SYMBOL(hchacha_block_generic);
+
+extern void hchacha_block(const u32 *state, u32 *stream, int nrounds)
+	__weak __alias(hchacha_block_generic);
+
+#ifndef CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA
 EXPORT_SYMBOL(hchacha_block);
+#endif
diff --git a/lib/crypto/libchacha.c b/lib/crypto/libchacha.c
new file mode 100644
index 000000000000..2389d98e6537
--- /dev/null
+++ b/lib/crypto/libchacha.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * The "hash function" used as the core of the ChaCha stream cipher (RFC7539)
+ *
+ * Copyright (C) 2015 Martin Willi
+ */
+
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/module.h>
+
+#include <crypto/algapi.h> // for crypto_xor_cpy
+#include <crypto/chacha.h>
+
+void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv)
+{
+	state[0]  = 0x61707865; /* "expa" */
+	state[1]  = 0x3320646e; /* "nd 3" */
+	state[2]  = 0x79622d32; /* "2-by" */
+	state[3]  = 0x6b206574; /* "te k" */
+	state[4]  = key[0];
+	state[5]  = key[1];
+	state[6]  = key[2];
+	state[7]  = key[3];
+	state[8]  = key[4];
+	state[9]  = key[5];
+	state[10] = key[6];
+	state[11] = key[7];
+	state[12] = get_unaligned_le32(iv +  0);
+	state[13] = get_unaligned_le32(iv +  4);
+	state[14] = get_unaligned_le32(iv +  8);
+	state[15] = get_unaligned_le32(iv + 12);
+}
+EXPORT_SYMBOL(chacha_init_generic);
+
+void chacha_crypt_generic(u32 *state, u8 *dst, const u8 *src,
+			  unsigned int bytes, int nrounds)
+{
+	/* aligned to potentially speed up crypto_xor() */
+	u8 stream[CHACHA_BLOCK_SIZE] __aligned(sizeof(long));
+
+	while (bytes >= CHACHA_BLOCK_SIZE) {
+		chacha_block_generic(state, stream, nrounds);
+		crypto_xor_cpy(dst, src, stream, CHACHA_BLOCK_SIZE);
+		bytes -= CHACHA_BLOCK_SIZE;
+		dst += CHACHA_BLOCK_SIZE;
+		src += CHACHA_BLOCK_SIZE;
+	}
+	if (bytes) {
+		chacha_block_generic(state, stream, nrounds);
+		crypto_xor_cpy(dst, src, stream, bytes);
+	}
+}
+EXPORT_SYMBOL(chacha_crypt_generic);
+
+extern void chacha_init(u32 *state, const u32 *key, const u8 *iv)
+	__weak __alias(chacha_init_generic);
+
+extern void chacha_crypt(u32 *, u8 *, const u8 *,  unsigned int, int)
+	__weak __alias(chacha_crypt_generic);
+
+#ifndef CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA
+EXPORT_SYMBOL(chacha_init);
+EXPORT_SYMBOL(chacha_crypt);
+#endif
+
+MODULE_LICENSE("GPL");
-- 
2.20.1

