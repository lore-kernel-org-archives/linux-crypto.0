From: Shannon Nelson <shannon.nelson@oracle.com>
Subject: [PATCH 2/4] n2rng: add device data descriptions
Date: Thu, 12 Jan 2017 10:52:47 -0800
Message-ID: <1484247169-245086-3-git-send-email-shannon.nelson@oracle.com>
References: <1484247169-245086-1-git-send-email-shannon.nelson@oracle.com>
Cc: sparclinux@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@oracle.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484247169-245086-1-git-send-email-shannon.nelson@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Since we're going to need to keep track of more than just one
attribute of the hardware, we'll change the use of the data field
from the match struct from a single flag to a struct pointer.
This patch adds the struct template and initial descriptions.

Signed-off-by: Shannon Nelson <shannon.nelson@oracle.com>
---
 drivers/char/hw_random/n2-drv.c |   47 ++++++++++++++++++++++++++++++++------
 drivers/char/hw_random/n2rng.h  |   15 ++++++++++++
 2 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 102560f..74c26c7 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -625,24 +625,23 @@ static void n2rng_driver_version(void)
 static int n2rng_probe(struct platform_device *op)
 {
 	const struct of_device_id *match;
-	int multi_capable;
 	int err = -ENOMEM;
 	struct n2rng *np;
 
 	match = of_match_device(n2rng_match, &op->dev);
 	if (!match)
 		return -EINVAL;
-	multi_capable = (match->data != NULL);
 
 	n2rng_driver_version();
 	np = devm_kzalloc(&op->dev, sizeof(*np), GFP_KERNEL);
 	if (!np)
 		goto out;
 	np->op = op;
+	np->data = (struct n2rng_template *)match->data;
 
 	INIT_DELAYED_WORK(&np->work, n2rng_work);
 
-	if (multi_capable)
+	if (np->data->multi_capable)
 		np->flags |= N2RNG_FLAG_MULTI;
 
 	err = -ENODEV;
@@ -673,8 +672,9 @@ static int n2rng_probe(struct platform_device *op)
 			dev_err(&op->dev, "VF RNG lacks rng-#units property\n");
 			goto out_hvapi_unregister;
 		}
-	} else
+	} else {
 		np->num_units = 1;
+	}
 
 	dev_info(&op->dev, "Registered RNG HVAPI major %lu minor %lu\n",
 		 np->hvapi_major, np->hvapi_minor);
@@ -731,30 +731,61 @@ static int n2rng_remove(struct platform_device *op)
 	return 0;
 }
 
+static struct n2rng_template n2_template = {
+	.id = N2_n2_rng,
+	.multi_capable = 0,
+	.chip_version = 1,
+};
+
+static struct n2rng_template vf_template = {
+	.id = N2_vf_rng,
+	.multi_capable = 1,
+	.chip_version = 1,
+};
+
+static struct n2rng_template kt_template = {
+	.id = N2_kt_rng,
+	.multi_capable = 1,
+	.chip_version = 1,
+};
+
+static struct n2rng_template m4_template = {
+	.id = N2_m4_rng,
+	.multi_capable = 1,
+	.chip_version = 2,
+};
+
+static struct n2rng_template m7_template = {
+	.id = N2_m7_rng,
+	.multi_capable = 1,
+	.chip_version = 2,
+};
+
 static const struct of_device_id n2rng_match[] = {
 	{
 		.name		= "random-number-generator",
 		.compatible	= "SUNW,n2-rng",
+		.data		= &n2_template,
 	},
 	{
 		.name		= "random-number-generator",
 		.compatible	= "SUNW,vf-rng",
-		.data		= (void *) 1,
+		.data		= &vf_template,
 	},
 	{
 		.name		= "random-number-generator",
 		.compatible	= "SUNW,kt-rng",
-		.data		= (void *) 1,
+		.data		= &kt_template,
 	},
 	{
 		.name		= "random-number-generator",
 		.compatible	= "ORCL,m4-rng",
-		.data		= (void *) 1,
+		.data		= &m4_template,
 	},
 	{
 		.name		= "random-number-generator",
 		.compatible	= "ORCL,m7-rng",
-		.data		= (void *) 1,
+		.data		= &m7_template,
 	},
 	{},
 };
diff --git a/drivers/char/hw_random/n2rng.h b/drivers/char/hw_random/n2rng.h
index f244ac8..e41e55a 100644
--- a/drivers/char/hw_random/n2rng.h
+++ b/drivers/char/hw_random/n2rng.h
@@ -60,6 +60,20 @@ extern unsigned long sun4v_rng_data_read_diag_v2(unsigned long data_ra,
 extern unsigned long sun4v_rng_data_read(unsigned long data_ra,
 					 unsigned long *tick_delta);
 
+enum n2rng_compat_id {
+	N2_n2_rng,
+	N2_vf_rng,
+	N2_kt_rng,
+	N2_m4_rng,
+	N2_m7_rng,
+};
+
+struct n2rng_template {
+	enum n2rng_compat_id id;
+	int multi_capable;
+	int chip_version;
+};
+
 struct n2rng_unit {
 	u64			control[HV_RNG_NUM_CONTROL];
 };
@@ -74,6 +88,7 @@ struct n2rng {
 #define N2RNG_FLAG_SHUTDOWN	0x00000010 /* Driver unregistering        */
 #define N2RNG_FLAG_BUFFER_VALID	0x00000020 /* u32 buffer holds valid data */
 
+	struct n2rng_template	*data;
 	int			num_units;
 	struct n2rng_unit	*units;
 
-- 
1.7.1
