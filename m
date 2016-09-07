From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH v2] hwrng: core - Allocate memory during module init
Date: Wed,  7 Sep 2016 20:18:02 +0530
Message-ID: <1473259682-11655-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, lee.jones@linaro.org,
        jslaby@suse.cz, peter@korsgaard.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33858 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936548AbcIGOsU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 10:48:20 -0400
Received: by mail-pf0-f194.google.com with SMTP id g202so1064884pfb.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 Sep 2016 07:48:14 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In core rng_buffer and rng_fillbuf is allocated in hwrng_register only
once and it is freed during module exit. This patch moves allocating
rng_buffer and rng_fillbuf from hwrng_register to rng core's init. This
avoids checking whether rng_buffer and rng_fillbuf was allocated from
every hwrng_register call. Also moving them to module init makes it
explicit that it is freed in module exit.

Change in v2:
Fix memory leak when register_miscdev fails.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/core.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 9203f2d..4827945 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -449,22 +449,6 @@ int hwrng_register(struct hwrng *rng)
 		goto out;
 
 	mutex_lock(&rng_mutex);
-
-	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
-	err = -ENOMEM;
-	if (!rng_buffer) {
-		rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
-		if (!rng_buffer)
-			goto out_unlock;
-	}
-	if (!rng_fillbuf) {
-		rng_fillbuf = kmalloc(rng_buffer_size(), GFP_KERNEL);
-		if (!rng_fillbuf) {
-			kfree(rng_buffer);
-			goto out_unlock;
-		}
-	}
-
 	/* Must not register two RNGs with the same name. */
 	err = -EEXIST;
 	list_for_each_entry(tmp, &rng_list, list) {
@@ -573,7 +557,26 @@ EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
 
 static int __init hwrng_modinit(void)
 {
-	return register_miscdev();
+	int ret = -ENOMEM;
+
+	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
+	rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
+	if (!rng_buffer)
+		return -ENOMEM;
+
+	rng_fillbuf = kmalloc(rng_buffer_size(), GFP_KERNEL);
+	if (!rng_fillbuf) {
+		kfree(rng_buffer);
+		return -ENOMEM;
+	}
+
+	ret = register_miscdev();
+	if (ret) {
+		kfree(rng_fillbuf);
+		kfree(rng_buffer);
+	}
+
+	return ret;
 }
 
 static void __exit hwrng_modexit(void)
-- 
2.5.0
