Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793379853;
	b=mHtVozb56K3+3sjtANUxzuHfK+mDeaGxOPbqrKMq6CrDVcqE+D2XfBH6U+9fUknvz5qC
	 jS4+U+MpAi2vi9XuEaPdImd1cYs1kbm+kHtVoXW4dp04sCwou8V4N2ZGgXiWZqjE7goWx
	 t5UUsTRfqG9HuY05jPPp+Gt0JULd1G7j1cGIlYDjVOHnzwl4STTVhkKNx01Zvbz290zpC
	 /FoK27t3wNu3S+mf964P1GGrE1P+bw/tDfCKSwHgEsWzqXJiU7f/CHJl7ocCZBN+QytHP
	 K1DCQOrq/Q8ntJmbldbfmorj2JwBmq5DK+H9+9SfQmibaUwSZmBkvkWxWpCKPX10VUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793379853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=o9W8NUm+ZOQf0oZ7JQwdgRfaXlSzznNyWOXyHQ3ZcLA=;
	b=RzSKWknBcCjaI/BTvhHNkt47hoIYuLZeCIt09od8oSOoadENwhtmPFPr2Rh2VUd8eUzj
	 He11/dGyMaMi+aG0A98ZJMsxYwGCIKWJQbydOr78MiExxwRBy4X7xXq0be2syp4znIzMo
	 Yh0kp+tcjdLyH1UqGKQfbh/VGG5rpepf8v32oJy1fvOWVRqevOa+fpCR8OYpJQyfjs5Lh
	 zzzR6Y0xhOo/739bhhBw5ZCV0jaLS0UGHrMcc8RJnUpbzl0rViIp2cbw54Ywm5sOkNETA
	 iFFRL7wSU3hkcOXIHcHKnux6S51XTCVMz7376KBw1C9hb8RHz1yJ+1j0yiqaWAcEjYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBD9h5J2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591C7606A31A;
	Fri, 30 Oct 2026 17:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBD9h5J2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCDD1F0093A;
	Fri, 30 Oct 2026 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793379852;
	bh=o9W8NUm+ZOQf0oZ7JQwdgRfaXlSzznNyWOXyHQ3ZcLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBD9h5J2Z+5ztOiGcvoLsdkXmupl2mjMan6YmbrDaHVXUMiD5QV924ydrgJwr+4iv
	 rarqVBWI3RycJChu6mstyH1TFX2sI5i54iB1t6TQnY8LQD/Eimep9x1vz2DDOso33b
	 5CFcCjqcoL++oBNRRyeJS9CKFK15kh5IcX/J1Iz4LGqdKzo54R9/yuT323nxifM3so
	 gaJajz4duyn/gEWQjvhN38Q3tir185gydDetmKXFrplrhjspPbtXiabBfxJB2PDQFX
	 gZ1ek3uFP6QLC1MGstHj98fpkZU82aYJgUJTmRdL3JF9xsg8MzQfRDP1D7J1nk/Rm+
	 7GWSd3dRS1Bww==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 2/3] Revert "crypto: jitter - replace LFSR with SHA3-256"
Date: Fri, 30 Oct 2026 10:02:19 -0700
Message-ID: <20261030170220.120015-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030170220.120015-1-ebiggers@kernel.org>
References: <20261030170220.120015-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit fc659f1a690351c0d18ed76c24ca5c4204bfc973.

This commit is known-broken, does not meet the stable inclusion
criteria, and has several follow-up fixes that were not included
including fixes for a use-after-finalization bug and initialization
failure on many systems.  Note also that before v7.1, this code was
sometimes used even when the kernel wasn't booted in fips mode.  It was
also accessible to unprivileged users via AF_ALG.

It was released in v6.1.191 kernel anyway, without Cc'ing the
corresponding subsystem mailing list, and over my objection as well
(after I happened to find the thread by searching lore -- see
https://lore.kernel.org/stable/20261029210038.GB49373@quark).

Revert it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig               |   1 -
 crypto/jitterentropy-kcapi.c | 183 ++++-------------------------------
 crypto/jitterentropy.c       | 145 ++++++++++++++++++---------
 crypto/jitterentropy.h       |  10 +-
 4 files changed, 120 insertions(+), 219 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ea1585f307bcf..2e2978e2939f1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1279,7 +1279,6 @@ endif	# if CRYPTO_DRBG_MENU
 config CRYPTO_JITTERENTROPY
 	tristate "CPU Jitter Non-Deterministic RNG (Random Number Generator)"
 	select CRYPTO_RNG
-	select CRYPTO_SHA3
 	help
 	  CPU Jitter RNG (Random Number Generator) from the Jitterentropy library
 
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 4b50cbc8a2faf..b9edfaa51b273 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -2,7 +2,7 @@
  * Non-physical true random number generator based on timing jitter --
  * Linux Kernel Crypto API specific code
  *
- * Copyright Stephan Mueller <smueller@chronox.de>, 2015 - 2023
+ * Copyright Stephan Mueller <smueller@chronox.de>, 2015
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -37,8 +37,6 @@
  * DAMAGE.
  */
 
-#include <crypto/hash.h>
-#include <crypto/sha3.h>
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -48,8 +46,6 @@
 
 #include "jitterentropy.h"
 
-#define JENT_CONDITIONING_HASH	"sha3-256-generic"
-
 /***************************************************************************
  * Helper function
  ***************************************************************************/
@@ -64,6 +60,11 @@ void jent_zfree(void *ptr)
 	kfree_sensitive(ptr);
 }
 
+void jent_memcpy(void *dest, const void *src, unsigned int n)
+{
+	memcpy(dest, src, n);
+}
+
 /*
  * Obtain a high-resolution time stamp value. The time stamp is used to measure
  * the execution time of a given code path and its variations. Hence, the time
@@ -90,91 +91,6 @@ void jent_get_nstime(__u64 *out)
 	*out = tmp;
 }
 
-int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
-		   unsigned int addtl_len, __u64 hash_loop_cnt,
-		   unsigned int stuck)
-{
-	struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
-	SHASH_DESC_ON_STACK(desc, hash_state_desc->tfm);
-	u8 intermediary[SHA3_256_DIGEST_SIZE];
-	__u64 j = 0;
-	int ret;
-
-	desc->tfm = hash_state_desc->tfm;
-
-	if (sizeof(intermediary) != crypto_shash_digestsize(desc->tfm)) {
-		pr_warn_ratelimited("Unexpected digest size\n");
-		return -EINVAL;
-	}
-
-	/*
-	 * This loop fills a buffer which is injected into the entropy pool.
-	 * The main reason for this loop is to execute something over which we
-	 * can perform a timing measurement. The injection of the resulting
-	 * data into the pool is performed to ensure the result is used and
-	 * the compiler cannot optimize the loop away in case the result is not
-	 * used at all. Yet that data is considered "additional information"
-	 * considering the terminology from SP800-90A without any entropy.
-	 *
-	 * Note, it does not matter which or how much data you inject, we are
-	 * interested in one Keccack1600 compression operation performed with
-	 * the crypto_shash_final.
-	 */
-	for (j = 0; j < hash_loop_cnt; j++) {
-		ret = crypto_shash_init(desc) ?:
-		      crypto_shash_update(desc, intermediary,
-					  sizeof(intermediary)) ?:
-		      crypto_shash_finup(desc, addtl, addtl_len, intermediary);
-		if (ret)
-			goto err;
-	}
-
-	/*
-	 * Inject the data from the previous loop into the pool. This data is
-	 * not considered to contain any entropy, but it stirs the pool a bit.
-	 */
-	ret = crypto_shash_update(desc, intermediary, sizeof(intermediary));
-	if (ret)
-		goto err;
-
-	/*
-	 * Insert the time stamp into the hash context representing the pool.
-	 *
-	 * If the time stamp is stuck, do not finally insert the value into the
-	 * entropy pool. Although this operation should not do any harm even
-	 * when the time stamp has no entropy, SP800-90B requires that any
-	 * conditioning operation to have an identical amount of input data
-	 * according to section 3.1.5.
-	 */
-	if (!stuck) {
-		ret = crypto_shash_update(hash_state_desc, (u8 *)&time,
-					  sizeof(__u64));
-	}
-
-err:
-	shash_desc_zero(desc);
-	memzero_explicit(intermediary, sizeof(intermediary));
-
-	return ret;
-}
-
-int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len)
-{
-	struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
-	u8 jent_block[SHA3_256_DIGEST_SIZE];
-	/* Obtain data from entropy pool and re-initialize it */
-	int ret = crypto_shash_final(hash_state_desc, jent_block) ?:
-		  crypto_shash_init(hash_state_desc) ?:
-		  crypto_shash_update(hash_state_desc, jent_block,
-				      sizeof(jent_block));
-
-	if (!ret && dst_len)
-		memcpy(dst, jent_block, dst_len);
-
-	memzero_explicit(jent_block, sizeof(jent_block));
-	return ret;
-}
-
 /***************************************************************************
  * Kernel crypto API interface
  ***************************************************************************/
@@ -182,82 +98,32 @@ int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len)
 struct jitterentropy {
 	spinlock_t jent_lock;
 	struct rand_data *entropy_collector;
-	struct crypto_shash *tfm;
-	struct shash_desc *sdesc;
 };
 
-static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
+static int jent_kcapi_init(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
+	int ret = 0;
 
-	spin_lock(&rng->jent_lock);
+	rng->entropy_collector = jent_entropy_collector_alloc(1, 0);
+	if (!rng->entropy_collector)
+		ret = -ENOMEM;
 
-	if (rng->sdesc) {
-		shash_desc_zero(rng->sdesc);
-		kfree(rng->sdesc);
-	}
-	rng->sdesc = NULL;
+	spin_lock_init(&rng->jent_lock);
+	return ret;
+}
 
-	if (rng->tfm)
-		crypto_free_shash(rng->tfm);
-	rng->tfm = NULL;
+static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
+{
+	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
 
+	spin_lock(&rng->jent_lock);
 	if (rng->entropy_collector)
 		jent_entropy_collector_free(rng->entropy_collector);
 	rng->entropy_collector = NULL;
 	spin_unlock(&rng->jent_lock);
 }
 
-static int jent_kcapi_init(struct crypto_tfm *tfm)
-{
-	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
-	struct crypto_shash *hash;
-	struct shash_desc *sdesc;
-	int size, ret = 0;
-
-	spin_lock_init(&rng->jent_lock);
-
-	/*
-	 * Use SHA3-256 as conditioner. We allocate only the generic
-	 * implementation as we are not interested in high-performance. The
-	 * execution time of the SHA3 operation is measured and adds to the
-	 * Jitter RNG's unpredictable behavior. If we have a slower hash
-	 * implementation, the execution timing variations are larger. When
-	 * using a fast implementation, we would need to call it more often
-	 * as its variations are lower.
-	 */
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
-
-	rng->entropy_collector = jent_entropy_collector_alloc(1, 0, sdesc);
-	if (!rng->entropy_collector) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	spin_lock_init(&rng->jent_lock);
-	return 0;
-
-err:
-	jent_kcapi_cleanup(tfm);
-	return ret;
-}
-
 static int jent_kcapi_random(struct crypto_rng *tfm,
 			     const u8 *src, unsigned int slen,
 			     u8 *rdata, unsigned int dlen)
@@ -314,24 +180,15 @@ static struct rng_alg jent_alg = {
 		.cra_module             = THIS_MODULE,
 		.cra_init               = jent_kcapi_init,
 		.cra_exit               = jent_kcapi_cleanup,
+
 	}
 };
 
 static int __init jent_mod_init(void)
 {
-	SHASH_DESC_ON_STACK(desc, tfm);
-	struct crypto_shash *tfm;
 	int ret = 0;
 
-	tfm = crypto_alloc_shash(JENT_CONDITIONING_HASH, 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	desc->tfm = tfm;
-	crypto_shash_init(desc);
-	ret = jent_entropy_init(desc);
-	shash_desc_zero(desc);
-	crypto_free_shash(tfm);
+	ret = jent_entropy_init();
 	if (ret) {
 		/* Handle permanent health test error */
 		if (fips_enabled)
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index c7d7f2caa7793..227cedfa4f0ae 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -2,7 +2,7 @@
  * Non-physical true random number generator based on timing jitter --
  * Jitter RNG standalone code.
  *
- * Copyright Stephan Mueller <smueller@chronox.de>, 2015 - 2023
+ * Copyright Stephan Mueller <smueller@chronox.de>, 2015 - 2020
  *
  * Design
  * ======
@@ -47,7 +47,7 @@
 
 /*
  * This Jitterentropy RNG is based on the jitterentropy library
- * version 3.4.0 provided at https://www.chronox.de/jent.html
+ * version 2.2.0 provided at https://www.chronox.de/jent.html
  */
 
 #ifdef __OPTIMIZE__
@@ -57,22 +57,21 @@
 typedef	unsigned long long	__u64;
 typedef	long long		__s64;
 typedef	unsigned int		__u32;
-typedef unsigned char		u8;
 #define NULL    ((void *) 0)
 
 /* The entropy pool */
 struct rand_data {
-	/* SHA3-256 is used as conditioner */
-#define DATA_SIZE_BITS 256
 	/* all data values that are vital to maintain the security
 	 * of the RNG are marked as SENSITIVE. A user must not
 	 * access that information while the RNG executes its loops to
 	 * calculate the next random value. */
-	void *hash_state;		/* SENSITIVE hash state entropy pool */
-	__u64 prev_time;		/* SENSITIVE Previous time stamp */
-	__u64 last_delta;		/* SENSITIVE stuck test */
-	__s64 last_delta2;		/* SENSITIVE stuck test */
-	unsigned int osr;		/* Oversample rate */
+	__u64 data;		/* SENSITIVE Actual random number */
+	__u64 old_data;		/* SENSITIVE Previous random number */
+	__u64 prev_time;	/* SENSITIVE Previous time stamp */
+#define DATA_SIZE_BITS ((sizeof(__u64)) * 8)
+	__u64 last_delta;	/* SENSITIVE stuck test */
+	__s64 last_delta2;	/* SENSITIVE stuck test */
+	unsigned int osr;	/* Oversample rate */
 #define JENT_MEMORY_BLOCKS 64
 #define JENT_MEMORY_BLOCKSIZE 32
 #define JENT_MEMORY_ACCESSLOOPS 128
@@ -302,13 +301,15 @@ static int jent_permanent_health_failure(struct rand_data *ec)
  * an entropy collection.
  *
  * Input:
+ * @ec entropy collector struct -- may be NULL
  * @bits is the number of low bits of the timer to consider
  * @min is the number of bits we shift the timer value to the right at
  *	the end to make sure we have a guaranteed minimum value
  *
  * @return Newly calculated loop counter
  */
-static __u64 jent_loop_shuffle(unsigned int bits, unsigned int min)
+static __u64 jent_loop_shuffle(struct rand_data *ec,
+			       unsigned int bits, unsigned int min)
 {
 	__u64 time = 0;
 	__u64 shuffle = 0;
@@ -316,7 +317,12 @@ static __u64 jent_loop_shuffle(unsigned int bits, unsigned int min)
 	unsigned int mask = (1<<bits) - 1;
 
 	jent_get_nstime(&time);
-
+	/*
+	 * Mix the current state of the random number into the shuffle
+	 * calculation to balance that shuffle a bit more.
+	 */
+	if (ec)
+		time ^= ec->data;
 	/*
 	 * We fold the time value as much as possible to ensure that as many
 	 * bits of the time stamp are included as possible.
@@ -338,32 +344,81 @@ static __u64 jent_loop_shuffle(unsigned int bits, unsigned int min)
  *			      execution time jitter
  *
  * This function injects the individual bits of the time value into the
- * entropy pool using a hash.
+ * entropy pool using an LFSR.
  *
- * ec [in] entropy collector
- * time [in] time stamp to be injected
- * stuck [in] Is the time stamp identified as stuck?
+ * The code is deliberately inefficient with respect to the bit shifting
+ * and shall stay that way. This function is the root cause why the code
+ * shall be compiled without optimization. This function not only acts as
+ * folding operation, but this function's execution is used to measure
+ * the CPU execution time jitter. Any change to the loop in this function
+ * implies that careful retesting must be done.
+ *
+ * @ec [in] entropy collector struct
+ * @time [in] time stamp to be injected
+ * @loop_cnt [in] if a value not equal to 0 is set, use the given value as
+ *		  number of loops to perform the folding
+ * @stuck [in] Is the time stamp identified as stuck?
  *
  * Output:
- * updated hash context in the entropy collector or error code
+ * updated ec->data
+ *
+ * @return Number of loops the folding operation is performed
  */
-static int jent_condition_data(struct rand_data *ec, __u64 time, int stuck)
+static void jent_lfsr_time(struct rand_data *ec, __u64 time, __u64 loop_cnt,
+			   int stuck)
 {
-#define SHA3_HASH_LOOP (1<<3)
-	struct {
-		int rct_count;
-		unsigned int apt_observations;
-		unsigned int apt_count;
-		unsigned int apt_base;
-	} addtl = {
-		ec->rct_count,
-		ec->apt_observations,
-		ec->apt_count,
-		ec->apt_base
-	};
-
-	return jent_hash_time(ec->hash_state, time, (u8 *)&addtl, sizeof(addtl),
-			      SHA3_HASH_LOOP, stuck);
+	unsigned int i;
+	__u64 j = 0;
+	__u64 new = 0;
+#define MAX_FOLD_LOOP_BIT 4
+#define MIN_FOLD_LOOP_BIT 0
+	__u64 fold_loop_cnt =
+		jent_loop_shuffle(ec, MAX_FOLD_LOOP_BIT, MIN_FOLD_LOOP_BIT);
+
+	/*
+	 * testing purposes -- allow test app to set the counter, not
+	 * needed during runtime
+	 */
+	if (loop_cnt)
+		fold_loop_cnt = loop_cnt;
+	for (j = 0; j < fold_loop_cnt; j++) {
+		new = ec->data;
+		for (i = 1; (DATA_SIZE_BITS) >= i; i++) {
+			__u64 tmp = time << (DATA_SIZE_BITS - i);
+
+			tmp = tmp >> (DATA_SIZE_BITS - 1);
+
+			/*
+			* Fibonacci LSFR with polynomial of
+			*  x^64 + x^61 + x^56 + x^31 + x^28 + x^23 + 1 which is
+			*  primitive according to
+			*   http://poincare.matf.bg.ac.rs/~ezivkovm/publications/primpol1.pdf
+			* (the shift values are the polynomial values minus one
+			* due to counting bits from 0 to 63). As the current
+			* position is always the LSB, the polynomial only needs
+			* to shift data in from the left without wrap.
+			*/
+			tmp ^= ((new >> 63) & 1);
+			tmp ^= ((new >> 60) & 1);
+			tmp ^= ((new >> 55) & 1);
+			tmp ^= ((new >> 30) & 1);
+			tmp ^= ((new >> 27) & 1);
+			tmp ^= ((new >> 22) & 1);
+			new <<= 1;
+			new ^= tmp;
+		}
+	}
+
+	/*
+	 * If the time stamp is stuck, do not finally insert the value into
+	 * the entropy pool. Although this operation should not do any harm
+	 * even when the time stamp has no entropy, SP800-90B requires that
+	 * any conditioning operation (SP800-90B considers the LFSR to be a
+	 * conditioning operation) to have an identical amount of input
+	 * data according to section 3.1.5.
+	 */
+	if (!stuck)
+		ec->data = new;
 }
 
 /*
@@ -397,7 +452,7 @@ static void jent_memaccess(struct rand_data *ec, __u64 loop_cnt)
 #define MAX_ACC_LOOP_BIT 7
 #define MIN_ACC_LOOP_BIT 0
 	__u64 acc_loop_cnt =
-		jent_loop_shuffle(MAX_ACC_LOOP_BIT, MIN_ACC_LOOP_BIT);
+		jent_loop_shuffle(ec, MAX_ACC_LOOP_BIT, MIN_ACC_LOOP_BIT);
 
 	if (NULL == ec || NULL == ec->mem)
 		return;
@@ -465,15 +520,14 @@ static int jent_measure_jitter(struct rand_data *ec)
 	stuck = jent_stuck(ec, current_delta);
 
 	/* Now call the next noise sources which also injects the data */
-	if (jent_condition_data(ec, current_delta, stuck))
-		stuck = 1;
+	jent_lfsr_time(ec, current_delta, 0, stuck);
 
 	return stuck;
 }
 
 /*
  * Generator of one 64 bit random number
- * Function fills rand_data->hash_state
+ * Function fills rand_data->data
  *
  * @ec [in] Reference to entropy collector
  */
@@ -520,7 +574,7 @@ static void jent_gen_entropy(struct rand_data *ec)
  * @return 0 when request is fulfilled or an error
  *
  * The following error codes can occur:
- *	-1	entropy_collector is NULL or the generation failed
+ *	-1	entropy_collector is NULL
  *	-2	Intermittent health failure
  *	-3	Permanent health failure
  */
@@ -550,7 +604,7 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			 * Perform startup health tests and return permanent
 			 * error if it fails.
 			 */
-			if (jent_entropy_init(ec->hash_state))
+			if (jent_entropy_init())
 				return -3;
 
 			return -2;
@@ -560,8 +614,7 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			tocopy = (DATA_SIZE_BITS / 8);
 		else
 			tocopy = len;
-		if (jent_read_random_block(ec->hash_state, p, tocopy))
-			return -1;
+		jent_memcpy(p, &ec->data, tocopy);
 
 		len -= tocopy;
 		p += tocopy;
@@ -575,8 +628,7 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
  ***************************************************************************/
 
 struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
-					       unsigned int flags,
-					       void *hash_state)
+					       unsigned int flags)
 {
 	struct rand_data *entropy_collector;
 
@@ -603,8 +655,6 @@ struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 		osr = 1; /* minimum sampling rate is 1 */
 	entropy_collector->osr = osr;
 
-	entropy_collector->hash_state = hash_state;
-
 	/* fill the data pad with non-zero values */
 	jent_gen_entropy(entropy_collector);
 
@@ -618,7 +668,7 @@ void jent_entropy_collector_free(struct rand_data *entropy_collector)
 	jent_zfree(entropy_collector);
 }
 
-int jent_entropy_init(void *hash_state)
+int jent_entropy_init(void)
 {
 	int i;
 	__u64 delta_sum = 0;
@@ -631,7 +681,6 @@ int jent_entropy_init(void *hash_state)
 
 	/* Required for RCT */
 	ec.osr = 1;
-	ec.hash_state = hash_state;
 
 	/* We could perform statistical tests here, but the problem is
 	 * that we only have a few loop counts to do testing. These
@@ -669,7 +718,7 @@ int jent_entropy_init(void *hash_state)
 		/* Invoke core entropy collection logic */
 		jent_get_nstime(&time);
 		ec.prev_time = time;
-		jent_condition_data(&ec, time, 0);
+		jent_lfsr_time(&ec, time, 0, 0);
 		jent_get_nstime(&time2);
 
 		/* test whether timer works */
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index b3890ff26a023..5cc583f6bc6b8 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -2,18 +2,14 @@
 
 extern void *jent_zalloc(unsigned int len);
 extern void jent_zfree(void *ptr);
+extern void jent_memcpy(void *dest, const void *src, unsigned int n);
 extern void jent_get_nstime(__u64 *out);
-extern int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
-			  unsigned int addtl_len, __u64 hash_loop_cnt,
-			  unsigned int stuck);
-int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len);
 
 struct rand_data;
-extern int jent_entropy_init(void *hash_state);
+extern int jent_entropy_init(void);
 extern int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			     unsigned int len);
 
 extern struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
-						      unsigned int flags,
-						      void *hash_state);
+						      unsigned int flags);
 extern void jent_entropy_collector_free(struct rand_data *entropy_collector);
-- 
2.56.0

