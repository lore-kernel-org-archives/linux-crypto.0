From: Joel A Fernandes <joelagnel@ti.com>
Subject: [PATCH] OMAP: AES: Don't idle/start AES device between Encrypt operations
Date: Sat, 11 May 2013 12:23:44 -0500
Message-ID: <1368293024-6654-1-git-send-email-joelagnel@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Mark A. Greer" <mgreer@animalcreek.com>,
	Joel A Fernandes <joelagnel@ti.com>
To: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33525 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab3EKRXt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 May 2013 13:23:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Calling runtime PM API for every block causes serious perf hit to
crypto operations that are done on a long buffer.
As crypto is performed on a page boundary, encrypting large buffers can
cause a series of crypto operations divided by page. The runtime PM API
is also called those many times.

We call runtime_pm_get_sync only at beginning of the session (cra_init)
and runtime_pm_put at the end. This result in upto a 50% speedup as below:

Before:
root@beagleboard:~# time -v openssl speed -evp aes-128-cbc
Doing aes-128-cbc for 3s on 16 size blocks: 13310 aes-128-cbc's in 0.01s
Doing aes-128-cbc for 3s on 64 size blocks: 13040 aes-128-cbc's in 0.04s
Doing aes-128-cbc for 3s on 256 size blocks: 9134 aes-128-cbc's in 0.03s
Doing aes-128-cbc for 3s on 1024 size blocks: 8939 aes-128-cbc's in 0.01s
Doing aes-128-cbc for 3s on 8192 size blocks: 4299 aes-128-cbc's in 0.00s

After:
root@beagleboard:~# time -v openssl speed -evp aes-128-cbc
Doing aes-128-cbc for 3s on 16 size blocks: 18911 aes-128-cbc's in 0.02s
Doing aes-128-cbc for 3s on 64 size blocks: 18878 aes-128-cbc's in 0.02s
Doing aes-128-cbc for 3s on 256 size blocks: 11878 aes-128-cbc's in 0.10s
Doing aes-128-cbc for 3s on 1024 size blocks: 11538 aes-128-cbc's in 0.05s
Doing aes-128-cbc for 3s on 8192 size blocks: 4857 aes-128-cbc's in 0.03s

While at it, also drop enter and exit pr_debugs, in related code. tracers
are exactly used for that.

Tested on a Beaglebone (AM335x SoC) board.

Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 drivers/crypto/omap-aes.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 6aa425f..e6474eb 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -208,7 +208,6 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 	 * It may be long delays between requests.
 	 * Device might go to off mode to save power.
 	 */
-	pm_runtime_get_sync(dd->dev);
 
 	if (!(dd->flags & FLAGS_INIT)) {
 		dd->flags |= FLAGS_INIT;
@@ -636,7 +635,6 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	pm_runtime_put(dd->dev);
 	dd->flags &= ~FLAGS_BUSY;
 
 	req->base.complete(&req->base, err);
@@ -837,8 +835,16 @@ static int omap_aes_ctr_decrypt(struct ablkcipher_request *req)
 
 static int omap_aes_cra_init(struct crypto_tfm *tfm)
 {
-	pr_debug("enter\n");
+	struct omap_aes_dev *dd = NULL;
+
+	/* Find AES device, currently picks the first device */
+	spin_lock_bh(&list_lock);
+	list_for_each_entry(dd, &dev_list, list) {
+		break;
+	}
+	spin_unlock_bh(&list_lock);
 
+	pm_runtime_get_sync(dd->dev);
 	tfm->crt_ablkcipher.reqsize = sizeof(struct omap_aes_reqctx);
 
 	return 0;
@@ -846,7 +852,16 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
 
 static void omap_aes_cra_exit(struct crypto_tfm *tfm)
 {
-	pr_debug("enter\n");
+	struct omap_aes_dev *dd = NULL;
+
+	/* Find AES device, currently picks the first device */
+	spin_lock_bh(&list_lock);
+	list_for_each_entry(dd, &dev_list, list) {
+		break;
+	}
+	spin_unlock_bh(&list_lock);
+
+	pm_runtime_put_sync(dd->dev);
 }
 
 /* ********************** ALGS ************************************ */
-- 
1.7.4.1
