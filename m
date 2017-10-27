From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hw_random: core: Reset user selected rng by writing "" to rng_current
Date: Fri, 27 Oct 2017 22:34:04 +0530
Message-ID: <20171027170404.21262-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        freude@linux.vnet.ibm.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:54421 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdJ0RFK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2017 13:05:10 -0400
Received: by mail-pf0-f193.google.com with SMTP id n89so5358806pfk.11
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2017 10:05:09 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

User is able to select a chosen rng by writing its name to rng_current
but there is no way to reset it without unbinding the rng. Let user
write "" to rng_current and delesect the chosen rng.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/core.c | 51 +++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 9701ac7..be03024 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -292,26 +292,48 @@ static struct miscdevice rng_miscdev = {
 	.groups		= rng_dev_groups,
 };
 
+static int enable_best_rng(void)
+{
+	int ret = -ENODEV;
+
+	BUG_ON(!mutex_is_locked(&rng_mutex));
+
+	/* rng_list is sorted by quality, use the best (=first) one */
+	if (!list_empty(&rng_list)) {
+		struct hwrng *new_rng;
+
+		new_rng = list_entry(rng_list.next, struct hwrng, list);
+		ret = ((new_rng == current_rng) ? 0 : set_current_rng(new_rng));
+		if (!ret)
+			cur_rng_set_by_user = 0;
+	}
+
+	return ret;
+}
+
 static ssize_t hwrng_attr_current_store(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
-	int err;
+	int err = -ENODEV;
 	struct hwrng *rng;
 
 	err = mutex_lock_interruptible(&rng_mutex);
 	if (err)
 		return -ERESTARTSYS;
-	err = -ENODEV;
-	list_for_each_entry(rng, &rng_list, list) {
-		if (sysfs_streq(rng->name, buf)) {
-			err = 0;
-			cur_rng_set_by_user = 1;
-			if (rng != current_rng)
+
+	if (sysfs_streq(buf, "")) {
+		err = enable_best_rng();
+	} else {
+		list_for_each_entry(rng, &rng_list, list) {
+			if (sysfs_streq(rng->name, buf)) {
+				cur_rng_set_by_user = 1;
 				err = set_current_rng(rng);
-			break;
+				break;
+			}
 		}
 	}
+
 	mutex_unlock(&rng_mutex);
 
 	return err ? : len;
@@ -493,17 +515,8 @@ void hwrng_unregister(struct hwrng *rng)
 	mutex_lock(&rng_mutex);
 
 	list_del(&rng->list);
-	if (current_rng == rng) {
-		drop_current_rng();
-		cur_rng_set_by_user = 0;
-		/* rng_list is sorted by quality, use the best (=first) one */
-		if (!list_empty(&rng_list)) {
-			struct hwrng *new_rng;
-
-			new_rng = list_entry(rng_list.next, struct hwrng, list);
-			set_current_rng(new_rng);
-		}
-	}
+	if (current_rng == rng)
+		enable_best_rng();
 
 	if (list_empty(&rng_list)) {
 		mutex_unlock(&rng_mutex);
-- 
2.10.0
