Return-Path: <SRS0=xDoY=XY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E12EC4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B05D21928
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C5im0cXQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbfI2RjD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:39:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35915 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729742AbfI2RjC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 13:39:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so10215381wmc.1
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2019 10:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EiwPtV0QFOq6zlLEHTm5HZSlYrdGW9J+wv2xPz8xyFY=;
        b=C5im0cXQNv3wGsmiCLsIcsFTaYYE97Ji1QEDLT98kH4bBwMlnuT0RmjtWkmdCyTFAi
         Jk1bPl29M1SEIu4iSZmeZl9Cufa8woVy6eFdZyngAXnJIwG7dlRHWzKOfpBOKQHjid38
         qT4VdUp3zcBV/GlPcJAx0VgNAiprMHf3JzC1VMjXh+NDpyisW8D+saVmRZoBOGtV7use
         jlq9DwT1tLbnsPg6Bg4JAbr6pbmZlc+BvH36Mvx2YY+WrViQZqgbrk4y7qkRrOBLOnGz
         MIjzLs/4A83Jw6lrQVdIhbXaEW4X1TFhxRwqjZv/85fEOBPFa2i7P8tlxpVxQCaQmD9v
         zFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EiwPtV0QFOq6zlLEHTm5HZSlYrdGW9J+wv2xPz8xyFY=;
        b=nJQTzurRO2DtjaksPA/1tzz+/WZzN4/PJu+E905S4SmzmZvnopm4gver11TnJ3U8VO
         YIfNEok6ACndFTfkGrDGEktrhuKKY96hdGWArdbUIa4d2u/OsRq5J/dsqn6PoDkC3w1W
         +bMzsaLEwqEMYmL5vlAgcj8LDfnOE6WG1EmAiwU4QO4z1JEBDuhSrj5O3N9itjvyzY8d
         0YjV7DkHPbnRFYPIkjgrLDzVpjflFNg6QK4HMwsiEZtS1dIad5gHKWex7HVSPfidh5l5
         +xYhtQhfcydsXgUHRMApxj6F5lJnj44CLYcW/MwkUkWthlARJQmvqKQHlp2wNGdl2oEw
         PeNg==
X-Gm-Message-State: APjAAAWXebtbmKg5gKMslWMh02uNyKJ4r21dbyeMVIlFb7BIuynlEjV8
        bknLAiZd0Y2fyzlyy+PHmqPo8a9R8UMPsjzU
X-Google-Smtp-Source: APXvYqz0/s7ZCwm+bkMhkID88/ReeGlSr4oErsjPCITzoNF0vT6AtWyybZ/mTW8wdn0p6O1ZNn0rLA==
X-Received: by 2002:a7b:c932:: with SMTP id h18mr11214396wml.86.1569778738649;
        Sun, 29 Sep 2019 10:38:58 -0700 (PDT)
Received: from e123331-lin.nice.arm.com (bar06-5-82-246-156-241.fbx.proxad.net. [82.246.156.241])
        by smtp.gmail.com with ESMTPSA id q192sm17339779wme.23.2019.09.29.10.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 10:38:57 -0700 (PDT)
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
Subject: [RFC PATCH 01/20] crypto: chacha - move existing library code into lib/crypto
Date:   Sun, 29 Sep 2019 19:38:31 +0200
Message-Id: <20190929173850.26055-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move the existing shared ChaCha code into lib/crypto, and at the
same time, split the support header into a public version, and an
internal version that is only intended for consumption by crypto
implementations.

Also, refactor the generic implementation so it only gets exposed as the
chacha_crypt() library function if the architecture does not override it
with its own implementation, potentially falling back to the generic
routine if needed.

And while at it, tidy up lib/crypto/Makefile a bit so we are ready for
some new arrivals.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/chacha-neon-glue.c   |  2 +-
 arch/arm64/crypto/chacha-neon-glue.c |  2 +-
 arch/x86/crypto/chacha_glue.c        |  2 +-
 crypto/Kconfig                       |  8 ++++
 crypto/chacha_generic.c              | 44 ++----------------
 include/crypto/chacha.h              | 49 +++++++++++++-------
 include/crypto/internal/chacha.h     | 25 ++++++++++
 lib/Makefile                         |  3 +-
 lib/crypto/Makefile                  | 19 ++++----
 lib/{ => crypto}/chacha.c            | 37 +++++++++++++--
 10 files changed, 118 insertions(+), 73 deletions(-)

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
index 9ea2b22aff90..5826381aca3a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1374,6 +1374,14 @@ config CRYPTO_SALSA20
 	  The Salsa20 stream cipher algorithm is designed by Daniel J.
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
+config CRYPTO_ARCH_HAVE_LIB_CHACHA
+	tristate
+
+config CRYPTO_LIB_CHACHA
+	tristate
+	default y
+	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
+
 config CRYPTO_CHACHA20
 	tristate "ChaCha stream cipher algorithms"
 	select CRYPTO_BLKCIPHER
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
index d1e723c6a37d..c29d8f7d69ed 100644
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
@@ -29,26 +28,42 @@
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
+}
+void hchacha_block_generic(const u32 *in, u32 *out, int nrounds);
+
+static inline void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv)
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
 }
-void hchacha_block(const u32 *in, u32 *out, int nrounds);
 
-void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv);
+static inline void chacha_init(u32 *state, const u32 *key, const u8 *iv)
+{
+	chacha_init_generic(state, key, iv);
+}
 
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
index 29c02a924973..1436c9608fdb 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -30,8 +30,7 @@ endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o timerqueue.o xarray.o \
-	 idr.o extable.o \
-	 sha1.o chacha.o irq_regs.o argv_split.o \
+	 idr.o extable.o sha1.o irq_regs.o argv_split.o \
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index cbe0b6a6450d..24dad058f2ae 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -1,13 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_CRYPTO_LIB_AES) += libaes.o
-libaes-y := aes.o
+# chacha is used by the /dev/random driver which is always builtin
+obj-y						+= chacha.o
 
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
similarity index 76%
rename from lib/chacha.c
rename to lib/crypto/chacha.c
index c7c9826564d3..d4b7c391d934 100644
--- a/lib/chacha.c
+++ b/lib/crypto/chacha.c
@@ -5,11 +5,14 @@
  * Copyright (C) 2015 Martin Willi
  */
 
+#include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/bitops.h>
+#include <linux/string.h>
 #include <linux/cryptohash.h>
 #include <asm/unaligned.h>
+#include <crypto/algapi.h> // for crypto_xor_cpy
 #include <crypto/chacha.h>
 
 static void chacha_permute(u32 *x, int nrounds)
@@ -72,7 +75,7 @@ static void chacha_permute(u32 *x, int nrounds)
  * The caller has already converted the endianness of the input.  This function
  * also handles incrementing the block counter in the input matrix.
  */
-void chacha_block(u32 *state, u8 *stream, int nrounds)
+void chacha_block_generic(u32 *state, u8 *stream, int nrounds)
 {
 	u32 x[16];
 	int i;
@@ -86,7 +89,7 @@ void chacha_block(u32 *state, u8 *stream, int nrounds)
 
 	state[12]++;
 }
-EXPORT_SYMBOL(chacha_block);
+EXPORT_SYMBOL(chacha_block_generic);
 
 /**
  * hchacha_block - abbreviated ChaCha core, for XChaCha
@@ -99,7 +102,7 @@ EXPORT_SYMBOL(chacha_block);
  * skips the final addition of the initial state, and outputs only certain words
  * of the state.  It should not be used for streaming directly.
  */
-void hchacha_block(const u32 *in, u32 *out, int nrounds)
+void hchacha_block_generic(const u32 *in, u32 *out, int nrounds)
 {
 	u32 x[16];
 
@@ -110,4 +113,30 @@ void hchacha_block(const u32 *in, u32 *out, int nrounds)
 	memcpy(&out[0], &x[0], 16);
 	memcpy(&out[4], &x[12], 16);
 }
-EXPORT_SYMBOL(hchacha_block);
+EXPORT_SYMBOL(hchacha_block_generic);
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
+#ifndef CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA
+extern void chacha_crypt(u32 *, u8 *, const u8 *,  unsigned int, int)
+	__alias(chacha_crypt_generic);
+EXPORT_SYMBOL(chacha_crypt);
+#endif
-- 
2.17.1

