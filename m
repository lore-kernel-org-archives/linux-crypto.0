From: Keith Packard <keithp@keithp.com>
Subject: [PATCH] hwrng: core - Allow for multiple simultaneous active hwrng devices
Date: Mon, 25 Jul 2016 13:07:35 -0700
Message-ID: <1469477255-26824-1-git-send-email-keithp@keithp.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Keith Packard <keithp@keithp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:52350 "EHLO elaine.keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbcGYUOU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jul 2016 16:14:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Instead of having only one hwrng feeding /dev/random at a time, maintain
a list of devices and cycle between them when filling the entropy pool.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/char/hw_random/core.c | 155 +++++++++++++++++++++++++++---------------
 include/linux/hw_random.h     |   2 +
 2 files changed, 104 insertions(+), 53 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 9203f2d..97fd4a7 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -51,10 +51,10 @@
 #define RNG_MISCDEV_MINOR	183 /* official */
 
 
-static struct hwrng *current_rng;
+static LIST_HEAD(active_rng);
 static struct task_struct *hwrng_fill;
 static LIST_HEAD(rng_list);
-/* Protects rng_list and current_rng */
+/* Protects rng_list and active_rng */
 static DEFINE_MUTEX(rng_mutex);
 /* Protects rng read functions, data_avail, rng_buffer and rng_fillbuf */
 static DEFINE_MUTEX(reading_mutex);
@@ -70,7 +70,6 @@ module_param(default_quality, ushort, 0644);
 MODULE_PARM_DESC(default_quality,
 		 "default entropy content of hwrng per mill");
 
-static void drop_current_rng(void);
 static int hwrng_init(struct hwrng *rng);
 static void start_khwrngd(void);
 
@@ -104,31 +103,65 @@ static inline void cleanup_rng(struct kref *kref)
 	complete(&rng->cleanup_done);
 }
 
-static int set_current_rng(struct hwrng *rng)
+static unsigned short rng_quality(struct hwrng *rng)
+{
+	unsigned short quality;
+
+	quality = current_quality;
+	if (!quality) {
+		quality = rng->quality;
+		if (!quality)
+			quality = default_quality;
+	}
+	if (quality > 1024)
+		quality = 1024;
+	return quality;
+}
+
+static int add_active_rng(struct hwrng *rng)
 {
 	int err;
 
 	BUG_ON(!mutex_is_locked(&rng_mutex));
 
+	if (rng->is_active)
+		return 0;
+
 	err = hwrng_init(rng);
 	if (err)
 		return err;
 
-	drop_current_rng();
-	current_rng = rng;
+	if (rng_quality(rng) != 0) {
+		rng->is_active = true;
+		list_add(&rng->active, &active_rng);
+		if (!hwrng_fill)
+			start_khwrngd();
+	}
 
 	return 0;
 }
 
-static void drop_current_rng(void)
+static int drop_active_rng(struct hwrng *rng)
 {
 	BUG_ON(!mutex_is_locked(&rng_mutex));
-	if (!current_rng)
-		return;
+	if (!rng->is_active)
+		return 0;
+
+	list_del(&rng->active);
+	rng->is_active = false;
 
 	/* decrease last reference for triggering the cleanup */
-	kref_put(&current_rng->ref, cleanup_rng);
-	current_rng = NULL;
+	kref_put(&rng->ref, cleanup_rng);
+
+	if (list_empty(&active_rng) && hwrng_fill)
+		kthread_stop(hwrng_fill);
+
+	return 0;
+}
+
+static struct hwrng *first_active_rng(void)
+{
+	return list_first_entry_or_null(&active_rng, struct hwrng, active);
 }
 
 /* Returns ERR_PTR(), NULL or refcounted hwrng */
@@ -139,18 +172,32 @@ static struct hwrng *get_current_rng(void)
 	if (mutex_lock_interruptible(&rng_mutex))
 		return ERR_PTR(-ERESTARTSYS);
 
-	rng = current_rng;
+	rng = first_active_rng();
 	if (rng)
 		kref_get(&rng->ref);
 
 	mutex_unlock(&rng_mutex);
+
 	return rng;
 }
 
+static int next_rng(void)
+{
+	if (mutex_lock_interruptible(&rng_mutex))
+		return -ERESTARTSYS;
+
+	if (!list_empty(&active_rng) && !list_is_singular(&active_rng))
+		list_rotate_left(&active_rng);
+
+	mutex_unlock(&rng_mutex);
+
+	return 0;
+}
+
 static void put_rng(struct hwrng *rng)
 {
 	/*
-	 * Hold rng_mutex here so we serialize in case they set_current_rng
+	 * Hold rng_mutex here so we serialize in case they add_active_rng
 	 * on rng again immediately.
 	 */
 	mutex_lock(&rng_mutex);
@@ -178,15 +225,6 @@ static int hwrng_init(struct hwrng *rng)
 skip_init:
 	add_early_randomness(rng);
 
-	current_quality = rng->quality ? : default_quality;
-	if (current_quality > 1024)
-		current_quality = 1024;
-
-	if (current_quality == 0 && hwrng_fill)
-		kthread_stop(hwrng_fill);
-	if (current_quality > 0 && !hwrng_fill)
-		start_khwrngd();
-
 	return 0;
 }
 
@@ -246,6 +284,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			bytes_read = rng_get_data(rng, rng_buffer,
 				rng_buffer_size(),
 				!(filp->f_flags & O_NONBLOCK));
+			next_rng();
 			if (bytes_read < 0) {
 				err = bytes_read;
 				goto out_unlock_reading;
@@ -320,20 +359,30 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 					const char *buf, size_t len)
 {
 	int err;
+	int add = 1;
 	struct hwrng *rng;
 
 	err = mutex_lock_interruptible(&rng_mutex);
 	if (err)
 		return -ERESTARTSYS;
+	if (*buf == '-') {
+		add = 0;
+		buf++;
+	} else if (*buf == '+') {
+		add = 1;
+		buf++;
+	}
 	err = -ENODEV;
 	list_for_each_entry(rng, &rng_list, list) {
 		if (sysfs_streq(rng->name, buf)) {
-			err = 0;
-			if (rng != current_rng)
-				err = set_current_rng(rng);
+			if (add)
+				err = add_active_rng(rng);
+			else
+				err = drop_active_rng(rng);
 			break;
 		}
 	}
+
 	mutex_unlock(&rng_mutex);
 
 	return err ? : len;
@@ -343,17 +392,26 @@ static ssize_t hwrng_attr_current_show(struct device *dev,
 				       struct device_attribute *attr,
 				       char *buf)
 {
-	ssize_t ret;
+	int err;
 	struct hwrng *rng;
 
-	rng = get_current_rng();
-	if (IS_ERR(rng))
-		return PTR_ERR(rng);
-
-	ret = snprintf(buf, PAGE_SIZE, "%s\n", rng ? rng->name : "none");
-	put_rng(rng);
+	err = mutex_lock_interruptible(&rng_mutex);
+	if (err)
+		return -ERESTARTSYS;
+	buf[0] = '\0';
+	if (list_empty(&active_rng)) {
+		strlcat(buf, "none", PAGE_SIZE);
+	} else {
+		list_for_each_entry(rng, &active_rng, active) {
+			if (rng != first_active_rng())
+				strlcat(buf, " ", PAGE_SIZE);
+			strlcat(buf, rng->name, PAGE_SIZE);
+		}
+	}
+	strlcat(buf, "\n", PAGE_SIZE);
+	mutex_unlock(&rng_mutex);
 
-	return ret;
+	return strlen(buf);
 }
 
 static ssize_t hwrng_attr_available_show(struct device *dev,
@@ -412,6 +470,7 @@ static int hwrng_fillfn(void *unused)
 		rng = get_current_rng();
 		if (IS_ERR(rng) || !rng)
 			break;
+		next_rng();
 		mutex_lock(&reading_mutex);
 		rc = rng_get_data(rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
@@ -442,7 +501,7 @@ static void start_khwrngd(void)
 int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
-	struct hwrng *old_rng, *tmp;
+	struct hwrng *tmp;
 
 	if (rng->name == NULL ||
 	    (rng->data_read == NULL && rng->read == NULL))
@@ -472,19 +531,18 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 	}
 
+	rng->is_active = false;
+
 	init_completion(&rng->cleanup_done);
 	complete(&rng->cleanup_done);
 
-	old_rng = current_rng;
-	err = 0;
-	if (!old_rng) {
-		err = set_current_rng(rng);
-		if (err)
-			goto out_unlock;
-	}
+	err = add_active_rng(rng);
+	if (err)
+		goto out_unlock;
+
 	list_add_tail(&rng->list, &rng_list);
 
-	if (old_rng && !rng->init) {
+	if (!rng->init) {
 		/*
 		 * Use a new device's input to add some randomness to
 		 * the system.  If this rng device isn't going to be
@@ -507,16 +565,7 @@ void hwrng_unregister(struct hwrng *rng)
 	mutex_lock(&rng_mutex);
 
 	list_del(&rng->list);
-	if (current_rng == rng) {
-		drop_current_rng();
-		if (!list_empty(&rng_list)) {
-			struct hwrng *tail;
-
-			tail = list_entry(rng_list.prev, struct hwrng, list);
-
-			set_current_rng(tail);
-		}
-	}
+	drop_active_rng(rng);
 
 	if (list_empty(&rng_list)) {
 		mutex_unlock(&rng_mutex);
@@ -579,7 +628,7 @@ static int __init hwrng_modinit(void)
 static void __exit hwrng_modexit(void)
 {
 	mutex_lock(&rng_mutex);
-	BUG_ON(current_rng);
+	WARN_ON(!list_empty(&active_rng));
 	kfree(rng_buffer);
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 4f7d8f4..c655563 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -45,7 +45,9 @@ struct hwrng {
 	unsigned short quality;
 
 	/* internal. */
+	bool is_active;
 	struct list_head list;
+	struct list_head active;
 	struct kref ref;
 	struct completion cleanup_done;
 };
-- 
2.8.1
