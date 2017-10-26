From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 2/4] hw_random: core: Rearranging rng_get_data to remove forward declaration
Date: Thu, 26 Oct 2017 21:04:25 +0530
Message-ID: <20171026153427.22334-3-prasannatsmkumar@gmail.com>
References: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, freude@linux.vnet.ibm.com,
        david.daney@cavium.com, clabbe.montjoie@gmail.com,
        linux-crypto@vger.kernel.org, mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:51062 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbdJZPfj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 11:35:39 -0400
Received: by mail-pf0-f195.google.com with SMTP id b6so2769906pfh.7
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 08:35:39 -0700 (PDT)
In-Reply-To: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rearrange rng_get_data such that its forward declaration is not
required.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/core.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 8e1f43c..7e2b1a7 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -52,14 +52,30 @@ MODULE_PARM_DESC(default_quality,
 static int hwrng_init(struct hwrng *rng);
 static void start_khwrngd(void);
 
-static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
-			       int wait);
-
 static size_t rng_buffer_size(void)
 {
 	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
 }
 
+static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
+			int wait) {
+	int present;
+
+	BUG_ON(!mutex_is_locked(&reading_mutex));
+	if (rng->read)
+		return rng->read(rng, (void *)buffer, size, wait);
+
+	if (rng->data_present)
+		present = rng->data_present(rng, wait);
+	else
+		present = 1;
+
+	if (present)
+		return rng->data_read(rng, (u32 *)buffer);
+
+	return 0;
+}
+
 static void add_early_randomness(struct hwrng *rng)
 {
 	int bytes_read;
@@ -178,25 +194,6 @@ static int rng_dev_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
-			int wait) {
-	int present;
-
-	BUG_ON(!mutex_is_locked(&reading_mutex));
-	if (rng->read)
-		return rng->read(rng, (void *)buffer, size, wait);
-
-	if (rng->data_present)
-		present = rng->data_present(rng, wait);
-	else
-		present = 1;
-
-	if (present)
-		return rng->data_read(rng, (u32 *)buffer);
-
-	return 0;
-}
-
 static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			    size_t size, loff_t *offp)
 {
-- 
2.10.0
