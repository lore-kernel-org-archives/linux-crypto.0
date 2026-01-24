Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9784C16132A
	for <linux-crypto@vger.kernel.org>; Sat, 24 Jan 2026 19:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769284613; cv=none; b=f+SiU4RR2wVheK+/ijQjYLZVkZgWdDohHPXDGt8XOUs4ciSZ/S4q3TlNTw3tVcMrPyp8BIYI3JUVxIU3mFsPw0bH8EzHetF7MhNgD16z3+27SAXveKb9JKho3b8eLClOSGoI+8oVDsgTV6mnNTka/RP9qI1kqMfOTkvKdUnRDxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769284613; c=relaxed/simple;
	bh=8ve1WF0HhpDOedhL9kYlTyH8zgjjXnWG4GIZuhFTyo4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m55Ca7w+GBa6FE1ukgLN7MpKUHpWwmOZri3mct6eB8PjAkH0gkPhljImb2uFPdGc41fG/B1orWuMp5o5MoIocAdLVdOnAne+VeQX7hUSfEm9JM00CTr3vc0s1LW/OQAHvIfO4cbhu/iMFKnx0MKBKrsUndO+717qS1I1FaGwRhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f28TWNGc; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f28TWNGc"
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-352c414bbbeso2979796a91.0
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jan 2026 11:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769284611; x=1769889411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GewPFQw0ynxEmDvTY1rOHAb5GhYXrLX6atZVH5viOR8=;
        b=f28TWNGclj3OniPy6D4Zod3ucJfdU/t3/GliImGFt7fLnAsz6Ivu5tHflyKRF217Pa
         jDFod9Teo1Ur4gg3Dfzp+2J3xqfY14Lz79FbSs19jq406LsG2qF+8OtlAAYHRT+2xVWH
         HnHm72Fa72JU9JwVCT4zhqA8cP7xsYE22wVmr9LJ0ixzsPOBz/r+Uuzhk2c9undb8Tp1
         So1Yo87j1xeM5jer+UD2BQqhVoM0k39okbm+1QCrdq1dfH0Q4UPPdbzXEeBiyrByc4bS
         nRK5LFG7FKsZjxgo95f2hs6TpU0abL864SzKxmHCfNu+KZ16TZnAH9J6eE7DhnJssSKB
         0OvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769284611; x=1769889411;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GewPFQw0ynxEmDvTY1rOHAb5GhYXrLX6atZVH5viOR8=;
        b=okDaOVM9wWR73jnixJ8jL9upWqw2YORGr9OW9n0TodeIzsO90KfLI+3CzuDDAZ9RyD
         W8OckJp/g/PuJPNbA/7IN72MPAuqRAFbkqMobsB4rwpVCjCP4w+TUSoR4oiHubtb6F5I
         XjzsY1L8MKgNAm+uvKi3YnIp6T5VAbQYJJh6wqpZyyKKhR9F/gRhhLKc/MykeT/5KwVf
         /ATsyc74jPdyS/9djhF1oMBnCqBs11lbwPCjKjAGAvBWclJ/ipPViDEQBhKncBxNRsiV
         RfnlR1cbkjmNvbiWP1E0fu6Eeas9CX3idiuAk0zkqNAUvgIuIBT4+yQL53eN6VcFQEk0
         SGZw==
X-Forwarded-Encrypted: i=1; AJvYcCUjBVfk78Rra8yFGnMyZKJVuOARl0rlPhUBXf6hAUhQJ2BzgG7agbQYPpcpG7qrVGCEbVhpZXs1MDpHx3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEX+E/f+Ycgq0+lO6Ckp8Cix4YZvAKZthLKIuR72f5vqTuwhb5
	Jjb6OePIGVYE9cdLP5WSWhfYQhYh9Kc5Imzzox/f+qrRGKMhlgDx6CUYOyUCiMbA
X-Gm-Gg: AZuq6aKR8CD1HxQaIhcV2UE++ivGhW0KwTp8/AVKIY1yKN9sQjSHiPOWYChZONMdf8Q
	Wupw6NIiLfADXz/vMVAgrG0hdSu4Kx2hHvIXlG6TPkFXDnkMq6BXGvqeyFjtJzOrnU1vTOYAhAH
	9C5fUFC14NGc9Agj0r5soSkeQjQLElDOwijys/pKAKVhK1LxYCOPoKCgoUmzBXZyvvH2zcJ8dxj
	CSybutPrzFJdjCjXMWLSD3LrYwBiMT4pbFp8j9tL4DKfxAi9s8kNDc2WuBp5w5Kgbe7W6NxJOEX
	4RcbdZwWrR7K+170Tc02BcfDHIujwy11qfvfmT7LGEtGYNyHEITU4OFaX7zLhMtyn+qUs9OMJo9
	wcnCF0vs0rh4eFBEE+d2WXQPmBiyj7YVuCA/FSIEbbcxtgJuo3eGh6W6DXc0CosftOi31fA1dVn
	fisZey9Cqj9ohrU5Uh+sNeMJIuz6MuHC1Qeq2fjEyTJtwJV+Sbp3xXbG6dnpa30PZsB3dPP7C8V
	8UiiedEiw==
X-Received: by 2002:a17:90b:4b51:b0:34e:6e7d:7e73 with SMTP id 98e67ed59e1d1-3533560eeadmr9062159a91.11.1769284610867;
        Sat, 24 Jan 2026 11:56:50 -0800 (PST)
Received: from kator.shina-lab.internal ([133.11.33.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3536f112f22sm2349359a91.5.2026.01.24.11.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 11:56:50 -0800 (PST)
From: Lianjie Wang <karin0.zst@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olivia Mackall <olivia@selenic.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianjie Wang <karin0.zst@gmail.com>
Subject: [PATCH v2] hwrng: core - use RCU for current_rng to fix race condition
Date: Sun, 25 Jan 2026 04:55:55 +0900
Message-ID: <20260124195555.851117-1-karin0.zst@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, hwrng_fill is not cleared until the hwrng_fillfn() thread
exits. Since hwrng_unregister() reads hwrng_fill outside the rng_mutex
lock, a concurrent hwrng_unregister() may call kthread_stop() again on
the same task.

Additionally, if the hwrng_unregister() call happens immediately after a
hwrng_register() before, the stopped thread may have never been running,
and thus hwrng_fill remains dirty even after the hwrng_unregister() call
returns. In this case, further calls to hwrng_register() may not start
new threads, and hwrng_unregister() will also call kthread_stop() on the
same task, causing use-after-free and sometimes lockups:

refcount_t: addition on 0; use-after-free.
WARNING: ... at lib/refcount.c:25 refcount_warn_saturate+0xec/0x1c0
Call Trace:
 kthread_stop+0x181/0x360
 hwrng_unregister+0x288/0x380
 virtrng_remove+0xe3/0x200

This patch fixes the race by protecting the global hwrng_fill pointer
inside the rng_mutex lock, so that hwrng_fillfn() thread is stopped only
once, and calls to kthread_create() and kthread_stop() are serialized
with the lock held.

To avoid deadlock in hwrng_fillfn() while being stopped,
get_current_rng() and put_rng() no longer hold the rng_mutex lock now.
Instead, we convert current_rng to RCU.

With hwrng_fill protected by the rng_mutex lock, hwrng_fillfn() can no
longer clear hwrng_fill itself. Therefore, the kthread_stop() call is
moved from hwrng_unregister() to drop_current_rng(), where the lock is
already held. This ensures the task is joined via kthread_stop() on all
possible paths (whether kthread_should_stop() is set, or
get_current_rng() starts returning NULL).

Since get_current_rng() no longer returns ERR_PTR values, the IS_ERR()
checks are removed from its callers. The NULL check is also moved from
put_rng() to its caller rng_current_show(), since all the other callers
of put_rng() already check for NULL.

Fixes: be4000bc4644 ("hwrng: create filler thread")
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Lianjie Wang <karin0.zst@gmail.com>
---
v2:
 - Convert the lock for get_current_rng() to RCU to break the deadlock, as
   suggested by Herbert Xu.
 - Remove rng_mutex from put_rng() and move NULL check to rng_current_show().
 - Move kthread_stop() to drop_current_rng() inside the lock to join the task
   on all paths, avoiding modifying hwrng_fill inside hwrng_fillfn().
 - Revert changes to rng_fillbuf.

v1: https://lore.kernel.org/linux-crypto/20251221122448.246531-1-karin0.zst@gmail.com/

 drivers/char/hw_random/core.c | 145 +++++++++++++++++++---------------
 1 file changed, 81 insertions(+), 64 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 96d7fe41b373..749678589d9a 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -20,6 +20,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
@@ -30,13 +31,13 @@

 #define RNG_BUFFER_SIZE (SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES)

-static struct hwrng *current_rng;
+static struct hwrng __rcu *current_rng;
 /* the current rng has been explicitly chosen by user via sysfs */
 static int cur_rng_set_by_user;
 static struct task_struct *hwrng_fill;
 /* list of registered rngs */
 static LIST_HEAD(rng_list);
-/* Protects rng_list and current_rng */
+/* Protects rng_list, hwrng_fill and updating on current_rng */
 static DEFINE_MUTEX(rng_mutex);
 /* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
 static DEFINE_MUTEX(reading_mutex);
@@ -76,6 +77,7 @@ static inline void cleanup_rng(struct kref *kref)

 static int set_current_rng(struct hwrng *rng)
 {
+	struct hwrng *old_rng;
 	int err;

 	BUG_ON(!mutex_is_locked(&rng_mutex));
@@ -84,8 +86,14 @@ static int set_current_rng(struct hwrng *rng)
 	if (err)
 		return err;

-	drop_current_rng();
-	current_rng = rng;
+	old_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
+	rcu_assign_pointer(current_rng, rng);
+
+	if (old_rng) {
+		synchronize_rcu();
+		kref_put(&old_rng->ref, cleanup_rng);
+	}

 	/* if necessary, start hwrng thread */
 	if (!hwrng_fill) {
@@ -101,47 +109,55 @@ static int set_current_rng(struct hwrng *rng)

 static void drop_current_rng(void)
 {
-	BUG_ON(!mutex_is_locked(&rng_mutex));
-	if (!current_rng)
+	struct hwrng *rng;
+
+	rng = rcu_dereference_protected(current_rng,
+					lockdep_is_held(&rng_mutex));
+	if (!rng)
 		return;

+	RCU_INIT_POINTER(current_rng, NULL);
+	synchronize_rcu();
+
+	if (hwrng_fill) {
+		kthread_stop(hwrng_fill);
+		hwrng_fill = NULL;
+	}
+
 	/* decrease last reference for triggering the cleanup */
-	kref_put(&current_rng->ref, cleanup_rng);
-	current_rng = NULL;
+	kref_put(&rng->ref, cleanup_rng);
 }

-/* Returns ERR_PTR(), NULL or refcounted hwrng */
+/* Returns NULL or refcounted hwrng */
 static struct hwrng *get_current_rng_nolock(void)
 {
-	if (current_rng)
-		kref_get(&current_rng->ref);
+	struct hwrng *rng;

-	return current_rng;
+	rng = rcu_dereference_protected(current_rng,
+					lockdep_is_held(&rng_mutex));
+	if (rng)
+		kref_get(&rng->ref);
+
+	return rng;
 }

 static struct hwrng *get_current_rng(void)
 {
 	struct hwrng *rng;

-	if (mutex_lock_interruptible(&rng_mutex))
-		return ERR_PTR(-ERESTARTSYS);
+	rcu_read_lock();
+	rng = rcu_dereference(current_rng);
+	if (rng && !kref_get_unless_zero(&rng->ref))
+		rng = NULL;

-	rng = get_current_rng_nolock();
+	rcu_read_unlock();

-	mutex_unlock(&rng_mutex);
 	return rng;
 }

 static void put_rng(struct hwrng *rng)
 {
-	/*
-	 * Hold rng_mutex here so we serialize in case they set_current_rng
-	 * on rng again immediately.
-	 */
-	mutex_lock(&rng_mutex);
-	if (rng)
-		kref_put(&rng->ref, cleanup_rng);
-	mutex_unlock(&rng_mutex);
+	kref_put(&rng->ref, cleanup_rng);
 }

 static int hwrng_init(struct hwrng *rng)
@@ -213,10 +229,6 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,

 	while (size) {
 		rng = get_current_rng();
-		if (IS_ERR(rng)) {
-			err = PTR_ERR(rng);
-			goto out;
-		}
 		if (!rng) {
 			err = -ENODEV;
 			goto out;
@@ -303,7 +315,7 @@ static struct miscdevice rng_miscdev = {

 static int enable_best_rng(void)
 {
-	struct hwrng *rng, *new_rng = NULL;
+	struct hwrng *rng, *cur_rng, *new_rng = NULL;
 	int ret = -ENODEV;

 	BUG_ON(!mutex_is_locked(&rng_mutex));
@@ -321,7 +333,9 @@ static int enable_best_rng(void)
 			new_rng = rng;
 	}

-	ret = ((new_rng == current_rng) ? 0 : set_current_rng(new_rng));
+	cur_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
+	ret = ((new_rng == cur_rng) ? 0 : set_current_rng(new_rng));
 	if (!ret)
 		cur_rng_set_by_user = 0;

@@ -371,11 +385,10 @@ static ssize_t rng_current_show(struct device *dev,
 	struct hwrng *rng;

 	rng = get_current_rng();
-	if (IS_ERR(rng))
-		return PTR_ERR(rng);

 	ret = sysfs_emit(buf, "%s\n", rng ? rng->name : "none");
-	put_rng(rng);
+	if (rng)
+		put_rng(rng);

 	return ret;
 }
@@ -416,8 +429,6 @@ static ssize_t rng_quality_show(struct device *dev,
 	struct hwrng *rng;

 	rng = get_current_rng();
-	if (IS_ERR(rng))
-		return PTR_ERR(rng);

 	if (!rng) /* no need to put_rng */
 		return -ENODEV;
@@ -432,6 +443,7 @@ static ssize_t rng_quality_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t len)
 {
+	struct hwrng *rng;
 	u16 quality;
 	int ret = -EINVAL;

@@ -448,12 +460,13 @@ static ssize_t rng_quality_store(struct device *dev,
 		goto out;
 	}

-	if (!current_rng) {
+	rng = rcu_dereference_protected(current_rng, lockdep_is_held(&rng_mutex));
+	if (!rng) {
 		ret = -ENODEV;
 		goto out;
 	}

-	current_rng->quality = quality;
+	rng->quality = quality;
 	current_quality = quality; /* obsolete */

 	/* the best available RNG may have changed */
@@ -489,8 +502,17 @@ static int hwrng_fillfn(void *unused)
 		struct hwrng *rng;

 		rng = get_current_rng();
-		if (IS_ERR(rng) || !rng)
+		if (!rng) {
+			/* This is only possible within drop_current_rng(),
+			 * so just wait until we are stopped.
+			 */
+			while (!kthread_should_stop()) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				schedule();
+			}
 			break;
+		}
+
 		mutex_lock(&reading_mutex);
 		rc = rng_get_data(rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
@@ -518,14 +540,13 @@ static int hwrng_fillfn(void *unused)
 		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
 					   entropy >> 10, true);
 	}
-	hwrng_fill = NULL;
 	return 0;
 }

 int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
-	struct hwrng *tmp;
+	struct hwrng *cur_rng, *tmp;

 	if (!rng->name || (!rng->data_read && !rng->read))
 		goto out;
@@ -547,16 +568,19 @@ int hwrng_register(struct hwrng *rng)
 	/* Adjust quality field to always have a proper value */
 	rng->quality = min3(default_quality, 1024, rng->quality ?: 1024);

-	if (!cur_rng_set_by_user &&
-	    (!current_rng || rng->quality > current_rng->quality)) {
-		/*
-		 * Set new rng as current as the new rng source
-		 * provides better entropy quality and was not
-		 * chosen by userspace.
-		 */
-		err = set_current_rng(rng);
-		if (err)
-			goto out_unlock;
+	if (!cur_rng_set_by_user) {
+		cur_rng = rcu_dereference_protected(current_rng,
+						    lockdep_is_held(&rng_mutex));
+		if (!cur_rng || rng->quality > cur_rng->quality) {
+			/*
+			 * Set new rng as current as the new rng source
+			 * provides better entropy quality and was not
+			 * chosen by userspace.
+			 */
+			err = set_current_rng(rng);
+			if (err)
+				goto out_unlock;
+		}
 	}
 	mutex_unlock(&rng_mutex);
 	return 0;
@@ -569,14 +593,17 @@ EXPORT_SYMBOL_GPL(hwrng_register);

 void hwrng_unregister(struct hwrng *rng)
 {
-	struct hwrng *new_rng;
+	struct hwrng *cur_rng;
 	int err;

 	mutex_lock(&rng_mutex);

 	list_del(&rng->list);
 	complete_all(&rng->dying);
-	if (current_rng == rng) {
+
+	cur_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
+	if (cur_rng == rng) {
 		err = enable_best_rng();
 		if (err) {
 			drop_current_rng();
@@ -584,17 +611,7 @@ void hwrng_unregister(struct hwrng *rng)
 		}
 	}

-	new_rng = get_current_rng_nolock();
-	if (list_empty(&rng_list)) {
-		mutex_unlock(&rng_mutex);
-		if (hwrng_fill)
-			kthread_stop(hwrng_fill);
-	} else
-		mutex_unlock(&rng_mutex);
-
-	if (new_rng)
-		put_rng(new_rng);
-
+	mutex_unlock(&rng_mutex);
 	wait_for_completion(&rng->cleanup_done);
 }
 EXPORT_SYMBOL_GPL(hwrng_unregister);
@@ -682,7 +699,7 @@ static int __init hwrng_modinit(void)
 static void __exit hwrng_modexit(void)
 {
 	mutex_lock(&rng_mutex);
-	BUG_ON(current_rng);
+	WARN_ON(rcu_access_pointer(current_rng));
 	kfree(rng_buffer);
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
--
2.52.0
