From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v5 6/7] crypto: isolate the chacha20_block function
Date: Sun, 19 Jun 2016 18:01:48 +0200
Message-ID: <2028708.VAINmYoSqU@positron.chronox.de>
References: <2754489.L1QYabbYUc@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2754489.L1QYabbYUc@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The chacha20_block function is extracted into its separate C file to
allow it to be used by other callers.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig            |  4 +++
 crypto/Makefile           |  1 +
 crypto/chacha20_block.c   | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 crypto/chacha20_generic.c | 61 ------------------------------------
 include/crypto/chacha20.h |  1 +
 5 files changed, 85 insertions(+), 61 deletions(-)
 create mode 100644 crypto/chacha20_block.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 772d430..2822c0f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1224,9 +1224,13 @@ config CRYPTO_SALSA20_X86_64
 	  The Salsa20 stream cipher algorithm is designed by Daniel J.
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
+config CRYPTO_CHACHA20_BLOCK
+	bool
+
 config CRYPTO_CHACHA20
 	tristate "ChaCha20 cipher algorithm"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_CHACHA20_BLOCK
 	help
 	  ChaCha20 cipher algorithm, RFC7539.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index f013fac..1b4cc35 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_SALSA20) += salsa20_generic.o
 obj-$(CONFIG_CRYPTO_CHACHA20) += chacha20_generic.o
+obj-$(CONFIG_CRYPTO_CHACHA20_BLOCK) += chacha20_block.o
 obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
diff --git a/crypto/chacha20_block.c b/crypto/chacha20_block.c
new file mode 100644
index 0000000..610b391
--- /dev/null
+++ b/crypto/chacha20_block.c
@@ -0,0 +1,79 @@
+/*
+ * ChaCha20 256-bit cipher algorithm, RFC7539
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/bitops.h>
+#include <linux/cryptohash.h>
+#include <asm/unaligned.h>
+#include <crypto/chacha20.h>
+
+static inline u32 rotl32(u32 v, u8 n)
+{
+	return (v << n) | (v >> (sizeof(v) * 8 - n));
+}
+
+void chacha20_block(u32 *state, void *stream)
+{
+	u32 x[16], *out = stream;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(x); i++)
+		x[i] = state[i];
+
+	for (i = 0; i < 20; i += 2) {
+		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],  16);
+		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],  16);
+		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],  16);
+		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],  16);
+
+		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],  12);
+		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],  12);
+		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10], 12);
+		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11], 12);
+
+		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],   8);
+		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],   8);
+		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],   8);
+		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],   8);
+
+		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],   7);
+		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],   7);
+		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10],  7);
+		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11],  7);
+
+		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],  16);
+		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],  16);
+		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],  16);
+		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],  16);
+
+		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10], 12);
+		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11], 12);
+		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],  12);
+		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],  12);
+
+		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],   8);
+		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],   8);
+		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],   8);
+		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],   8);
+
+		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10],  7);
+		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11],  7);
+		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],   7);
+		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],   7);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(x); i++)
+		out[i] = cpu_to_le32(x[i] + state[i]);
+
+	state[12]++;
+}
+EXPORT_SYMBOL(chacha20_block);
diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
index da9c899..1cab831 100644
--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -15,72 +15,11 @@
 #include <linux/module.h>
 #include <crypto/chacha20.h>
 
-static inline u32 rotl32(u32 v, u8 n)
-{
-	return (v << n) | (v >> (sizeof(v) * 8 - n));
-}
-
 static inline u32 le32_to_cpuvp(const void *p)
 {
 	return le32_to_cpup(p);
 }
 
-static void chacha20_block(u32 *state, void *stream)
-{
-	u32 x[16], *out = stream;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(x); i++)
-		x[i] = state[i];
-
-	for (i = 0; i < 20; i += 2) {
-		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],  16);
-		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],  16);
-		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],  16);
-		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],  16);
-
-		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],  12);
-		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],  12);
-		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10], 12);
-		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11], 12);
-
-		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],   8);
-		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],   8);
-		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],   8);
-		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],   8);
-
-		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],   7);
-		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],   7);
-		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10],  7);
-		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11],  7);
-
-		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],  16);
-		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],  16);
-		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],  16);
-		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],  16);
-
-		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10], 12);
-		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11], 12);
-		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],  12);
-		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],  12);
-
-		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],   8);
-		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],   8);
-		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],   8);
-		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],   8);
-
-		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10],  7);
-		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11],  7);
-		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],   7);
-		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],   7);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(x); i++)
-		out[i] = cpu_to_le32(x[i] + state[i]);
-
-	state[12]++;
-}
-
 static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
 			     unsigned int bytes)
 {
diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
index 274bbae..20d20f68 100644
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -16,6 +16,7 @@ struct chacha20_ctx {
 	u32 key[8];
 };
 
+void chacha20_block(u32 *state, void *stream);
 void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
 int crypto_chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keysize);
-- 
2.5.5
