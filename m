From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 3/4] crypto: drbg - replace spinlock with mutex
Date: Fri, 17 Apr 2015 14:55:28 +0200
Message-ID: <2415536.7nqArbGB13@myon.chronox.de>
References: <1551177.C0RmlOO9iU@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34155 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbbDQM4s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 08:56:48 -0400
In-Reply-To: <1551177.C0RmlOO9iU@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The DRBG shall hold a long term lock. Therefore, the lock is changed to
a mutex which implies that the DRBG can only be used in process context.

The lock now guards the instantiation as well as the entire DRBG
generation operation. Therefore, multiple callers are fully serialized
when generating a random number.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 22 ++++++++++++++--------
 include/crypto/drbg.h |  4 ++--
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index c8a083c..19916ea 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1181,7 +1181,6 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		if (!drbg->scratchpad)
 			goto err;
 	}
-	spin_lock_init(&drbg->drbg_lock);
 	return 0;
 
 err:
@@ -1349,7 +1348,9 @@ static int drbg_generate_long(struct drbg_state *drbg,
 		unsigned int chunk = 0;
 		slice = ((buflen - len) / drbg_max_request_bytes(drbg));
 		chunk = slice ? drbg_max_request_bytes(drbg) : (buflen - len);
+		mutex_lock(&drbg->drbg_mutex);
 		tmplen = drbg_generate(drbg, buf + len, chunk, addtl);
+		mutex_unlock(&drbg->drbg_mutex);
 		if (0 >= tmplen)
 			return tmplen;
 		len += tmplen;
@@ -1377,10 +1378,12 @@ static int drbg_generate_long(struct drbg_state *drbg,
 static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 			    int coreref, bool pr)
 {
-	int ret = -ENOMEM;
+	int ret = -EOPNOTSUPP;
 
 	pr_devel("DRBG: Initializing DRBG core %d with prediction resistance "
 		 "%s\n", coreref, pr ? "enabled" : "disabled");
+	mutex_init(&drbg->drbg_mutex);
+	mutex_lock(&drbg->drbg_mutex);
 	drbg->core = &drbg_cores[coreref];
 	drbg->pr = pr;
 	drbg->seeded = false;
@@ -1401,7 +1404,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		break;
 #endif /* CONFIG_CRYPTO_DRBG_CTR */
 	default:
-		return -EOPNOTSUPP;
+		goto unlock;
 	}
 
 	/* 9.1 step 1 is implicit with the selected DRBG type */
@@ -1416,7 +1419,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 
 	ret = drbg_alloc_state(drbg);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	ret = -EFAULT;
 	if (drbg->d_ops->crypto_init(drbg))
@@ -1426,10 +1429,13 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
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
 
@@ -1444,10 +1450,10 @@ err:
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
 
@@ -1462,9 +1468,9 @@ static inline void drbg_set_testdata(struct drbg_state *drbg,
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
