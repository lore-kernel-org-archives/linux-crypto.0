From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v9 4/5] crypto: drbg - use Jitter RNG to obtain seed
Date: Wed, 20 May 2015 22:04:21 +0200
Message-ID: <5553173.kjULmmqftR@tachyon.chronox.de>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3340545.QDDPvU7BuN@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
 crypto/drbg.c         | 51 ++++++++++++++++++++++++++++++++++++++++++++-------
 include/crypto/drbg.h |  1 +
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 563e5e9..e9fd60d 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1072,7 +1072,11 @@ static void drbg_async_seed(struct work_struct *work)
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
@@ -1107,10 +1111,24 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
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
 
@@ -1135,7 +1153,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	 * Clear the initial entropy buffer as the async call may not overwrite
 	 * that buffer for quite some time.
 	 */
-	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len);
+	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len * 2);
 	if (ret)
 		goto out;
 	/*
@@ -1175,6 +1193,10 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 #endif
 	kzfree(drbg->seed_buf);
 	drbg->seed_buf = NULL;
+	if (drbg->jent) {
+		crypto_free_rng(drbg->jent);
+		drbg->jent = NULL;
+	}
 }
 
 /*
@@ -1250,14 +1272,29 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
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
