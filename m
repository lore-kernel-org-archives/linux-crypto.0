From: Patrick McHardy <kaber@trash.net>
Subject: [HWRNG 01/03]: move status polling loop to data_present callbacks
Date: Sun, 18 Nov 2007 22:32:53 +0100 (MET)
Message-ID: <20071118213243.9217.21179.sendpatchset@localhost.localdomain>
References: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Cc: johnpol@2ka.mipt.ru, Patrick McHardy <kaber@trash.net>,
	linux-crypto@vger.kernel.org, mb@bu3sch.de,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46266 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbXKRVcz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 16:32:55 -0500
In-Reply-To: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[HWRNG]: move status polling loop to data_present callbacks

Handle waiting for new random within the drivers themselves, this allows to
use better suited timeouts for the individual rngs.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5632554998aafc5605635f842bca50d5353cd9d4
tree 161324874febaf01d70ab2dd0b434db962108265
parent 92704884669e1af381feb364bc83985a63934c56
author Patrick McHardy <kaber@trash.net> Sun, 18 Nov 2007 22:09:05 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 18 Nov 2007 22:09:05 +0100

 drivers/char/hw_random/amd-rng.c    |   12 ++++++++++--
 drivers/char/hw_random/core.c       |   24 ++++++------------------
 drivers/char/hw_random/geode-rng.c  |   12 ++++++++++--
 drivers/char/hw_random/intel-rng.c  |   15 ++++++++++++---
 drivers/char/hw_random/omap-rng.c   |   13 +++++++++++--
 drivers/char/hw_random/pasemi-rng.c |   14 +++++++++++---
 drivers/char/hw_random/via-rng.c    |   19 ++++++++++++-------
 include/linux/hw_random.h           |    2 +-
 8 files changed, 73 insertions(+), 38 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 556fd81..c422e87 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/hw_random.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 
 
@@ -52,11 +53,18 @@ MODULE_DEVICE_TABLE(pci, pci_tbl);
 static struct pci_dev *amd_pdev;
 
 
-static int amd_rng_data_present(struct hwrng *rng)
+static int amd_rng_data_present(struct hwrng *rng, int wait)
 {
 	u32 pmbase = (u32)rng->priv;
+	int data, i;
 
-      	return !!(inl(pmbase + 0xF4) & 1);
+	for (i = 0; i < 20; i++) {
+		data = !!(inl(pmbase + 0xF4) & 1);
+		if (data || !wait)
+			break;
+		udelay(10);
+	}
+	return data;
 }
 
 static int amd_rng_data_read(struct hwrng *rng, u32 *data)
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 26a860a..0118b98 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -66,11 +66,11 @@ static inline void hwrng_cleanup(struct hwrng *rng)
 		rng->cleanup(rng);
 }
 
-static inline int hwrng_data_present(struct hwrng *rng)
+static inline int hwrng_data_present(struct hwrng *rng, int wait)
 {
 	if (!rng->data_present)
 		return 1;
-	return rng->data_present(rng);
+	return rng->data_present(rng, wait);
 }
 
 static inline int hwrng_data_read(struct hwrng *rng, u32 *data)
@@ -94,8 +94,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 {
 	u32 data;
 	ssize_t ret = 0;
-	int i, err = 0;
-	int data_present;
+	int err = 0;
 	int bytes_read;
 
 	while (size) {
@@ -107,21 +106,10 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			err = -ENODEV;
 			goto out;
 		}
-		if (filp->f_flags & O_NONBLOCK) {
-			data_present = hwrng_data_present(current_rng);
-		} else {
-			/* Some RNG require some time between data_reads to gather
-			 * new entropy. Poll it.
-			 */
-			for (i = 0; i < 20; i++) {
-				data_present = hwrng_data_present(current_rng);
-				if (data_present)
-					break;
-				udelay(10);
-			}
-		}
+
 		bytes_read = 0;
-		if (data_present)
+		if (hwrng_data_present(current_rng,
+				       !(filp->f_flags & O_NONBLOCK)))
 			bytes_read = hwrng_data_read(current_rng, &data);
 		mutex_unlock(&rng_mutex);
 
diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 8e8658d..fed4ef5 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/hw_random.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 
 
@@ -61,11 +62,18 @@ static int geode_rng_data_read(struct hwrng *rng, u32 *data)
 	return 4;
 }
 
-static int geode_rng_data_present(struct hwrng *rng)
+static int geode_rng_data_present(struct hwrng *rng, int wait)
 {
 	void __iomem *mem = (void __iomem *)rng->priv;
+	int data, i;
 
-	return !!(readl(mem + GEODE_RNG_STATUS_REG));
+	for (i = 0; i < 20; i++) {
+		data = !!(readl(mem + GEODE_RNG_STATUS_REG));
+		if (data || !wait)
+			break;
+		udelay(10);
+	}
+	return data;
 }
 
 
diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 753f460..5cc651e 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/stop_machine.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 
 
@@ -162,11 +163,19 @@ static inline u8 hwstatus_set(void __iomem *mem,
 	return hwstatus_get(mem);
 }
 
-static int intel_rng_data_present(struct hwrng *rng)
+static int intel_rng_data_present(struct hwrng *rng, int wait)
 {
 	void __iomem *mem = (void __iomem *)rng->priv;
-
-	return !!(readb(mem + INTEL_RNG_STATUS) & INTEL_RNG_DATA_PRESENT);
+	int data, i;
+
+	for (i = 0; i < 20; i++) {
+		data = !!(readb(mem + INTEL_RNG_STATUS) &
+			  INTEL_RNG_DATA_PRESENT);
+		if (data || !wait)
+			break;
+		udelay(10);
+	}
+	return data;
 }
 
 static int intel_rng_data_read(struct hwrng *rng, u32 *data)
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 3f35a1c..7e31995 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -29,6 +29,7 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 
@@ -65,9 +66,17 @@ static void omap_rng_write_reg(int reg, u32 val)
 }
 
 /* REVISIT: Does the status bit really work on 16xx? */
-static int omap_rng_data_present(struct hwrng *rng)
+static int omap_rng_data_present(struct hwrng *rng, int wait)
 {
-	return omap_rng_read_reg(RNG_STAT_REG) ? 0 : 1;
+	int data, i;
+
+	for (i = 0; i < 20; i++) {
+		data = omap_rng_read_reg(RNG_STAT_REG) ? 0 : 1;
+		if (data || !wait)
+			break;
+		udelay(10);
+	}
+	return data;
 }
 
 static int omap_rng_data_read(struct hwrng *rng, u32 *data)
diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index fa6040b..621adf2 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
+#include <linux/delay.h>
 #include <asm/of_platform.h>
 #include <asm/io.h>
 
@@ -44,9 +45,16 @@
 static int pasemi_rng_data_present(struct hwrng *rng)
 {
 	void __iomem *rng_regs = (void __iomem *)rng->priv;
-
-	return (in_le32(rng_regs + SDCRNG_CTL_REG)
-		& SDCRNG_CTL_FVLD_M) ? 1 : 0;
+	int data, i;
+
+	for (i = 0; i < 20; i++) {
+		data = (in_le32(rng_regs + SDCRNG_CTL_REG)
+			& SDCRNG_CTL_FVLD_M) ? 1 : 0;
+		if (data || !wait)
+			break;
+		udelay(10);
+	}
+	return data;
 }
 
 static int pasemi_rng_data_read(struct hwrng *rng, u32 *data)
diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index ec435cb..868e39f 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/hw_random.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -77,10 +78,11 @@ static inline u32 xstore(u32 *addr, u32 edx_in)
 	return eax_out;
 }
 
-static int via_rng_data_present(struct hwrng *rng)
+static int via_rng_data_present(struct hwrng *rng, int wait)
 {
 	u32 bytes_out;
 	u32 *via_rng_datum = (u32 *)(&rng->priv);
+	int i;
 
 	/* We choose the recommended 1-byte-per-instruction RNG rate,
 	 * for greater randomness at the expense of speed.  Larger
@@ -95,12 +97,15 @@ static int via_rng_data_present(struct hwrng *rng)
 	 * completes.
 	 */
 
-	*via_rng_datum = 0; /* paranoia, not really necessary */
-	bytes_out = xstore(via_rng_datum, VIA_RNG_CHUNK_1);
-	bytes_out &= VIA_XSTORE_CNT_MASK;
-	if (bytes_out == 0)
-		return 0;
-	return 1;
+	for (i = 0; i < 20; i++) {
+		*via_rng_datum = 0; /* paranoia, not really necessary */
+		bytes_out = xstore(via_rng_datum, VIA_RNG_CHUNK_1);
+		bytes_out &= VIA_XSTORE_CNT_MASK;
+		if (bytes_out || !wait)
+			break;
+		udelay(10);
+	}
+	return bytes_out ? 1 : 0;
 }
 
 static int via_rng_data_read(struct hwrng *rng, u32 *data)
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 21ea761..85d1191 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -33,7 +33,7 @@ struct hwrng {
 	const char *name;
 	int (*init)(struct hwrng *rng);
 	void (*cleanup)(struct hwrng *rng);
-	int (*data_present)(struct hwrng *rng);
+	int (*data_present)(struct hwrng *rng, int wait);
 	int (*data_read)(struct hwrng *rng, u32 *data);
 	unsigned long priv;
 
