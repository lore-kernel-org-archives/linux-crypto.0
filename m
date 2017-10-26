From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 3/4] hw_random: core: Rearranging start_khwrngd to remove forward declaration
Date: Thu, 26 Oct 2017 21:04:26 +0530
Message-ID: <20171026153427.22334-4-prasannatsmkumar@gmail.com>
References: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, freude@linux.vnet.ibm.com,
        david.daney@cavium.com, clabbe.montjoie@gmail.com,
        linux-crypto@vger.kernel.org, mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:52127 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932275AbdJZPfn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 11:35:43 -0400
Received: by mail-pf0-f194.google.com with SMTP id n14so2763396pfh.8
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 08:35:42 -0700 (PDT)
In-Reply-To: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rearrange start_khwrngd such that its forward declaration is not
required.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/core.c | 75 +++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 7e2b1a7..534c2ae 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -50,7 +50,6 @@ MODULE_PARM_DESC(default_quality,
 		 "default entropy content of hwrng per mill");
 
 static int hwrng_init(struct hwrng *rng);
-static void start_khwrngd(void);
 
 static size_t rng_buffer_size(void)
 {
@@ -153,6 +152,43 @@ static void put_rng(struct hwrng *rng)
 	mutex_unlock(&rng_mutex);
 }
 
+static int hwrng_fillfn(void *unused)
+{
+	long rc;
+
+	while (!kthread_should_stop()) {
+		struct hwrng *rng;
+
+		rng = get_current_rng();
+		if (IS_ERR(rng) || !rng)
+			break;
+		mutex_lock(&reading_mutex);
+		rc = rng_get_data(rng, rng_fillbuf,
+				  rng_buffer_size(), 1);
+		mutex_unlock(&reading_mutex);
+		put_rng(rng);
+		if (rc <= 0) {
+			pr_warn("hwrng: no data available\n");
+			msleep_interruptible(10000);
+			continue;
+		}
+		/* Outside lock, sure, but y'know: randomness. */
+		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
+					   rc * current_quality * 8 >> 10);
+	}
+	hwrng_fill = NULL;
+	return 0;
+}
+
+static void start_khwrngd(void)
+{
+	hwrng_fill = kthread_run(hwrng_fillfn, NULL, "hwrng");
+	if (IS_ERR(hwrng_fill)) {
+		pr_err("hwrng_fill thread creation failed");
+		hwrng_fill = NULL;
+	}
+}
+
 static int hwrng_init(struct hwrng *rng)
 {
 	if (kref_get_unless_zero(&rng->ref))
@@ -387,43 +423,6 @@ static int __init register_miscdev(void)
 	return misc_register(&rng_miscdev);
 }
 
-static int hwrng_fillfn(void *unused)
-{
-	long rc;
-
-	while (!kthread_should_stop()) {
-		struct hwrng *rng;
-
-		rng = get_current_rng();
-		if (IS_ERR(rng) || !rng)
-			break;
-		mutex_lock(&reading_mutex);
-		rc = rng_get_data(rng, rng_fillbuf,
-				  rng_buffer_size(), 1);
-		mutex_unlock(&reading_mutex);
-		put_rng(rng);
-		if (rc <= 0) {
-			pr_warn("hwrng: no data available\n");
-			msleep_interruptible(10000);
-			continue;
-		}
-		/* Outside lock, sure, but y'know: randomness. */
-		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
-					   rc * current_quality * 8 >> 10);
-	}
-	hwrng_fill = NULL;
-	return 0;
-}
-
-static void start_khwrngd(void)
-{
-	hwrng_fill = kthread_run(hwrng_fillfn, NULL, "hwrng");
-	if (IS_ERR(hwrng_fill)) {
-		pr_err("hwrng_fill thread creation failed");
-		hwrng_fill = NULL;
-	}
-}
-
 int hwrng_register(struct hwrng *rng)
 {
 	int err = -EINVAL;
-- 
2.10.0
