Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96090ECE58E
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5837621479
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nFJCD1Dq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbfJGQqY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53372 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbfJGQqY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so210235wmd.3
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0gEmxeH+jAL5YCY/xaxgt/hBFTpKA4iqFe2+CerWP+o=;
        b=nFJCD1DqafdU3WmBpCjv7uA9aJcdKgZq24FSWW0Vb/pgoB/ouvYaSm9qc4wE+ddWe1
         vsB9dMqibJW/3mRa6nf8MMtdD361K78R+GPgdgTIwMN2IdHNttcC/wgg8VKWE0ckzRfG
         KH6rS772FhpIHYC/cEPPv7inLxmQJ/zF1CA+aEQaljVL4na9lJVUY6vNAeAaAeHjhmqi
         aC1h0MyWpyeFDIHNOLnJXS5EVe0sTWk3p8EBXTrgGAISxM28vxlY9trzASBTdOZsOok+
         b1UzsHZfraSYN8FrCezc+x8yKMzDFx7DSI1UwN1bypiRe2vjZZTJXfZfOg/mU9Jae6iu
         smVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0gEmxeH+jAL5YCY/xaxgt/hBFTpKA4iqFe2+CerWP+o=;
        b=HnYRvK+RnY51jEXDQzADbwHjQV6jveCkVu6Om6KIz+8GOCxpLJYdU8Lqqy/F/rs+Ty
         sFT5SISXSI6Hwj9axaT2vKW1PV83how/U1Exc4YQeWuvUaR81RcfwPzf/I7YVV4Y4E3/
         +Yr0K9q5D+D5FslnD/PChbRA7fSCyr13uKHGPnRNroJofd8cwu3U6TkR9eBeub+BaV+F
         XlUShZHjZ2iNsfhaSmv9Bse7UAnMNpY6Mh/5taMQof2PE30M4ENK8Q6AK7doJU5/otUH
         LzSrHRYovE6bYzYtwqaOhPbiIy7TtBWFmILEfZK27zbtVDxzmyu3jDqv9t/iDTd1rwPi
         n65g==
X-Gm-Message-State: APjAAAUepuNQuPrajg6Sq1cxWoHdEBv/3i4uEJ9m7OIPIc8l4/HLHR3a
        SVHreVcxIaMUXDgIj8ZmBJEdJAvmoZ8pxw==
X-Google-Smtp-Source: APXvYqyn4wK1qCRGUCutqfF0BjdBpLwrSrmUZEhX72aiG2TulbemVf4lG9q5wGy7/opo592SofF4EQ==
X-Received: by 2002:a1c:2d54:: with SMTP id t81mr129924wmt.167.1570466780753;
        Mon, 07 Oct 2019 09:46:20 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:19 -0700 (PDT)
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
Subject: [PATCH v3 01/29] crypto: chacha - move existing library code into lib/crypto
Date:   Mon,  7 Oct 2019 18:45:42 +0200
Message-Id: <20191007164610.6881-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, our generic ChaCha implementation consists of a permute
function in lib/chacha.c that operates on the 64-byte ChaCha state
directly [and which is always included into the core kernel since it
is used by the /dev/random driver], and the crypto API plumbing to
expose it as a skcipher.

In order to support in-kernel users that need the ChaCha streamcipher
but have no need [or tolerance] for going through the abstractions of
the crypto API, let's expose the streamcipher bits via a library API
as well, in a way that permits the implementation to be superseded by
an architecture specific one if provided.

So move the streamcipher code into a separate module in lib/crypto,
and expose the init() and crypt() routines to users of the library.

And while at it, tidy up lib/crypto/Makefile a bit so we are ready for
some new arrivals.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/chacha-neon-glue.c   |  2 +-
 arch/arm64/crypto/chacha-neon-glue.c |  2 +-
 arch/x86/crypto/chacha_glue.c        |  2 +-
 crypto/Kconfig                       | 12 ++++
 crypto/chacha_generic.c              | 60 ++------------------
 include/crypto/chacha.h              | 48 ++++++++++------
 include/crypto/internal/chacha.h     | 41 +++++++++++++
 lib/Makefile                         |  3 +-
 lib/crypto/Makefile                  | 20 ++++---
 lib/{ => crypto}/chacha.c            | 25 +++++---
 lib/crypto/libchacha.c               | 49 ++++++++++++++++
 11 files changed, 171 insertions(+), 93 deletions(-)

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
index 9e524044d312..b39ca79ef65f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1402,8 +1402,20 @@ config CRYPTO_SALSA20
 	  The Salsa20 stream cipher algorithm is designed by Daniel J.
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
+config CRYPTO_ARCH_HAVE_LIB_CHACHA
+	tristate
+
+config CRYPTO_LIB_CHACHA
+	tristate
+
+config CRYPTO_LIB_CHACHA_GENERIC
+	tristate
+	default CRYPTO_LIB_CHACHA if !CRYPTO_ARCH_HAVE_LIB_CHACHA
+	select CRYPTO_ALGAPI
+
 config CRYPTO_CHACHA20
 	tristate "ChaCha stream cipher algorithms"
+	select CRYPTO_LIB_CHACHA_GENERIC
 	select CRYPTO_BLKCIPHER
 	help
 	  The ChaCha20, XChaCha20, and XChaCha12 stream cipher algorithms.
diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index 085d8d219987..ebae6d9d9b32 100644
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
 
@@ -58,41 +39,10 @@ static int chacha_stream_xor(struct skcipher_request *req,
 
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
 
-static int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			 unsigned int keysize, int nrounds)
-{
-	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int i;
-
-	if (keysize != CHACHA_KEY_SIZE)
-		return -EINVAL;
-
-	for (i = 0; i < ARRAY_SIZE(ctx->key); i++)
-		ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
-
-	ctx->nrounds = nrounds;
-	return 0;
-}
-
 int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keysize)
 {
@@ -126,7 +76,7 @@ int crypto_xchacha_crypt(struct skcipher_request *req)
 
 	/* Compute the subkey given the original key and first 128 nonce bits */
 	crypto_chacha_init(state, ctx, req->iv);
-	hchacha_block(state, subctx.key, ctx->nrounds);
+	hchacha_block_generic(state, subctx.key, ctx->nrounds);
 	subctx.nrounds = ctx->nrounds;
 
 	/* Build the real IV */
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index d1e723c6a37d..3b63cda7a994 100644
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
@@ -29,26 +28,41 @@
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
index 000000000000..8724545bc959
--- /dev/null
+++ b/include/crypto/internal/chacha.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _CRYPTO_INTERNAL_CHACHA_H
+#define _CRYPTO_INTERNAL_CHACHA_H
+
+#include <crypto/chacha.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/crypto.h>
+
+struct chacha_ctx {
+	u32 key[8];
+	int nrounds;
+};
+
+void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv);
+
+static inline int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				unsigned int keysize, int nrounds)
+{
+	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int i;
+
+	if (keysize != CHACHA_KEY_SIZE)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(ctx->key); i++)
+		ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
+
+	ctx->nrounds = nrounds;
+	return 0;
+}
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
index cbe0b6a6450d..0ce40604e104 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -1,13 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_CRYPTO_LIB_AES) += libaes.o
-libaes-y := aes.o
+# chacha is used by the /dev/random driver which is always builtin
+obj-y						+= chacha.o
+obj-$(CONFIG_CRYPTO_LIB_CHACHA_GENERIC)		+= libchacha.o
 
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
index c7c9826564d3..6617ee36967d 100644
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
+#if !IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA)
 EXPORT_SYMBOL(hchacha_block);
+#endif
diff --git a/lib/crypto/libchacha.c b/lib/crypto/libchacha.c
new file mode 100644
index 000000000000..95c927a2f2a9
--- /dev/null
+++ b/lib/crypto/libchacha.c
@@ -0,0 +1,49 @@
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
+void __weak chacha_init(u32 *state, const u32 *key, const u8 *iv)
+{
+	chacha_init_generic(state, key, iv);
+}
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
+extern void chacha_crypt(u32 *state, u8 *dst, const u8 *src,
+			 unsigned int bytes, int nrounds)
+	__weak __alias(chacha_crypt_generic);
+
+#if !IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA)
+EXPORT_SYMBOL(chacha_init);
+EXPORT_SYMBOL(chacha_crypt);
+#endif
+
+MODULE_LICENSE("GPL");
-- 
2.20.1

