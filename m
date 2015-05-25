From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v10 3/5] crypto: drbg - add async seeding operation
Date: Mon, 25 May 2015 15:09:36 +0200
Message-ID: <5647124.50TYTOCQD2@tachyon.chronox.de>
References: <1818200.UPNYCFQzYg@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1818200.UPNYCFQzYg@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The async seeding operation is triggered during initalization right
after the first non-blocking seeding is completed. As required by the
asynchronous operation of random.c, a callback function is provided that
is triggered by random.c once entropy is available. That callback
function performs the actual seeding of the DRBG.

CC: Andreas Steffen <andreas.steffen@strongswan.org>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Sandy Harris <sandyinchina@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 24 ++++++++++++++++++++++++
 include/crypto/drbg.h |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 36dfece..aca8684 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1056,6 +1056,23 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	return ret;
 }
 
+static void drbg_async_seed(struct work_struct *work)
+{
+	struct drbg_string data;
+	LIST_HEAD(seedlist);
+	struct drbg_state *drbg = container_of(work, struct drbg_state,
+					       seed_work);
+
+	get_blocking_random_bytes(drbg->seed_buf, drbg->seed_buf_len);
+
+	drbg_string_fill(&data, drbg->seed_buf, drbg->seed_buf_len);
+	list_add_tail(&data.list, &seedlist);
+	mutex_lock(&drbg->drbg_mutex);
+	__drbg_seed(drbg, &seedlist, true);
+	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len);
+	mutex_unlock(&drbg->drbg_mutex);
+}
+
 /*
  * Seeding or reseeding of the DRBG
  *
@@ -1125,6 +1142,10 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	if (!reseed)
 		drbg->seed_buf_len = drbg->seed_buf_len / 3 * 2;
 
+	/* Invoke asynchronous seeding unless DRBG is in test mode. */
+	if (!list_empty(&drbg->test_data.list) && !reseed)
+		schedule_work(&drbg->seed_work);
+
 out:
 	return ret;
 }
@@ -1231,6 +1252,8 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	if (!drbg->seed_buf)
 		goto err;
 
+	INIT_WORK(&drbg->seed_work, drbg_async_seed);
+
 	return 0;
 
 err:
@@ -1487,6 +1510,7 @@ unlock:
  */
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
+	cancel_work_sync(&drbg->seed_work);
 	if (drbg->d_ops)
 		drbg->d_ops->crypto_fini(drbg);
 	drbg_dealloc_state(drbg);
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index b052698..46994b2 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -51,6 +51,7 @@
 #include <linux/fips.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/workqueue.h>
 
 /*
  * Concatenation Helper and string operation helper
@@ -119,6 +120,7 @@ struct drbg_state {
 	bool fips_primed;	/* Continuous test primed? */
 	unsigned char *prev;	/* FIPS 140-2 continuous test value */
 #endif
+	struct work_struct seed_work;	/* asynchronous seeding support */
 	u8 *seed_buf;			/* buffer holding the seed */
 	size_t seed_buf_len;
 	const struct drbg_state_ops *d_ops;
-- 
2.1.0
