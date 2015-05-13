From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v6 3/5] crypto: drbg - add async seeding operation
Date: Wed, 13 May 2015 21:55:40 +0200
Message-ID: <1869317.TuXuA2NK4B@tachyon.chronox.de>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34775 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965001AbbEMT5y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 15:57:54 -0400
In-Reply-To: <1921857.OvxEu6y28S@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
 crypto/drbg.c         | 25 +++++++++++++++++++++++++
 include/crypto/drbg.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 36dfece..2b2738e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1056,6 +1056,24 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	return ret;
 }
 
+static void drbg_async_seed(struct work_struct *work)
+{
+	struct drbg_string data;
+	LIST_HEAD(seedlist);
+	struct drbg_state *drbg = container_of(work, struct drbg_state,
+					       seed_work);
+	int ret = 0;
+
+	get_blocking_random_bytes(drbg->seed_buf, drbg->seed_buf_len);
+
+	drbg_string_fill(&data, drbg->seed_buf, drbg->seed_buf_len);
+	list_add_tail(&data.list, &seedlist);
+	mutex_lock(&drbg->drbg_mutex);
+	ret = __drbg_seed(drbg, &seedlist, true);
+	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len);
+	mutex_unlock(&drbg->drbg_mutex);
+}
+
 /*
  * Seeding or reseeding of the DRBG
  *
@@ -1125,6 +1143,10 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	if (!reseed)
 		drbg->seed_buf_len = drbg->seed_buf_len / 3 * 2;
 
+	/* Invoke asynchronous seeding unless DRBG is in test mode. */
+	if (!list_empty(&drbg->test_data.list))
+		schedule_work(&drbg->seed_work);
+
 out:
 	return ret;
 }
@@ -1134,6 +1156,7 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
+	cancel_work_sync(&drbg->seed_work);
 	kzfree(drbg->V);
 	drbg->V = NULL;
 	kzfree(drbg->C);
@@ -1231,6 +1254,8 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	if (!drbg->seed_buf)
 		goto err;
 
+	INIT_WORK(&drbg->seed_work, drbg_async_seed);
+
 	return 0;
 
 err:
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
