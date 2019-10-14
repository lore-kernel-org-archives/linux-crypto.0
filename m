Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6B3ECE587
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 11:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 029F32084B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 11:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbfJNLqh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 07:46:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbfJNLqh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 07:46:37 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A35CC801673;
        Mon, 14 Oct 2019 11:46:35 +0000 (UTC)
Received: from thinkpad.redhat.com (ovpn-116-247.ams2.redhat.com [10.36.116.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5186619C6A;
        Mon, 14 Oct 2019 11:46:33 +0000 (UTC)
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Matt Mackall <mpm@selenic.com>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH] hwrng: core - Fix use-after-free warning in hwrng_register()
Date:   Mon, 14 Oct 2019 13:46:32 +0200
Message-Id: <20191014114632.10875-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Mon, 14 Oct 2019 11:46:36 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit daae28debcb0 has moved add_early_randomness() out of the
rng_mutex and tries to protect the reference of the new rng device
by incrementing the reference counter.

But in hwrng_register(), the function can be called with a new device
that is not set as the current_rng device and the reference has not been
initialized. This patch fixes the problem by not using the reference
counter when the device is not the current one: the reference counter
is only meaningful in the case of the current rng device and a device
is not used if it is not the current one (except in hwrng_register())

The problem has been reported by Marek Szyprowski on ARM 32bit
Exynos5420-based Chromebook Peach-Pit board:

WARNING: CPU: 3 PID: 1 at lib/refcount.c:156 hwrng_register+0x13c/0x1b4
refcount_t: increment on 0; use-after-free.
Modules linked in:
CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc1-00061-gdaae28debcb0
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[<c01124c8>] (unwind_backtrace) from [<c010dfb8>] (show_stack+0x10/0x14)
[<c010dfb8>] (show_stack) from [<c0ae86d8>] (dump_stack+0xa8/0xd4)
[<c0ae86d8>] (dump_stack) from [<c0127428>] (__warn+0xf4/0x10c)
[<c0127428>] (__warn) from [<c01274b4>] (warn_slowpath_fmt+0x74/0xb8)
[<c01274b4>] (warn_slowpath_fmt) from [<c054729c>] (hwrng_register+0x13c/0x1b4)
[<c054729c>] (hwrng_register) from [<c0547e54>] (tpm_chip_register+0xc4/0x274)
...

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: daae28debcb0 ("hwrng: core - move add_early_randomness() out of rng_mutex")
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/char/hw_random/core.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 29f50c045c92..d85c6e18a2d2 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -471,17 +471,15 @@ static void start_khwrngd(void)
 int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
-	struct hwrng *old_rng, *new_rng, *tmp;
+	struct hwrng *tmp;
 	struct list_head *rng_list_ptr;
+	bool is_new_current = false;
 
 	if (!rng->name || (!rng->data_read && !rng->read))
 		goto out;
 
 	mutex_lock(&rng_mutex);
 
-	old_rng = current_rng;
-	new_rng = NULL;
-
 	/* Must not register two RNGs with the same name. */
 	err = -EEXIST;
 	list_for_each_entry(tmp, &rng_list, list) {
@@ -500,9 +498,8 @@ int hwrng_register(struct hwrng *rng)
 	}
 	list_add_tail(&rng->list, rng_list_ptr);
 
-	err = 0;
-	if (!old_rng ||
-	    (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
+	if (!current_rng ||
+	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
 		/*
 		 * Set new rng as current as the new rng source
 		 * provides better entropy quality and was not
@@ -511,15 +508,14 @@ int hwrng_register(struct hwrng *rng)
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
-	new_rng = rng;
-	kref_get(&new_rng->ref);
-out_unlock:
 	mutex_unlock(&rng_mutex);
-
-	if (new_rng) {
-		if (new_rng != old_rng || !rng->init) {
+	if (is_new_current || !rng->init) {
 		/*
 		 * Use a new device's input to add some randomness to
 		 * the system.  If this rng device isn't going to be
@@ -527,10 +523,13 @@ int hwrng_register(struct hwrng *rng)
 		 * called yet by set_current_rng(); so only use the
 		 * randomness from devices that don't need an init callback
 		 */
-			add_early_randomness(new_rng);
-		}
-		put_rng(new_rng);
+		add_early_randomness(rng);
 	}
+	if (is_new_current)
+		put_rng(rng);
+	return 0;
+out_unlock:
+	mutex_unlock(&rng_mutex);
 out:
 	return err;
 }
-- 
2.21.0

