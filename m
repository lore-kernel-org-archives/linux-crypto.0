From: Rick Altherr <raltherr@google.com>
Subject: [PATCH v2 3/3] hw_random: timeriomem_rng: Improve performance for sub-jiffie update periods
Date: Wed,  5 Apr 2017 16:21:00 -0700
Message-ID: <20170405232100.2023-4-raltherr@google.com>
References: <20170405232100.2023-1-raltherr@google.com>
Cc: openbmc@lists.ozlabs.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: alex@digriz.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:35618 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756201AbdDEXVK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 19:21:10 -0400
Received: by mail-pg0-f45.google.com with SMTP id 81so18186312pgh.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2017 16:21:10 -0700 (PDT)
In-Reply-To: <20170405232100.2023-1-raltherr@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some hardware RNGs provide a single register for obtaining random data.
Instead of signaling when new data is available, the reader must wait a
fixed amount of time between reads for new data to be generated.
timeriomem_rng implements this scheme with the period specified in
platform data or device tree.  While the period is specified in
microseconds, the implementation used a standard timer which has a
minimum delay of 1 jiffie and caused a significant bottleneck for
devices that can update at 1us.  By switching to an hrtimer, 1us periods
now only delay at most 2us per read.

Signed-off-by: Rick Altherr <raltherr@google.com>
---

Changes in v2:
- Split performance improvements into separate patch

 drivers/char/hw_random/timeriomem-rng.c | 86 +++++++++++++++++----------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 024bdff7999f..a0faa5f05deb 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -21,23 +21,24 @@
  */
 
 #include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/hrtimer.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
-#include <linux/jiffies.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/time.h>
 #include <linux/timeriomem-rng.h>
-#include <linux/timer.h>
 
 struct timeriomem_rng_private {
 	void __iomem		*io_base;
-	unsigned int		expires;
-	unsigned int		period;
+	ktime_t			period;
 	unsigned int		present:1;
 
-	struct timer_list	timer;
+	struct hrtimer		timer;
 	struct completion	completion;
 
 	struct hwrng		rng_ops;
@@ -48,10 +49,13 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 {
 	struct timeriomem_rng_private *priv =
 		container_of(hwrng, struct timeriomem_rng_private, rng_ops);
-	unsigned long cur;
-	s32 delay;
+	int retval = 0;
+	int period_us = ktime_to_us(priv->period);
 
-	/* The RNG provides 32-bit per read.  Ensure there is enough space. */
+	/*
+	 * The RNG provides 32-bits per read.  Ensure there is enough space for
+	 * at minimum one read.
+	 */
 	if (max < sizeof(u32))
 		return 0;
 
@@ -66,33 +70,44 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
 
 	wait_for_completion(&priv->completion);
 
-	*(u32 *)data = readl(priv->io_base);
+	do {
+		/*
+		 * After the first read, all additional reads will need to wait
+		 * for the RNG to generate new data.  Since the period can have
+		 * a wide range of values (1us to 1s have been observed), allow
+		 * for 1% tolerance in the sleep time rather than a fixed value.
+		 */
+		if (retval > 0)
+			usleep_range(period_us,
+					period_us + min(1, period_us / 100));
+
+		*(u32 *)data = readl(priv->io_base);
+		retval += sizeof(u32);
+		data += sizeof(u32);
+		max -= sizeof(u32);
+	} while (wait && max > sizeof(u32));
 
 	/*
 	 * Block any new callers until the RNG has had time to generate new
 	 * data.
 	 */
-	cur = jiffies;
-
-	delay = cur - priv->expires;
-	delay = priv->period - (delay % priv->period);
-
-	priv->expires = cur + delay;
 	priv->present = 0;
-
 	reinit_completion(&priv->completion);
-	mod_timer(&priv->timer, priv->expires);
+	hrtimer_forward_now(&priv->timer, priv->period);
+	hrtimer_restart(&priv->timer);
 
-	return 4;
+	return retval;
 }
 
-static void timeriomem_rng_trigger(unsigned long data)
+static enum hrtimer_restart timeriomem_rng_trigger(struct hrtimer *timer)
 {
 	struct timeriomem_rng_private *priv
-			= (struct timeriomem_rng_private *)data;
+		= container_of(timer, struct timeriomem_rng_private, timer);
 
 	priv->present = 1;
 	complete(&priv->completion);
+
+	return HRTIMER_NORESTART;
 }
 
 static int timeriomem_rng_probe(struct platform_device *pdev)
@@ -140,43 +155,33 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 		period = pdata->period;
 	}
 
-	priv->period = usecs_to_jiffies(period);
-	if (priv->period < 1) {
-		dev_err(&pdev->dev, "period is less than one jiffy\n");
-		return -EINVAL;
-	}
-
-	priv->expires	= jiffies;
-	priv->present	= 1;
-
+	priv->period = ns_to_ktime(period * NSEC_PER_USEC);
 	init_completion(&priv->completion);
-	complete(&priv->completion);
-
-	setup_timer(&priv->timer, timeriomem_rng_trigger, (unsigned long)priv);
+	hrtimer_init(&priv->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	priv->timer.function = timeriomem_rng_trigger;
 
 	priv->rng_ops.name = dev_name(&pdev->dev);
 	priv->rng_ops.read = timeriomem_rng_read;
 
 	priv->io_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->io_base)) {
-		err = PTR_ERR(priv->io_base);
-		goto out_timer;
+		return PTR_ERR(priv->io_base);
 	}
 
+	/* Assume random data is already available. */
+	priv->present = 1;
+	complete(&priv->completion);
+
 	err = hwrng_register(&priv->rng_ops);
 	if (err) {
 		dev_err(&pdev->dev, "problem registering\n");
-		goto out_timer;
+		return err;
 	}
 
 	dev_info(&pdev->dev, "32bits from 0x%p @ %dus\n",
 			priv->io_base, period);
 
 	return 0;
-
-out_timer:
-	del_timer_sync(&priv->timer);
-	return err;
 }
 
 static int timeriomem_rng_remove(struct platform_device *pdev)
@@ -184,8 +189,7 @@ static int timeriomem_rng_remove(struct platform_device *pdev)
 	struct timeriomem_rng_private *priv = platform_get_drvdata(pdev);
 
 	hwrng_unregister(&priv->rng_ops);
-
-	del_timer_sync(&priv->timer);
+	hrtimer_cancel(&priv->timer);
 
 	return 0;
 }
-- 
2.12.2.715.g7642488e1d-goog
