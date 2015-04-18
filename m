From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 2/3] crypto: drbg - replace spinlock with mutex
Date: Sat, 18 Apr 2015 16:45:30 +0200
Message-ID: <2062472.s6K7ZpkRq2@myon.chronox.de>
References: <2596998.Ykulm8tym0@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34187 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbbDROq6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 10:46:58 -0400
In-Reply-To: <2596998.Ykulm8tym0@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The creation of a shadow copy is intended to only hold a short term
lock. But the drawback is that parallel users have a very similar DRBG
state which only differs by a high-resolution time stamp.

The DRBG will now hold a long term lock. Therefore, the lock is changed
to a mutex which implies that the DRBG can only be used in process
context.

The lock now guards the instantiation as well as the entire DRBG
generation operation. Therefore, multiple callers are fully serialized
when generating a random number.

As the locking is changed to use a long-term lock to avoid such similar
DRBG states, the entire creation and maintenance of a shadow copy can be
removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 144 +++++++++-----------------------------------------
 include/crypto/drbg.h |   4 +-
 2 files changed, 27 insertions(+), 121 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 74f7c1e..d34926b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1181,7 +1181,6 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		if (!drbg->scratchpad)
 			goto err;
 	}
-	spin_lock_init(&drbg->drbg_lock);
 	return 0;
 
 err:
@@ -1189,79 +1188,6 @@ err:
 	return ret;
 }
 
-/*
- * Strategy to avoid holding long term locks: generate a shadow copy of DRBG
- * and perform all operations on this shadow copy. After finishing, restore
- * the updated state of the shadow copy into original drbg state. This way,
- * only the read and write operations of the original drbg state must be
- * locked
- */
-static inline void drbg_copy_drbg(struct drbg_state *src,
-				  struct drbg_state *dst)
-{
-	if (!src || !dst)
-		return;
-	memcpy(dst->V, src->V, drbg_statelen(src));
-	memcpy(dst->C, src->C, drbg_statelen(src));
-	dst->reseed_ctr = src->reseed_ctr;
-	dst->seeded = src->seeded;
-	dst->pr = src->pr;
-#ifdef CONFIG_CRYPTO_FIPS
-	dst->fips_primed = src->fips_primed;
-	memcpy(dst->prev, src->prev, drbg_blocklen(src));
-#endif
-	/*
-	 * Not copied:
-	 * scratchpad is initialized drbg_alloc_state;
-	 * priv_data is initialized with call to crypto_init;
-	 * d_ops and core are set outside, as these parameters are const;
-	 * test_data is set outside to prevent it being copied back.
-	 */
-}
-
-static int drbg_make_shadow(struct drbg_state *drbg, struct drbg_state **shadow)
-{
-	int ret = -ENOMEM;
-	struct drbg_state *tmp = NULL;
-
-	tmp = kzalloc(sizeof(struct drbg_state), GFP_KERNEL);
-	if (!tmp)
-		return -ENOMEM;
-
-	/* read-only data as they are defined as const, no lock needed */
-	tmp->core = drbg->core;
-	tmp->d_ops = drbg->d_ops;
-
-	ret = drbg_alloc_state(tmp);
-	if (ret)
-		goto err;
-
-	spin_lock_bh(&drbg->drbg_lock);
-	drbg_copy_drbg(drbg, tmp);
-	/* only make a link to the test buffer, as we only read that data */
-	tmp->test_data = drbg->test_data;
-	spin_unlock_bh(&drbg->drbg_lock);
-	*shadow = tmp;
-	return 0;
-
-err:
-	kzfree(tmp);
-	return ret;
-}
-
-static void drbg_restore_shadow(struct drbg_state *drbg,
-				struct drbg_state **shadow)
-{
-	struct drbg_state *tmp = *shadow;
-
-	spin_lock_bh(&drbg->drbg_lock);
-	drbg_copy_drbg(tmp, drbg);
-	spin_unlock_bh(&drbg->drbg_lock);
-	drbg_dealloc_state(tmp);
-	kzfree(tmp);
-	*shadow = NULL;
-}
-
 /*************************************************************************
  * DRBG interface functions
  *************************************************************************/
@@ -1287,13 +1213,7 @@ static int drbg_generate(struct drbg_state *drbg,
 			 struct drbg_string *addtl)
 {
 	int len = 0;
-	struct drbg_state *shadow = NULL;
 	LIST_HEAD(addtllist);
-	struct drbg_string timestamp;
-	union {
-		cycles_t cycles;
-		unsigned char char_cycles[sizeof(cycles_t)];
-	} now;
 
 	if (0 == buflen || !buf) {
 		pr_devel("DRBG: no output buffer provided\n");
@@ -1304,15 +1224,9 @@ static int drbg_generate(struct drbg_state *drbg,
 		return -EINVAL;
 	}
 
-	len = drbg_make_shadow(drbg, &shadow);
-	if (len) {
-		pr_devel("DRBG: shadow copy cannot be generated\n");
-		return len;
-	}
-
 	/* 9.3.1 step 2 */
 	len = -EINVAL;
-	if (buflen > (drbg_max_request_bytes(shadow))) {
+	if (buflen > (drbg_max_request_bytes(drbg))) {
 		pr_devel("DRBG: requested random numbers too large %u\n",
 			 buflen);
 		goto err;
@@ -1321,7 +1235,7 @@ static int drbg_generate(struct drbg_state *drbg,
 	/* 9.3.1 step 3 is implicit with the chosen DRBG */
 
 	/* 9.3.1 step 4 */
-	if (addtl && addtl->len > (drbg_max_addtl(shadow))) {
+	if (addtl && addtl->len > (drbg_max_addtl(drbg))) {
 		pr_devel("DRBG: additional information string too long %zu\n",
 			 addtl->len);
 		goto err;
@@ -1332,46 +1246,34 @@ static int drbg_generate(struct drbg_state *drbg,
 	 * 9.3.1 step 6 and 9 supplemented by 9.3.2 step c is implemented
 	 * here. The spec is a bit convoluted here, we make it simpler.
 	 */
-	if ((drbg_max_requests(shadow)) < shadow->reseed_ctr)
-		shadow->seeded = false;
+	if ((drbg_max_requests(drbg)) < drbg->reseed_ctr)
+		drbg->seeded = false;
 
 	/* allocate cipher handle */
-	len = shadow->d_ops->crypto_init(shadow);
+	len = drbg->d_ops->crypto_init(drbg);
 	if (len)
 		goto err;
 
-	if (shadow->pr || !shadow->seeded) {
+	if (drbg->pr || !drbg->seeded) {
 		pr_devel("DRBG: reseeding before generation (prediction "
 			 "resistance: %s, state %s)\n",
 			 drbg->pr ? "true" : "false",
 			 drbg->seeded ? "seeded" : "unseeded");
 		/* 9.3.1 steps 7.1 through 7.3 */
-		len = drbg_seed(shadow, addtl, true);
+		len = drbg_seed(drbg, addtl, true);
 		if (len)
 			goto err;
 		/* 9.3.1 step 7.4 */
 		addtl = NULL;
 	}
 
-	/*
-	 * Mix the time stamp into the DRBG state if the DRBG is not in
-	 * test mode. If there are two callers invoking the DRBG at the same
-	 * time, i.e. before the first caller merges its shadow state back,
-	 * both callers would obtain the same random number stream without
-	 * changing the state here.
-	 */
-	if (!drbg->test_data) {
-		now.cycles = random_get_entropy();
-		drbg_string_fill(&timestamp, now.char_cycles, sizeof(cycles_t));
-		list_add_tail(&timestamp.list, &addtllist);
-	}
 	if (addtl && 0 < addtl->len)
 		list_add_tail(&addtl->list, &addtllist);
 	/* 9.3.1 step 8 and 10 */
-	len = shadow->d_ops->generate(shadow, buf, buflen, &addtllist);
+	len = drbg->d_ops->generate(drbg, buf, buflen, &addtllist);
 
 	/* 10.1.1.4 step 6, 10.1.2.5 step 7, 10.2.1.5.2 step 7 */
-	shadow->reseed_ctr++;
+	drbg->reseed_ctr++;
 	if (0 >= len)
 		goto err;
 
@@ -1391,7 +1293,7 @@ static int drbg_generate(struct drbg_state *drbg,
 	 * case somebody has a need to implement the test of 11.3.3.
 	 */
 #if 0
-	if (shadow->reseed_ctr && !(shadow->reseed_ctr % 4096)) {
+	if (drbg->reseed_ctr && !(drbg->reseed_ctr % 4096)) {
 		int err = 0;
 		pr_devel("DRBG: start to perform self test\n");
 		if (drbg->core->flags & DRBG_HMAC)
@@ -1410,8 +1312,6 @@ static int drbg_generate(struct drbg_state *drbg,
 			 * are returned when reusing this DRBG cipher handle
 			 */
 			drbg_uninstantiate(drbg);
-			drbg_dealloc_state(shadow);
-			kzfree(shadow);
 			return 0;
 		} else {
 			pr_devel("DRBG: self test successful\n");
@@ -1425,8 +1325,7 @@ static int drbg_generate(struct drbg_state *drbg,
 	 */
 	len = 0;
 err:
-	shadow->d_ops->crypto_fini(shadow);
-	drbg_restore_shadow(drbg, &shadow);
+	drbg->d_ops->crypto_fini(drbg);
 	return len;
 }
 
@@ -1449,7 +1348,9 @@ static int drbg_generate_long(struct drbg_state *drbg,
 		unsigned int chunk = 0;
 		slice = ((buflen - len) / drbg_max_request_bytes(drbg));
 		chunk = slice ? drbg_max_request_bytes(drbg) : (buflen - len);
+		mutex_lock(&drbg->drbg_mutex);
 		tmplen = drbg_generate(drbg, buf + len, chunk, addtl);
+		mutex_unlock(&drbg->drbg_mutex);
 		if (0 > tmplen)
 			return tmplen;
 		len += tmplen;
@@ -1477,10 +1378,11 @@ static int drbg_generate_long(struct drbg_state *drbg,
 static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 			    int coreref, bool pr)
 {
-	int ret = -ENOMEM;
+	int ret = -EOPNOTSUPP;
 
 	pr_devel("DRBG: Initializing DRBG core %d with prediction resistance "
 		 "%s\n", coreref, pr ? "enabled" : "disabled");
+	mutex_lock(&drbg->drbg_mutex);
 	drbg->core = &drbg_cores[coreref];
 	drbg->pr = pr;
 	drbg->seeded = false;
@@ -1501,7 +1403,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		break;
 #endif /* CONFIG_CRYPTO_DRBG_CTR */
 	default:
-		return -EOPNOTSUPP;
+		goto unlock;
 	}
 
 	/* 9.1 step 1 is implicit with the selected DRBG type */
@@ -1516,7 +1418,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 
 	ret = drbg_alloc_state(drbg);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	ret = -EFAULT;
 	if (drbg->d_ops->crypto_init(drbg))
@@ -1526,10 +1428,13 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 	if (ret)
 		goto err;
 
+	mutex_unlock(&drbg->drbg_mutex);
 	return 0;
 
 err:
 	drbg_dealloc_state(drbg);
+unlock:
+	mutex_unlock(&drbg->drbg_mutex);
 	return ret;
 }
 
@@ -1544,10 +1449,10 @@ err:
  */
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
-	spin_lock_bh(&drbg->drbg_lock);
+	mutex_lock(&drbg->drbg_mutex);
 	drbg_dealloc_state(drbg);
 	/* no scrubbing of test_data -- this shall survive an uninstantiate */
-	spin_unlock_bh(&drbg->drbg_lock);
+	mutex_unlock(&drbg->drbg_mutex);
 	return 0;
 }
 
@@ -1562,9 +1467,9 @@ static inline void drbg_set_testdata(struct drbg_state *drbg,
 {
 	if (!test_data || !test_data->testentropy)
 		return;
-	spin_lock_bh(&drbg->drbg_lock);
+	mutex_lock(&drbg->drbg_mutex);;
 	drbg->test_data = test_data;
-	spin_unlock_bh(&drbg->drbg_lock);
+	mutex_unlock(&drbg->drbg_mutex);
 }
 
 /***************************************************************
@@ -1717,6 +1622,7 @@ static int drbg_kcapi_init(struct crypto_tfm *tfm)
 	bool pr = false;
 	int coreref = 0;
 
+	mutex_init(&drbg->drbg_mutex);
 	drbg_convert_tfm_core(crypto_tfm_alg_driver_name(tfm), &coreref, &pr);
 	/*
 	 * when personalization string is needed, the caller must call reset
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 5186f75..a43a7ed 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -49,7 +49,7 @@
 #include <crypto/internal/rng.h>
 #include <crypto/rng.h>
 #include <linux/fips.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/list.h>
 
 /*
@@ -104,7 +104,7 @@ struct drbg_test_data {
 };
 
 struct drbg_state {
-	spinlock_t drbg_lock;	/* lock around DRBG */
+	struct mutex drbg_mutex;	/* lock around DRBG */
 	unsigned char *V;	/* internal state 10.1.1.1 1a) */
 	/* hash: static value 10.1.1.1 1b) hmac / ctr: key */
 	unsigned char *C;
-- 
2.1.0
