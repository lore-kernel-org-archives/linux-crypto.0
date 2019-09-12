Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAAEC4CEC5
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 13:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F004F20856
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 13:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732112AbfILNaZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 09:30:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731687AbfILNaZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 09:30:25 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CDFA08980E1;
        Thu, 12 Sep 2019 13:30:24 +0000 (UTC)
Received: from thinkpad.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4718D608AB;
        Thu, 12 Sep 2019 13:30:23 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH] hw_random: move add_early_randomness() out of rng_mutex
Date:   Thu, 12 Sep 2019 15:30:22 +0200
Message-Id: <20190912133022.14870-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Thu, 12 Sep 2019 13:30:25 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

add_early_randomness() is called every time a new rng backend is added
and every time it is set as the current rng provider.

add_early_randomness() is called from functions locking rng_mutex,
and if it hangs all the hw_random framework hangs: we can't read sysfs,
add or remove a backend.

This patch move add_early_randomness() out of the rng_mutex zone.
It only needs the reading_mutex.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/char/hw_random/core.c | 60 +++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 9044d31ab1a1..745ace6fffd7 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -111,6 +111,14 @@ static void drop_current_rng(void)
 }
 
 /* Returns ERR_PTR(), NULL or refcounted hwrng */
+static struct hwrng *get_current_rng_nolock(void)
+{
+	if (current_rng)
+		kref_get(&current_rng->ref);
+
+	return current_rng;
+}
+
 static struct hwrng *get_current_rng(void)
 {
 	struct hwrng *rng;
@@ -118,9 +126,7 @@ static struct hwrng *get_current_rng(void)
 	if (mutex_lock_interruptible(&rng_mutex))
 		return ERR_PTR(-ERESTARTSYS);
 
-	rng = current_rng;
-	if (rng)
-		kref_get(&rng->ref);
+	rng = get_current_rng_nolock();
 
 	mutex_unlock(&rng_mutex);
 	return rng;
@@ -155,8 +161,6 @@ static int hwrng_init(struct hwrng *rng)
 	reinit_completion(&rng->cleanup_done);
 
 skip_init:
-	add_early_randomness(rng);
-
 	current_quality = rng->quality ? : default_quality;
 	if (current_quality > 1024)
 		current_quality = 1024;
@@ -320,12 +324,13 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 					const char *buf, size_t len)
 {
 	int err = -ENODEV;
-	struct hwrng *rng;
+	struct hwrng *rng, *old_rng, *new_rng;
 
 	err = mutex_lock_interruptible(&rng_mutex);
 	if (err)
 		return -ERESTARTSYS;
 
+	old_rng = current_rng;
 	if (sysfs_streq(buf, "")) {
 		err = enable_best_rng();
 	} else {
@@ -337,9 +342,15 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 			}
 		}
 	}
-
+	new_rng = get_current_rng_nolock();
 	mutex_unlock(&rng_mutex);
 
+	if (new_rng) {
+		if (new_rng != old_rng)
+			add_early_randomness(new_rng);
+		put_rng(new_rng);
+	}
+
 	return err ? : len;
 }
 
@@ -457,13 +468,17 @@ static void start_khwrngd(void)
 int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
-	struct hwrng *old_rng, *tmp;
+	struct hwrng *old_rng, *new_rng, *tmp;
 	struct list_head *rng_list_ptr;
 
 	if (!rng->name || (!rng->data_read && !rng->read))
 		goto out;
 
 	mutex_lock(&rng_mutex);
+
+	old_rng = current_rng;
+	new_rng = NULL;
+
 	/* Must not register two RNGs with the same name. */
 	err = -EEXIST;
 	list_for_each_entry(tmp, &rng_list, list) {
@@ -482,7 +497,6 @@ int hwrng_register(struct hwrng *rng)
 	}
 	list_add_tail(&rng->list, rng_list_ptr);
 
-	old_rng = current_rng;
 	err = 0;
 	if (!old_rng ||
 	    (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
@@ -496,19 +510,24 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 	}
 
-	if (old_rng && !rng->init) {
+	new_rng = rng;
+	kref_get(&new_rng->ref);
+out_unlock:
+	mutex_unlock(&rng_mutex);
+
+	if (new_rng) {
+		if (new_rng != old_rng || !rng->init) {
 		/*
 		 * Use a new device's input to add some randomness to
 		 * the system.  If this rng device isn't going to be
 		 * used right away, its init function hasn't been
-		 * called yet; so only use the randomness from devices
-		 * that don't need an init callback.
+		 * called yet by set_current_rng(); so only use the
+		 * randomness from devices that don't need an init callback
 		 */
-		add_early_randomness(rng);
+			add_early_randomness(new_rng);
+		}
+		put_rng(new_rng);
 	}
-
-out_unlock:
-	mutex_unlock(&rng_mutex);
 out:
 	return err;
 }
@@ -516,10 +535,12 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 
 void hwrng_unregister(struct hwrng *rng)
 {
+	struct hwrng *old_rng, *new_rng;
 	int err;
 
 	mutex_lock(&rng_mutex);
 
+	old_rng = current_rng;
 	list_del(&rng->list);
 	if (current_rng == rng) {
 		err = enable_best_rng();
@@ -529,6 +550,7 @@ void hwrng_unregister(struct hwrng *rng)
 		}
 	}
 
+	new_rng = get_current_rng_nolock();
 	if (list_empty(&rng_list)) {
 		mutex_unlock(&rng_mutex);
 		if (hwrng_fill)
@@ -536,6 +558,12 @@ void hwrng_unregister(struct hwrng *rng)
 	} else
 		mutex_unlock(&rng_mutex);
 
+	if (new_rng) {
+		if (old_rng != new_rng)
+			add_early_randomness(new_rng);
+		put_rng(new_rng);
+	}
+
 	wait_for_completion(&rng->cleanup_done);
 }
 EXPORT_SYMBOL_GPL(hwrng_unregister);
-- 
2.21.0

