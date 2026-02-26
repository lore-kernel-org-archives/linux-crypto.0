Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D178286A8;
	Thu, 26 Feb 2026 01:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772067663; cv=none; b=qwC2j08AMKrGw0JIlkgQhWcp2BcxbRVm5twCJQ0j+SEIdq5xfl1TQWYzvGJQ/vzG6nIghb/id9xxQm2aNq+HlIDt7Hk0FUMEWRsCc0NxagM2ayT7bN3FkN3LmzHEbqG7mSfrLKPVWrL5GsNlCUyOBwwMiRxM02qiBGT4fYyK9G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772067663; c=relaxed/simple;
	bh=Ji5LxfWj1anZrwpHckibl9J9THc03YWUv+WBFodcAiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ObKqkE1yyH2Ua4TKj6abDQkTA/73iPfR6jPw9tHLZpApO8zF8IPh4n+VwujijBQvuONSgqoB4qnxl1bNhnK9nbGIs2ZFM8RAMvAYPGS8qJJKvETXKlDy019u/kQQxlfUNAtEx5wqAEU/yPddK0Bjl0MMDC+W/Mn1ijncIod/Sbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKtC8VNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKtC8VNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7944C19425;
	Thu, 26 Feb 2026 01:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067663;
	bh=Ji5LxfWj1anZrwpHckibl9J9THc03YWUv+WBFodcAiE=;
	h=From:To:Cc:Subject:Date:From;
	b=PKtC8VNLsQfI2Ocvnm7GWEv6KbO6okgRKEk0QaCrVzVK9NrjT7iksuIog8JqP0R1J
	 edhCp2hpYTj/WUl2czzg9kEGxzXGdwrnf5omojHP8fFJpJothUWoucyUuznMemzXRV
	 S0+4UFtfUcK0DKvbdDEqyGA1pl6+sUZGYVcJLTgAUQrahshY/c6cYLDM2/rXZllFDB
	 FOXn4p4+q939r/kzE8jHCHAMNh2Thytrr1FdYHBFTWuCIgOkCFxd+KGfK9fo1MG4OI
	 LphlxO+tUSHeuuxWFvCkdUDWF4KvpYDpbD+WvXETKWVz2GCTNwqdMr+CvOft3ZlyUH
	 57z7ILmrdMv4Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v7] crypto: jitterentropy - Use SHA-3 library
Date: Wed, 25 Feb 2026 17:00:05 -0800
Message-ID: <20260226010005.43528-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

Make the jitterentropy RNG use the SHA-3 library API instead of
crypto_shash.  This ends up being quite a bit simpler, as various
dynamic allocations and error checks become unnecessary.

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This is a cleaned-up and rebased version of
https://lore.kernel.org/linux-crypto/20251017144311.817771-7-dhowells@redhat.com/
If there are no objections, I'll take this via libcrypto-next.

 crypto/Kconfig               |   2 +-
 crypto/jitterentropy-kcapi.c | 114 +++++++++--------------------------
 crypto/jitterentropy.c       |  25 ++++----
 crypto/jitterentropy.h       |  19 +++---
 4 files changed, 52 insertions(+), 108 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e2b4106ac961..f3d30a697439 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1182,12 +1182,12 @@ config CRYPTO_DRBG
 
 endif	# if CRYPTO_DRBG_MENU
 
 config CRYPTO_JITTERENTROPY
 	tristate "CPU Jitter Non-Deterministic RNG (Random Number Generator)"
+	select CRYPTO_LIB_SHA3
 	select CRYPTO_RNG
-	select CRYPTO_SHA3
 	help
 	  CPU Jitter RNG (Random Number Generator) from the Jitterentropy library
 
 	  A non-physical non-deterministic ("true") RNG (e.g., an entropy source
 	  compliant with NIST SP800-90B) intended to provide a seed to a
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 7c880cf34c52..4ad729357441 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -35,23 +35,20 @@
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
  * DAMAGE.
  */
 
-#include <crypto/hash.h>
 #include <crypto/sha3.h>
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <crypto/internal/rng.h>
 
 #include "jitterentropy.h"
 
-#define JENT_CONDITIONING_HASH	"sha3-256"
-
 /***************************************************************************
  * Helper function
  ***************************************************************************/
 
 void *jent_kvzalloc(unsigned int len)
@@ -99,26 +96,18 @@ void jent_get_nstime(__u64 *out)
 
 	*out = tmp;
 	jent_raw_hires_entropy_store(tmp);
 }
 
-int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
-		   unsigned int addtl_len, __u64 hash_loop_cnt,
-		   unsigned int stuck)
+void jent_hash_time(struct sha3_ctx *hash_state, __u64 time, u8 *addtl,
+		    unsigned int addtl_len, __u64 hash_loop_cnt,
+		    unsigned int stuck)
 {
-	struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
-	SHASH_DESC_ON_STACK(desc, hash_state_desc->tfm);
+	struct sha3_ctx tmp_state; /* zeroized by sha3_final() */
 	u8 intermediary[SHA3_256_DIGEST_SIZE];
 	__u64 j = 0;
-	int ret;
-
-	desc->tfm = hash_state_desc->tfm;
 
-	if (sizeof(intermediary) != crypto_shash_digestsize(desc->tfm)) {
-		pr_warn_ratelimited("Unexpected digest size\n");
-		return -EINVAL;
-	}
 	kmsan_unpoison_memory(intermediary, sizeof(intermediary));
 
 	/*
 	 * This loop fills a buffer which is injected into the entropy pool.
 	 * The main reason for this loop is to execute something over which we
@@ -128,28 +117,24 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * used at all. Yet that data is considered "additional information"
 	 * considering the terminology from SP800-90A without any entropy.
 	 *
 	 * Note, it does not matter which or how much data you inject, we are
 	 * interested in one Keccack1600 compression operation performed with
-	 * the crypto_shash_final.
+	 * the sha3_final.
 	 */
 	for (j = 0; j < hash_loop_cnt; j++) {
-		ret = crypto_shash_init(desc) ?:
-		      crypto_shash_update(desc, intermediary,
-					  sizeof(intermediary)) ?:
-		      crypto_shash_finup(desc, addtl, addtl_len, intermediary);
-		if (ret)
-			goto err;
+		sha3_256_init(&tmp_state);
+		sha3_update(&tmp_state, intermediary, sizeof(intermediary));
+		sha3_update(&tmp_state, addtl, addtl_len);
+		sha3_final(&tmp_state, intermediary);
 	}
 
 	/*
 	 * Inject the data from the previous loop into the pool. This data is
 	 * not considered to contain any entropy, but it stirs the pool a bit.
 	 */
-	ret = crypto_shash_update(hash_state_desc, intermediary, sizeof(intermediary));
-	if (ret)
-		goto err;
+	sha3_update(hash_state, intermediary, sizeof(intermediary));
 
 	/*
 	 * Insert the time stamp into the hash context representing the pool.
 	 *
 	 * If the time stamp is stuck, do not finally insert the value into the
@@ -160,100 +145,66 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 */
 	if (stuck) {
 		time = 0;
 	}
 
-	ret = crypto_shash_update(hash_state_desc, (u8 *)&time, sizeof(__u64));
-
-err:
-	shash_desc_zero(desc);
+	sha3_update(hash_state, (u8 *)&time, sizeof(__u64));
 	memzero_explicit(intermediary, sizeof(intermediary));
-
-	return ret;
 }
 
-int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len)
+void jent_read_random_block(struct sha3_ctx *hash_state, char *dst,
+			    unsigned int dst_len)
 {
-	struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
 	u8 jent_block[SHA3_256_DIGEST_SIZE];
+
 	/* Obtain data from entropy pool and re-initialize it */
-	int ret = crypto_shash_final(hash_state_desc, jent_block) ?:
-		  crypto_shash_init(hash_state_desc) ?:
-		  crypto_shash_update(hash_state_desc, jent_block,
-				      sizeof(jent_block));
+	sha3_final(hash_state, jent_block);
+	sha3_256_init(hash_state);
+	sha3_update(hash_state, jent_block, sizeof(jent_block));
 
-	if (!ret && dst_len)
+	if (dst_len)
 		memcpy(dst, jent_block, dst_len);
 
 	memzero_explicit(jent_block, sizeof(jent_block));
-	return ret;
 }
 
 /***************************************************************************
  * Kernel crypto API interface
  ***************************************************************************/
 
 struct jitterentropy {
 	spinlock_t jent_lock;
 	struct rand_data *entropy_collector;
-	struct crypto_shash *tfm;
-	struct shash_desc *sdesc;
+	struct sha3_ctx hash_state;
 };
 
 static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
 
 	spin_lock(&rng->jent_lock);
 
-	if (rng->sdesc) {
-		shash_desc_zero(rng->sdesc);
-		kfree(rng->sdesc);
-	}
-	rng->sdesc = NULL;
-
-	if (rng->tfm)
-		crypto_free_shash(rng->tfm);
-	rng->tfm = NULL;
+	memzero_explicit(&rng->hash_state, sizeof(rng->hash_state));
 
 	if (rng->entropy_collector)
 		jent_entropy_collector_free(rng->entropy_collector);
 	rng->entropy_collector = NULL;
 	spin_unlock(&rng->jent_lock);
 }
 
 static int jent_kcapi_init(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
-	struct crypto_shash *hash;
-	struct shash_desc *sdesc;
-	int size, ret = 0;
+	int ret = 0;
 
 	spin_lock_init(&rng->jent_lock);
 
 	/* Use SHA3-256 as conditioner */
-	hash = crypto_alloc_shash(JENT_CONDITIONING_HASH, 0, 0);
-	if (IS_ERR(hash)) {
-		pr_err("Cannot allocate conditioning digest\n");
-		return PTR_ERR(hash);
-	}
-	rng->tfm = hash;
-
-	size = sizeof(struct shash_desc) + crypto_shash_descsize(hash);
-	sdesc = kmalloc(size, GFP_KERNEL);
-	if (!sdesc) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	sdesc->tfm = hash;
-	crypto_shash_init(sdesc);
-	rng->sdesc = sdesc;
+	sha3_256_init(&rng->hash_state);
 
-	rng->entropy_collector =
-		jent_entropy_collector_alloc(CONFIG_CRYPTO_JITTERENTROPY_OSR, 0,
-					     sdesc);
+	rng->entropy_collector = jent_entropy_collector_alloc(
+		CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, &rng->hash_state);
 	if (!rng->entropy_collector) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
@@ -324,27 +275,20 @@ static struct rng_alg jent_alg = {
 	}
 };
 
 static int __init jent_mod_init(void)
 {
-	SHASH_DESC_ON_STACK(desc, tfm);
-	struct crypto_shash *tfm;
+	struct sha3_ctx hash_state;
 	int ret = 0;
 
 	jent_testing_init();
 
-	tfm = crypto_alloc_shash(JENT_CONDITIONING_HASH, 0, 0);
-	if (IS_ERR(tfm)) {
-		jent_testing_exit();
-		return PTR_ERR(tfm);
-	}
+	sha3_256_init(&hash_state);
 
-	desc->tfm = tfm;
-	crypto_shash_init(desc);
-	ret = jent_entropy_init(CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, desc, NULL);
-	shash_desc_zero(desc);
-	crypto_free_shash(tfm);
+	ret = jent_entropy_init(CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, &hash_state,
+				NULL);
+	memzero_explicit(&hash_state, sizeof(hash_state));
 	if (ret) {
 		/* Handle permanent health test error */
 		if (fips_enabled)
 			panic("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
 
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 3f93cdc9a7af..d5832caa8ab3 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -66,11 +66,11 @@ struct rand_data {
 #define DATA_SIZE_BITS 256
 	/* all data values that are vital to maintain the security
 	 * of the RNG are marked as SENSITIVE. A user must not
 	 * access that information while the RNG executes its loops to
 	 * calculate the next random value. */
-	void *hash_state;		/* SENSITIVE hash state entropy pool */
+	struct sha3_ctx *hash_state;	/* SENSITIVE hash state entropy pool */
 	__u64 prev_time;		/* SENSITIVE Previous time stamp */
 	__u64 last_delta;		/* SENSITIVE stuck test */
 	__s64 last_delta2;		/* SENSITIVE stuck test */
 
 	unsigned int flags;		/* Flags used to initialize */
@@ -415,14 +415,13 @@ static __u64 jent_loop_shuffle(unsigned int bits, unsigned int min)
  *
  * ec [in] entropy collector
  * time [in] time stamp to be injected
  * stuck [in] Is the time stamp identified as stuck?
  *
- * Output:
- * updated hash context in the entropy collector or error code
+ * Output: updated hash context in the entropy collector
  */
-static int jent_condition_data(struct rand_data *ec, __u64 time, int stuck)
+static void jent_condition_data(struct rand_data *ec, __u64 time, int stuck)
 {
 #define SHA3_HASH_LOOP (1<<3)
 	struct {
 		int rct_count;
 		unsigned int apt_observations;
@@ -433,12 +432,12 @@ static int jent_condition_data(struct rand_data *ec, __u64 time, int stuck)
 		ec->apt_observations,
 		ec->apt_count,
 		ec->apt_base
 	};
 
-	return jent_hash_time(ec->hash_state, time, (u8 *)&addtl, sizeof(addtl),
-			      SHA3_HASH_LOOP, stuck);
+	jent_hash_time(ec->hash_state, time, (u8 *)&addtl, sizeof(addtl),
+		       SHA3_HASH_LOOP, stuck);
 }
 
 /*
  * Memory Access noise source -- this is a noise source based on variations in
  *				 memory access times
@@ -536,12 +535,11 @@ static int jent_measure_jitter(struct rand_data *ec, __u64 *ret_current_delta)
 
 	/* Check whether we have a stuck measurement. */
 	stuck = jent_stuck(ec, current_delta);
 
 	/* Now call the next noise sources which also injects the data */
-	if (jent_condition_data(ec, current_delta, stuck))
-		stuck = 1;
+	jent_condition_data(ec, current_delta, stuck);
 
 	/* return the raw entropy value */
 	if (ret_current_delta)
 		*ret_current_delta = current_delta;
 
@@ -595,11 +593,11 @@ static void jent_gen_entropy(struct rand_data *ec)
  *	     in bytes
  *
  * @return 0 when request is fulfilled or an error
  *
  * The following error codes can occur:
- *	-1	entropy_collector is NULL or the generation failed
+ *	-1	entropy_collector is NULL
  *	-2	Intermittent health failure
  *	-3	Permanent health failure
  */
 int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 		      unsigned int len)
@@ -638,12 +636,11 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 
 			return -2;
 		}
 
 		tocopy = min(DATA_SIZE_BITS / 8, len);
-		if (jent_read_random_block(ec->hash_state, p, tocopy))
-			return -1;
+		jent_read_random_block(ec->hash_state, p, tocopy);
 
 		len -= tocopy;
 		p += tocopy;
 	}
 
@@ -654,11 +651,11 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
  * Initialization logic
  ***************************************************************************/
 
 struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 					       unsigned int flags,
-					       void *hash_state)
+					       struct sha3_ctx *hash_state)
 {
 	struct rand_data *entropy_collector;
 
 	entropy_collector = jent_zalloc(sizeof(struct rand_data));
 	if (!entropy_collector)
@@ -702,12 +699,12 @@ void jent_entropy_collector_free(struct rand_data *entropy_collector)
 	jent_kvzfree(entropy_collector->mem, JENT_MEMORY_SIZE);
 	entropy_collector->mem = NULL;
 	jent_zfree(entropy_collector);
 }
 
-int jent_entropy_init(unsigned int osr, unsigned int flags, void *hash_state,
-		      struct rand_data *p_ec)
+int jent_entropy_init(unsigned int osr, unsigned int flags,
+		      struct sha3_ctx *hash_state, struct rand_data *p_ec)
 {
 	/*
 	 * If caller provides an allocated ec, reuse it which implies that the
 	 * health test entropy data is used to further still the available
 	 * entropy pool.
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index 4c5dbf2a8d8f..5bb15cb33000 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -1,26 +1,29 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+struct sha3_ctx;
 extern void *jent_kvzalloc(unsigned int len);
 extern void jent_kvzfree(void *ptr, unsigned int len);
 extern void *jent_zalloc(unsigned int len);
 extern void jent_zfree(void *ptr);
 extern void jent_get_nstime(__u64 *out);
-extern int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
-			  unsigned int addtl_len, __u64 hash_loop_cnt,
-			  unsigned int stuck);
-int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len);
+void jent_hash_time(struct sha3_ctx *hash_state, __u64 time, u8 *addtl,
+		    unsigned int addtl_len, __u64 hash_loop_cnt,
+		    unsigned int stuck);
+void jent_read_random_block(struct sha3_ctx *hash_state, char *dst,
+			    unsigned int dst_len);
 
 struct rand_data;
 extern int jent_entropy_init(unsigned int osr, unsigned int flags,
-			     void *hash_state, struct rand_data *p_ec);
+			     struct sha3_ctx *hash_state,
+			     struct rand_data *p_ec);
 extern int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			     unsigned int len);
 
-extern struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
-						      unsigned int flags,
-						      void *hash_state);
+extern struct rand_data *
+jent_entropy_collector_alloc(unsigned int osr, unsigned int flags,
+			     struct sha3_ctx *hash_state);
 extern void jent_entropy_collector_free(struct rand_data *entropy_collector);
 
 #ifdef CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE
 int jent_raw_hires_entropy_store(__u64 value);
 void jent_testing_init(void);

base-commit: 7dff99b354601dd01829e1511711846e04340a69
-- 
2.53.0

