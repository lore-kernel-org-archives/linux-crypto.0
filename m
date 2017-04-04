From: Rick Altherr <raltherr@google.com>
Subject: [PATCH v1] hw_random: Fix timeriomem_rng for sub-jiffie update periods
Date: Tue,  4 Apr 2017 14:43:07 -0700
Message-ID: <20170404214307.7748-1-raltherr@google.com>
Cc: openbmc@lists.ozlabs.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: alex@digriz.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:35304 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753363AbdDDVnL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2017 17:43:11 -0400
Received: by mail-pg0-f41.google.com with SMTP id 81so164269248pgh.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Apr 2017 14:43:11 -0700 (PDT)
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

Migrated to new hw_random API while I in this driver.

Signed-off-by: Rick Altherr <raltherr@google.com>
---

 drivers/char/hw_random/timeriomem-rng.c | 153 ++++++++++++++++----------------
 1 file changed, 75 insertions(+), 78 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index cf37db263ecd..7482de2ca71c 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -20,90 +20,99 @@
  * TODO: add support for reading sizes other than 32bits and masking
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/of.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/hrtimer.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/time.h>
 #include <linux/timeriomem-rng.h>
-#include <linux/jiffies.h>
-#include <linux/sched.h>
-#include <linux/timer.h>
-#include <linux/completion.h>
 
-struct timeriomem_rng_private_data {
+struct timeriomem_rng_private {
 	void __iomem		*io_base;
-	unsigned int		expires;
-	unsigned int		period;
+	ktime_t			period;
 	unsigned int		present:1;
 
-	struct timer_list	timer;
+	struct hrtimer		timer;
 	struct completion	completion;
 
-	struct hwrng		timeriomem_rng_ops;
+	struct hwrng		rng_ops;
 };
 
-#define to_rng_priv(rng) \
-		((struct timeriomem_rng_private_data *)rng->priv)
-
-/*
- * have data return 1, however return 0 if we have nothing
- */
-static int timeriomem_rng_data_present(struct hwrng *rng, int wait)
+static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
+				size_t max, bool wait)
 {
-	struct timeriomem_rng_private_data *priv = to_rng_priv(rng);
-
-	if (!wait || priv->present)
-		return priv->present;
+	struct timeriomem_rng_private *priv =
+		container_of(hwrng, struct timeriomem_rng_private, rng_ops);
+	int retval = 0;
+	int period_us = ktime_to_us(priv->period);
+
+	/*
+	 * There may not have been enough time for new data to be generated
+	 * since the last request.  If the caller doesn't want to wait, let them
+	 * bail out.  Otherwise, wait for the completion.  If the new data has
+	 * already been generated, the completion should already be available.
+	 */
+	if (!wait && !priv->present)
+		return 0;
 
 	wait_for_completion(&priv->completion);
 
-	return 1;
-}
-
-static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
-{
-	struct timeriomem_rng_private_data *priv = to_rng_priv(rng);
-	unsigned long cur;
-	s32 delay;
-
-	*data = readl(priv->io_base);
-
-	cur = jiffies;
-
-	delay = cur - priv->expires;
-	delay = priv->period - (delay % priv->period);
-
-	priv->expires = cur + delay;
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
+
+	/*
+	 * Block any new callers until the RNG has had time to generate new
+	 * data.
+	 */
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
-	struct timeriomem_rng_private_data *priv
-			= (struct timeriomem_rng_private_data *)data;
+	struct timeriomem_rng_private *priv
+		= container_of(timer, struct timeriomem_rng_private, timer);
 
 	priv->present = 1;
 	complete(&priv->completion);
+
+	return HRTIMER_NORESTART;
 }
 
 static int timeriomem_rng_probe(struct platform_device *pdev)
 {
 	struct timeriomem_rng_data *pdata = pdev->dev.platform_data;
-	struct timeriomem_rng_private_data *priv;
+	struct timeriomem_rng_private *priv;
 	struct resource *res;
 	int err = 0;
 	int period;
 
 	if (!pdev->dev.of_node && !pdata) {
-		dev_err(&pdev->dev, "timeriomem_rng_data is missing\n");
+		dev_err(&pdev->dev, "timeriomem_rng_private is missing\n");
 		return -EINVAL;
 	}
 
@@ -119,7 +128,7 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 
 	/* Allocate memory for the device structure (and zero it) */
 	priv = devm_kzalloc(&pdev->dev,
-			sizeof(struct timeriomem_rng_private_data), GFP_KERNEL);
+			sizeof(struct timeriomem_rng_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -139,54 +148,42 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
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
+	hrtimer_init(&priv->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	priv->timer.function = timeriomem_rng_trigger;
 
-	setup_timer(&priv->timer, timeriomem_rng_trigger, (unsigned long)priv);
-
-	priv->timeriomem_rng_ops.name		= dev_name(&pdev->dev);
-	priv->timeriomem_rng_ops.data_present	= timeriomem_rng_data_present;
-	priv->timeriomem_rng_ops.data_read	= timeriomem_rng_data_read;
-	priv->timeriomem_rng_ops.priv		= (unsigned long)priv;
+	priv->rng_ops.name		= dev_name(&pdev->dev);
+	priv->rng_ops.read	= timeriomem_rng_read;
+	priv->rng_ops.priv		= (unsigned long)priv;
 
 	priv->io_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->io_base)) {
-		err = PTR_ERR(priv->io_base);
-		goto out_timer;
+		return PTR_ERR(priv->io_base);
 	}
 
-	err = hwrng_register(&priv->timeriomem_rng_ops);
+	/* Assume random data is already available. */
+	priv->present = 1;
+	complete(&priv->completion);
+
+	err = hwrng_register(&priv->rng_ops);
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
 {
-	struct timeriomem_rng_private_data *priv = platform_get_drvdata(pdev);
-
-	hwrng_unregister(&priv->timeriomem_rng_ops);
+	struct timeriomem_rng_private *priv = platform_get_drvdata(pdev);
 
-	del_timer_sync(&priv->timer);
+	hwrng_unregister(&priv->rng_ops);
+	hrtimer_cancel(&priv->timer);
 
 	return 0;
 }
-- 
2.12.2.715.g7642488e1d-goog
