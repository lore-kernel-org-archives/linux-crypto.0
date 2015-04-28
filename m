From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 3/6] crypto: drbg - prepare for async seeding
Date: Tue, 28 Apr 2015 04:59:34 +0200
Message-ID: <6532993.CAu85Fcg7H@myon.chronox.de>
References: <11175802.HG0pHJfshY@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <11175802.HG0pHJfshY@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In order to prepare for the addition of the asynchronous seeding call,
the invocation of seeding the DRBG is moved out into a helper function.

In addition, a block of memory is allocated during initialization time
that will be used as a scratchpad for obtaining entropy. That scratchpad
is used for the initial seeding operation as well as by the
asynchronous seeding call. The memory must be zeroized every time the
DRBG seeding call succeeds to avoid entropy data lingering in memory.

CC: Andreas Steffen <andreas.steffen@strongswan.org>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Sandy Harris <sandyinchina@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 81 ++++++++++++++++++++++++++++++++++-----------------
 include/crypto/drbg.h |  2 ++
 2 files changed, 56 insertions(+), 27 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 23d444e..36dfece 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1041,6 +1041,21 @@ static struct drbg_state_ops drbg_hash_ops = {
  * Functions common for DRBG implementations
  ******************************************************************/
 
+static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
+			      int reseed)
+{
+	int ret = drbg->d_ops->update(drbg, seed, reseed);
+
+	if (ret)
+		return ret;
+
+	drbg->seeded = true;
+	/* 10.1.1.2 / 10.1.1.3 step 5 */
+	drbg->reseed_ctr = 1;
+
+	return ret;
+}
+
 /*
  * Seeding or reseeding of the DRBG
  *
@@ -1056,8 +1071,6 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		     bool reseed)
 {
 	int ret = 0;
-	unsigned char *entropy = NULL;
-	size_t entropylen = 0;
 	struct drbg_string data1;
 	LIST_HEAD(seedlist);
 
@@ -1073,26 +1086,10 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 				 drbg->test_data.len);
 		pr_devel("DRBG: using test entropy\n");
 	} else {
-		/*
-		 * Gather entropy equal to the security strength of the DRBG.
-		 * With a derivation function, a nonce is required in addition
-		 * to the entropy. A nonce must be at least 1/2 of the security
-		 * strength of the DRBG in size. Thus, entropy * nonce is 3/2
-		 * of the strength. The consideration of a nonce is only
-		 * applicable during initial seeding.
-		 */
-		entropylen = drbg_sec_strength(drbg->core->flags);
-		if (!entropylen)
-			return -EFAULT;
-		if (!reseed)
-			entropylen = ((entropylen + 1) / 2) * 3;
 		pr_devel("DRBG: (re)seeding with %zu bytes of entropy\n",
-			 entropylen);
-		entropy = kzalloc(entropylen, GFP_KERNEL);
-		if (!entropy)
-			return -ENOMEM;
-		get_random_bytes(entropy, entropylen);
-		drbg_string_fill(&data1, entropy, entropylen);
+			 drbg->seed_buf_len);
+		get_random_bytes(drbg->seed_buf, drbg->seed_buf_len);
+		drbg_string_fill(&data1, drbg->seed_buf, drbg->seed_buf_len);
 	}
 	list_add_tail(&data1.list, &seedlist);
 
@@ -1111,16 +1108,24 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		memset(drbg->C, 0, drbg_statelen(drbg));
 	}
 
-	ret = drbg->d_ops->update(drbg, &seedlist, reseed);
+	ret = __drbg_seed(drbg, &seedlist, reseed);
+
+	/*
+	 * Clear the initial entropy buffer as the async call may not overwrite
+	 * that buffer for quite some time.
+	 */
+	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len);
 	if (ret)
 		goto out;
-
-	drbg->seeded = true;
-	/* 10.1.1.2 / 10.1.1.3 step 5 */
-	drbg->reseed_ctr = 1;
+	/*
+	 * For all subsequent seeding calls, we only need the seed buffer
+	 * equal to the security strength of the DRBG. We undo the calculation
+	 * in drbg_alloc_state.
+	 */
+	if (!reseed)
+		drbg->seed_buf_len = drbg->seed_buf_len / 3 * 2;
 
 out:
-	kzfree(entropy);
 	return ret;
 }
 
@@ -1143,6 +1148,8 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	drbg->prev = NULL;
 	drbg->fips_primed = false;
 #endif
+	kzfree(drbg->seed_buf);
+	drbg->seed_buf = NULL;
 }
 
 /*
@@ -1204,6 +1211,26 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		if (!drbg->scratchpad)
 			goto err;
 	}
+
+	/*
+	 * Gather entropy equal to the security strength of the DRBG.
+	 * With a derivation function, a nonce is required in addition
+	 * to the entropy. A nonce must be at least 1/2 of the security
+	 * strength of the DRBG in size. Thus, entropy * nonce is 3/2
+	 * of the strength. The consideration of a nonce is only
+	 * applicable during initial seeding.
+	 */
+	drbg->seed_buf_len = drbg_sec_strength(drbg->core->flags);
+	if (!drbg->seed_buf_len) {
+		ret = -EFAULT;
+		goto err;
+	}
+	/* ensure we have sufficient buffer space for initial seed */
+	drbg->seed_buf_len = ((drbg->seed_buf_len + 1) / 2) * 3;
+	drbg->seed_buf = kzalloc(drbg->seed_buf_len, GFP_KERNEL);
+	if (!drbg->seed_buf)
+		goto err;
+
 	return 0;
 
 err:
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 480d7a0..b052698 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -119,6 +119,8 @@ struct drbg_state {
 	bool fips_primed;	/* Continuous test primed? */
 	unsigned char *prev;	/* FIPS 140-2 continuous test value */
 #endif
+	u8 *seed_buf;			/* buffer holding the seed */
+	size_t seed_buf_len;
 	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
 	struct drbg_string test_data;
-- 
2.1.0
