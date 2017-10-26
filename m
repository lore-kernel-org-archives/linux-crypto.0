From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 1/4] hw_random: core: Remove forward declaration by rearranging code
Date: Thu, 26 Oct 2017 21:04:24 +0530
Message-ID: <20171026153427.22334-2-prasannatsmkumar@gmail.com>
References: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, freude@linux.vnet.ibm.com,
        david.daney@cavium.com, clabbe.montjoie@gmail.com,
        linux-crypto@vger.kernel.org, mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:56969 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbdJZPfg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 11:35:36 -0400
Received: by mail-pg0-f68.google.com with SMTP id m18so2967617pgd.13
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 08:35:36 -0700 (PDT)
In-Reply-To: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rearrange drop_current_rng such that its forward declaration is not
required.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/core.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 9701ac7..8e1f43c 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -49,7 +49,6 @@ module_param(default_quality, ushort, 0644);
 MODULE_PARM_DESC(default_quality,
 		 "default entropy content of hwrng per mill");
 
-static void drop_current_rng(void);
 static int hwrng_init(struct hwrng *rng);
 static void start_khwrngd(void);
 
@@ -83,6 +82,17 @@ static inline void cleanup_rng(struct kref *kref)
 	complete(&rng->cleanup_done);
 }
 
+static void drop_current_rng(void)
+{
+	BUG_ON(!mutex_is_locked(&rng_mutex));
+	if (!current_rng)
+		return;
+
+	/* decrease last reference for triggering the cleanup */
+	kref_put(&current_rng->ref, cleanup_rng);
+	current_rng = NULL;
+}
+
 static int set_current_rng(struct hwrng *rng)
 {
 	int err;
@@ -99,17 +109,6 @@ static int set_current_rng(struct hwrng *rng)
 	return 0;
 }
 
-static void drop_current_rng(void)
-{
-	BUG_ON(!mutex_is_locked(&rng_mutex));
-	if (!current_rng)
-		return;
-
-	/* decrease last reference for triggering the cleanup */
-	kref_put(&current_rng->ref, cleanup_rng);
-	current_rng = NULL;
-}
-
 /* Returns ERR_PTR(), NULL or refcounted hwrng */
 static struct hwrng *get_current_rng(void)
 {
-- 
2.10.0
