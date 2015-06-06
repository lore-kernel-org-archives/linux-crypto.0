From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: use list to stage async seeding requests
Date: Sat, 06 Jun 2015 04:16:54 +0200
Message-ID: <1758927.bAziGtcHhF@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, andreas.steffen@strongswan.org,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch uses a list to track the asynchronous seeding requests until
the nonblocking pool is fully initialized. The random.c is provided with
two API calls: the get_blocking_random_bytes_cb allows the caller to
provide a callback function that is triggered once the nonblocking pool
is initialized. If the nonblocking pool is already initialized at the
time of invocation, the function is a noop. The second API call of
get_blocking_random_bytes_cancel allows the caller to cancel an
outstanding request.

The previous approach used a waitqueue for maintaining the requests
until the nonblocking pool is initialized. In some circumstances, the
wait can be very long (in the orders of minutes) where the use of
waitqueues is not appropriate.

The patch also removes the entropy buffer registered with the DRBG
handle in favor of stack variables to hold the seed data.

CC: Andreas Steffen <andreas.steffen@strongswan.org>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Sandy Harris <sandyinchina@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c          | 112 ++++++++++++++++++++++++-------------------------
 drivers/char/random.c  |  99 +++++++++++++++++++++++++++++++++++++++----
 include/crypto/drbg.h  |   4 --
 include/linux/random.h |   4 +-
 4 files changed, 149 insertions(+), 70 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 04836b4..7339cc5 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1056,25 +1056,31 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	return ret;
 }
 
-static void drbg_async_seed(struct work_struct *work)
+static void drbg_async_seed(void *private)
 {
 	struct drbg_string data;
 	LIST_HEAD(seedlist);
-	struct drbg_state *drbg = container_of(work, struct drbg_state,
-					       seed_work);
-	int ret;
+	struct drbg_state *drbg = (struct drbg_state *)private;
+	unsigned char entropy[32];
+	size_t entropylen = drbg_sec_strength(drbg->core->flags);
+	int ret = 0;
 
-	get_blocking_random_bytes(drbg->seed_buf, drbg->seed_buf_len);
+	BUG_ON(!entropylen);
+	BUG_ON(entropylen > sizeof(entropy));
+	get_random_bytes(entropy, entropylen);
 
-	drbg_string_fill(&data, drbg->seed_buf, drbg->seed_buf_len);
+	drbg_string_fill(&data, entropy, entropylen);
 	list_add_tail(&data.list, &seedlist);
+
 	mutex_lock(&drbg->drbg_mutex);
 	ret = __drbg_seed(drbg, &seedlist, true);
+
+	/* If nonblocking pool is initialized, deactivate Jitter RNG */
 	if (!ret && drbg->jent) {
 		crypto_free_rng(drbg->jent);
 		drbg->jent = NULL;
 	}
-	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len);
+	memzero_explicit(entropy, entropylen);
 	mutex_unlock(&drbg->drbg_mutex);
 }
 
@@ -1093,6 +1099,8 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		     bool reseed)
 {
 	int ret = 0;
+	unsigned char entropy[((32 + 16) * 2)];
+	size_t entropylen = drbg_sec_strength(drbg->core->flags);
 	struct drbg_string data1;
 	LIST_HEAD(seedlist);
 
@@ -1108,23 +1116,51 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 				 drbg->test_data.len);
 		pr_devel("DRBG: using test entropy\n");
 	} else {
+		/*
+		 * Gather entropy equal to the security strength of the DRBG.
+		 * With a derivation function, a nonce is required in addition
+		 * to the entropy. A nonce must be at least 1/2 of the security
+		 * strength of the DRBG in size. Thus, entropy + nonce is 3/2
+		 * of the strength. The consideration of a nonce is only
+		 * applicable during initial seeding.
+		 */
+		BUG_ON(!entropylen);
+		if (!reseed)
+			entropylen = ((entropylen + 1) / 2) * 3;
+		BUG_ON((entropylen * 2) > sizeof(entropy));
+
+		/*
+		 * Trigger async seeding: This function may not trigger the
+		 * async callback in case the nonblocking is filled. To avoid
+		 * a race between get_random_bytes operating on a not yet
+		 * initialized nonblocking pool and get_blocking_random_bytes_cb
+		 * already operating on an initialized nonblocking pool and thus
+		 * not calling the async callback, invoke the async trigger
+		 * before get_random_bytes.
+		 */
+		ret = get_blocking_random_bytes_cb(drbg, drbg_async_seed);
+
 		/* Get seed from in-kernel /dev/urandom */
-		get_random_bytes(drbg->seed_buf, drbg->seed_buf_len);
+		get_random_bytes(entropy, entropylen);
 
 		/* Get seed from Jitter RNG */
 		if (!drbg->jent ||
 		    crypto_rng_get_bytes(drbg->jent,
-					 drbg->seed_buf + drbg->seed_buf_len,
-					 drbg->seed_buf_len)) {
-			drbg_string_fill(&data1, drbg->seed_buf,
-					 drbg->seed_buf_len);
+					 entropy + entropylen,
+					 entropylen)) {
+			drbg_string_fill(&data1, entropy, entropylen);
 			pr_devel("DRBG: (re)seeding with %zu bytes of entropy\n",
-				 drbg->seed_buf_len);
+				 entropylen);
 		} else {
-			drbg_string_fill(&data1, drbg->seed_buf,
-					 drbg->seed_buf_len * 2);
+			drbg_string_fill(&data1, entropy, entropylen * 2);
 			pr_devel("DRBG: (re)seeding with %zu bytes of entropy\n",
-				 drbg->seed_buf_len * 2);
+				 entropylen * 2);
+		}
+
+		/* If nonblocking pool is initialized, deactivate Jitter RNG */
+		if (!ret && drbg->jent) {
+			crypto_free_rng(drbg->jent);
+			drbg->jent = NULL;
 		}
 	}
 	list_add_tail(&data1.list, &seedlist);
@@ -1150,22 +1186,8 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	 * Clear the initial entropy buffer as the async call may not overwrite
 	 * that buffer for quite some time.
 	 */
-	memzero_explicit(drbg->seed_buf, drbg->seed_buf_len * 2);
-	if (ret)
-		goto out;
-	/*
-	 * For all subsequent seeding calls, we only need the seed buffer
-	 * equal to the security strength of the DRBG. We undo the calculation
-	 * in drbg_alloc_state.
-	 */
-	if (!reseed)
-		drbg->seed_buf_len = drbg->seed_buf_len / 3 * 2;
+	memzero_explicit(entropy, entropylen * 2);
 
-	/* Invoke asynchronous seeding unless DRBG is in test mode. */
-	if (!list_empty(&drbg->test_data.list) && !reseed)
-		schedule_work(&drbg->seed_work);
-
-out:
 	return ret;
 }
 
@@ -1188,8 +1210,6 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	drbg->prev = NULL;
 	drbg->fips_primed = false;
 #endif
-	kzfree(drbg->seed_buf);
-	drbg->seed_buf = NULL;
 	if (drbg->jent) {
 		crypto_free_rng(drbg->jent);
 		drbg->jent = NULL;
@@ -1256,30 +1276,6 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 			goto err;
 	}
 
-	/*
-	 * Gather entropy equal to the security strength of the DRBG.
-	 * With a derivation function, a nonce is required in addition
-	 * to the entropy. A nonce must be at least 1/2 of the security
-	 * strength of the DRBG in size. Thus, entropy * nonce is 3/2
-	 * of the strength. The consideration of a nonce is only
-	 * applicable during initial seeding.
-	 */
-	drbg->seed_buf_len = drbg_sec_strength(drbg->core->flags);
-	if (!drbg->seed_buf_len) {
-		ret = -EFAULT;
-		goto err;
-	}
-	/*
-	 * Ensure we have sufficient buffer space for initial seed which
-	 * consists of the seed from get_random_bytes and the Jitter RNG.
-	 */
-	drbg->seed_buf_len = ((drbg->seed_buf_len + 1) / 2) * 3;
-	drbg->seed_buf = kzalloc(drbg->seed_buf_len * 2, GFP_KERNEL);
-	if (!drbg->seed_buf)
-		goto err;
-
-	INIT_WORK(&drbg->seed_work, drbg_async_seed);
-
 	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
 	if(IS_ERR(drbg->jent))
 	{
@@ -1548,7 +1544,7 @@ unlock:
  */
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
-	cancel_work_sync(&drbg->seed_work);
+	get_blocking_random_bytes_cancel(drbg);
 	if (drbg->d_ops)
 		drbg->d_ops->crypto_fini(drbg);
 	drbg_dealloc_state(drbg);
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 159d070..53eff0f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -409,6 +409,16 @@ static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static DECLARE_WAIT_QUEUE_HEAD(urandom_init_wait);
 static struct fasync_struct *fasync;
 
+static LIST_HEAD(random_wait_list);
+static DEFINE_MUTEX(random_wait_list_mutex);
+struct random_work {
+	struct list_head	list;
+	struct work_struct	rw_work;
+	void			*rw_private;
+	void			(*rw_cb)(void *private);
+};
+static void process_random_waiters(void);
+
 /**********************************************************************
  *
  * OS independent entropy store.   Here are the functions which handle
@@ -660,6 +670,7 @@ retry:
 		r->entropy_total = 0;
 		if (r == &nonblocking_pool) {
 			prandom_reseed_late();
+			process_random_waiters();
 			wake_up_all(&urandom_init_wait);
 			pr_notice("random: %s pool is initialized\n", r->name);
 		}
@@ -1244,17 +1255,91 @@ void get_random_bytes(void *buf, int nbytes)
 }
 EXPORT_SYMBOL(get_random_bytes);
 
+static void process_random_waiters(void)
+{
+	struct random_work *rw, *tmp;
+
+	mutex_lock(&random_wait_list_mutex);
+	list_for_each_entry_safe(rw, tmp, &random_wait_list, list) {
+		list_del(&rw->list);
+		schedule_work(&rw->rw_work);
+	}
+	mutex_unlock(&random_wait_list_mutex);
+}
+
+static void get_blocking_random_bytes_work(struct work_struct *work)
+{
+	struct random_work *rw = container_of(work, struct random_work,
+					      rw_work);
+
+	rw->rw_cb(rw->rw_private);
+	kfree(rw);
+}
+
 /*
- * Equivalent function to get_random_bytes with the difference that this
- * function blocks the request until the nonblocking_pool is initialized.
+ * API to ping the caller once the nonblocking_pool is initialized
+ *
+ * returns: 0 if nonblocking_pool is already initialized (callback is not
+ *	      invoked)
+ *	    -EINPROGRESS if nonblocking_pool is not initialized and the callback
+ *	      will be called after it has been initialized.
+ *	    other errors in case of error condition
  */
-void get_blocking_random_bytes(void *buf, int nbytes)
+int get_blocking_random_bytes_cb(void *private, void (*cb)(void *private))
 {
-	if (unlikely(nonblocking_pool.initialized == 0))
-		wait_event(urandom_init_wait, nonblocking_pool.initialized);
-	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+	struct random_work *rw;
+	int ret = 0;
+
+	mutex_lock(&random_wait_list_mutex);
+
+	if (nonblocking_pool.initialized)
+		goto out;
+
+	list_for_each_entry(rw, &random_wait_list, list) {
+		/* no double enqueuing */
+		if (private == rw->rw_private) {
+			ret = -EINPROGRESS;
+			goto out;
+		}
+	}
+
+	rw = kmalloc(sizeof(struct random_work), GFP_KERNEL);
+	if (!rw) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	INIT_WORK(&rw->rw_work, get_blocking_random_bytes_work);
+	rw->rw_private = private;
+	rw->rw_cb = cb;
+	list_add_tail(&rw->list, &random_wait_list);
+	ret = -EINPROGRESS;
+
+out:
+	mutex_unlock(&random_wait_list_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(get_blocking_random_bytes_cb);
+
+/*
+ * Cancel an outstanding request initialized with get_blocking_random_bytes_cb.
+ * It is harmless to call this function even when no request is registered or
+ * the registered request has already been processed.
+ */
+void get_blocking_random_bytes_cancel(void *private)
+{
+	struct random_work *rw, *tmp;
+
+	mutex_lock(&random_wait_list_mutex);
+	list_for_each_entry_safe(rw, tmp, &random_wait_list, list) {
+		if (private == rw->rw_private) {
+			list_del(&rw->list);
+			kfree(rw);
+			break;
+		}
+	}
+	mutex_unlock(&random_wait_list_mutex);
 }
-EXPORT_SYMBOL(get_blocking_random_bytes);
+EXPORT_SYMBOL(get_blocking_random_bytes_cancel);
 
 /*
  * This function will use the architecture-specific hardware random
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index c3f208d..e2c9530 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -51,7 +51,6 @@
 #include <linux/fips.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
-#include <linux/workqueue.h>
 
 /*
  * Concatenation Helper and string operation helper
@@ -120,9 +119,6 @@ struct drbg_state {
 	bool fips_primed;	/* Continuous test primed? */
 	unsigned char *prev;	/* FIPS 140-2 continuous test value */
 #endif
-	struct work_struct seed_work;	/* asynchronous seeding support */
-	u8 *seed_buf;			/* buffer holding the seed */
-	size_t seed_buf_len;
 	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
diff --git a/include/linux/random.h b/include/linux/random.h
index 796267d..4b07de0 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -14,7 +14,9 @@ extern void add_input_randomness(unsigned int type, unsigned int code,
 extern void add_interrupt_randomness(int irq, int irq_flags);
 
 extern void get_random_bytes(void *buf, int nbytes);
-extern void get_blocking_random_bytes(void *buf, int nbytes);
+extern int get_blocking_random_bytes_cb(void *private,
+					void (*cb)(void *private));
+extern void get_blocking_random_bytes_cancel(void *private);
 extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
 extern int random_int_secret_init(void);
-- 
2.4.2
