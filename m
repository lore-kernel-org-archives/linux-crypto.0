Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD19031C57B
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 22:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769638265; cv=none; b=lCzH/GWRCjJVgUiu8HfqPxdszJCRd/9EazWkOGHKtY/fAFxKH6cE/uJZX/jIdsauqpABMk68jdt0XvtaHgEBpGHMUaD2VpHjdAz0HPKn91LmgL2P02S5gVULPG63KmP33KPoi4GdsQmJA2T4UE6gwKmJJxiy5fqX2fO4CI3UWSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769638265; c=relaxed/simple;
	bh=Hvu2zOltdFd5+paePnjm3qeAHpuA6oXjxdbTfLX3/G0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LV2M9yAYwymTea9hFC99HJ/7PB8wenuqstzfwG2IXjdVJcN/+vhKpgDgve80gji7NizpopsIBNN+vvPqJVH1xwAFB6fV/zzwTr06AkaGwfIEtd1qPypXbxC3DA81hO46W+Li0lt/YhwpaXTqy6vRLs6amNBDXT7/OS/+ZX5iZkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CUv9C5qL; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CUv9C5qL"
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a7a94c6d4fso1347195ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 14:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769638263; x=1770243063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DqY9UiMBv6wGikpAOmqkzeZyxh/eeRZipUUvQ4beoUQ=;
        b=CUv9C5qLAVwA9R7dykpkqXqiDih6MVFMjihHTf7zJ5zN6wQl7nBthnhkDwKDwhC/VH
         1h7Ej+eOXC8uE/P/Cjy335nAaeUMDzJw/5h5vp2vK2cJaLz9jKviqfiObO7NbHX7A5j6
         kMcuV7OiaLWRpa0FRdlcQ6j0UsulsGOkl4FOno7Xr4a65NdYfT8Yv1CHq8/nrkzAjk34
         taBNexRWbfELyWiz5tunDkD224YvfLIMo/q4Y06a8p2xyBrC+n7/i5niHWGBdTZupoMy
         10MW/GPbhMQdrbHZDWmaxeW8rEsrUXPUiG4SkrHqNbDd8SCSQ+Kt5ATJ5x5N5eeNWhvP
         zAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769638263; x=1770243063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqY9UiMBv6wGikpAOmqkzeZyxh/eeRZipUUvQ4beoUQ=;
        b=Psc4jymzL6ZowaJDUpEWixHayxSMdPhYnbphdWLG3RBtU5NiVa9zjyd5E92Sc01ZTo
         AnMAsAFfPJDKD+9sSnn92L8r6SZInbCe90VOsmAmNcHhSkrOno1z6r2C1sNeDG6Lm4bf
         JGaGYsRxoIQZ+vW4als4/fzgwsZ3h4C/B5IA1cATPWi5pfG8Y8qL+q9JxKxic4Jldof/
         gE5fFCfv83/cvO9hALD/serfpl5+Mhvnv1ns022IP8LG7NccIgW1W8be2hkpCGRla4F5
         ZrhlP0Po6gJcZADyYT5SB8vFZvFy+vqSRw+V2jr/z1lBXzWoXpm9QQVyGbN7esJUt/Ea
         HOfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdDgvi+SUtdN8agYrqRxlETbe1rUMq2+fY10Ia7vkQIeTJBdgVcj6znUNvz2taupkOc3vqrGC/f1WBnbs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgAWjmRtzGpUTDxf6XZFtXUyoAMl3LOKeCxY7x0y74SxCN/WR8
	uD0DBucmraRYP5atoS39jw6PzCzMaarBtCrEkMp8KFwQEJsu+Rkys8O8
X-Gm-Gg: AZuq6aLn8f+IGm8pUlD102DYSyOtKAlSEpup2ja3ZZWYKGuMgU/kxr1eU2cJDNDfYlP
	pu94iRuy+3NSclsWQl5qaJA+jeLXySGz7JpY51Cw3z2GeXb4ue0q1Gy2dUjXNKid0r6KiH0V0b1
	U8EmAUPGgfTaXPIjr9AieD8Dbc5ds90hzUORzugXG6ZXk+ixbnsALx23+2nzYA4kFMaTAAnzRoA
	FNOokdjWyOViPIovNw15N+VutCl+c7j7DWb8LvJa+1lCLrEvu8dJuKqlMS8FGlpUp+P8/ROZK0B
	lzc+jqEfGzaZYeY67MfO5uD0BS35Z3c7NfSx9YBqXkby36dFRmuOjv9PtsaLAOFPcxHmMdwdG/c
	LflRLaRRith8jzoPtA/nuVPglWBBn2gePFbWqqsA/Mh/Kaa6jMmdEbnjfObpsKNhWw+fUwrUPGD
	26nQgpdRmI8lbwMZ50qgMCd2XPQZN9KgwikZCsCAd+wLxtPcUs6CUByF77vHLdF2qXXyg6JySLa
	Yfs7zlIAA==
X-Received: by 2002:a17:903:1ac6:b0:2a0:c58c:fdd2 with SMTP id d9443c01a7336-2a870d9efdbmr70783975ad.26.1769638262900;
        Wed, 28 Jan 2026 14:11:02 -0800 (PST)
Received: from kator.shina-lab.internal ([133.11.33.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379bfd797sm3490546b3a.43.2026.01.28.14.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 14:11:02 -0800 (PST)
From: Lianjie Wang <karin0.zst@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olivia Mackall <olivia@selenic.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianjie Wang <karin0.zst@gmail.com>
Subject: [PATCH v3] hwrng: core - use RCU and work_struct to fix race condition
Date: Thu, 29 Jan 2026 07:10:52 +0900
Message-ID: <20260128221052.2141154-1-karin0.zst@gmail.com>
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
v3:
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

 drivers/char/hw_random/core.c | 167 +++++++++++++++++++++-------------
 include/linux/hw_random.h     |   2 +
 2 files changed, 106 insertions(+), 63 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 96d7fe41b373..01660854d95e 100644
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
@@ -64,18 +65,39 @@ static size_t rng_buffer_size(void)
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
@@ -84,8 +106,14 @@ static int set_current_rng(struct hwrng *rng)
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
@@ -101,47 +129,56 @@ static int set_current_rng(struct hwrng *rng)
 
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
@@ -213,10 +250,6 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 
 	while (size) {
 		rng = get_current_rng();
-		if (IS_ERR(rng)) {
-			err = PTR_ERR(rng);
-			goto out;
-		}
 		if (!rng) {
 			err = -ENODEV;
 			goto out;
@@ -303,7 +336,7 @@ static struct miscdevice rng_miscdev = {
 
 static int enable_best_rng(void)
 {
-	struct hwrng *rng, *new_rng = NULL;
+	struct hwrng *rng, *cur_rng, *new_rng = NULL;
 	int ret = -ENODEV;
 
 	BUG_ON(!mutex_is_locked(&rng_mutex));
@@ -321,7 +354,9 @@ static int enable_best_rng(void)
 			new_rng = rng;
 	}
 
-	ret = ((new_rng == current_rng) ? 0 : set_current_rng(new_rng));
+	cur_rng = rcu_dereference_protected(current_rng,
+					    lockdep_is_held(&rng_mutex));
+	ret = ((new_rng == cur_rng) ? 0 : set_current_rng(new_rng));
 	if (!ret)
 		cur_rng_set_by_user = 0;
 
@@ -371,8 +406,6 @@ static ssize_t rng_current_show(struct device *dev,
 	struct hwrng *rng;
 
 	rng = get_current_rng();
-	if (IS_ERR(rng))
-		return PTR_ERR(rng);
 
 	ret = sysfs_emit(buf, "%s\n", rng ? rng->name : "none");
 	put_rng(rng);
@@ -416,8 +449,6 @@ static ssize_t rng_quality_show(struct device *dev,
 	struct hwrng *rng;
 
 	rng = get_current_rng();
-	if (IS_ERR(rng))
-		return PTR_ERR(rng);
 
 	if (!rng) /* no need to put_rng */
 		return -ENODEV;
@@ -432,6 +463,7 @@ static ssize_t rng_quality_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t len)
 {
+	struct hwrng *rng;
 	u16 quality;
 	int ret = -EINVAL;
 
@@ -448,12 +480,13 @@ static ssize_t rng_quality_store(struct device *dev,
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
@@ -489,8 +522,20 @@ static int hwrng_fillfn(void *unused)
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
@@ -518,14 +563,13 @@ static int hwrng_fillfn(void *unused)
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
@@ -540,6 +584,7 @@ int hwrng_register(struct hwrng *rng)
 	}
 	list_add_tail(&rng->list, &rng_list);
 
+	INIT_WORK(&rng->cleanup_work, cleanup_rng_work);
 	init_completion(&rng->cleanup_done);
 	complete(&rng->cleanup_done);
 	init_completion(&rng->dying);
@@ -547,16 +592,19 @@ int hwrng_register(struct hwrng *rng)
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
@@ -569,14 +617,17 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 
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
@@ -584,17 +635,7 @@ void hwrng_unregister(struct hwrng *rng)
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
@@ -682,7 +723,7 @@ static int __init hwrng_modinit(void)
 static void __exit hwrng_modexit(void)
 {
 	mutex_lock(&rng_mutex);
-	BUG_ON(current_rng);
+	WARN_ON(rcu_access_pointer(current_rng));
 	kfree(rng_buffer);
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index b424555753b1..2ccfd081a94a 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -15,6 +15,7 @@
 #include <linux/completion.h>
 #include <linux/kref.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 
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
