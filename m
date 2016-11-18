From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hw_random: Make explicit that max >= 32 always
Date: Fri, 18 Nov 2016 23:00:10 +0530
Message-ID: <20161118173010.5448-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        daniel.thompson@linaro.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33802 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbcKRRaj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2016 12:30:39 -0500
Received: by mail-pg0-f67.google.com with SMTP id e9so20819927pgc.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2016 09:30:39 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As hw_random core calls ->read with max > 32 or more, make it explicit.
Also remove checks involving 'max' being less than 8.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/msm-rng.c     | 4 ----
 drivers/char/hw_random/pic32-rng.c   | 3 ---
 drivers/char/hw_random/pseries-rng.c | 5 ++---
 include/linux/hw_random.h            | 3 +--
 4 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/char/hw_random/msm-rng.c b/drivers/char/hw_random/msm-rng.c
index 96fb986..841fee8 100644
--- a/drivers/char/hw_random/msm-rng.c
+++ b/drivers/char/hw_random/msm-rng.c
@@ -90,10 +90,6 @@ static int msm_rng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
 	/* calculate max size bytes to transfer back to caller */
 	maxsize = min_t(size_t, MAX_HW_FIFO_SIZE, max);
 
-	/* no room for word data */
-	if (maxsize < WORD_SZ)
-		return 0;
-
 	ret = clk_prepare_enable(rng->clk);
 	if (ret)
 		return ret;
diff --git a/drivers/char/hw_random/pic32-rng.c b/drivers/char/hw_random/pic32-rng.c
index 11dc9b7..9b5e68a 100644
--- a/drivers/char/hw_random/pic32-rng.c
+++ b/drivers/char/hw_random/pic32-rng.c
@@ -62,9 +62,6 @@ static int pic32_rng_read(struct hwrng *rng, void *buf, size_t max,
 	u32 t;
 	unsigned int timeout = RNG_TIMEOUT;
 
-	if (max < 8)
-		return 0;
-
 	do {
 		t = readl(priv->base + RNGRCNT) & RCNT_MASK;
 		if (t == 64) {
diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index 63ce51d..d9f46b4 100644
--- a/drivers/char/hw_random/pseries-rng.c
+++ b/drivers/char/hw_random/pseries-rng.c
@@ -28,7 +28,6 @@
 static int pseries_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	u64 buffer[PLPAR_HCALL_BUFSIZE];
-	size_t size = max < 8 ? max : 8;
 	int rc;
 
 	rc = plpar_hcall(H_RANDOM, (unsigned long *)buffer);
@@ -36,10 +35,10 @@ static int pseries_rng_read(struct hwrng *rng, void *data, size_t max, bool wait
 		pr_err_ratelimited("H_RANDOM call failed %d\n", rc);
 		return -EIO;
 	}
-	memcpy(data, buffer, size);
+	memcpy(data, buffer, 8);
 
 	/* The hypervisor interface returns 64 bits */
-	return size;
+	return 8;
 }
 
 /**
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 34a0dc1..bee0827 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -30,8 +30,7 @@
  *			Must not be NULL.    *OBSOLETE*
  * @read:		New API. drivers can fill up to max bytes of data
  *			into the buffer. The buffer is aligned for any type
- *			and max is guaranteed to be >= to that alignment
- *			(either 4 or 8 depending on architecture).
+ *			and max is a multiple of 4 and >= 32 bytes.
  * @priv:		Private data, for use by the RNG driver.
  * @quality:		Estimation of true entropy in RNG's bitstream
  *			(per mill).
-- 
2.9.3
