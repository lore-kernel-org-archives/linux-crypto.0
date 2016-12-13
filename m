From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Tue, 13 Dec 2016 15:10:59 +0100
Message-ID: <20161213141059.GB10647@Red>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au>
 <20161205125738.GA13525@Red>
 <20161207120900.GC20680@gondor.apana.org.au>
 <20161207125127.GB28218@Red>
 <20161208090618.GB22932@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:35625 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932254AbcLMOLE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 09:11:04 -0500
Content-Disposition: inline
In-Reply-To: <20161208090618.GB22932@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 08, 2016 at 05:06:18PM +0800, Herbert Xu wrote:
> On Wed, Dec 07, 2016 at 01:51:27PM +0100, Corentin Labbe wrote:
> > 
> > So I must expose it as a crypto_rng ?
> 
> If it is to be exposed at all then algif_rng would be the best
> place.
> 
> > Could you explain why PRNG must not be used as hw_random ?
> 
> The hwrng interface was always meant to be an interface for real
> hardware random number generators.  People rely on that so we
> should not provide bogus entropy sources through this interface.
> 
> Cheers,

I have found two solutions:

The simplier is to add an attribute isprng to hwrng like that:
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -150,7 +150,8 @@ static int hwrng_init(struct hwrng *rng)
        reinit_completion(&rng->cleanup_done);
 
 skip_init:
-       add_early_randomness(rng);
+       if (!rng->isprng)
+               add_early_randomness(rng);
 
        current_quality = rng->quality ? : default_quality;
        if (current_quality > 1024)
@@ -158,7 +159,7 @@ static int hwrng_init(struct hwrng *rng)
 
        if (current_quality == 0 && hwrng_fill)
                kthread_stop(hwrng_fill);
-       if (current_quality > 0 && !hwrng_fill)
+       if (current_quality > 0 && !hwrng_fill && !rng->isprng)
                start_khwrngd();
 
        return 0;
@@ -439,7 +440,7 @@ int hwrng_register(struct hwrng *rng)
        }
        list_add_tail(&rng->list, &rng_list);
 
-       if (old_rng && !rng->init) {
+       if (old_rng && !rng->init && !rng->isprng) {
                /*
                 * Use a new device's input to add some randomness to
                 * the system.  If this rng device isn't going to be
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 34a0dc1..5a5b8dc 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -50,6 +50,7 @@ struct hwrng {
        struct list_head list;
        struct kref ref;
        struct completion cleanup_done;
+       bool isprng;
 };


With that, we still could register prng, but they dont provide any entropy.
An optional Kconfig/"module parameter" could still be added for people still wanting this old behavour.


The other solution is to "duplicate" /dev/hwrng to /dev/hwprng like that:
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -24,8 +24,11 @@
 #include <linux/uaccess.h>
 
 #define RNG_MODULE_NAME		"hw_random"
+#define PRNG_MODULE_NAME	"hw_prng"
+#define HWPRNG_MINOR	185 /* not official */
 
 static struct hwrng *current_rng;
+static struct hwrng *current_prng;
 static struct task_struct *hwrng_fill;
 static LIST_HEAD(rng_list);
 /* Protects rng_list and current_rng */
@@ -44,7 +47,7 @@ module_param(default_quality, ushort, 0644);
 MODULE_PARM_DESC(default_quality,
 		 "default entropy content of hwrng per mill");
 
-static void drop_current_rng(void);
+static void drop_current_rng(bool prng);
 static int hwrng_init(struct hwrng *rng);
 static void start_khwrngd(void);
 
@@ -56,6 +59,14 @@ static size_t rng_buffer_size(void)
 	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
 }
 
+static bool is_current_xrng(struct hwrng *rng)
+{
+	if (rng->isprng)
+		return (rng == current_prng);
+	else
+		return (rng == current_rng);
+}
+
 static void add_early_randomness(struct hwrng *rng)
 {
 	int bytes_read;
@@ -88,32 +99,46 @@ static int set_current_rng(struct hwrng *rng)
 	if (err)
 		return err;
 
-	drop_current_rng();
-	current_rng = rng;
+	drop_current_rng(rng->isprng);
+	if (rng->isprng)
+		current_prng = rng;
+	else
+		current_rng = rng;
 
 	return 0;
 }
 
-static void drop_current_rng(void)
+static void drop_current_rng(bool prng)
 {
 	BUG_ON(!mutex_is_locked(&rng_mutex));
-	if (!current_rng)
-		return;
-
-	/* decrease last reference for triggering the cleanup */
-	kref_put(&current_rng->ref, cleanup_rng);
-	current_rng = NULL;
+	if (prng) {
+		if (!current_prng)
+			return;
+		/* decrease last reference for triggering the cleanup */
+		kref_put(&current_prng->ref, cleanup_rng);
+		current_prng = NULL;
+	} else {
+		if (!current_rng)
+			return;
+		/* decrease last reference for triggering the cleanup */
+		kref_put(&current_rng->ref, cleanup_rng);
+		current_rng = NULL;
+	}
 }
 
 /* Returns ERR_PTR(), NULL or refcounted hwrng */
-static struct hwrng *get_current_rng(void)
+static struct hwrng *get_current_rng(bool prng)
 {
 	struct hwrng *rng;
 
 	if (mutex_lock_interruptible(&rng_mutex))
 		return ERR_PTR(-ERESTARTSYS);
 
-	rng = current_rng;
+	if (prng)
+		rng = current_prng;
+	else
+		rng = current_rng;
+
 	if (rng)
 		kref_get(&rng->ref);
 
@@ -193,8 +218,8 @@ static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
 	return 0;
 }
 
-static ssize_t rng_dev_read(struct file *filp, char __user *buf,
-			    size_t size, loff_t *offp)
+static ssize_t genrng_dev_read(struct file *filp, char __user *buf,
+			    size_t size, loff_t *offp, bool prng)
 {
 	ssize_t ret = 0;
 	int err = 0;
@@ -202,7 +227,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 	struct hwrng *rng;
 
 	while (size) {
-		rng = get_current_rng();
+		rng = get_current_rng(prng);
 		if (IS_ERR(rng)) {
 			err = PTR_ERR(rng);
 			goto out;
@@ -270,6 +295,18 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 	goto out;
 }
 
+static ssize_t rng_dev_read(struct file *filp, char __user *buf,
+			    size_t size, loff_t *offp)
+{
+	return genrng_dev_read(filp, buf, size, offp, false);
+}
+
+static ssize_t prng_dev_read(struct file *filp, char __user *buf,
+			    size_t size, loff_t *offp)
+{
+	return genrng_dev_read(filp, buf, size, offp, true);
+}
+
 static const struct file_operations rng_chrdev_ops = {
 	.owner		= THIS_MODULE,
 	.open		= rng_dev_open,
@@ -278,6 +315,7 @@ static const struct file_operations rng_chrdev_ops = {
 };
 
 static const struct attribute_group *rng_dev_groups[];
+static const struct attribute_group *prng_dev_groups[];
 
 static struct miscdevice rng_miscdev = {
 	.minor		= HWRNG_MINOR,
@@ -287,9 +325,24 @@ static struct miscdevice rng_miscdev = {
 	.groups		= rng_dev_groups,
 };
 
-static ssize_t hwrng_attr_current_store(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf, size_t len)
+static const struct file_operations prng_chrdev_ops = {
+	.owner		= THIS_MODULE,
+	.open		= rng_dev_open,
+	.read		= prng_dev_read,
+	.llseek		= noop_llseek,
+};
+
+static struct miscdevice prng_miscdev = {
+	.minor		= HWPRNG_MINOR,
+	.name		= PRNG_MODULE_NAME,
+	.nodename	= "hwprng",
+	.fops		= &prng_chrdev_ops,
+	.groups		= prng_dev_groups,
+};
+
+static ssize_t genrng_attr_current_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len, bool prng)
 {
 	int err;
 	struct hwrng *rng;
@@ -301,8 +354,13 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 	list_for_each_entry(rng, &rng_list, list) {
 		if (sysfs_streq(rng->name, buf)) {
 			err = 0;
-			if (rng != current_rng)
-				err = set_current_rng(rng);
+			if (prng) {
+				if (rng != current_prng)
+					err = set_current_rng(rng);
+			} else {
+				if (rng != current_rng)
+					err = set_current_rng(rng);
+			}
 			break;
 		}
 	}
@@ -311,14 +369,28 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 	return err ? : len;
 }
 
-static ssize_t hwrng_attr_current_show(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf)
+static ssize_t hwrng_attr_current_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	return genrng_attr_current_store(dev, attr, buf, len, false);
+}
+
+static ssize_t hwprng_attr_current_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len)
+{
+	return genrng_attr_current_store(dev, attr, buf, len, true);
+}
+
+static ssize_t genrng_attr_current_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf, bool prng)
 {
 	ssize_t ret;
 	struct hwrng *rng;
 
-	rng = get_current_rng();
+	rng = get_current_rng(prng);
 	if (IS_ERR(rng))
 		return PTR_ERR(rng);
 
@@ -328,9 +400,24 @@ static ssize_t hwrng_attr_current_show(struct device *dev,
 	return ret;
 }
 
-static ssize_t hwrng_attr_available_show(struct device *dev,
+static ssize_t hwrng_attr_current_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	return genrng_attr_current_show(dev, attr, buf, false);
+}
+
+static ssize_t hwprng_attr_current_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return genrng_attr_current_show(dev, attr, buf, true);
+}
+
+
+static ssize_t hwgenrng_attr_available_show(struct device *dev,
 					 struct device_attribute *attr,
-					 char *buf)
+					 char *buf, bool prng)
 {
 	int err;
 	struct hwrng *rng;
@@ -340,8 +427,10 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 		return -ERESTARTSYS;
 	buf[0] = '\0';
 	list_for_each_entry(rng, &rng_list, list) {
-		strlcat(buf, rng->name, PAGE_SIZE);
-		strlcat(buf, " ", PAGE_SIZE);
+		if (rng->isprng == prng) {
+			strlcat(buf, rng->name, PAGE_SIZE);
+			strlcat(buf, " ", PAGE_SIZE);
+		}
 	}
 	strlcat(buf, "\n", PAGE_SIZE);
 	mutex_unlock(&rng_mutex);
@@ -349,6 +438,20 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 	return strlen(buf);
 }
 
+static ssize_t hwrng_attr_available_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return hwgenrng_attr_available_show(dev, attr, buf, false);
+}
+
+static ssize_t hwprng_attr_available_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	return hwgenrng_attr_available_show(dev, attr, buf, true);
+}
+
 static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
 		   hwrng_attr_current_show,
 		   hwrng_attr_current_store);
@@ -356,6 +459,13 @@ static DEVICE_ATTR(rng_available, S_IRUGO,
 		   hwrng_attr_available_show,
 		   NULL);
 
+static DEVICE_ATTR(prng_current, S_IRUGO | S_IWUSR,
+		   hwprng_attr_current_show,
+		   hwprng_attr_current_store);
+static DEVICE_ATTR(prng_available, S_IRUGO,
+		   hwprng_attr_available_show,
+		   NULL);
+
 static struct attribute *rng_dev_attrs[] = {
 	&dev_attr_rng_current.attr,
 	&dev_attr_rng_available.attr,
@@ -364,14 +474,35 @@ static struct attribute *rng_dev_attrs[] = {
 
 ATTRIBUTE_GROUPS(rng_dev);
 
+static struct attribute *prng_dev_attrs[] = {
+	&dev_attr_prng_current.attr,
+	&dev_attr_prng_available.attr,
+	NULL
+};
+
+ATTRIBUTE_GROUPS(prng_dev);
+
 static void __exit unregister_miscdev(void)
 {
 	misc_deregister(&rng_miscdev);
+	misc_deregister(&prng_miscdev);
 }
 
 static int __init register_miscdev(void)
 {
-	return misc_register(&rng_miscdev);
+	int err;
+
+	err = misc_register(&rng_miscdev);
+	if (err)
+		return err;
+	err = misc_register(&prng_miscdev);
+	if (err)
+		goto reg_error;
+	else
+		return 0;
+reg_error:
+	misc_deregister(&rng_miscdev);
+	return err;
 }
 
 static int hwrng_fillfn(void *unused)
@@ -381,7 +512,7 @@ static int hwrng_fillfn(void *unused)
 	while (!kthread_should_stop()) {
 		struct hwrng *rng;
 
-		rng = get_current_rng();
+		rng = get_current_rng(false);
 		if (IS_ERR(rng) || !rng)
 			break;
 		mutex_lock(&reading_mutex);
@@ -462,8 +593,8 @@ void hwrng_unregister(struct hwrng *rng)
 	mutex_lock(&rng_mutex);
 
 	list_del(&rng->list);
-	if (current_rng == rng) {
-		drop_current_rng();
+	if (is_current_xrng(rng)) {
+		drop_current_rng(rng->isprng);
 		if (!list_empty(&rng_list)) {
 			struct hwrng *tail;
 
@@ -553,7 +684,8 @@ static int __init hwrng_modinit(void)
 static void __exit hwrng_modexit(void)
 {
 	mutex_lock(&rng_mutex);
-	BUG_ON(current_rng);
+	WARN_ON(current_rng);
+	WARN_ON(current_prng);
 	kfree(rng_buffer);
 	kfree(rng_fillbuf);
 	mutex_unlock(&rng_mutex);
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 34a0dc1..5a5b8dc 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -50,6 +50,7 @@ struct hwrng {
 	struct list_head list;
 	struct kref ref;
 	struct completion cleanup_done;
+	bool isprng;
 };

What do you think about those two solutions ?

Regards
Corentin Labbe
