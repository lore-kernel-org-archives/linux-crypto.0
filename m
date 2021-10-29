Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E3CC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 17:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF99561038
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 17:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhJ2RWl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 13:22:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39298 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229772AbhJ2RWk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 13:22:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19T9guNc021580;
        Fri, 29 Oct 2021 10:20:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=BNBPy6yoq30KNnnebf41B4x1hlBp+qktD7iKduOxm9Q=;
 b=DIpFF09uuifPvnCwZ5pSczW+G3N4qG8iXxKPTrOmWwg2DV495HKd2aAVy33jhvqGxAEo
 3IH4k+XyUtzQRQMot4ci1cJLUFWy+Decffmq3zSV4QGe7HT1ffKm0IGy0pEVA2p1JtK0
 qKunCw9fZucyaMFuSA0S2Gx1EIyOhgg/++UGPy1wrHYWLgi0U+3tivVQ3r27jwaImHGy
 aQP38l0idereN1+NaJIwNhTpvewJeRVyKlGcVT78GvZ4LVxpbY2LkBSiCi+U5PjS8wzN
 SV3BWsKMtVPPstOLXXQD9Ge94XLV6RhReE6XV9nWznwnpBpGexXAhJxy0r8XxoV/Yt8N EQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3c06hukhgn-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 10:20:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct
 2021 10:20:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 29 Oct 2021 10:20:06 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id B07BF3F7079;
        Fri, 29 Oct 2021 10:20:05 -0700 (PDT)
From:   <sgoutham@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Sunil Goutham" <sgoutham@marvell.com>
Subject: [PATCH v2] hwrng: cavium: Check health status while reading random data
Date:   Fri, 29 Oct 2021 22:49:59 +0530
Message-ID: <1635527999-21780-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: HZlAft3iQDa-uorpZT9eB0BrLApQCSib
X-Proofpoint-ORIG-GUID: HZlAft3iQDa-uorpZT9eB0BrLApQCSib
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_04,2021-10-29_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This RNG device is present on Marvell OcteonTx2 silicons as well and
also provides entropy health status.

HW continuously checks health condition of entropy and reports
faults. Fault is in terms of co-processor cycles since last fault
detected. This doesn't get cleared and only updated when new fault
is detected. Also there are chances of detecting false positives.
So to detect a entropy failure SW has to check if failures are
persistent ie cycles elapsed is frequently updated by HW.

This patch adds support to detect health failures using below algo.
1. Consider any fault detected before 10ms as a false positive and ignore.
   10ms is chosen randomly, no significance.
2. Upon first failure detection make a note of cycles elapsed and when this
   error happened in realtime (cntvct).
3. Upon subsequent failure, check if this is new or a old one by comparing
   current cycles with the ones since last failure. cycles or time since
   last failure is calculated using cycles and time info captured at (2).

HEALTH_CHECK status register is not available to VF, hence had to map
PF registers. Also since cycles are in terms of co-processor cycles,
had to retrieve co-processor clock rate from RST device.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
v1->v2:
 - Fixed COMPILE_TEST failures
 - Since silicon checks are done using standard ARM specific macros
   had to remove COMPILE_TEST.
---
 drivers/char/hw_random/Kconfig         |   2 +-
 drivers/char/hw_random/cavium-rng-vf.c | 194 +++++++++++++++++++++++++++++++--
 drivers/char/hw_random/cavium-rng.c    |  11 +-
 3 files changed, 190 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 814b3d0..1da6477 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -414,7 +414,7 @@ config HW_RANDOM_MESON
 
 config HW_RANDOM_CAVIUM
 	tristate "Cavium ThunderX Random Number Generator support"
-	depends on HW_RANDOM && PCI && (ARM64 || (COMPILE_TEST && 64BIT))
+	depends on HW_RANDOM && PCI && ARM64
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
index 3de4a6a..6f66919 100644
--- a/drivers/char/hw_random/cavium-rng-vf.c
+++ b/drivers/char/hw_random/cavium-rng-vf.c
@@ -1,10 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
- * Hardware Random Number Generator support for Cavium, Inc.
- * Thunder processor family.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
+ * Hardware Random Number Generator support.
+ * Cavium Thunder, Marvell OcteonTx/Tx2 processor families.
  *
  * Copyright (C) 2016 Cavium, Inc.
  */
@@ -15,16 +12,146 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 
+#include <asm/arch_timer.h>
+
+/* PCI device IDs */
+#define	PCI_DEVID_CAVIUM_RNG_PF		0xA018
+#define	PCI_DEVID_CAVIUM_RNG_VF		0xA033
+
+#define HEALTH_STATUS_REG		0x38
+
+/* RST device info */
+#define PCI_DEVICE_ID_RST_OTX2		0xA085
+#define RST_BOOT_REG			0x1600ULL
+#define CLOCK_BASE_RATE			50000000ULL
+#define MSEC_TO_NSEC(x)			(x * 1000000)
+
 struct cavium_rng {
 	struct hwrng ops;
 	void __iomem *result;
+	void __iomem *pf_regbase;
+	struct pci_dev *pdev;
+	u64  clock_rate;
+	u64  prev_error;
+	u64  prev_time;
 };
 
+static inline bool is_octeontx(struct pci_dev *pdev)
+{
+	if (midr_is_cpu_model_range(read_cpuid_id(), MIDR_THUNDERX_83XX,
+				    MIDR_CPU_VAR_REV(0, 0),
+				    MIDR_CPU_VAR_REV(3, 0)) ||
+	    midr_is_cpu_model_range(read_cpuid_id(), MIDR_THUNDERX_81XX,
+				    MIDR_CPU_VAR_REV(0, 0),
+				    MIDR_CPU_VAR_REV(3, 0)) ||
+	    midr_is_cpu_model_range(read_cpuid_id(), MIDR_THUNDERX,
+				    MIDR_CPU_VAR_REV(0, 0),
+				    MIDR_CPU_VAR_REV(3, 0)))
+		return true;
+
+	return false;
+}
+
+static u64 rng_get_coprocessor_clkrate(void)
+{
+	u64 ret = CLOCK_BASE_RATE * 16; /* Assume 800Mhz as default */
+	struct pci_dev *pdev;
+	void __iomem *base;
+
+	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
+			      PCI_DEVICE_ID_RST_OTX2, NULL);
+	if (!pdev)
+		goto error;
+
+	base = pci_ioremap_bar(pdev, 0);
+	if (!base)
+		goto error_put_pdev;
+
+	/* RST: PNR_MUL * 50Mhz gives clockrate */
+	ret = CLOCK_BASE_RATE * ((readq(base + RST_BOOT_REG) >> 33) & 0x3F);
+
+	iounmap(base);
+
+error_put_pdev:
+	pci_dev_put(pdev);
+
+error:
+	return ret;
+}
+
+static int check_rng_health(struct cavium_rng *rng)
+{
+	u64 cur_err, cur_time;
+	u64 status, cycles;
+	u64 time_elapsed;
+
+
+	/* Skip checking health for OcteonTx */
+	if (!rng->pf_regbase)
+		return 0;
+
+	status = readq(rng->pf_regbase + HEALTH_STATUS_REG);
+	if (status & BIT_ULL(0)) {
+		dev_err(&rng->pdev->dev, "HWRNG: Startup health test failed\n");
+		return -EIO;
+	}
+
+	cycles = status >> 1;
+	if (!cycles)
+		return 0;
+
+	cur_time = arch_timer_read_counter();
+
+	/* RNM_HEALTH_STATUS[CYCLES_SINCE_HEALTH_FAILURE]
+	 * Number of coprocessor cycles times 2 since the last failure.
+	 * This field doesn't get cleared/updated until another failure.
+	 */
+	cycles = cycles / 2;
+	cur_err = (cycles * 1000000000) / rng->clock_rate; /* In nanosec */
+
+	/* Ignore errors that happenned a long time ago, these
+	 * are most likely false positive errors.
+	 */
+	if (cur_err > MSEC_TO_NSEC(10)) {
+		rng->prev_error = 0;
+		rng->prev_time = 0;
+		return 0;
+	}
+
+	if (rng->prev_error) {
+		/* Calculate time elapsed since last error
+		 * '1' tick of CNTVCT is 10ns, since it runs at 100Mhz.
+		 */
+		time_elapsed = (cur_time - rng->prev_time) * 10;
+		time_elapsed += rng->prev_error;
+
+		/* Check if current error is a new one or the old one itself.
+		 * If error is a new one then consider there is a persistent
+		 * issue with entropy, declare hardware failure.
+		 */
+		if (cur_err < time_elapsed) {
+			dev_err(&rng->pdev->dev, "HWRNG failure detected\n");
+			rng->prev_error = cur_err;
+			rng->prev_time = cur_time;
+			return -EIO;
+		}
+	}
+
+	rng->prev_error = cur_err;
+	rng->prev_time = cur_time;
+	return 0;
+}
+
 /* Read data from the RNG unit */
 static int cavium_rng_read(struct hwrng *rng, void *dat, size_t max, bool wait)
 {
 	struct cavium_rng *p = container_of(rng, struct cavium_rng, ops);
 	unsigned int size = max;
+	int err = 0;
+
+	err = check_rng_health(p);
+	if (err)
+		return err;
 
 	while (size >= 8) {
 		*((u64 *)dat) = readq(p->result);
@@ -39,6 +166,39 @@ static int cavium_rng_read(struct hwrng *rng, void *dat, size_t max, bool wait)
 	return max;
 }
 
+static int cavium_map_pf_regs(struct cavium_rng *rng)
+{
+	struct pci_dev *pdev;
+
+	/* Health status is not supported on 83xx, skip mapping PF CSRs */
+	if (is_octeontx(rng->pdev)) {
+		rng->pf_regbase = NULL;
+		return 0;
+	}
+
+	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
+			      PCI_DEVID_CAVIUM_RNG_PF, NULL);
+	if (!pdev) {
+		dev_err(&pdev->dev, "Cannot find RNG PF device\n");
+		return -EIO;
+	}
+
+	rng->pf_regbase = ioremap(pci_resource_start(pdev, 0),
+				  pci_resource_len(pdev, 0));
+	if (!rng->pf_regbase) {
+		dev_err(&pdev->dev, "Failed to map PF CSR region\n");
+		pci_dev_put(pdev);
+		return -ENOMEM;
+	}
+
+	pci_dev_put(pdev);
+
+	/* Get co-processor clock rate */
+	rng->clock_rate = rng_get_coprocessor_clkrate();
+
+	return 0;
+}
+
 /* Map Cavium RNG to an HWRNG object */
 static int cavium_rng_probe_vf(struct	pci_dev		*pdev,
 			 const struct	pci_device_id	*id)
@@ -50,6 +210,8 @@ static int cavium_rng_probe_vf(struct	pci_dev		*pdev,
 	if (!rng)
 		return -ENOMEM;
 
+	rng->pdev = pdev;
+
 	/* Map the RNG result */
 	rng->result = pcim_iomap(pdev, 0, 0);
 	if (!rng->result) {
@@ -67,6 +229,11 @@ static int cavium_rng_probe_vf(struct	pci_dev		*pdev,
 
 	pci_set_drvdata(pdev, rng);
 
+	/* Health status is available only at PF, hence map PF registers. */
+	ret = cavium_map_pf_regs(rng);
+	if (ret)
+		return ret;
+
 	ret = devm_hwrng_register(&pdev->dev, &rng->ops);
 	if (ret) {
 		dev_err(&pdev->dev, "Error registering device as HWRNG.\n");
@@ -76,10 +243,18 @@ static int cavium_rng_probe_vf(struct	pci_dev		*pdev,
 	return 0;
 }
 
+/* Remove the VF */
+static void cavium_rng_remove_vf(struct pci_dev *pdev)
+{
+	struct cavium_rng *rng;
+
+	rng = pci_get_drvdata(pdev);
+	iounmap(rng->pf_regbase);
+}
 
 static const struct pci_device_id cavium_rng_vf_id_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, 0xa033), 0, 0, 0},
-	{0,},
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CAVIUM_RNG_VF) },
+	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, cavium_rng_vf_id_table);
 
@@ -87,8 +262,9 @@ static struct pci_driver cavium_rng_vf_driver = {
 	.name		= "cavium_rng_vf",
 	.id_table	= cavium_rng_vf_id_table,
 	.probe		= cavium_rng_probe_vf,
+	.remove		= cavium_rng_remove_vf,
 };
 module_pci_driver(cavium_rng_vf_driver);
 
 MODULE_AUTHOR("Omer Khaliq <okhaliq@caviumnetworks.com>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/char/hw_random/cavium-rng.c b/drivers/char/hw_random/cavium-rng.c
index 63d6e68..b965792 100644
--- a/drivers/char/hw_random/cavium-rng.c
+++ b/drivers/char/hw_random/cavium-rng.c
@@ -1,10 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
- * Hardware Random Number Generator support for Cavium Inc.
- * Thunder processor family.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
+ * Hardware Random Number Generator support.
+ * Cavium Thunder, Marvell OcteonTx/Tx2 processor families.
  *
  * Copyright (C) 2016 Cavium, Inc.
  */
@@ -91,4 +88,4 @@ static struct pci_driver cavium_rng_pf_driver = {
 
 module_pci_driver(cavium_rng_pf_driver);
 MODULE_AUTHOR("Omer Khaliq <okhaliq@caviumnetworks.com>");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4

