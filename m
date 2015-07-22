From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 2/8] crypto: nx - remove pSeries NX 'status' field
Date: Wed, 22 Jul 2015 14:26:32 -0400
Message-ID: <1437589598-23917-3-git-send-email-ddstreet@ieee.org>
References: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove the 'status' field from the pSeries NX driver data.

The 'status' field isn't used by the driver at all; it simply checks the
devicetree status node at initialization, and returns success if 'okay'
and failure otherwise.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 39 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index fc59520..b375877 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -99,11 +99,6 @@ struct nx842_workmem {
 #define NX842_HW_PAGE_SIZE	(4096)
 #define NX842_HW_PAGE_MASK	(~(NX842_HW_PAGE_SIZE-1))
 
-enum nx842_status {
-	UNAVAILABLE,
-	AVAILABLE
-};
-
 struct ibm_nx842_counters {
 	atomic64_t comp_complete;
 	atomic64_t comp_failed;
@@ -121,7 +116,6 @@ static struct nx842_devdata {
 	unsigned int max_sg_len;
 	unsigned int max_sync_size;
 	unsigned int max_sync_sg;
-	enum nx842_status status;
 } __rcu *devdata;
 static DEFINE_SPINLOCK(devdata_mutex);
 
@@ -537,48 +531,36 @@ static int nx842_OF_set_defaults(struct nx842_devdata *devdata)
 		devdata->max_sync_size = 0;
 		devdata->max_sync_sg = 0;
 		devdata->max_sg_len = 0;
-		devdata->status = UNAVAILABLE;
 		return 0;
 	} else
 		return -ENOENT;
 }
 
 /**
- * nx842_OF_upd_status -- Update the device info from OF status prop
+ * nx842_OF_upd_status -- Check the device info from OF status prop
  *
  * The status property indicates if the accelerator is enabled.  If the
  * device is in the OF tree it indicates that the hardware is present.
  * The status field indicates if the device is enabled when the status
  * is 'okay'.  Otherwise the device driver will be disabled.
  *
- * @devdata - struct nx842_devdata to update
  * @prop - struct property point containing the maxsyncop for the update
  *
  * Returns:
  *  0 - Device is available
  *  -ENODEV - Device is not available
  */
-static int nx842_OF_upd_status(struct nx842_devdata *devdata,
-					struct property *prop) {
-	int ret = 0;
+static int nx842_OF_upd_status(struct property *prop)
+{
 	const char *status = (const char *)prop->value;
 
-	if (!strncmp(status, "okay", (size_t)prop->length)) {
-		devdata->status = AVAILABLE;
-	} else {
-		/*
-		 * Caller will log that the device is disabled, so only
-		 * output if there is an unexpected status.
-		 */
-		if (strncmp(status, "disabled", (size_t)prop->length)) {
-			dev_info(devdata->dev, "%s: status '%s' is not 'okay'\n",
-				__func__, status);
-		}
-		devdata->status = UNAVAILABLE;
-		ret = -ENODEV;
-	}
+	if (!strncmp(status, "okay", (size_t)prop->length))
+		return 0;
+	if (!strncmp(status, "disabled", (size_t)prop->length))
+		return -ENODEV;
+	dev_info(devdata->dev, "%s: unknown status '%s'\n", __func__, status);
 
-	return ret;
+	return -EINVAL;
 }
 
 /**
@@ -784,7 +766,7 @@ static int nx842_OF_upd(struct property *new_prop)
 		goto out;
 
 	/* Perform property updates */
-	ret = nx842_OF_upd_status(new_devdata, status);
+	ret = nx842_OF_upd_status(status);
 	if (ret)
 		goto error_out;
 
@@ -1100,7 +1082,6 @@ static int __init nx842_pseries_init(void)
 		pr_err("Could not allocate memory for device data\n");
 		return -ENOMEM;
 	}
-	new_devdata->status = UNAVAILABLE;
 	RCU_INIT_POINTER(devdata, new_devdata);
 
 	ret = vio_register_driver(&nx842_vio_driver);
-- 
2.1.0
