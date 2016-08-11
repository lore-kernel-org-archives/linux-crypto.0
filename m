From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v6 5/5] crypto: LRNG - add ChaCha20 support
Date: Thu, 11 Aug 2016 14:26:48 +0200
Message-ID: <3413618.ZeIvpBsgr3@positron.chronox.de>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34746 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbcHKM0w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2016 08:26:52 -0400
In-Reply-To: <4723196.TTQvcXsLCG@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case the kernel crypto API is not compiled, use ChaCha20 stream
cipher as DRNG. The LRNG ChaCha20 support provides the DRNG
implementation with the generate and update functions.

Th DRNG implements enhanced backward secrecy by re-creating the
entire internal state after generating random numbers.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig           |   1 -
 crypto/Makefile          |   7 +-
 crypto/lrng_standalone.c | 220 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 226 insertions(+), 2 deletions(-)
 create mode 100644 crypto/lrng_standalone.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 71df7fc..ee5aff4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1667,7 +1667,6 @@ config CRYPTO_JITTERENTROPY
 
 config CRYPTO_LRNG
 	bool "Linux Random Number Generator"
-	select CRYPTO_DRBG_MENU
 	select CRYPTO_CMAC if CRYPTO_DRBG_CTR
 	help
 	  The Linux Random Number Generator (LRNG) is the replacement
diff --git a/crypto/Makefile b/crypto/Makefile
index 12d4249..99fb0e1 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -123,7 +123,12 @@ obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
 CFLAGS_jitterentropy.o = -O0
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
 obj-$(CONFIG_CRYPTO_LRNG) += lrng.o
-lrng-y += lrng_base.o lrng_kcapi.o
+lrng-y += lrng_base.o
+ifeq ($(CONFIG_CRYPTO_DRBG),y)
+lrng-y += lrng_kcapi.o
+else
+lrng-y += lrng_standalone.o
+endif
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
diff --git a/crypto/lrng_standalone.c b/crypto/lrng_standalone.c
new file mode 100644
index 0000000..7c5d456
--- /dev/null
+++ b/crypto/lrng_standalone.c
@@ -0,0 +1,220 @@
+/*
+ * Backend for the LRNG providing the cryptographic primitives using
+ * standalone cipher implementations.
+ *
+ * Copyright (C) 2016, Stephan Mueller <smueller@chronox.de>
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, and the entire permission notice in its entirety,
+ *    including the disclaimer of warranties.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote
+ *    products derived from this software without specific prior
+ *    written permission.
+ *
+ * ALTERNATIVELY, this product may be distributed under the terms of
+ * the GNU General Public License, in which case the provisions of the GPL2
+ * are required INSTEAD OF the above restrictions.  (This clause is
+ * necessary due to a potential bad interaction between the GPL and
+ * the restrictions contained in a BSD-style copyright.)
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
+ * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+ * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/cryptohash.h>
+#include <crypto/chacha20.h>
+#include <linux/random.h>
+
+/******************************* ChaCha20 DRNG *******************************/
+
+/* State according to RFC 7539 section 2.3 */
+struct chacha20_state {
+	u32 constants[4];
+	union {
+		u32 u[(CHACHA20_KEY_SIZE / sizeof(u32))];
+		u8  b[CHACHA20_KEY_SIZE];
+	} key;
+	u32 counter;
+	u32 nonce[3];
+};
+
+/**
+ * Update of the ChaCha20 state by generating one ChaCha20 block which is
+ * equal to the state of the ChaCha20. The generated block is XORed into
+ * the key part of the state. This shall ensure backtracking resistance as well
+ * as a proper mix of the ChaCha20 state once the key is injected.
+ */
+static void lrng_chacha20_update(struct chacha20_state *chacha20)
+{
+	u32 tmp[(CHACHA20_BLOCK_SIZE / sizeof(u32))];
+	u32 i;
+
+	BUILD_BUG_ON(sizeof(struct chacha20_state) != CHACHA20_BLOCK_SIZE);
+	BUILD_BUG_ON(CHACHA20_BLOCK_SIZE != 2 * CHACHA20_KEY_SIZE);
+
+	chacha20_block(&chacha20->constants[0], tmp);
+	for (i = 0; i < (CHACHA20_KEY_SIZE / sizeof(uint32_t)); i++)
+		chacha20->key.u[i] ^= tmp[i];
+	for (i = 0; i < (CHACHA20_KEY_SIZE / sizeof(uint32_t)); i++)
+		chacha20->key.u[i] ^=
+			tmp[i + (CHACHA20_KEY_SIZE / sizeof(uint32_t))];
+
+	memzero_explicit(tmp, sizeof(tmp));
+
+	/* Deterministic increment of nonce as required in RFC 7539 chapter 4 */
+	chacha20->nonce[0]++;
+	if (chacha20->nonce[0] == 0)
+		chacha20->nonce[1]++;
+	if (chacha20->nonce[1] == 0)
+		chacha20->nonce[2]++;
+
+	/* Leave counter untouched as it is start value is undefined in RFC */
+}
+
+/**
+ * Seed the ChaCha20 DRNG by injecting the input data into the key part of
+ * the ChaCha20 state. If the input data is longer than the ChaCha20 key size,
+ * perform a ChaCha20 operation after processing of key size input data.
+ * This operation shall spread out the entropy into the ChaCha20 state before
+ * new entropy is injected into the key part.
+ */
+int lrng_drng_seed_helper(void *drng, const u8 *inbuf, u32 inbuflen)
+{
+	struct chacha20_state *chacha20 = (struct chacha20_state *)drng;
+
+	while (inbuflen) {
+		u32 i, todo = min_t(u32, inbuflen, CHACHA20_KEY_SIZE);
+
+		for (i = 0; i < todo; i++)
+			chacha20->key.b[i] ^= inbuf[i];
+
+		/* Break potential dependencies between the inbuf key blocks */
+		lrng_chacha20_update(chacha20);
+		inbuf += todo;
+		inbuflen -= todo;
+	}
+
+	return 0;
+}
+
+/**
+ * Chacha20 DRNG generation of random numbers: the stream output of ChaCha20
+ * is the random number. After the completion of the generation of the
+ * stream, the entire ChaCha20 state is updated.
+ *
+ * Note, as the ChaCha20 implements a 32 bit counter, we must ensure
+ * that this function is only invoked for at most 2^32 - 1 ChaCha20 blocks
+ * before a reseed or an update happens. This is ensured by the variable
+ * outbuflen which is a 32 bit integer defining the number of bytes to be
+ * generated by the ChaCha20 DRNG. At the end of this function, an update
+ * operation is invoked which implies that the 32 bit counter will never be
+ * overflown in this implementation.
+ */
+int lrng_drng_generate_helper(void *drng, u8 *outbuf, u32 outbuflen)
+{
+	struct chacha20_state *chacha20 = (struct chacha20_state *)drng;
+	u32 ret = outbuflen;
+
+	while (outbuflen >= CHACHA20_BLOCK_SIZE) {
+		chacha20_block(&chacha20->constants[0], outbuf);
+		outbuf += CHACHA20_BLOCK_SIZE;
+		outbuflen -= CHACHA20_BLOCK_SIZE;
+	}
+
+	if (outbuflen) {
+		u8 stream[CHACHA20_BLOCK_SIZE];
+
+		chacha20_block(&chacha20->constants[0], stream);
+		memcpy(outbuf, stream, outbuflen);
+		memzero_explicit(stream, sizeof(stream));
+	}
+
+	lrng_chacha20_update(chacha20);
+
+	return ret;
+}
+
+/**
+ * Allocation of the DRBG state
+ */
+void *lrng_drng_alloc(u8 *drng_name, u32 blocklen_bytes, u32 sec_strength)
+{
+	struct chacha20_state *chacha20;
+	unsigned long v;
+
+	chacha20 = kzalloc(sizeof(struct chacha20_state), GFP_KERNEL);
+	if (!chacha20)
+		return NULL;
+
+	memcpy(&chacha20->constants[0], "expand 32-byte k", 16);
+	if (arch_get_random_long(&v))
+		chacha20->nonce[0] ^= v;
+	if (arch_get_random_long(&v))
+		chacha20->nonce[1] ^= v;
+	if (arch_get_random_long(&v))
+		chacha20->nonce[2] ^= v;
+
+	if (sec_strength > CHACHA20_KEY_SIZE)
+		goto err;
+	if (blocklen_bytes != CHACHA20_BLOCK_SIZE)
+		goto err;
+
+	pr_info("ChaCha20 core allocated\n");
+
+	return chacha20;
+
+err:
+	kfree(chacha20);
+	return NULL;
+}
+
+void lrng_drng_dealloc(void *drng)
+{
+	struct chacha20_state *chacha20 = (struct chacha20_state *)drng;
+
+	kzfree(chacha20);
+}
+
+/******************************* Hash Operation *******************************/
+
+void *lrng_hash_alloc(u8 *hashname, u8 *key, u32 keylen)
+{
+	return NULL;
+}
+
+u32 lrng_hash_digestsize(void *hash)
+{
+	return (SHA_DIGEST_WORDS * sizeof(u32));
+}
+
+int lrng_hash_buffer(void *hash, u8 *inbuf, u32 inbuflen, u8 *digest)
+{
+	u32 i;
+	u32 workspace[SHA_WORKSPACE_WORDS];
+
+	WARN_ON(inbuflen % SHA_WORKSPACE_WORDS);
+
+	for (i = 0; i < inbuflen; i += (SHA_WORKSPACE_WORDS * sizeof(u32)))
+		sha_transform((u32 *)digest, (inbuf + i), workspace);
+	memzero_explicit(workspace, sizeof(workspace));
+
+	return 0;
+}
-- 
2.7.4
