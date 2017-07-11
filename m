From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH 2/2] crypto: hwrng remember rng chosen by user
Date: Tue, 11 Jul 2017 09:36:23 +0200
Message-ID: <1499758583-14626-3-git-send-email-freude@linux.vnet.ibm.com>
References: <1499758583-14626-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, prasannatsmkumar@gmail.com,
        schwidefsky@de.ibm.com,
        Harald Freudenberger <freude@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755382AbdGKHhY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2017 03:37:24 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6B7YOOO047348
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2017 03:37:18 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bmd4c12b2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jul 2017 03:37:18 -0400
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
        Tue, 11 Jul 2017 08:37:16 +0100
In-Reply-To: <1499758583-14626-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When a user chooses a rng source via sysfs attribute
this rng should be sticky, even when other sources
with better quality to register. This patch introduces
a simple way to remember the user's choice. This is
reflected by a new sysfs attribute file 'rng_selected'
which shows if the current rng has been chosen by
userspace. The new attribute file shows '1' for user
selected rng and '0' otherwise.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/core.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index e9dda16..9701ac7 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -28,6 +28,8 @@
 #define RNG_MODULE_NAME		"hw_random"
 
 static struct hwrng *current_rng;
+/* the current rng has been explicitly chosen by user via sysfs */
+static int cur_rng_set_by_user;
 static struct task_struct *hwrng_fill;
 /* list of registered rngs, sorted decending by quality */
 static LIST_HEAD(rng_list);
@@ -304,6 +306,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 	list_for_each_entry(rng, &rng_list, list) {
 		if (sysfs_streq(rng->name, buf)) {
 			err = 0;
+			cur_rng_set_by_user = 1;
 			if (rng != current_rng)
 				err = set_current_rng(rng);
 			break;
@@ -352,16 +355,27 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 	return strlen(buf);
 }
 
+static ssize_t hwrng_attr_selected_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", cur_rng_set_by_user);
+}
+
 static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
 		   hwrng_attr_current_show,
 		   hwrng_attr_current_store);
 static DEVICE_ATTR(rng_available, S_IRUGO,
 		   hwrng_attr_available_show,
 		   NULL);
+static DEVICE_ATTR(rng_selected, S_IRUGO,
+		   hwrng_attr_selected_show,
+		   NULL);
 
 static struct attribute *rng_dev_attrs[] = {
 	&dev_attr_rng_current.attr,
 	&dev_attr_rng_available.attr,
+	&dev_attr_rng_selected.attr,
 	NULL
 };
 
@@ -444,10 +458,12 @@ int hwrng_register(struct hwrng *rng)
 
 	old_rng = current_rng;
 	err = 0;
-	if (!old_rng || (rng->quality > old_rng->quality)) {
+	if (!old_rng ||
+	    (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
 		/*
 		 * Set new rng as current as the new rng source
-		 * provides better entropy quality.
+		 * provides better entropy quality and was not
+		 * chosen by userspace.
 		 */
 		err = set_current_rng(rng);
 		if (err)
@@ -479,6 +495,7 @@ void hwrng_unregister(struct hwrng *rng)
 	list_del(&rng->list);
 	if (current_rng == rng) {
 		drop_current_rng();
+		cur_rng_set_by_user = 0;
 		/* rng_list is sorted by quality, use the best (=first) one */
 		if (!list_empty(&rng_list)) {
 			struct hwrng *new_rng;
-- 
2.7.4
