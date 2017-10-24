From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH] tpm: Move Linux RNG connection to hwrng
Date: Tue, 24 Oct 2017 12:42:35 -0600
Message-ID: <20171024184235.GC1806@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Matt Mackall <mpm@selenic.com>,
        David Safford <safford@us.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The tpm-rng.c approach is completely inconsistent with how the kernel
handles hotplug. Instead manage a hwrng device for each TPM. This will
cause the kernel to read entropy from the TPM when it is plugged in,
and allow access to the TPM rng via /dev/hwrng.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/hw_random/Kconfig   | 13 -----------
 drivers/char/hw_random/Makefile  |  1 -
 drivers/char/hw_random/tpm-rng.c | 50 ----------------------------------------
 drivers/char/tpm/Kconfig         | 13 +++++++++++
 drivers/char/tpm/tpm-chip.c      | 41 ++++++++++++++++++++++++++++----
 drivers/char/tpm/tpm-interface.c | 37 ++++++++++++++++-------------
 drivers/char/tpm/tpm.h           |  5 ++++
 7 files changed, 76 insertions(+), 84 deletions(-)
 delete mode 100644 drivers/char/hw_random/tpm-rng.c

All,

It is such a good idea, I took PrasannaKumar's patch, reviewed and
revised it to the level it could be merged.

This is compile tested only.

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 95a031e9eced07..a20fed182cbcce 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -306,19 +306,6 @@ config HW_RANDOM_POWERNV
 
 	  If unsure, say Y.
 
-config HW_RANDOM_TPM
-	tristate "TPM HW Random Number Generator support"
-	depends on TCG_TPM
-	default HW_RANDOM
-	---help---
-	  This driver provides kernel-side support for the Random Number
-	  Generator in the Trusted Platform Module
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tpm-rng.
-
-	  If unsure, say Y.
-
 config HW_RANDOM_HISI
 	tristate "Hisilicon Random Number Generator support"
 	depends on HW_RANDOM && ARCH_HISI
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 39a67defac67cb..91cb8e8213e7c1 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -26,7 +26,6 @@ obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
 obj-$(CONFIG_HW_RANDOM_HISI)	+= hisi-rng.o
-obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
 obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
 obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
 obj-$(CONFIG_HW_RANDOM_MSM) += msm-rng.o
diff --git a/drivers/char/hw_random/tpm-rng.c b/drivers/char/hw_random/tpm-rng.c
deleted file mode 100644
index d6d448266f0752..00000000000000
--- a/drivers/char/hw_random/tpm-rng.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Copyright (C) 2012 Kent Yoder IBM Corporation
- *
- * HWRNG interfaces to pull RNG data from a TPM
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- */
-
-#include <linux/module.h>
-#include <linux/hw_random.h>
-#include <linux/tpm.h>
-
-#define MODULE_NAME "tpm-rng"
-
-static int tpm_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
-{
-	return tpm_get_random(TPM_ANY_NUM, data, max);
-}
-
-static struct hwrng tpm_rng = {
-	.name = MODULE_NAME,
-	.read = tpm_rng_read,
-};
-
-static int __init rng_init(void)
-{
-	return hwrng_register(&tpm_rng);
-}
-module_init(rng_init);
-
-static void __exit rng_exit(void)
-{
-	hwrng_unregister(&tpm_rng);
-}
-module_exit(rng_exit);
-
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Kent Yoder <key@linux.vnet.ibm.com>");
-MODULE_DESCRIPTION("RNG driver for TPM devices");
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index a30352202f1fdc..a95725fa77789e 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -26,6 +26,19 @@ menuconfig TCG_TPM
 
 if TCG_TPM
 
+config HW_RANDOM_TPM
+	tristate "TPM HW Random Number Generator support"
+	depends on TCG_TPM && HW_RANDOM
+	default HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator in the Trusted Platform Module
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tpm-rng.
+
+	  If unsure, say Y.
+
 config TCG_TIS_CORE
 	tristate
 	---help---
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 0eca20c5a80cf2..f3571406fb2995 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -26,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
 #include <linux/major.h>
+#include <linux/hw_random.h>
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
@@ -387,6 +388,26 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 
 	return 0;
 }
+
+static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct tpm_chip *chip = container_of(rng, struct tpm_chip, tpm_hwrng);
+
+	return tpm_get_random_dev(chip, data, max);
+}
+
+static int tpm_add_hwrng(struct tpm_chip *chip)
+{
+	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM))
+		return 0;
+
+	snprintf(chip->tpm_hwrng_name, sizeof(chip->tpm_hwrng_name),
+		 "tpm-rng-%d", chip->dev_num);
+	chip->tpm_hwrng.name = chip->tpm_hwrng_name;
+	chip->tpm_hwrng.read = tpm_hwrng_read;
+	return hwrng_register(&chip->tpm_hwrng);
+}
+
 /*
  * tpm_chip_register() - create a character device for the TPM chip
  * @chip: TPM chip to use.
@@ -419,11 +440,13 @@ int tpm_chip_register(struct tpm_chip *chip)
 
 	tpm_add_ppi(chip);
 
+	rc = tpm_add_hwrng(chip);
+	if (rc)
+		goto out_ppi;
+
 	rc = tpm_add_char_device(chip);
-	if (rc) {
-		tpm_bios_log_teardown(chip);
-		return rc;
-	}
+	if (rc)
+		goto out_hwrng;
 
 	rc = tpm_add_legacy_sysfs(chip);
 	if (rc) {
@@ -432,6 +455,14 @@ int tpm_chip_register(struct tpm_chip *chip)
 	}
 
 	return 0;
+
+out_hwrng:
+	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
+		hwrng_unregister(&chip->tpm_hwrng);
+out_ppi:
+	tpm_bios_log_teardown(chip);
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_chip_register);
 
@@ -451,6 +482,8 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
 void tpm_chip_unregister(struct tpm_chip *chip)
 {
 	tpm_del_legacy_sysfs(chip);
+	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
+		hwrng_unregister(&chip->tpm_hwrng);
 	tpm_bios_log_teardown(chip);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		cdev_device_del(&chip->cdevs, &chip->devs);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1d6729be4cd637..310de288549818 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1194,9 +1194,8 @@ static const struct tpm_input_header tpm_getrandom_header = {
  *
  * Returns < 0 on error and the number of bytes read on success
  */
-int tpm_get_random(u32 chip_num, u8 *out, size_t max)
+int tpm_get_random_dev(struct tpm_chip *chip, u8 *out, size_t max)
 {
-	struct tpm_chip *chip;
 	struct tpm_cmd_t tpm_cmd;
 	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA), rlength;
 	int err, total = 0, retries = 5;
@@ -1205,15 +1204,8 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
 		return -EINVAL;
 
-	chip = tpm_chip_find_get(chip_num);
-	if (chip == NULL)
-		return -ENODEV;
-
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		err = tpm2_get_random(chip, out, max);
-		tpm_put_ops(chip);
-		return err;
-	}
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return tpm2_get_random(chip, out, max);
 
 	do {
 		tpm_cmd.header.in = tpm_getrandom_header;
@@ -1231,10 +1223,9 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 
 		rlength = be32_to_cpu(tpm_cmd.header.out.length);
 		if (rlength < offsetof(struct tpm_getrandom_out, rng_data) +
-			      recd) {
-			total = -EFAULT;
-			break;
-		}
+			      recd)
+			return -EFAULT;
+
 		memcpy(dest, tpm_cmd.params.getrandom_out.rng_data, recd);
 
 		dest += recd;
@@ -1242,9 +1233,23 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 		num_bytes -= recd;
 	} while (retries-- && total < max);
 
-	tpm_put_ops(chip);
 	return total ? total : -EIO;
 }
+
+int tpm_get_random(u32 chip_num, u8 *out, size_t max)
+{
+	int rc;
+	struct tpm_chip *chip;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+
+	rc = tpm_get_random_dev(chip, out, max);
+
+	tpm_put_ops(chip);
+	return rc;
+}
 EXPORT_SYMBOL_GPL(tpm_get_random);
 
 /**
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 2d5466a72e40f8..0e41e044d81be2 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
+#include <linux/hw_random.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/platform_device.h>
@@ -210,6 +211,9 @@ struct tpm_chip {
 	int dev_num;		/* /dev/tpm# */
 	unsigned long is_open;	/* only one allowed */
 
+	char tpm_hwrng_name[64];
+	struct hwrng tpm_hwrng;
+
 	struct mutex tpm_mutex;	/* tpm is processing */
 
 	unsigned long timeout_a; /* jiffies */
@@ -548,6 +552,7 @@ void tpm_chip_unregister(struct tpm_chip *chip);
 void tpm_sysfs_add_device(struct tpm_chip *chip);
 
 int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
+int tpm_get_random_dev(struct tpm_chip *chip, u8 *out, size_t max);
 
 #ifdef CONFIG_ACPI
 extern void tpm_add_ppi(struct tpm_chip *chip);
-- 
2.7.4
