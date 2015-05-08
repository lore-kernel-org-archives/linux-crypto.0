From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v5 1/5] random: Async and sync API for accessing nonblocking_pool
Date: Fri, 08 May 2015 08:41:30 +0200
Message-ID: <3264123.O3YfJV7UGj@tachyon.chronox.de>
References: <1887272.cxqymnQQZn@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1887272.cxqymnQQZn@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The added API calls provide a synchronous function call
get_blocking_random_bytes where the caller is blocked until
the nonblocking_pool is initialized.

In addition, an asynchronous API call of get_blocking_random_bytes_cb
is provided which returns immediately to the caller after submitting
the request for random data. The caller-provided buffer that shall be
filled with random data is filled up as available entropy permits. The
caller may provide a callback function that is invoked once the
request is completed.

A third API call, get_blocking_random_bytes_cancel, is provided to
cancel the random number gathering operation.

CC: Andreas Steffen <andreas.steffen@strongswan.org>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Sandy Harris <sandyinchina@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c  | 104 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h |  20 ++++++++++
 2 files changed, 124 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9cd6968..05faef2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -407,6 +407,7 @@ static struct poolinfo {
 static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static DECLARE_WAIT_QUEUE_HEAD(urandom_init_wait);
+static DECLARE_WAIT_QUEUE_HEAD(urandom_kernel_wait);
 static struct fasync_struct *fasync;
 
 /**********************************************************************
@@ -661,6 +662,7 @@ retry:
 		if (r == &nonblocking_pool) {
 			prandom_reseed_late();
 			wake_up_interruptible(&urandom_init_wait);
+			wake_up_interruptible(&urandom_kernel_wait);
 			pr_notice("random: %s pool is initialized\n", r->name);
 		}
 	}
@@ -1778,3 +1781,106 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	credit_entropy_bits(poolp, entropy);
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
+
+static bool get_blocking_random_bytes_term(bool *cancel)
+{
+	if (nonblocking_pool.initialized)
+		return true;
+	return *cancel;
+}
+
+/*
+ * Equivalent function to get_random_bytes with the difference that this
+ * function blocks the request until the nonblocking_pool is initialized.
+ *
+ * This function may sleep.
+ *
+ * @buf caller allocated buffer filled with random data
+ * @nbytes requested number of bytes -- buffer should be at least as big
+ * @cancel pointer to variable that can be used to cancel the collection
+ *	   operation. If this boolean is set to true, the collection operation
+ *	   is terminated immediately. When it is set to true during the
+ *	   collection loop, the collection is terminated immediately.
+ */
+void get_blocking_random_bytes(void *buf, int nbytes, bool *cancel)
+{
+	if (unlikely(nonblocking_pool.initialized == 0))
+		wait_event_interruptible(urandom_kernel_wait,
+				get_blocking_random_bytes_term(cancel));
+
+	if (!cancel)
+		extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+}
+EXPORT_SYMBOL(get_blocking_random_bytes);
+
+/*
+ * Immediate canceling the collection operation for the random_work
+ */
+void get_blocking_random_bytes_cancel(struct random_work *rw)
+{
+	rw->cancel = true;
+	wake_up_interruptible(&urandom_kernel_wait);
+
+}
+EXPORT_SYMBOL(get_blocking_random_bytes_cancel);
+
+static void get_blocking_random_bytes_work(struct work_struct *work)
+{
+	struct random_work *rw = container_of(work, struct random_work,
+					      rw_work);
+
+	get_blocking_random_bytes(rw->rw_buf, rw->rw_len, &rw->cancel);
+	if (!rw->cancel)
+		rw->rw_cb(rw->rw_buf, rw->rw_len, rw->private);
+}
+
+/*
+ * Asynchronous invocation of the blocking interface. The function
+ * queues the request in either the private work queue supplied with the
+ * wq argument or in the general work queue framework if wq is NULL.
+ * Once the request is completed or upon receiving an error, the callback
+ * function of cb is called, if not NULL, to inform the caller about the
+ * completion of its operation.
+ *
+ * Only if no work is pending, the pointers for the callback function
+ * or the output data can be changed.
+ *
+ * If a caller wants to cancel the work (e.g. in the module_exit function),
+ * simply call
+ *	get_blocking_random_bytes_cancel(&my_random_work);
+ *	cancel_work_sync(&my_random_work.rw_work);
+ *
+ * @wq pointer to private work queue or NULL - input
+ * @rw handle to the work queue frame - output
+ * @buf allocated buffer where random numbers are to be stored
+ * @nbytes size of buf and implicitly number of bytes requested
+ * @private pointer to data that is not processed by here, but handed to the
+ *	    callback function to allow the caller to maintain a state
+ * @cb callback function where
+ *	* buf holds the pointer to buf will be supplied
+ *	* buflen holds the length of the gathered random numbers or error code
+ *	  of the generation function.
+ *	* private provides a reference to the private data pointer
+ */
+void get_blocking_random_bytes_cb(struct workqueue_struct *wq,
+				  struct random_work *rw,
+				  u8 *buf, ssize_t nbytes, void *private,
+				  void (*cb)(void *buf, ssize_t buflen,
+					     void *private))
+{
+	BUG_ON(!cb);
+	if (!rw->rw_cb)
+		INIT_WORK(&rw->rw_work, get_blocking_random_bytes_work);
+	if (!work_pending(&rw->rw_work)) {
+		rw->rw_buf = buf;
+		rw->rw_len = nbytes;
+		rw->private = private;
+		rw->rw_cb = cb;
+		rw->cancel = false;
+	}
+	if (wq)
+		queue_work(wq, &rw->rw_work);
+	else
+		schedule_work(&rw->rw_work);
+}
+EXPORT_SYMBOL(get_blocking_random_bytes_cb);
diff --git a/include/linux/random.h b/include/linux/random.h
index b05856e..226e8b0 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -7,6 +7,7 @@
 #define _LINUX_RANDOM_H
 
 #include <uapi/linux/random.h>
+#include <linux/workqueue.h>
 
 extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
@@ -112,4 +113,23 @@ static inline u32 next_pseudo_random32(u32 seed)
 	return seed * 1664525 + 1013904223;
 }
 
+/* API for asynchronous in-kernel operation */
+struct random_work {
+	struct work_struct	rw_work;
+	u8			*rw_buf;
+	ssize_t			rw_len;
+	void			*private;
+	void			(*rw_cb)(void *buf, ssize_t buflen,
+					 void *private);
+	bool			cancel;
+};
+
+void get_blocking_random_bytes(void *buf, int nbytes, bool *cancel);
+void get_blocking_random_bytes_cancel(struct random_work *rw);
+void get_blocking_random_bytes_cb(struct workqueue_struct *wq,
+				  struct random_work *rw,
+				  u8 *buf, ssize_t nbytes, void *private,
+				  void (*cb)(void *buf, ssize_t buflen,
+					     void *private));
+
 #endif /* _LINUX_RANDOM_H */
-- 
2.1.0
