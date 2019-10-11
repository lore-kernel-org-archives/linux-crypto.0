Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FE4ECE58C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 13:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D757214E0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 13:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfJKNr2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 09:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727950AbfJKNr2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 09:47:28 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E4EC510C0311;
        Fri, 11 Oct 2019 13:47:27 +0000 (UTC)
Received: from thinkpad.redhat.com (ovpn-116-143.ams2.redhat.com [10.36.116.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6248600C4;
        Fri, 11 Oct 2019 13:47:25 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-crypto@vger.kernel.org,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2] hwrng: core - move add_early_randomness() out of rng_mutex
Date:   Fri, 11 Oct 2019 15:47:24 +0200
Message-Id: <20191011134724.28651-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Fri, 11 Oct 2019 13:47:28 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

add_early_randomness() is called every time a new rng backend is added
and every time it is set as the current rng provider.

add_early_randomness() is called from functions locking rng_mutex,
and if it hangs all the hw_random framework hangs: we can't read sysfs,
add or remove a backend.

This patch moves add_early_randomness() out of the rng_mutex zone.
It only needs the reading_mutex.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---

Notes:
    v2: in hwrng_register, take rng->ref only if rng is the new current_rng

 drivers/char/hw_random/core.c | 61 +++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 80b850ef1bf6..d85c6e18a2d2 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -112,6 +112,14 @@ static void drop_current_rng(void)
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
@@ -119,9 +127,7 @@ static struct hwrng *get_current_rng(void)
 	if (mutex_lock_interruptible(&rng_mutex))
 		return ERR_PTR(-ERESTARTSYS);
 
-	rng = current_rng;
-	if (rng)
-		kref_get(&rng->ref);
+	rng = get_current_rng_nolock();
 
 	mutex_unlock(&rng_mutex);
 	return rng;
@@ -156,8 +162,6 @@ static int hwrng_init(struct hwrng *rng)
 	reinit_completion(&rng->cleanup_done);
 
 skip_init:
-	add_early_randomness(rng);
-
 	current_quality = rng->quality ? : default_quality;
 	if (current_quality > 1024)
 		current_quality = 1024;
@@ -321,12 +325,13 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
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
@@ -338,9 +343,15 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
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
 
@@ -460,13 +471,15 @@ static void start_khwrngd(void)
 int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
-	struct hwrng *old_rng, *tmp;
+	struct hwrng *tmp;
 	struct list_head *rng_list_ptr;
+	bool is_new_current = false;
 
 	if (!rng->name || (!rng->data_read && !rng->read))
 		goto out;
 
 	mutex_lock(&rng_mutex);
+
 	/* Must not register two RNGs with the same name. */
 	err = -EEXIST;
 	list_for_each_entry(tmp, &rng_list, list) {
@@ -485,10 +498,8 @@ int hwrng_register(struct hwrng *rng)
 	}
 	list_add_tail(&rng->list, rng_list_ptr);
 
-	old_rng = current_rng;
-	err = 0;
-	if (!old_rng ||
-	    (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
+	if (!current_rng ||
+	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
 		/*
 		 * Set new rng as current as the new rng source
 		 * provides better entropy quality and was not
@@ -497,19 +508,26 @@ int hwrng_register(struct hwrng *rng)
 		err = set_current_rng(rng);
 		if (err)
 			goto out_unlock;
+		/* to use current_rng in add_early_randomness() we need
+		 * to take a ref
+		 */
+		is_new_current = true;
+		kref_get(&rng->ref);
 	}
-
-	if (old_rng && !rng->init) {
+	mutex_unlock(&rng_mutex);
+	if (is_new_current || !rng->init) {
 		/*
 		 * Use a new device's input to add some randomness to
 		 * the system.  If this rng device isn't going to be
 		 * used right away, its init function hasn't been
-		 * called yet; so only use the randomness from devices
-		 * that don't need an init callback.
+		 * called yet by set_current_rng(); so only use the
+		 * randomness from devices that don't need an init callback
 		 */
 		add_early_randomness(rng);
 	}
-
+	if (is_new_current)
+		put_rng(rng);
+	return 0;
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
@@ -519,10 +537,12 @@ EXPORT_SYMBOL_GPL(hwrng_register);
 
 void hwrng_unregister(struct hwrng *rng)
 {
+	struct hwrng *old_rng, *new_rng;
 	int err;
 
 	mutex_lock(&rng_mutex);
 
+	old_rng = current_rng;
 	list_del(&rng->list);
 	if (current_rng == rng) {
 		err = enable_best_rng();
@@ -532,6 +552,7 @@ void hwrng_unregister(struct hwrng *rng)
 		}
 	}
 
+	new_rng = get_current_rng_nolock();
 	if (list_empty(&rng_list)) {
 		mutex_unlock(&rng_mutex);
 		if (hwrng_fill)
@@ -539,6 +560,12 @@ void hwrng_unregister(struct hwrng *rng)
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

