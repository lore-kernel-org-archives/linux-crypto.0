From: Rick Altherr <raltherr@google.com>
Subject: [PATCH v2 1/3] hw_random: Migrate timeriomem_rng to new API
Date: Wed,  5 Apr 2017 16:20:58 -0700
Message-ID: <20170405232100.2023-2-raltherr@google.com>
References: <20170405232100.2023-1-raltherr@google.com>
Cc: openbmc@lists.ozlabs.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: alex@digriz.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170405232100.2023-1-raltherr@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Preserves the existing behavior of only returning 32-bits per call.

Signed-off-by: Rick Altherr <raltherr@google.com>
---

Changes in v2:
- Split API migration into separate patch

 drivers/char/hw_random/timeriomem-rng.c | 60 ++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index cf37db263ecd..17574452fd35 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -20,18 +20,16 @@
  * TODO: add support for reading sizes other than 32bits and masking
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/of.h>
+#include <linux/completion.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/timeriomem-rng.h>
-#include <linux/jiffies.h>
-#include <linux/sched.h>
 #include <linux/timer.h>
-#include <linux/completion.h>
 
 struct timeriomem_rng_private_data {
 	void __iomem		*io_base;
@@ -45,32 +43,36 @@ struct timeriomem_rng_private_data {
 	struct hwrng		timeriomem_rng_ops;
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
+	struct timeriomem_rng_private_data *priv =
+		container_of(hwrng, struct timeriomem_rng_private_data,
+				timeriomem_rng_ops);
+	unsigned long cur;
+	s32 delay;
 
-	if (!wait || priv->present)
-		return priv->present;
+	/* The RNG provides 32-bit per read.  Ensure there is enough space. */
+	if (max < sizeof(u32))
+		return 0;
 
-	wait_for_completion(&priv->completion);
+	/*
+	 * There may not have been enough time for new data to be generated
+	 * since the last request.  If the caller doesn't want to wait, let them
+	 * bail out.  Otherwise, wait for the completion.  If the new data has
+	 * already been generated, the completion should already be available.
+	 */
+	if (!wait && !priv->present)
+		return 0;
 
-	return 1;
-}
-
-static int timeriomem_rng_data_read(struct hwrng *rng, u32 *data)
-{
-	struct timeriomem_rng_private_data *priv = to_rng_priv(rng);
-	unsigned long cur;
-	s32 delay;
+	wait_for_completion(&priv->completion);
 
-	*data = readl(priv->io_base);
+	*(u32 *)data = readl(priv->io_base);
 
+	/*
+	 * Block any new callers until the RNG has had time to generate new
+	 * data.
+	 */
 	cur = jiffies;
 
 	delay = cur - priv->expires;
@@ -154,9 +156,7 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 	setup_timer(&priv->timer, timeriomem_rng_trigger, (unsigned long)priv);
 
 	priv->timeriomem_rng_ops.name		= dev_name(&pdev->dev);
-	priv->timeriomem_rng_ops.data_present	= timeriomem_rng_data_present;
-	priv->timeriomem_rng_ops.data_read	= timeriomem_rng_data_read;
-	priv->timeriomem_rng_ops.priv		= (unsigned long)priv;
+	priv->timeriomem_rng_ops.read		= timeriomem_rng_read;
 
 	priv->io_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->io_base)) {
-- 
2.12.2.715.g7642488e1d-goog
