From: Feng Kan <fkan@apm.com>
Subject: [PATCH] rng: xgene-rng: add ACPI support for APM X-Gene RNG unit
Date: Fri,  6 Mar 2015 14:53:15 -0800
Message-ID: <1425682395-17821-1-git-send-email-fkan@apm.com>
Cc: Feng Kan <fkan@apm.com>
To: patches@apm.com, mpm@selenic.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This adds ACPI support for APM X-Gene RNG unit.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/char/hw_random/xgene-rng.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index 23caa05..c37cf75 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/hw_random.h>
@@ -310,6 +311,14 @@ static int xgene_rng_init(struct hwrng *rng)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id xgene_rng_acpi_match[] = {
+	{ "APMC0D18", },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, xgene_rng_acpi_match);
+#endif
+
 static struct hwrng xgene_rng_func = {
 	.name		= "xgene-rng",
 	.init		= xgene_rng_init,
@@ -415,6 +424,7 @@ static struct platform_driver xgene_rng_driver = {
 	.driver = {
 		.name		= "xgene-rng",
 		.of_match_table = xgene_rng_of_match,
+		.acpi_match_table = ACPI_PTR(xgene_rng_acpi_match),
 	},
 };
 
-- 
1.9.1
