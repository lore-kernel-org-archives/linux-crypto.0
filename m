From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH 1/3] crypto: hwrng use rng source with best quality
Date: Mon,  3 Jul 2017 12:03:22 +0200
Message-ID: <1499076204-18547-2-git-send-email-freude@linux.vnet.ibm.com>
References: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, schwidefsky@de.ibm.com,
        Harald Freudenberger <freude@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49653 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753800AbdGCKDq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2017 06:03:46 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v639wg2s065908
        for <linux-crypto@vger.kernel.org>; Mon, 3 Jul 2017 06:03:45 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bfdbcdh4r-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jul 2017 06:03:45 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
        Mon, 3 Jul 2017 11:03:43 +0100
In-Reply-To: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch rewoks the hwrng to always use the
rng source with best entropy quality.

On registation and unregistration the hwrng now
tries to choose the best (= highest quality value)
rng source. The handling of the internal list
of registered rng sources is now always sorted
by quality and the top most rng chosen.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 drivers/char/hw_random/core.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 503a41d..e9dda16 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -29,6 +29,7 @@
 
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;
+/* list of registered rngs, sorted decending by quality */
 static LIST_HEAD(rng_list);
 /* Protects rng_list and current_rng */
 static DEFINE_MUTEX(rng_mutex);
@@ -417,6 +418,7 @@ int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
 	struct hwrng *old_rng, *tmp;
+	struct list_head *rng_list_ptr;
 
 	if (!rng->name || (!rng->data_read && !rng->read))
 		goto out;
@@ -432,14 +434,25 @@ int hwrng_register(struct hwrng *rng)
 	init_completion(&rng->cleanup_done);
 	complete(&rng->cleanup_done);
 
+	/* rng_list is sorted by decreasing quality */
+	list_for_each(rng_list_ptr, &rng_list) {
+		tmp = list_entry(rng_list_ptr, struct hwrng, list);
+		if (tmp->quality < rng->quality)
+			break;
+	}
+	list_add_tail(&rng->list, rng_list_ptr);
+
 	old_rng = current_rng;
 	err = 0;
-	if (!old_rng) {
+	if (!old_rng || (rng->quality > old_rng->quality)) {
+		/*
+		 * Set new rng as current as the new rng source
+		 * provides better entropy quality.
+		 */
 		err = set_current_rng(rng);
 		if (err)
 			goto out_unlock;
 	}
-	list_add_tail(&rng->list, &rng_list);
 
 	if (old_rng && !rng->init) {
 		/*
@@ -466,12 +479,12 @@ void hwrng_unregister(struct hwrng *rng)
 	list_del(&rng->list);
 	if (current_rng == rng) {
 		drop_current_rng();
+		/* rng_list is sorted by quality, use the best (=first) one */
 		if (!list_empty(&rng_list)) {
-			struct hwrng *tail;
-
-			tail = list_entry(rng_list.prev, struct hwrng, list);
+			struct hwrng *new_rng;
 
-			set_current_rng(tail);
+			new_rng = list_entry(rng_list.next, struct hwrng, list);
+			set_current_rng(new_rng);
 		}
 	}
 
-- 
2.7.4
