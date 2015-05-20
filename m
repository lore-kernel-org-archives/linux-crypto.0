From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v7 4/5] crypto: drbg - use Jitter RNG to obtain seed
Date: Wed, 20 May 2015 19:46:06 +0200
Message-ID: <1731838.z6QyqzxrEu@tachyon.chronox.de>
References: <1693038.ndeE0L22jl@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58001 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbbETRs3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 13:48:29 -0400
In-Reply-To: <1693038.ndeE0L22jl@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

During initialization, the DRBG now tries to allocate a handle of the
Jitter RNG. If such a Jitter RNG is available during seeding, the DRBG
pulls the required entropy/nonce string from get_random_bytes and
concatenates it with a string of equal size from the Jitter RNG. That
combined string is now the seed for the DRBG.

Written differently, the initial seed of the DRBG is now:

get_random_bytes(entropy/nonce) || jitterentropy (entropy/nonce)

If the Jitter RNG is not available, the DRBG only seeds from
get_random_bytes.

CC: Andreas Steffen <andreas.steffen@strongswan.org>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Sandy Harris <sandyinchina@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 52 ++++++++++++++++++++++++++++++++++++++++++++-------
 include/crypto/drbg.h |  1 +
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index aca8684..9284348 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1062,13 +1062,18 @@ static void drbg_async_seed(struct work_struct *work)
 	LIST_HEAD(seedlist);
 	struct drbg_state *drbg = container_of(work, struct drbg_state,
 					       seed_work);
+	int ret;
 
 	get_blocking_random_bytes(drbg->seed_buf, drbg->seed_buf_len);
 
 	drbg_string_fill(&data, drbg->seed_buf, drbg->seed_buf_len);
 	list_add_tail(&data.list, &seedlist);
 	mutex_lock(&drbg->drbg_mutex);
-	__drbg_seed(drbg, &seedlist, true);
+	ret = __drbg_seed(drbg, &seedlist, true);
+	if (!ret && drbg->jent) {
+		crypto_free_rng(drbg->jent);
+		drbg->jent = NULL;
+	}
 	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len);
 	mutex_unlock(&drbg->drbg_mutex);
 }
@@ -1103,10 +1108,24 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 				 drbg->test_data.len);
 		pr_devel("DRBG: using test entropy\n");
 	} else {
-		pr_devel("DRBG: (re)seeding with %zu bytes of entropy\n",
-			 drbg->seed_buf_len);
+		/* Get seed from in-kernel /dev/urandom */
 		get_random_bytes(drbg->seed_buf, drbg->seed_buf_len);
-		drbg_string_fill(&data1, drbg->seed_buf, drbg->seed_buf_len);
+
+		/* Get seed from Jitter RNG */
+		if (!drbg->jent ||
+		    crypto_rng_get_bytes(drbg->jent,
+					 drbg->seed_buf + drbg->seed_buf_len,
+					 drbg->seed_buf_len)) {
+			drbg_string_fill(&data1, drbg->seed_buf,
+					 drbg->seed_buf_len);
+			pr_devel("DRBG: (re)seeding with %zu bytes of entropy\n",
+				 drbg->seed_buf_len);
+		} else {
+			drbg_string_fill(&data1, drbg->seed_buf,
+					 drbg->seed_buf_len * 2);
+			pr_devel("DRBG: (re)seeding with %zu bytes of entropy\n",
+				 drbg->seed_buf_len * 2);
+		}
 	}
 	list_add_tail(&data1.list, &seedlist);
 
@@ -1131,7 +1150,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	 * Clear the initial entropy buffer as the async call may not overwrite
 	 * that buffer for quite some time.
 	 */
-	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len);
+	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len * 2);
 	if (ret)
 		goto out;
 	/*
@@ -1171,6 +1190,10 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 #endif
 	kzfree(drbg->seed_buf);
 	drbg->seed_buf = NULL;
+	if (drbg->jent) {
+		crypto_free_rng(drbg->jent);
+		drbg->jent = NULL;
+	}
 }
 
 /*
@@ -1246,14 +1269,29 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		ret = -EFAULT;
 		goto err;
 	}
-	/* ensure we have sufficient buffer space for initial seed */
+	/*
+	 * Ensure we have sufficient buffer space for initial seed which
+	 * consists of the seed from get_random_bytes and the Jitter RNG.
+	 */
 	drbg->seed_buf_len = ((drbg->seed_buf_len + 1) / 2) * 3;
-	drbg->seed_buf = kzalloc(drbg->seed_buf_len, GFP_KERNEL);
+	drbg->seed_buf = kzalloc(drbg->seed_buf_len * 2, GFP_KERNEL);
 	if (!drbg->seed_buf)
 		goto err;
 
 	INIT_WORK(&drbg->seed_work, drbg_async_seed);
 
+	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
+	if(IS_ERR(drbg->jent))
+	{
+		pr_info("DRBG: could not allocate Jitter RNG handle for seeding\n");
+		/*
+		 * As the Jitter RNG is a module that may not be present, we
+		 * continue with the operation and do not fully tie the DRBG
+		 * to the Jitter RNG.
+		 */
+		drbg->jent = NULL;
+	}
+
 	return 0;
 
 err:
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 46994b2..c3f208d 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -123,6 +123,7 @@ struct drbg_state {
 	struct work_struct seed_work;	/* asynchronous seeding support */
 	u8 *seed_buf;			/* buffer holding the seed */
 	size_t seed_buf_len;
+	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
 	struct drbg_string test_data;
-- 
2.1.0
