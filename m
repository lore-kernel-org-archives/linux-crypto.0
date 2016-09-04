From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hwrng: core - Allocate memory during module init
Date: Sun,  4 Sep 2016 13:59:38 +0530
Message-ID: <1472977778-23996-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: prasannatsmkumar@gmail.com
To: mpm@selenic.com, herbert@gondor.apana.org.au, jslaby@suse.cz,
        peter@korsgaard.com, lee.jones@linaro.org,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36176 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbcIDIcK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Sep 2016 04:32:10 -0400
Received: by mail-pa0-f66.google.com with SMTP id ez1so7672878pab.3
        for <linux-crypto@vger.kernel.org>; Sun, 04 Sep 2016 01:30:30 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In core rng_buffer and rng_fillbuf is allocated in hwrng_register only
once and it is freed during module exit. This patch moves allocating
rng_buffer and rng_fillbuf from hwrng_register to rng core's init. This
avoids checking whether rng_buffer and rng_fillbuf was allocated from
every hwrng_register call. Also moving them to module init makes it
explicit that it is freed in module exit.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/core.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 9203f2d..ec6846b 100644
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
@@ -573,6 +557,17 @@ EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
 
 static int __init hwrng_modinit(void)
 {
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
 	return register_miscdev();
 }
 
-- 
2.5.0
