Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49B63845CD;
	Mon, 20 Apr 2026 06:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667022; cv=none; b=ZtoEtrI6Ybzkzpht7uaD/K9pQdMHkmA/8Yiaa5OH9tcjvnQcHo3B7PW+emZq5oq064X+NyCjmZanR4pOzUvngxaHqMEXtjwjpedP+lujPM1POyWvR0S9RX8d6D2UurTKet044w0+AW8gHCwVlETf7Gz3tKWguPbGo06asrTzmsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667022; c=relaxed/simple;
	bh=pgmbSZaeplpYpYVkYXHT1PScIfnrYC0zn1l59QAiwoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcvLwDehIbHBbuXgWp1rGgFa5DpLQw0yLU9gX/WkMT5MuxyDaS93yp2EGKNUBuecX9sxx9GW0h1d4HVBDBQaWgRlHfPGc4y9TR/Goww5PwctFc9740xkIVPpbJQI1MRbCxv+lTMdnyXBDxlCwQKkw/tbewM6MK7yLHSJElr9w+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PIkfI5eG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PIkfI5eG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51925C2BCB8;
	Mon, 20 Apr 2026 06:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667022;
	bh=pgmbSZaeplpYpYVkYXHT1PScIfnrYC0zn1l59QAiwoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIkfI5eG8tKehMYjvnYWoW8TPcwg+PnMWgZmb3fOk+UhLX7pfpKjXU6eNrDdw7OQL
	 f35cpawKgxGpFzGO4oLI+qdTVaxgTVndUPKC2yTQOTx28IAj21kGSUN6meFi8NRK/U
	 uxBFur/EkYKyGMBaiAS2qKQLXZaiEYUY7tBDRaTQ3ovQSVyVD6VQRQVgTg79QQACO3
	 mkJhUDOy/Xz+jpO9JrBfUu+d9EuBzdG4eHuisy78ztlPhZxqeEVL0Ydc6c1V5ZDynz
	 WCu04Zyq2BcX1XVTmgCGLmzF/JPIUBCqVmOYMdJ4Zj7363uHyTn+W1C4x20wqrjB+B
	 7/GkpOjzc5Fpg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/38] crypto: drbg - Fold include/crypto/drbg.h into crypto/drbg.c
Date: Sun, 19 Apr 2026 23:33:54 -0700
Message-ID: <20260420063422.324906-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

include/crypto/drbg.h no longer contains anything that is used
externally to crypto/drbg.c.  Therefore, fold it into crypto/drbg.c.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c                                 | 132 ++++++++++++-
 crypto/testmgr.c                              |   3 +-
 include/crypto/drbg.h                         | 181 ------------------
 .../crypto/chacha20-s390/test-cipher.c        |   1 -
 4 files changed, 132 insertions(+), 185 deletions(-)
 delete mode 100644 include/crypto/drbg.h

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 66d7739469c6..fd1d75addaf7 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -90,18 +90,148 @@
  * Usage with personalization and additional information strings
  * -------------------------------------------------------------
  * Just mix both scenarios above.
  */
 
-#include <crypto/drbg.h>
 #include <crypto/df_sp80090a.h>
 #include <crypto/internal/cipher.h>
+#include <crypto/internal/drbg.h>
+#include <crypto/internal/rng.h>
+#include <crypto/hash.h>
+#include <crypto/skcipher.h>
+#include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/scatterlist.h>
 #include <linux/string_choices.h>
 #include <linux/unaligned.h>
 
+struct drbg_state;
+typedef uint32_t drbg_flag_t;
+
+struct drbg_core {
+	drbg_flag_t flags;	/* flags for the cipher */
+	__u8 statelen;		/* maximum state length */
+	__u8 blocklen_bytes;	/* block size of output in bytes */
+	char cra_name[CRYPTO_MAX_ALG_NAME]; /* mapping to kernel crypto API */
+	 /* kernel crypto API backend cipher name */
+	char backend_cra_name[CRYPTO_MAX_ALG_NAME];
+};
+
+struct drbg_state_ops {
+	int (*update)(struct drbg_state *drbg, struct list_head *seed,
+		      int reseed);
+	int (*generate)(struct drbg_state *drbg,
+			unsigned char *buf, unsigned int buflen,
+			struct list_head *addtl);
+	int (*crypto_init)(struct drbg_state *drbg);
+	int (*crypto_fini)(struct drbg_state *drbg);
+
+};
+
+enum drbg_seed_state {
+	DRBG_SEED_STATE_UNSEEDED,
+	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
+	DRBG_SEED_STATE_FULL,
+};
+
+struct drbg_state {
+	struct mutex drbg_mutex;	/* lock around DRBG */
+	unsigned char *V;	/* internal state 10.1.1.1 1a) */
+	unsigned char *Vbuf;
+	/* hash: static value 10.1.1.1 1b) hmac / ctr: key */
+	unsigned char *C;
+	unsigned char *Cbuf;
+	/* Number of RNG requests since last reseed -- 10.1.1.1 1c) */
+	size_t reseed_ctr;
+	size_t reseed_threshold;
+	 /* some memory the DRBG can use for its operation */
+	unsigned char *scratchpad;
+	unsigned char *scratchpadbuf;
+	void *priv_data;	/* Cipher handle */
+
+	struct crypto_skcipher *ctr_handle;	/* CTR mode cipher handle */
+	struct skcipher_request *ctr_req;	/* CTR mode request handle */
+	__u8 *outscratchpadbuf;			/* CTR mode output scratchpad */
+        __u8 *outscratchpad;			/* CTR mode aligned outbuf */
+	struct crypto_wait ctr_wait;		/* CTR mode async wait obj */
+	struct scatterlist sg_in, sg_out;	/* CTR mode SGLs */
+
+	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
+	unsigned long last_seed_time;
+	bool pr;		/* Prediction resistance enabled? */
+	struct crypto_rng *jent;
+	const struct drbg_state_ops *d_ops;
+	const struct drbg_core *core;
+	struct drbg_string test_data;
+};
+
+static inline __u8 drbg_statelen(struct drbg_state *drbg)
+{
+	if (drbg && drbg->core)
+		return drbg->core->statelen;
+	return 0;
+}
+
+static inline __u8 drbg_blocklen(struct drbg_state *drbg)
+{
+	if (drbg && drbg->core)
+		return drbg->core->blocklen_bytes;
+	return 0;
+}
+
+static inline __u8 drbg_keylen(struct drbg_state *drbg)
+{
+	if (drbg && drbg->core)
+		return (drbg->core->statelen - drbg->core->blocklen_bytes);
+	return 0;
+}
+
+static inline size_t drbg_max_request_bytes(struct drbg_state *drbg)
+{
+	/* SP800-90A requires the limit 2**19 bits, but we return bytes */
+	return (1 << 16);
+}
+
+/*
+ * SP800-90A allows implementations to support additional info / personalization
+ * strings of up to 2**35 bits.  Implementations can have a smaller maximum.  We
+ * use 2**35 - 16 bits == U32_MAX - 1 bytes so that the max + 1 always fits in a
+ * size_t, allowing drbg_healthcheck_sanity() to verify its enforcement.
+ */
+static inline size_t drbg_max_addtl(struct drbg_state *drbg)
+{
+	return U32_MAX - 1;
+}
+
+static inline size_t drbg_max_requests(struct drbg_state *drbg)
+{
+	/* SP800-90A requires 2**48 maximum requests before reseeding */
+	return (1<<20);
+}
+
+/* DRBG type flags */
+#define DRBG_CTR	((drbg_flag_t)1<<0)
+#define DRBG_HMAC	((drbg_flag_t)1<<1)
+#define DRBG_HASH	((drbg_flag_t)1<<2)
+#define DRBG_TYPE_MASK	(DRBG_CTR | DRBG_HMAC | DRBG_HASH)
+/* DRBG strength flags */
+#define DRBG_STRENGTH128	((drbg_flag_t)1<<3)
+#define DRBG_STRENGTH192	((drbg_flag_t)1<<4)
+#define DRBG_STRENGTH256	((drbg_flag_t)1<<5)
+#define DRBG_STRENGTH_MASK	(DRBG_STRENGTH128 | DRBG_STRENGTH192 | \
+				 DRBG_STRENGTH256)
+
+enum drbg_prefixes {
+	DRBG_PREFIX0 = 0x00,
+	DRBG_PREFIX1,
+	DRBG_PREFIX2,
+	DRBG_PREFIX3
+};
+
 /***************************************************************
  * Backend cipher definitions available to DRBG
  ***************************************************************/
 
 /*
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 35ff2b50e3c2..480368a41cc0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -26,17 +26,16 @@
 #include <linux/prandom.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uio.h>
-#include <crypto/rng.h>
-#include <crypto/drbg.h>
 #include <crypto/akcipher.h>
 #include <crypto/kpp.h>
 #include <crypto/acompress.h>
 #include <crypto/sig.h>
 #include <crypto/internal/cipher.h>
+#include <crypto/internal/rng.h>
 #include <crypto/internal/simd.h>
 
 #include "internal.h"
 
 MODULE_IMPORT_NS("CRYPTO_INTERNAL");
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
deleted file mode 100644
index 4fafc69a8ee6..000000000000
--- a/include/crypto/drbg.h
+++ /dev/null
@@ -1,181 +0,0 @@
-/*
- * DRBG based on NIST SP800-90A
- *
- * Copyright Stephan Mueller <smueller@chronox.de>, 2014
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, and the entire permission notice in its entirety,
- *    including the disclaimer of warranties.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. The name of the author may not be used to endorse or promote
- *    products derived from this software without specific prior
- *    written permission.
- *
- * ALTERNATIVELY, this product may be distributed under the terms of
- * the GNU General Public License, in which case the provisions of the GPL are
- * required INSTEAD OF the above restrictions.  (This clause is
- * necessary due to a potential bad interaction between the GPL and
- * the restrictions contained in a BSD-style copyright.)
- *
- * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
- * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
- * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
- * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
- * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
- * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
- * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
- * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
- * DAMAGE.
- */
-
-#ifndef _DRBG_H
-#define _DRBG_H
-
-
-#include <linux/random.h>
-#include <linux/scatterlist.h>
-#include <crypto/hash.h>
-#include <crypto/skcipher.h>
-#include <linux/module.h>
-#include <linux/crypto.h>
-#include <linux/slab.h>
-#include <crypto/internal/drbg.h>
-#include <crypto/internal/rng.h>
-#include <crypto/rng.h>
-#include <linux/fips.h>
-#include <linux/mutex.h>
-#include <linux/list.h>
-#include <linux/workqueue.h>
-
-struct drbg_state;
-typedef uint32_t drbg_flag_t;
-
-struct drbg_core {
-	drbg_flag_t flags;	/* flags for the cipher */
-	__u8 statelen;		/* maximum state length */
-	__u8 blocklen_bytes;	/* block size of output in bytes */
-	char cra_name[CRYPTO_MAX_ALG_NAME]; /* mapping to kernel crypto API */
-	 /* kernel crypto API backend cipher name */
-	char backend_cra_name[CRYPTO_MAX_ALG_NAME];
-};
-
-struct drbg_state_ops {
-	int (*update)(struct drbg_state *drbg, struct list_head *seed,
-		      int reseed);
-	int (*generate)(struct drbg_state *drbg,
-			unsigned char *buf, unsigned int buflen,
-			struct list_head *addtl);
-	int (*crypto_init)(struct drbg_state *drbg);
-	int (*crypto_fini)(struct drbg_state *drbg);
-
-};
-
-enum drbg_seed_state {
-	DRBG_SEED_STATE_UNSEEDED,
-	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
-	DRBG_SEED_STATE_FULL,
-};
-
-struct drbg_state {
-	struct mutex drbg_mutex;	/* lock around DRBG */
-	unsigned char *V;	/* internal state 10.1.1.1 1a) */
-	unsigned char *Vbuf;
-	/* hash: static value 10.1.1.1 1b) hmac / ctr: key */
-	unsigned char *C;
-	unsigned char *Cbuf;
-	/* Number of RNG requests since last reseed -- 10.1.1.1 1c) */
-	size_t reseed_ctr;
-	size_t reseed_threshold;
-	 /* some memory the DRBG can use for its operation */
-	unsigned char *scratchpad;
-	unsigned char *scratchpadbuf;
-	void *priv_data;	/* Cipher handle */
-
-	struct crypto_skcipher *ctr_handle;	/* CTR mode cipher handle */
-	struct skcipher_request *ctr_req;	/* CTR mode request handle */
-	__u8 *outscratchpadbuf;			/* CTR mode output scratchpad */
-        __u8 *outscratchpad;			/* CTR mode aligned outbuf */
-	struct crypto_wait ctr_wait;		/* CTR mode async wait obj */
-	struct scatterlist sg_in, sg_out;	/* CTR mode SGLs */
-
-	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
-	unsigned long last_seed_time;
-	bool pr;		/* Prediction resistance enabled? */
-	struct crypto_rng *jent;
-	const struct drbg_state_ops *d_ops;
-	const struct drbg_core *core;
-	struct drbg_string test_data;
-};
-
-static inline __u8 drbg_statelen(struct drbg_state *drbg)
-{
-	if (drbg && drbg->core)
-		return drbg->core->statelen;
-	return 0;
-}
-
-static inline __u8 drbg_blocklen(struct drbg_state *drbg)
-{
-	if (drbg && drbg->core)
-		return drbg->core->blocklen_bytes;
-	return 0;
-}
-
-static inline __u8 drbg_keylen(struct drbg_state *drbg)
-{
-	if (drbg && drbg->core)
-		return (drbg->core->statelen - drbg->core->blocklen_bytes);
-	return 0;
-}
-
-static inline size_t drbg_max_request_bytes(struct drbg_state *drbg)
-{
-	/* SP800-90A requires the limit 2**19 bits, but we return bytes */
-	return (1 << 16);
-}
-
-/*
- * SP800-90A allows implementations to support additional info / personalization
- * strings of up to 2**35 bits.  Implementations can have a smaller maximum.  We
- * use 2**35 - 16 bits == U32_MAX - 1 bytes so that the max + 1 always fits in a
- * size_t, allowing drbg_healthcheck_sanity() to verify its enforcement.
- */
-static inline size_t drbg_max_addtl(struct drbg_state *drbg)
-{
-	return U32_MAX - 1;
-}
-
-static inline size_t drbg_max_requests(struct drbg_state *drbg)
-{
-	/* SP800-90A requires 2**48 maximum requests before reseeding */
-	return (1<<20);
-}
-
-/* DRBG type flags */
-#define DRBG_CTR	((drbg_flag_t)1<<0)
-#define DRBG_HMAC	((drbg_flag_t)1<<1)
-#define DRBG_HASH	((drbg_flag_t)1<<2)
-#define DRBG_TYPE_MASK	(DRBG_CTR | DRBG_HMAC | DRBG_HASH)
-/* DRBG strength flags */
-#define DRBG_STRENGTH128	((drbg_flag_t)1<<3)
-#define DRBG_STRENGTH192	((drbg_flag_t)1<<4)
-#define DRBG_STRENGTH256	((drbg_flag_t)1<<5)
-#define DRBG_STRENGTH_MASK	(DRBG_STRENGTH128 | DRBG_STRENGTH192 | \
-				 DRBG_STRENGTH256)
-
-enum drbg_prefixes {
-	DRBG_PREFIX0 = 0x00,
-	DRBG_PREFIX1,
-	DRBG_PREFIX2,
-	DRBG_PREFIX3
-};
-
-#endif /* _DRBG_H */
diff --git a/tools/testing/crypto/chacha20-s390/test-cipher.c b/tools/testing/crypto/chacha20-s390/test-cipher.c
index 827507844e8f..9f61454ed077 100644
--- a/tools/testing/crypto/chacha20-s390/test-cipher.c
+++ b/tools/testing/crypto/chacha20-s390/test-cipher.c
@@ -9,11 +9,10 @@
 #include <asm/smp.h>
 #include <crypto/skcipher.h>
 #include <crypto/akcipher.h>
 #include <crypto/acompress.h>
 #include <crypto/rng.h>
-#include <crypto/drbg.h>
 #include <crypto/kpp.h>
 #include <crypto/internal/simd.h>
 #include <crypto/chacha.h>
 #include <crypto/aead.h>
 #include <crypto/hash.h>
-- 
2.53.0

