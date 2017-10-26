From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 4/4] hw_random: core: Remove forward declaration of hwrng_init
Date: Thu, 26 Oct 2017 21:04:27 +0530
Message-ID: <20171026153427.22334-5-prasannatsmkumar@gmail.com>
References: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, freude@linux.vnet.ibm.com,
        david.daney@cavium.com, clabbe.montjoie@gmail.com,
        linux-crypto@vger.kernel.org, mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:55680 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbdJZPfq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 11:35:46 -0400
Received: by mail-pf0-f193.google.com with SMTP id 17so2759324pfn.12
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 08:35:46 -0700 (PDT)
In-Reply-To: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rearrange set_current_rng such that hwrng_init's forward declaration can
be removed.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/core.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 534c2ae..328d065 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -49,8 +49,6 @@ module_param(default_quality, ushort, 0644);
 MODULE_PARM_DESC(default_quality,
 		 "default entropy content of hwrng per mill");
 
-static int hwrng_init(struct hwrng *rng);
-
 static size_t rng_buffer_size(void)
 {
 	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
@@ -108,22 +106,6 @@ static void drop_current_rng(void)
 	current_rng = NULL;
 }
 
-static int set_current_rng(struct hwrng *rng)
-{
-	int err;
-
-	BUG_ON(!mutex_is_locked(&rng_mutex));
-
-	err = hwrng_init(rng);
-	if (err)
-		return err;
-
-	drop_current_rng();
-	current_rng = rng;
-
-	return 0;
-}
-
 /* Returns ERR_PTR(), NULL or refcounted hwrng */
 static struct hwrng *get_current_rng(void)
 {
@@ -220,6 +202,22 @@ static int hwrng_init(struct hwrng *rng)
 	return 0;
 }
 
+static int set_current_rng(struct hwrng *rng)
+{
+	int err;
+
+	BUG_ON(!mutex_is_locked(&rng_mutex));
+
+	err = hwrng_init(rng);
+	if (err)
+		return err;
+
+	drop_current_rng();
+	current_rng = rng;
+
+	return 0;
+}
+
 static int rng_dev_open(struct inode *inode, struct file *filp)
 {
 	/* enforce read-only access to this chrdev */
-- 
2.10.0
