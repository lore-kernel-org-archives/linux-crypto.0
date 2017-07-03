From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH 2/3] crypto: hwrng remember rng chosen by user
Date: Mon,  3 Jul 2017 12:03:23 +0200
Message-ID: <1499076204-18547-3-git-send-email-freude@linux.vnet.ibm.com>
References: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, schwidefsky@de.ibm.com,
        Harald Freudenberger <freude@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753800AbdGCKDv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2017 06:03:51 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v639wnj7125353
        for <linux-crypto@vger.kernel.org>; Mon, 3 Jul 2017 06:03:50 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bfh29en9y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jul 2017 06:03:50 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
        Mon, 3 Jul 2017 11:03:46 +0100
In-Reply-To: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When a user chooses a rng source via sysfs
attribute this rng should be sticky, even
when other sources with better quality to
register. This patch introduces a simple way
to remember the user's choise.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 drivers/char/hw_random/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index e9dda16..ffd4e36 100644
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
@@ -444,10 +447,12 @@ int hwrng_register(struct hwrng *rng)
 
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
@@ -479,6 +484,7 @@ void hwrng_unregister(struct hwrng *rng)
 	list_del(&rng->list);
 	if (current_rng == rng) {
 		drop_current_rng();
+		cur_rng_set_by_user = 0;
 		/* rng_list is sorted by quality, use the best (=first) one */
 		if (!list_empty(&rng_list)) {
 			struct hwrng *new_rng;
-- 
2.7.4
