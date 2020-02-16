Return-Path: <SRS0=RXXs=4E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82878C7619B
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 10:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C75B2084E
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 10:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgBPKEz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Feb 2020 05:04:55 -0500
Received: from foss.arm.com ([217.140.110.172]:53020 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgBPKEz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Feb 2020 05:04:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C48E230E;
        Sun, 16 Feb 2020 02:04:53 -0800 (PST)
Received: from ssg-dev-vb.kfn.arm.com (unknown [10.50.4.137])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D4CB3F68F;
        Sun, 16 Feb 2020 02:04:49 -0800 (PST)
From:   Hadar Gat <hadar.gat@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>
Subject: [PATCH v4 2/3] hw_random: cctrng: introduce Arm CryptoCell driver
Date:   Sun, 16 Feb 2020 12:04:09 +0200
Message-Id: <1581847450-22924-3-git-send-email-hadar.gat@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1581847450-22924-1-git-send-email-hadar.gat@arm.com>
References: <1581847450-22924-1-git-send-email-hadar.gat@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce low level Arm CryptoCell TRNG HW support.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
---
 drivers/char/hw_random/Kconfig  |  12 +
 drivers/char/hw_random/Makefile |   1 +
 drivers/char/hw_random/cctrng.c | 767 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/hw_random/cctrng.h |  69 ++++
 4 files changed, 849 insertions(+)
 create mode 100644 drivers/char/hw_random/cctrng.c
 create mode 100644 drivers/char/hw_random/cctrng.h

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 914e293..94a524e 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -466,6 +466,18 @@ config HW_RANDOM_NPCM
 
  	  If unsure, say Y.
 
+config HW_RANDOM_CCTRNG
+	tristate "Arm CryptoCell True Random Number Generator support"
+	default HW_RANDOM
+	help
+	  This driver provides support for the True Random Number
+	  Generator available in Arm TrustZone CryptoCell.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called cctrng.
+
+	  If unsure, say Y.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index a7801b4..2c67247 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -41,3 +41,4 @@ obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
 obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
 obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
 obj-$(CONFIG_HW_RANDOM_NPCM) += npcm-rng.o
+obj-$(CONFIG_HW_RANDOM_CCTRNG) += cctrng.o
diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
new file mode 100644
index 0000000..7ec5226
--- /dev/null
+++ b/drivers/char/hw_random/cctrng.c
@@ -0,0 +1,767 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2019-2020 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/interrupt.h>
+#include <linux/irqreturn.h>
+#include <linux/workqueue.h>
+#include <linux/circ_buf.h>
+#include <linux/completion.h>
+#include <linux/of.h>
+#include <linux/bitfield.h>
+
+#include "cctrng.h"
+
+#define CC_REG_LOW(name)  (name ## _BIT_SHIFT)
+#define CC_REG_HIGH(name) (CC_REG_LOW(name) + name ## _BIT_SIZE - 1)
+#define CC_GENMASK(name)  GENMASK(CC_REG_HIGH(name), CC_REG_LOW(name))
+
+#define CC_REG_FLD_GET(reg_name, fld_name, reg_val)     \
+	(FIELD_GET(CC_GENMASK(CC_ ## reg_name ## _ ## fld_name), reg_val))
+
+#define CC_HW_RESET_LOOP_COUNT 10
+#define CC_TRNG_SUSPEND_TIMEOUT 3000
+
+/* data circular buffer in words must be:
+ *  - of a power-of-2 size (limitation of circ_buf.h macros)
+ *  - at least 6, the size generated in the EHR according to HW implementation
+ */
+#define CCTRNG_DATA_BUF_WORDS 32
+
+/* The timeout for the TRNG operation should be calculated with the formula:
+ * Timeout = EHR_NUM * VN_COEFF * EHR_LENGTH * SAMPLE_CNT * SCALE_VALUE
+ * while:
+ *  - SAMPLE_CNT is input value from the characterisation process
+ *  - all the rest are constants
+ */
+#define EHR_NUM 1
+#define VN_COEFF 4
+#define EHR_LENGTH CC_TRNG_EHR_IN_BITS
+#define SCALE_VALUE 2
+#define CCTRNG_TIMEOUT(smpl_cnt) \
+	(EHR_NUM * VN_COEFF * EHR_LENGTH * smpl_cnt * SCALE_VALUE)
+
+struct cctrng_drvdata {
+	struct platform_device *pdev;
+	void __iomem *cc_base;
+	struct clk *clk;
+	struct hwrng rng;
+	u32 active_rosc;
+	/* Sampling interval for each ring oscillator:
+	 * count of ring oscillator cycles between consecutive bits sampling.
+	 * Value of 0 indicates non-valid rosc
+	 */
+	u32 smpl_ratio[CC_TRNG_NUM_OF_ROSCS];
+
+	u32 data_buf[CCTRNG_DATA_BUF_WORDS];
+	struct circ_buf circ;
+	struct work_struct compwork;
+	struct work_struct startwork;
+
+	/* pending_hw - 1 when HW is pending, 0 when it is idle */
+	atomic_t pending_hw;
+
+	/* protects against multiple concurrent consumers of data_buf */
+	spinlock_t read_lock;
+};
+
+
+/* functions for write/read CC registers */
+static inline void cc_iowrite(struct cctrng_drvdata *drvdata, u32 reg, u32 val)
+{
+	iowrite32(val, (drvdata->cc_base + reg));
+}
+static inline u32 cc_ioread(struct cctrng_drvdata *drvdata, u32 reg)
+{
+	return ioread32(drvdata->cc_base + reg);
+}
+
+
+static int cc_trng_pm_get(struct device *dev)
+{
+	int rc = 0;
+
+	rc = pm_runtime_get_sync(dev);
+
+	/* pm_runtime_get_sync() can return 1 as a valid return code */
+	return (rc == 1 ? 0 : rc);
+}
+
+static void cc_trng_pm_put_suspend(struct device *dev)
+{
+	int rc = 0;
+
+	pm_runtime_mark_last_busy(dev);
+	rc = pm_runtime_put_autosuspend(dev);
+	if (rc)
+		dev_err(dev, "pm_runtime_put_autosuspend returned %x\n", rc);
+}
+
+static int cc_trng_pm_init(struct cctrng_drvdata *drvdata)
+{
+	struct device *dev = &(drvdata->pdev->dev);
+
+	/* must be before the enabling to avoid redundant suspending */
+	pm_runtime_set_autosuspend_delay(dev, CC_TRNG_SUSPEND_TIMEOUT);
+	pm_runtime_use_autosuspend(dev);
+	/* set us as active - note we won't do PM ops until cc_trng_pm_go()! */
+	return pm_runtime_set_active(dev);
+}
+
+static void cc_trng_pm_go(struct cctrng_drvdata *drvdata)
+{
+	struct device *dev = &(drvdata->pdev->dev);
+
+	/* enable the PM module*/
+	pm_runtime_enable(dev);
+}
+
+static void cc_trng_pm_fini(struct cctrng_drvdata *drvdata)
+{
+	struct device *dev = &(drvdata->pdev->dev);
+
+	pm_runtime_disable(dev);
+}
+
+static bool cc_trng_pm_is_dev_suspended(struct device *dev)
+{
+	/* check device state using runtime api */
+	return pm_runtime_suspended(dev);
+}
+
+
+static inline int cc_trng_parse_sampling_ratio(struct cctrng_drvdata *drvdata)
+{
+	struct device *dev = &(drvdata->pdev->dev);
+	struct device_node *np = drvdata->pdev->dev.of_node;
+	int rc;
+	int i;
+	/* ret will be set to 0 if at least one rosc has (sampling ratio > 0) */
+	int ret = -EINVAL;
+
+	rc = of_property_read_u32_array(np, "arm,rosc-ratio",
+					drvdata->smpl_ratio,
+					CC_TRNG_NUM_OF_ROSCS);
+	if (rc) {
+		/* arm,rosc-ratio was not found in device tree */
+		return rc;
+	}
+
+	/* verify that at least one rosc has (sampling ratio > 0) */
+	for (i = 0; i < CC_TRNG_NUM_OF_ROSCS; ++i) {
+		dev_dbg(dev, "rosc %d sampling ratio %u",
+			i, drvdata->smpl_ratio[i]);
+
+		if (drvdata->smpl_ratio[i] > 0)
+			ret = 0;
+	}
+
+	return ret;
+}
+
+static int cc_trng_change_rosc(struct cctrng_drvdata *drvdata)
+{
+	struct device *dev = &(drvdata->pdev->dev);
+
+	dev_dbg(dev, "cctrng change rosc (was %d)\n", drvdata->active_rosc);
+	drvdata->active_rosc += 1;
+
+	while (drvdata->active_rosc < CC_TRNG_NUM_OF_ROSCS) {
+		if (drvdata->smpl_ratio[drvdata->active_rosc] > 0)
+			return 0;
+
+		drvdata->active_rosc += 1;
+	}
+	return -EINVAL;
+}
+
+
+static void cc_trng_enable_rnd_source(struct cctrng_drvdata *drvdata)
+{
+	u32 max_cycles;
+
+	/* Set watchdog threshold to maximal allowed time (in CPU cycles) */
+	max_cycles = CCTRNG_TIMEOUT(drvdata->smpl_ratio[drvdata->active_rosc]);
+	cc_iowrite(drvdata, CC_RNG_WATCHDOG_VAL_REG_OFFSET, max_cycles);
+
+	/* enable the RND source */
+	cc_iowrite(drvdata, CC_RND_SOURCE_ENABLE_REG_OFFSET, 0x1);
+
+	/* unmask RNG interrupts */
+	cc_iowrite(drvdata, CC_RNG_IMR_REG_OFFSET, (u32)~CC_RNG_INT_MASK);
+}
+
+
+/* increase circular data buffer index (head/tail) */
+static inline void circ_idx_inc(int *idx, int bytes)
+{
+	*idx += (bytes + 3) >> 2;
+	*idx &= (CCTRNG_DATA_BUF_WORDS - 1);
+}
+
+static inline size_t circ_buf_space(struct cctrng_drvdata *drvdata)
+{
+	return CIRC_SPACE(drvdata->circ.head,
+			  drvdata->circ.tail, CCTRNG_DATA_BUF_WORDS);
+
+}
+
+static int cctrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	/* current implementation ignores "wait" */
+
+	struct cctrng_drvdata *drvdata = (struct cctrng_drvdata *)rng->priv;
+	struct device *dev = &(drvdata->pdev->dev);
+	u32 *buf = (u32 *)drvdata->circ.buf;
+	size_t copied = 0;
+	size_t cnt_w;
+	size_t size;
+	size_t left;
+
+	if (!spin_trylock(&drvdata->read_lock)) {
+		/* concurrent consumers from data_buf cannot be served */
+		dev_dbg_ratelimited(dev, "unable to hold lock\n");
+		return 0;
+	}
+
+	/* copy till end of data buffer (without wrap back) */
+	cnt_w = CIRC_CNT_TO_END(drvdata->circ.head,
+				drvdata->circ.tail, CCTRNG_DATA_BUF_WORDS);
+	size = min((cnt_w<<2), max);
+	memcpy(data, &(buf[drvdata->circ.tail]), size);
+	copied = size;
+	circ_idx_inc(&drvdata->circ.tail, size);
+	/* copy rest of data in data buffer */
+	left = max - copied;
+	if (left > 0) {
+		cnt_w = CIRC_CNT(drvdata->circ.head,
+				 drvdata->circ.tail, CCTRNG_DATA_BUF_WORDS);
+		size = min((cnt_w<<2), left);
+		memcpy(data, &(buf[drvdata->circ.tail]), size);
+		copied += size;
+		circ_idx_inc(&drvdata->circ.tail, size);
+	}
+
+	spin_unlock(&drvdata->read_lock);
+
+	if (circ_buf_space(drvdata) >= CC_TRNG_EHR_IN_WORDS) {
+		if (atomic_cmpxchg(&drvdata->pending_hw, 0, 1) == 0) {
+			/* re-check space in buffer to avoid potential race */
+			if (circ_buf_space(drvdata) >= CC_TRNG_EHR_IN_WORDS) {
+				/* increment device's usage counter */
+				int rc = cc_trng_pm_get(dev);
+
+				if (rc) {
+					dev_err(dev,
+						"cc_trng_pm_get returned %x\n",
+						rc);
+					return rc;
+				}
+
+				/* schedule execution of deferred work handler
+				 * for filling of data buffer
+				 */
+				schedule_work(&drvdata->startwork);
+			} else {
+				atomic_set(&drvdata->pending_hw, 0);
+			}
+		}
+	}
+
+	return copied;
+}
+
+static void cc_trng_hw_trigger(struct cctrng_drvdata *drvdata)
+{
+	u32 tmp_smpl_cnt = 0;
+	struct device *dev = &(drvdata->pdev->dev);
+
+	dev_dbg(dev, "cctrng hw trigger.\n");
+
+	/* enable the HW RND clock */
+	cc_iowrite(drvdata, CC_RNG_CLK_ENABLE_REG_OFFSET, 0x1);
+
+	/* do software reset */
+	cc_iowrite(drvdata, CC_RNG_SW_RESET_REG_OFFSET, 0x1);
+	/* in order to verify that the reset has completed,
+	 * the sample count need to be verified
+	 */
+	do {
+		/* enable the HW RND clock   */
+		cc_iowrite(drvdata, CC_RNG_CLK_ENABLE_REG_OFFSET, 0x1);
+
+		/* set sampling ratio (rng_clocks) between consecutive bits */
+		cc_iowrite(drvdata, CC_SAMPLE_CNT1_REG_OFFSET,
+			   drvdata->smpl_ratio[drvdata->active_rosc]);
+
+		/* read the sampling ratio  */
+		tmp_smpl_cnt = cc_ioread(drvdata, CC_SAMPLE_CNT1_REG_OFFSET);
+
+	} while (tmp_smpl_cnt != drvdata->smpl_ratio[drvdata->active_rosc]);
+
+	/* disable the RND source for setting new parameters in HW */
+	cc_iowrite(drvdata, CC_RND_SOURCE_ENABLE_REG_OFFSET, 0);
+
+	cc_iowrite(drvdata, CC_RNG_ICR_REG_OFFSET, 0xFFFFFFFF);
+
+	cc_iowrite(drvdata, CC_TRNG_CONFIG_REG_OFFSET, drvdata->active_rosc);
+
+	/* Debug Control register: set to 0 - no bypasses */
+	cc_iowrite(drvdata, CC_TRNG_DEBUG_CONTROL_REG_OFFSET, 0);
+
+	cc_trng_enable_rnd_source(drvdata);
+}
+
+void cc_trng_compwork_handler(struct work_struct *w)
+{
+	u32 isr = 0;
+	u32 ehr_valid = 0;
+	struct cctrng_drvdata *drvdata =
+			container_of(w, struct cctrng_drvdata, compwork);
+	struct device *dev = &(drvdata->pdev->dev);
+	int i;
+
+	/* stop DMA and the RNG source */
+	cc_iowrite(drvdata, CC_RNG_DMA_ENABLE_REG_OFFSET, 0);
+	cc_iowrite(drvdata, CC_RND_SOURCE_ENABLE_REG_OFFSET, 0);
+
+	/* read RNG_ISR and check for errors */
+	isr = cc_ioread(drvdata, CC_RNG_ISR_REG_OFFSET);
+	ehr_valid = CC_REG_FLD_GET(RNG_ISR, EHR_VALID, isr);
+	dev_dbg(dev, "Got RNG_ISR=0x%08X (EHR_VALID=%u)\n", isr, ehr_valid);
+
+#ifdef CONFIG_CRYPTO_FIPS
+	if (CC_REG_FLD_GET(RNG_ISR, CRNGT_ERR, isr) && fips_enabled) {
+		fips_fail_notify();
+		/* FIPS error is fatal */
+		panic("Got HW CRNGT error while fips is enabled!\n");
+	}
+#endif
+
+	/* Clear all pending RNG interrupts */
+	cc_iowrite(drvdata, CC_RNG_ICR_REG_OFFSET, isr);
+
+
+	if (!ehr_valid) {
+		/* in case of AUTOCORR/TIMEOUT error, try the next ROSC */
+		if (CC_REG_FLD_GET(RNG_ISR, AUTOCORR_ERR, isr) ||
+				CC_REG_FLD_GET(RNG_ISR, WATCHDOG, isr)) {
+			dev_dbg(dev, "cctrng autocorr/timeout error.\n");
+			goto next_rosc;
+		}
+
+		/* in case of VN error, ignore it */
+	}
+
+	/* read EHR data from registers */
+	for (i = 0; i < CC_TRNG_EHR_IN_WORDS; i++) {
+		/* calc word ptr in data_buf */
+		u32 *buf = (u32 *)drvdata->circ.buf;
+
+		buf[drvdata->circ.head] = cc_ioread(drvdata,
+				CC_EHR_DATA_0_REG_OFFSET + (i*sizeof(u32)));
+
+		/* EHR_DATA registers are cleared on read. In case 0 value was
+		 * returned, restart the entropy collection.
+		 */
+		if (buf[drvdata->circ.head] == 0) {
+			dev_dbg(dev, "Got 0 value in EHR. active_rosc %u\n",
+				drvdata->active_rosc);
+			goto next_rosc;
+		}
+
+		circ_idx_inc(&drvdata->circ.head, 1<<2);
+	}
+
+	atomic_set(&drvdata->pending_hw, 0);
+
+	/* continue to fill data buffer if needed */
+	if (circ_buf_space(drvdata) >= CC_TRNG_EHR_IN_WORDS) {
+		if (atomic_cmpxchg(&drvdata->pending_hw, 0, 1) == 0) {
+			/* Re-enable rnd source */
+			cc_trng_enable_rnd_source(drvdata);
+			return;
+		}
+	}
+
+	cc_trng_pm_put_suspend(dev);
+
+	dev_dbg(dev, "compwork handler done\n");
+	return;
+
+next_rosc:
+	if ((circ_buf_space(drvdata) >= CC_TRNG_EHR_IN_WORDS) &&
+			(cc_trng_change_rosc(drvdata) == 0)) {
+		/* trigger trng hw with next rosc */
+		cc_trng_hw_trigger(drvdata);
+	} else {
+		atomic_set(&drvdata->pending_hw, 0);
+		cc_trng_pm_put_suspend(dev);
+	}
+}
+
+static irqreturn_t cc_isr(int irq, void *dev_id)
+{
+	struct cctrng_drvdata *drvdata = (struct cctrng_drvdata *)dev_id;
+	struct device *dev = &(drvdata->pdev->dev);
+	u32 irr;
+
+	/* if driver suspended return, probably shared interrupt */
+	if (cc_trng_pm_is_dev_suspended(dev))
+		return IRQ_NONE;
+
+	/* read the interrupt status */
+	irr = cc_ioread(drvdata, CC_HOST_RGF_IRR_REG_OFFSET);
+	dev_dbg(dev, "Got IRR=0x%08X\n", irr);
+
+	if (irr == 0) /* Probably shared interrupt line */
+		return IRQ_NONE;
+
+	/* clear interrupt - must be before processing events */
+	cc_iowrite(drvdata, CC_HOST_RGF_ICR_REG_OFFSET, irr);
+
+	/* RNG interrupt - most probable */
+	if (irr & CC_HOST_RNG_IRQ_MASK) {
+		/* Mask RNG interrupts - will be unmasked in deferred work */
+		cc_iowrite(drvdata, CC_RNG_IMR_REG_OFFSET, 0xFFFFFFFF);
+
+		/* We clear RNG interrupt here,
+		 * to avoid it from firing as we'll unmask RNG interrupts.
+		 */
+		cc_iowrite(drvdata, CC_HOST_RGF_ICR_REG_OFFSET,
+			   CC_HOST_RNG_IRQ_MASK);
+
+		irr &= ~CC_HOST_RNG_IRQ_MASK;
+
+		/* schedule execution of deferred work handler */
+		schedule_work(&drvdata->compwork);
+	}
+
+	if (irr) {
+		dev_dbg_ratelimited(dev,
+				"IRR includes unknown cause bits (0x%08X)\n",
+				irr);
+		/* Just warning */
+	}
+
+	return IRQ_HANDLED;
+}
+
+void cc_trng_startwork_handler(struct work_struct *w)
+{
+	struct cctrng_drvdata *drvdata =
+			container_of(w, struct cctrng_drvdata, startwork);
+
+	drvdata->active_rosc = 0;
+	cc_trng_hw_trigger(drvdata);
+}
+
+
+static int cc_trng_clk_on(struct cctrng_drvdata *drvdata)
+{
+	struct clk *clk = drvdata->clk;
+
+	if (IS_ERR(clk))
+		/* Not all devices have a clock associated with CryptoCell */
+		return 0;
+
+	return clk_prepare_enable(clk);
+}
+
+static void cc_trng_clk_off(struct cctrng_drvdata *drvdata)
+{
+	clk_disable_unprepare(drvdata->clk);
+}
+
+static int cc_trng_clk_init(struct cctrng_drvdata *drvdata)
+{
+	struct clk *clk;
+	struct device *dev = &(drvdata->pdev->dev);
+	int rc = 0;
+
+	clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(clk))
+		switch (PTR_ERR(clk)) {
+		/* Clock is optional so this might be fine */
+		case -ENOENT:
+			break;
+
+		/* Clock not available, let's try again soon */
+		case -EPROBE_DEFER:
+			return -EPROBE_DEFER;
+
+		default:
+			dev_err(dev, "Error getting clock: %ld\n",
+				PTR_ERR(clk));
+			return PTR_ERR(clk);
+		}
+	drvdata->clk = clk;
+
+	rc = cc_trng_clk_on(drvdata);
+	if (rc) {
+		dev_err(dev, "Could not enable the clk.\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+static void cc_trng_clk_fini(struct cctrng_drvdata *drvdata)
+{
+	cc_trng_clk_off(drvdata);
+}
+
+
+static int cctrng_probe(struct platform_device *pdev)
+{
+	struct resource *req_mem_cc_regs = NULL;
+	struct cctrng_drvdata *drvdata;
+	struct device *dev = &pdev->dev;
+	int rc = 0;
+	u32 val;
+	int irq;
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	drvdata->rng.name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
+	if (!drvdata->rng.name)
+		return -ENOMEM;
+
+	drvdata->rng.read = cctrng_read;
+	drvdata->rng.priv = (unsigned long)drvdata;
+
+	platform_set_drvdata(pdev, drvdata);
+	drvdata->pdev = pdev;
+
+	drvdata->circ.buf = (char *)drvdata->data_buf;
+
+	/* Get device resources */
+	/* First CC registers space */
+	req_mem_cc_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	/* Map registers space */
+	drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
+	if (IS_ERR(drvdata->cc_base)) {
+		dev_err(dev, "Failed to ioremap registers");
+		return PTR_ERR(drvdata->cc_base);
+	}
+
+	dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
+		req_mem_cc_regs);
+	dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
+		&req_mem_cc_regs->start, drvdata->cc_base);
+
+	/* Then IRQ */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "Failed getting IRQ resource\n");
+		return irq;
+	}
+
+	/* parse sampling rate from device tree */
+	rc = cc_trng_parse_sampling_ratio(drvdata);
+	if (rc) {
+		dev_err(dev, "Failed to get legal sampling ratio for rosc\n");
+		return rc;
+	}
+
+	rc = cc_trng_clk_init(drvdata);
+	if (rc) {
+		dev_err(dev, "cc_trng_clk_init failed\n");
+		return rc;
+	}
+
+	INIT_WORK(&drvdata->compwork, cc_trng_compwork_handler);
+	INIT_WORK(&drvdata->startwork, cc_trng_startwork_handler);
+	spin_lock_init(&drvdata->read_lock);
+
+	/* register the driver isr function */
+	rc = devm_request_irq(dev, irq, cc_isr, IRQF_SHARED, "cctrng", drvdata);
+	if (rc) {
+		dev_err(dev, "Could not register to interrupt %d\n", irq);
+		goto post_clk_err;
+	}
+	dev_dbg(dev, "Registered to IRQ: %d\n", irq);
+
+	/* Clear all pending interrupts */
+	val = cc_ioread(drvdata, CC_HOST_RGF_IRR_REG_OFFSET);
+	dev_dbg(dev, "IRR=0x%08X\n", val);
+	cc_iowrite(drvdata, CC_HOST_RGF_ICR_REG_OFFSET, val);
+
+	/* unmask HOST RNG interrupt */
+	cc_iowrite(drvdata, CC_HOST_RGF_IMR_REG_OFFSET,
+		   cc_ioread(drvdata, CC_HOST_RGF_IMR_REG_OFFSET) &
+		   ~CC_HOST_RNG_IRQ_MASK);
+
+	/* init PM */
+	rc = cc_trng_pm_init(drvdata);
+	if (rc) {
+		dev_err(dev, "cc_trng_pm_init failed\n");
+		goto post_clk_err;
+	}
+
+	/* increment device's usage counter */
+	rc = cc_trng_pm_get(dev);
+	if (rc) {
+		dev_err(dev, "cc_trng_pm_get returned %x\n", rc);
+		goto post_pm_err;
+	}
+
+	/* set pending_hw to verify that HW won't be triggered from read */
+	atomic_set(&drvdata->pending_hw, 1);
+
+	/* registration of the hwrng device */
+	rc = hwrng_register(&drvdata->rng);
+	if (rc) {
+		dev_err(dev, "Could not register hwrng device.\n");
+		goto post_pm_err;
+	}
+
+	/* trigger HW to start generate data */
+	drvdata->active_rosc = 0;
+	cc_trng_hw_trigger(drvdata);
+
+	/* All set, we can allow auto-suspend */
+	cc_trng_pm_go(drvdata);
+
+	dev_info(dev, "ARM cctrng device initialized\n");
+
+	return 0;
+
+post_pm_err:
+	cc_trng_pm_fini(drvdata);
+
+post_clk_err:
+	cc_trng_clk_fini(drvdata);
+
+	return rc;
+}
+
+static int cctrng_remove(struct platform_device *pdev)
+{
+	struct cctrng_drvdata *drvdata = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+
+	dev_dbg(dev, "Releasing cctrng resources...\n");
+
+	hwrng_unregister(&drvdata->rng);
+
+	cc_trng_pm_fini(drvdata);
+
+	cc_trng_clk_fini(drvdata);
+
+	dev_info(dev, "ARM cctrng device terminated\n");
+
+	return 0;
+}
+
+static int __maybe_unused cctrng_suspend(struct device *dev)
+{
+	struct cctrng_drvdata *drvdata = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
+	cc_iowrite(drvdata, CC_HOST_POWER_DOWN_EN_REG_OFFSET,
+			POWER_DOWN_ENABLE);
+
+	cc_trng_clk_off(drvdata);
+
+	return 0;
+}
+
+static bool cctrng_wait_for_reset_completion(struct cctrng_drvdata *drvdata)
+{
+	unsigned int val;
+	unsigned int i;
+
+	for (i = 0; i < CC_HW_RESET_LOOP_COUNT; i++) {
+		/* in cc7x3 NVM_IS_IDLE indicates that CC reset is
+		 *  completed and device is fully functional
+		 */
+		val = cc_ioread(drvdata, CC_NVM_IS_IDLE_REG_OFFSET);
+		if (val & BIT(CC_NVM_IS_IDLE_VALUE_BIT_SHIFT)) {
+			/* hw indicate reset completed */
+			return true;
+		}
+		/* allow scheduling other process on the processor */
+		schedule();
+	}
+	/* reset not completed */
+	return false;
+}
+
+static int __maybe_unused cctrng_resume(struct device *dev)
+{
+	struct cctrng_drvdata *drvdata = dev_get_drvdata(dev);
+	int rc;
+
+	dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
+	/* Enables the device source clk */
+	rc = cc_trng_clk_on(drvdata);
+	if (rc) {
+		dev_err(dev, "failed getting clock back on. We're toast.\n");
+		return rc;
+	}
+
+	/* wait for Cryptocell reset completion */
+	if (!cctrng_wait_for_reset_completion(drvdata)) {
+		dev_err(dev, "Cryptocell reset not completed");
+		return -EBUSY;
+	}
+
+	/* unmask HOST RNG interrupt */
+	cc_iowrite(drvdata, CC_HOST_RGF_IMR_REG_OFFSET,
+		   cc_ioread(drvdata, CC_HOST_RGF_IMR_REG_OFFSET) &
+		   ~CC_HOST_RNG_IRQ_MASK);
+
+	cc_iowrite(drvdata, CC_HOST_POWER_DOWN_EN_REG_OFFSET,
+		   POWER_DOWN_DISABLE);
+
+	return 0;
+}
+
+static UNIVERSAL_DEV_PM_OPS(cctrng_pm, cctrng_suspend, cctrng_resume, NULL);
+
+static const struct of_device_id arm_cctrng_dt_match[] = {
+	{ .compatible = "arm,cryptocell-713-trng", },
+	{ .compatible = "arm,cryptocell-703-trng", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, arm_cctrng_dt_match);
+
+static struct platform_driver cctrng_driver = {
+	.driver = {
+		.name = "cctrng",
+		.of_match_table = arm_cctrng_dt_match,
+		.pm = &cctrng_pm,
+	},
+	.probe = cctrng_probe,
+	.remove = cctrng_remove,
+};
+
+static int __init cctrng_mod_init(void)
+{
+	/* Compile time assertion checks */
+	BUILD_BUG_ON(CCTRNG_DATA_BUF_WORDS < 6);
+	BUILD_BUG_ON((CCTRNG_DATA_BUF_WORDS & (CCTRNG_DATA_BUF_WORDS-1)) != 0);
+
+	return platform_driver_register(&cctrng_driver);
+}
+module_init(cctrng_mod_init);
+
+static void __exit cctrng_mod_exit(void)
+{
+	platform_driver_unregister(&cctrng_driver);
+}
+module_exit(cctrng_mod_exit);
+
+/* Module description */
+MODULE_DESCRIPTION("ARM CryptoCell TRNG Driver");
+MODULE_AUTHOR("ARM");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/char/hw_random/cctrng.h b/drivers/char/hw_random/cctrng.h
new file mode 100644
index 0000000..fcaeb72
--- /dev/null
+++ b/drivers/char/hw_random/cctrng.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2019-2020 ARM Limited or its affiliates. */
+
+#include <linux/bitops.h>
+
+#define POWER_DOWN_ENABLE 0x01
+#define POWER_DOWN_DISABLE 0x00
+
+/* CryptoCell TRNG HW definitions */
+#define CC_TRNG_NUM_OF_ROSCS	4
+/* The number of words generated in the entropy holding register (EHR)
+ * 6 words (192 bit) according to HW implementation
+ */
+#define CC_TRNG_EHR_IN_WORDS	6
+#define CC_TRNG_EHR_IN_BITS	(CC_TRNG_EHR_IN_WORDS * BITS_PER_TYPE(u32))
+
+#define CC_HOST_RNG_IRQ_MASK BIT(CC_HOST_RGF_IRR_RNG_INT_BIT_SHIFT)
+
+/* RNG interrupt mask */
+#define CC_RNG_INT_MASK (BIT(CC_RNG_IMR_EHR_VALID_INT_MASK_BIT_SHIFT) | \
+			 BIT(CC_RNG_IMR_AUTOCORR_ERR_INT_MASK_BIT_SHIFT) | \
+			 BIT(CC_RNG_IMR_CRNGT_ERR_INT_MASK_BIT_SHIFT) | \
+			 BIT(CC_RNG_IMR_VN_ERR_INT_MASK_BIT_SHIFT) | \
+			 BIT(CC_RNG_IMR_WATCHDOG_INT_MASK_BIT_SHIFT))
+
+// --------------------------------------
+// BLOCK: RNG
+// --------------------------------------
+#define CC_RNG_IMR_REG_OFFSET	0x0100UL
+#define CC_RNG_IMR_EHR_VALID_INT_MASK_BIT_SHIFT	0x0UL
+#define CC_RNG_IMR_AUTOCORR_ERR_INT_MASK_BIT_SHIFT	0x1UL
+#define CC_RNG_IMR_CRNGT_ERR_INT_MASK_BIT_SHIFT	0x2UL
+#define CC_RNG_IMR_VN_ERR_INT_MASK_BIT_SHIFT	0x3UL
+#define CC_RNG_IMR_WATCHDOG_INT_MASK_BIT_SHIFT	0x4UL
+#define CC_RNG_ISR_REG_OFFSET	0x0104UL
+#define CC_RNG_ISR_EHR_VALID_BIT_SHIFT	0x0UL
+#define CC_RNG_ISR_EHR_VALID_BIT_SIZE	0x1UL
+#define CC_RNG_ISR_AUTOCORR_ERR_BIT_SHIFT	0x1UL
+#define CC_RNG_ISR_AUTOCORR_ERR_BIT_SIZE	0x1UL
+#define CC_RNG_ISR_CRNGT_ERR_BIT_SHIFT	0x2UL
+#define CC_RNG_ISR_CRNGT_ERR_BIT_SIZE	0x1UL
+#define CC_RNG_ISR_WATCHDOG_BIT_SHIFT	0x4UL
+#define CC_RNG_ISR_WATCHDOG_BIT_SIZE	0x1UL
+#define CC_RNG_ICR_REG_OFFSET	0x0108UL
+#define CC_TRNG_CONFIG_REG_OFFSET	0x010CUL
+#define CC_EHR_DATA_0_REG_OFFSET	0x0114UL
+#define CC_RND_SOURCE_ENABLE_REG_OFFSET	0x012CUL
+#define CC_SAMPLE_CNT1_REG_OFFSET	0x0130UL
+#define CC_TRNG_DEBUG_CONTROL_REG_OFFSET	0x0138UL
+#define CC_RNG_SW_RESET_REG_OFFSET	0x0140UL
+#define CC_RNG_CLK_ENABLE_REG_OFFSET	0x01C4UL
+#define CC_RNG_DMA_ENABLE_REG_OFFSET	0x01C8UL
+#define CC_RNG_WATCHDOG_VAL_REG_OFFSET	0x01D8UL
+// --------------------------------------
+// BLOCK: SEC_HOST_RGF
+// --------------------------------------
+#define CC_HOST_RGF_IRR_REG_OFFSET	0x0A00UL
+#define CC_HOST_RGF_IRR_RNG_INT_BIT_SHIFT	0xAUL
+#define CC_HOST_RGF_IMR_REG_OFFSET	0x0A04UL
+#define CC_HOST_RGF_ICR_REG_OFFSET	0x0A08UL
+
+#define CC_HOST_POWER_DOWN_EN_REG_OFFSET	0x0A78UL
+
+// --------------------------------------
+// BLOCK: NVM
+// --------------------------------------
+#define CC_NVM_IS_IDLE_REG_OFFSET	0x0F10UL
+#define CC_NVM_IS_IDLE_VALUE_BIT_SHIFT	0x0UL
+#define CC_NVM_IS_IDLE_VALUE_BIT_SIZE	0x1UL
-- 
2.7.4

