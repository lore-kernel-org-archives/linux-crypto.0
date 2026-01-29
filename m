Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3FC36683F
	for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 21:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769723452; cv=none; b=Y63NgkKwbu+URxBp0rp3pkIejwlGN2HA7hS3iNZtegXDneDziuwtY28hKPNk/e+rvHc4efJP3wQaPAa42w+pkVwPcBwYku0lHAoMKSWhNQuf2RUJ9/sUlHM2bfwu0Ccc+phV4ttUE02RI5Lv21pbnRsVobmSXopTxkZUJnsm5+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769723452; c=relaxed/simple;
	bh=ZmYulvijVpVN8u4fFLD119J4Lh4Pr/UOgKupgfDcl1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kHoMBSLT4mf73riKY+SMoXD1/FDakPlLFsB+RFp8ts/QlsLdHVeqUXjIfo807ikjpcOsRbt6kNYc4Fp9/VtOFzWwknOdEXVzV+CPMynv/66i1NRRlhIoSAMnbyjCSHyJ0ug/HodqV2GNeKfSOjQNwAre8E2xNXJjInjFg89lSoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XqasEmzc; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XqasEmzc"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-81df6a302b1so1418296b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 13:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769723446; x=1770328246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dVZ2yku2Ko/8tZ8Irc1VgCxoovL8Brno7qmr0cH0kl0=;
        b=XqasEmzc0XBj7oIaqQvePf5yZ7xLuRH+EjPs5FrRmwc7d/GqXvDP69ufAbd5JlhIWM
         wP067PZlREfSmgp2MP0NVN5laDipmYXHnvZy20hltCx4xucSPc4MI3r78Tp3iOhFlRMA
         5s+sc2OENp+ZXh5HIOSQJCNlzQxi1XAQYeZjGWzZgp6MF30zATYQO1cieKrxbKuDhl9H
         eHw70F7vuUgWDqrmdtdxxhiWMOmFKs9MCIdmHYvsc4bzAODtq1Y6EuzkKWgOZLe9vAd6
         M3xl2ltWesv0sTS07G1p/NVyu2tQWyDdB3J3fpjJCj8LvOVSitQchyywu0yIo1/D7Lf5
         juTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769723446; x=1770328246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dVZ2yku2Ko/8tZ8Irc1VgCxoovL8Brno7qmr0cH0kl0=;
        b=J9mETEglGfgMF3GMo+OrHNkLpjklW005agmsbFvty/F2Lkxi0fIp/dzhKmk8kBD0iQ
         MGvHfG/ZNVc8GJPXgB3E8457z2M07HFmPN7UjrMV44w0a3jdE1nCZFLFktZuwdXuvGpc
         wHmR96eJSVBTeRtAZVGJx4IgsliH0vJ+SleWDcM7+TgHZ1skDnjYgEj3xR5DHUWBDGq8
         UQEkod+o0EbRbpQ4md7pxXtHZRCB15gLefZV2SF9SPab7wxa1mRhVhYhEkrown0aNDlm
         pDfC6adwPVlowDa+7PNy5J0Y8dvnzWUbldCMlMdDW8jBnhLZYT0RcX2g88XTP5UB3ssn
         rltA==
X-Forwarded-Encrypted: i=1; AJvYcCUxpABvAlDsOpCTuQYycY6czQ1uvjD8+nSS348/xZv7HR34VzhCwbXQ5ZbmwNS+cKB+Zu4CtDkZL4kdSlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSX/ePolyrC9uE9/7lV83i9v0hpF9cN7qt5kabbyvmodMo/GEt
	DmwR/0xLR9VwpKY6jaEHIwxHsxQMnWO233982nsh9h9THs5dtr3+uDHx
X-Gm-Gg: AZuq6aIyNmcQl/jEkSpvXtX71+fnwX3uooS15WcH1FDOgaObRZ3cBLFbshFqZ4chHQa
	oCDyqQp4jVlSLPaR/DxxRrtJwHyLMJj57p2TAlRdIg2OvmxD4L6dnQ81WHAwYiOKqYzpY7H+l0m
	Kisojx7wXAGYEVi/J29NWhScj3dduxxy0PnJbkJASHe6TX3QPps4oXhFjFkDOGGg+OgkUYL/iIr
	TVcixk7iwkzfoIIXAgawhe9MPqo+mMem77zTQI8s+t9+MUVdJxeJYrDJBRbFVPXJ2FKWcXzLj1o
	cakEbLpKAoueI2GazjxiCk13ZBVJHSveyYr7YxJBoqK7zUdl7cxr/BaPYkshLMpbryERAiLtd9e
	Pq0g8Z5QxMswak8mekzVgJJUFbo5RnkQTP7VHFtP0NNlmrie9zgQNGkAZkm4jJ2YjwpWhXHr2tF
	OecnELLmq86gbU4Hw6orR2tQkavxtp3P+Jm2uAoMbNeV2yEmCdUQjGUl1Zhq1yXy/IHmADpYo/g
	83fX50LBRaHd5IFnnNJ
X-Received: by 2002:a05:6a21:32a3:b0:364:37d:cc63 with SMTP id adf61e73a8af0-392e0148311mr403708637.56.1769723446248;
        Thu, 29 Jan 2026 13:50:46 -0800 (PST)
Received: from kator.shina-lab.internal ([133.11.33.33])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c642afc045dsm5881498a12.35.2026.01.29.13.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:50:45 -0800 (PST)
From: Lianjie Wang <karin0.zst@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olivia Mackall <olivia@selenic.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianjie Wang <karin0.zst@gmail.com>
Subject: [PATCH v4] hwrng: core - use RCU and work_struct to fix race condition
Date: Fri, 30 Jan 2026 06:50:16 +0900
Message-ID: <20260129215016.3042874-1-karin0.zst@gmail.com>
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

Additionally, if hwrng_unregister() is called immediately after
hwrng_register(), the stopped thread may have never been executed. Thus,
hwrng_fill remains dirty even after hwrng_unregister() returns. In this
case, subsequent calls to hwrng_register() will fail to start new
threads, and hwrng_unregister() will call kthread_stop() on the same
freed task. In both cases, a use-after-free occurs:

refcount_t: addition on 0; use-after-free.
WARNING: ... at lib/refcount.c:25 refcount_warn_saturate+0xec/0x1c0
Call Trace:
 kthread_stop+0x181/0x360
 hwrng_unregister+0x288/0x380
 virtrng_remove+0xe3/0x200

This patch fixes the race by protecting the global hwrng_fill pointer
inside the rng_mutex lock, so that hwrng_fillfn() thread is stopped only
once, and calls to kthread_run() and kthread_stop() are serialized
with the lock held.

To avoid deadlock in hwrng_fillfn() while being stopped with the lock
held, we convert current_rng to RCU, so that get_current_rng() can read
current_rng without holding the lock. To remove the lock from put_rng(),
we also delay the actual cleanup into a work_struct.

Since get_current_rng() no longer returns ERR_PTR values, the IS_ERR()
checks are removed from its callers.

With hwrng_fill protected by the rng_mutex lock, hwrng_fillfn() can no
longer clear hwrng_fill itself. Therefore, if hwrng_fillfn() returns
directly after current_rng is dropped, kthread_stop() would be called on
a freed task_struct later. To fix this, hwrng_fillfn() calls schedule()
now to keep the task alive until being stopped. The kthread_stop() call
is also moved from hwrng_unregister() to drop_current_rng(), ensuring
kthread_stop() is called on all possible paths where current_rng becomes
NULL, so that the thread would not wait forever.

Fixes: be4000bc4644 ("hwrng: create filler thread")
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Lianjie Wang <karin0.zst@gmail.com>
---
v4:
 - Include linux/workqueue_types.h in hw_random.h, rather than
   linux/workqueue.h.
 - Include linux/workqueue.h in core.c.

v3: https://lore.kernel.org/linux-crypto/20260128221052.2141154-1-karin0.zst@gmail.com/
 - Add work_struct to delay the cleanup and protect it with rng_mutex
   again to avoid races with hwrng_init().
 - Change the waiting loop in hwrng_fillfn() to match the pattern in
   fs/ext4/mmp.c, and add comments for clarity.
 - Change kref_get_unless_zero() back to a plain kref_get() in
   get_current_rng().
 - Move the NULL check back to put_rng().

v2: https://lore.kernel.org/linux-crypto/20260124195555.851117-1-karin0.zst@gmail.com/
 - Convert the lock for get_current_rng() to RCU to break the deadlock, as
   suggested by Herbert Xu.
 - Remove rng_mutex from put_rng() and move NULL check to rng_current_show().
 - Move kthread_stop() to drop_current_rng() inside the lock to join the task
   on all paths, avoiding modifying hwrng_fill inside hwrng_fillfn().
 - Revert changes to rng_fillbuf.

v1: https://lore.kernel.org/linux-crypto/20251221122448.246531-1-karin0.zst@gmail.com/

 drivers/char/hw_random/core.c | 168 +++++++++++++++++++++-------------
 include/linux/hw_random.h     |   2 +
 2 files changed, 107 insertions(+), 63 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 96d7fe41b373..aba92d777f72 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -20,23 +20,25 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/workqueue.h>
 
 #define RNG_MODULE_NAME		"hw_random"
 
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
@@ -64,18 +66,39 @@ static size_t rng_buffer_size(void)
 	return RNG_BUFFER_SIZE;
 }
 
-static inline void cleanup_rng(struct kref *kref)
+static void cleanup_rng_work(struct work_struct *work)
 {
-	struct hwrng *rng = container_of(kref, struct hwrng, ref);
+	struct hwrng *rng = container_of(work, struct hwrng, cleanup_work);
+
+	/*
+	 * Hold rng_mutex here so we serialize in case they set_current_rng
+	 * on rng again immediately.
+	 */
+	mutex_lock(&rng_mutex);
+
+	/* Skip if rng has been reinitialized. */
+	if (kref_read(&rng->ref)) {
+		mutex_unlock(&rng_mutex);
+		return;
+	}
 
 	if (rng->cleanup)
 		rng->cleanup(rng);
 
 	complete(&rng->cleanup_done);
+	mutex_unlock(&rng_mutex);
+}
+
+static inline void cleanup_rng(struct kref *kref)
+{
+	struct hwrng *rng = container_of(kref, struct hwrng, ref);
+
+	schedule_work(&rng->cleanup_work);
 }
 
 static int set_current_rng(struct hwrng *rng)
 {
+	struct hwrng *old_rng;
 	int err;
 
 	BUG_ON(!mutex_is_locked(&rng_mutex));
@@ -84,8 +107,14 @@ static int set_current_rng(struct hwrng *rng)
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
@@ -101,47 +130,56 @@ static int set_current_rng(struct hwrng *rng)
 
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
+
+	rng = rcu_dereference_protected(current_rng,
+					lockdep_is_held(&rng_mutex));
+	if (rng)
+		kref_get(&rng->ref);
 
-	return current_rng;
+	return rng;
 }
 
 static struct hwrng *get_current_rng(void)
 {
 	struct hwrng *rng;
 
-	if (mutex_lock_interruptible(&rng_mutex))
-		return ERR_PTR(-ERESTARTSYS);
+	rcu_read_lock();
+	rng = rcu_dereference(current_rng);
+	if (rng)
+		kref_get(&rng->ref);
 
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
 	if (rng)
 		kref_put(&rng->ref, cleanup_rng);
-	mutex_unlock(&rng_mutex);
 }
 
 static int hwrng_init(struct hwrng *rng)
@@ -213,10 +251,6 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 
 	while (size) {
 		rng = get_current_rng();
-		if (IS_ERR(rng)) {
-			err = PTR_ERR(rng);
-			goto out;
-		}
 		if (!rng) {
 			err = -ENODEV;
 			goto out;
@@ -303,7 +337,7 @@ static struct miscdevice rng_miscdev = {
 
 static int enable_best_rng(void)
 {
-	struct hwrng *rng, *new_rng = NULL;
+	struct hwrng *rng, *cur_rng, *new_rng = NULL;
 	int ret = -ENODEV;
 
 	BUG_ON(!mutex_is_locked(&rng_mutex));
@@ -321,7 +355,9 @@ static int enable_best_rng(void)
 			new_rng = rng;
 	}
 
-	ret = ((new_rng == current_rng) ? 0 : set_current_rng(new_rng));
+	cur_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
+	ret = ((new_rng == cur_rng) ? 0 : set_current_rng(new_rng));
 	if (!ret)
 		cur_rng_set_by_user = 0;
 
@@ -371,8 +407,6 @@ static ssize_t rng_current_show(struct device *dev,
 	struct hwrng *rng;
 
 	rng = get_current_rng();
-	if (IS_ERR(rng))
-		return PTR_ERR(rng);
 
 	ret = sysfs_emit(buf, "%s\n", rng ? rng->name : "none");
 	put_rng(rng);
@@ -416,8 +450,6 @@ static ssize_t rng_quality_show(struct device *dev,
 	struct hwrng *rng;
 
 	rng = get_current_rng();
-	if (IS_ERR(rng))
-		return PTR_ERR(rng);
 
 	if (!rng) /* no need to put_rng */
 		return -ENODEV;
@@ -432,6 +464,7 @@ static ssize_t rng_quality_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t len)
 {
+	struct hwrng *rng;
 	u16 quality;
 	int ret = -EINVAL;
 
@@ -448,12 +481,13 @@ static ssize_t rng_quality_store(struct device *dev,
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
@@ -489,8 +523,20 @@ static int hwrng_fillfn(void *unused)
 		struct hwrng *rng;
 
 		rng = get_current_rng();
-		if (IS_ERR(rng) || !rng)
+		if (!rng) {
+			/*
+			 * Keep the task_struct alive until kthread_stop()
+			 * is called to avoid UAF in drop_current_rng().
+			 */
+			while (!kthread_should_stop()) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				if (!kthread_should_stop())
+					schedule();
+			}
+			set_current_state(TASK_RUNNING);
 			break;
+		}
+
 		mutex_lock(&reading_mutex);
 		rc = rng_get_data(rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
@@ -518,14 +564,13 @@ static int hwrng_fillfn(void *unused)
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
@@ -540,6 +585,7 @@ int hwrng_register(struct hwrng *rng)
 	}
 	list_add_tail(&rng->list, &rng_list);
 
+	INIT_WORK(&rng->cleanup_work, cleanup_rng_work);
 	init_completion(&rng->cleanup_done);
 	complete(&rng->cleanup_done);
 	init_completion(&rng->dying);
@@ -547,16 +593,19 @@ int hwrng_register(struct hwrng *rng)
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
@@ -569,14 +618,17 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 
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
@@ -584,17 +636,7 @@ void hwrng_unregister(struct hwrng *rng)
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
@@ -682,7 +724,7 @@ static int __init hwrng_modinit(void)
 static void __exit hwrng_modexit(void)
 {
 	mutex_lock(&rng_mutex);
-	BUG_ON(current_rng);
+	WARN_ON(rcu_access_pointer(current_rng));
 	kfree(rng_buffer);
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index b424555753b1..b77bc55a4cf3 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -15,6 +15,7 @@
 #include <linux/completion.h>
 #include <linux/kref.h>
 #include <linux/types.h>
+#include <linux/workqueue_types.h>
 
 /**
  * struct hwrng - Hardware Random Number Generator driver
@@ -48,6 +49,7 @@ struct hwrng {
 	/* internal. */
 	struct list_head list;
 	struct kref ref;
+	struct work_struct cleanup_work;
 	struct completion cleanup_done;
 	struct completion dying;
 };
-- 
2.52.0

