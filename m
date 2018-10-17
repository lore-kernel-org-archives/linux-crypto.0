Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJQXPI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 19:15:08 -0400
From: AnilKumar Chimata <anilc@codeaurora.org>
To: andy.gross@linaro.org, david.brown@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        AnilKumar Chimata <anilc@codeaurora.org>
Subject: [PATCH 3/3] crypto: qce: ice: Add support for Inline Crypto Engine
Date: Wed, 17 Oct 2018 20:47:56 +0530
Message-Id: <1539789476-6098-4-git-send-email-anilc@codeaurora.org>
In-Reply-To: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
References: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds support for Inline Crypto Engine (ICE), which
is embedded into storage device/controller such as UFS/eMMC.
ICE is intended for high throughput cryptographic encryption
or decryption of storage data.

Signed-off-by: AnilKumar Chimata <anilc@codeaurora.org>
---
 Documentation/crypto/msm/ice.txt |  235 ++++++
 drivers/crypto/Kconfig           |   10 +
 drivers/crypto/qce/Makefile      |    1 +
 drivers/crypto/qce/ice.c         | 1613 ++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/iceregs.h     |  159 ++++
 include/crypto/ice.h             |   80 ++
 6 files changed, 2098 insertions(+)
 create mode 100644 Documentation/crypto/msm/ice.txt
 create mode 100644 drivers/crypto/qce/ice.c
 create mode 100644 drivers/crypto/qce/iceregs.h
 create mode 100644 include/crypto/ice.h

diff --git a/Documentation/crypto/msm/ice.txt b/Documentation/crypto/msm/ice.txt
new file mode 100644
index 0000000..58f7081
--- /dev/null
+++ b/Documentation/crypto/msm/ice.txt
@@ -0,0 +1,235 @@
+Introduction:
+=============
+Storage encryption has been one of the most required feature from security
+point of view. QTI based storage encryption solution uses general purpose
+crypto engine. While this kind of solution provide a decent amount of
+performance, it falls short as storage speed is improving significantly
+continuously. To overcome performance degradation, newer chips are going to
+have Inline Crypto Engine (ICE) embedded into storage device. ICE is supposed
+to meet the line speed of storage devices.
+
+Hardware Description
+====================
+ICE is a HW block that is embedded into storage device such as UFS/eMMC. By
+default, ICE works in bypass mode i.e. ICE HW does not perform any crypto
+operation on data to be processed by storage device. If required, ICE can be
+configured to perform crypto operation in one direction (i.e. either encryption
+or decryption) or in both direction(both encryption & decryption).
+
+When a switch between the operation modes(plain to crypto or crypto to plain)
+is desired for a particular partition, SW must complete all transactions for
+that particular partition before switching the crypto mode i.e. no crypto, one
+direction crypto or both direction crypto operation. Requests for other
+partitions are not impacted due to crypto mode switch.
+
+ICE HW currently supports AES128/256 bit ECB & XTS mode encryption algorithms.
+
+Keys for crypto operations are loaded from SW. Keys are stored in a lookup
+table(LUT) located inside ICE HW. Maximum of 32 keys can be loaded in ICE key
+LUT. A Key inside the LUT can be referred using a key index.
+
+SW Description
+==============
+ICE HW has categorized ICE registers in 2 groups: those which can be accessed by
+only secure side i.e. TZ and those which can be accessed by non-secure side such
+as HLOS as well. This requires that ICE driver to be split in two pieces: one
+running from TZ space and another from HLOS space.
+
+ICE driver from TZ would configure keys as requested by HLOS side.
+
+ICE driver on HLOS side is responsible for initialization of ICE HW.
+
+SW Architecture Diagram
+=======================
+Following are all the components involved in the ICE driver for control path:
+
++++++++++++++++++++++++++++++++++++++++++
++               App layer               +
++++++++++++++++++++++++++++++++++++++++++
++             System layer              +
++   ++++++++         +++++++            +
++   + VOLD +         + PFM +            +
++   ++++++++         +++++++            +
++         ||         ||                 +
++         ||         ||                 +
++         \/         \/                 +
++     +++++++++++++++++++++++++++       +
++     + LibQSEECom / cryptfs_hw +       +
++     +++++++++++++++++++++++++++       +
++++++++++++++++++++++++++++++++++++++++++
++             Kernel                    +       +++++++++++++++++
++                                       +       +     KMS       +
++  +++++++  +++++++++++  +++++++++++    +       +++++++++++++++++
++  + ICE +  + Storage +  + QSEECom +    +       +   ICE Driver  +
++++++++++++++++++++++++++++++++++++++++++ <===> +++++++++++++++++
+               ||                                    ||
+               ||                                    ||
+               \/                                    \/
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++                      Storage Device                           +
++                      ++++++++++++++                           +
++                      +   ICE HW   +                           +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+
+Use Cases:
+----------
+a) Device bootup
+ICE HW is detected during bootup time and corresponding probe function is
+called. ICE driver parses its data from device tree node. ICE HW and storage
+HW are tightly coupled. Storage device probing is dependent upon ICE device
+probing. ICE driver configures all the required registers to put the ICE HW
+in bypass mode.
+
+b) Configuring keys
+Currently, there are couple of use cases to configure the keys.
+
+1) Full Disk Encryption(FDE)
+System layer(VOLD) at invocation of apps layer would call libqseecom to create
+the encryption key. Libqseecom calls qseecom driver to communicate with KMS
+module on the secure side i.e. TZ. KMS would call ICE driver on the TZ side to
+create and set the keys in ICE HW. At the end of transaction, VOLD would have
+key index of key LUT where encryption key is present.
+
+2) Per File Encryption (PFE)
+Per File Manager(PFM) calls QSEECom api to create the key. PFM has a peer comp-
+onent(PFT) at kernel layer which gets the corresponding key index from PFM.
+
+Following are all the components involved in the ICE driver for data path:
+
+       +++++++++++++++++++++++++++++++++++++++++
+       +               App layer               +
+       +++++++++++++++++++++++++++++++++++++++++
+       +              VFS                      +
+       +---------------------------------------+
+       +         File System (EXT4)            +
+       +---------------------------------------+
+       +             Block Layer               +
+       + --------------------------------------+
+       +                              +++++++  +
+       +              dm-req-crypt => + PFT +  +
+       +                              +++++++  +
+       +                                       +
+       +---------------------------------------+
+       +    +++++++++++           +++++++      +
+       +    + Storage +           + ICE +      +
+       +++++++++++++++++++++++++++++++++++++++++
+       +                  ||                   +
+       +                  || (Storage Req with +
+       +                  \/  ICE parameters ) +
+       +++++++++++++++++++++++++++++++++++++++++
+       +          Storage Device               +
+       +          ++++++++++++++               +
+       +          +   ICE HW   +               +
+       +++++++++++++++++++++++++++++++++++++++++
+
+c) Data transaction
+Once the crypto key has been configured, VOLD/PFM creates device mapping for
+data partition. As part of device mapping VOLD passes key index, crypto
+algorithm, mode and key length to dm layer. In case of PFE, keys are provided
+by PFT as and when request is processed by dm-req-crypt. When any application
+needs to read/write data, it would go through DM layer which would add crypto
+information, provided by VOLD/PFT, to Request. For each Request, Storage driver
+would ask ICE driver to configure crypto part of request. ICE driver extracts
+crypto data from Request structure and provide it to storage driver which would
+finally dispatch request to storage device.
+
+d) Error Handling
+Due to issue # 1 mentioned in "Known Issues", ICE driver does not register for
+any interrupt. However, it enables sources of interrupt for ICE HW. After each
+data transaction, Storage driver receives transaction completion event. As part
+of event handling, storage driver calls  ICE driver to check if any of ICE
+interrupt status is set. If yes, storage driver returns error to upper layer.
+
+Error handling would be changed in future chips.
+
+Interfaces
+==========
+ICE driver exposes interfaces for storage driver to :
+1. Get the global instance of ICE driver
+2. Get the implemented interfaces of the particular ice instance
+3. Initialize the ICE HW
+4. Reset the ICE HW
+5. Resume/Suspend the ICE HW
+6. Get the Crypto configuration for the data request for storage
+7. Check if current data transaction has generated any interrupt
+
+Driver Parameters
+=================
+This driver is built and statically linked into the kernel; therefore,
+there are no module parameters supported by this driver.
+
+There are no kernel command line parameters supported by this driver.
+
+Power Management
+================
+ICE driver does not do power management on its own as it is part of storage
+hardware. Whenever storage driver receives request for power collapse/suspend
+resume, it would call ICE driver which exposes APIs for Storage HW. ICE HW
+during power collapse or reset, wipes crypto configuration data. When ICE
+driver receives request to resume, it would ask ICE driver on TZ side to
+restore the configuration. ICE driver does not do anything as part of power
+collapse or suspend event.
+
+Interface:
+==========
+ICE driver exposes following APIs for storage driver to use:
+
+int (*init)(struct platform_device *, void *, ice_success_cb, ice_error_cb);
+	-- This function is invoked by storage controller during initialization of
+	storage controller. Storage controller would provide success and error call
+	backs which would be invoked asynchronously once ICE HW init is done.
+
+int (*reset)(struct platform_device *);
+	-- ICE HW reset as part of storage controller reset. When storage controller
+	received reset command, it would call reset on ICE HW. As of now, ICE HW
+	does not need to do anything as part of reset.
+
+int (*resume)(struct platform_device *);
+	-- ICE HW while going to reset, wipes all crypto keys and other data from ICE
+	HW. ICE driver would reconfigure those data as part of resume operation.
+
+int (*suspend)(struct platform_device *);
+	-- This API would be called by storage driver when storage device is going to
+	suspend mode. As of today, ICE driver does not do anything to handle suspend.
+
+int (*config)(struct platform_device *, struct request* , struct ice_data_setting*);
+	-- Storage driver would call this interface to get all crypto data required to
+	perform crypto operation.
+
+int (*status)(struct platform_device *);
+	-- Storage driver would call this interface to check if previous data transfer
+	generated any error.
+
+Config options
+==============
+This driver is enabled by the kernel config option CONFIG_CRYPTO_DEV_MSM_ICE.
+
+Dependencies
+============
+ICE driver depends upon corresponding ICE driver on TZ side to function
+appropriately.
+
+Known Issues
+============
+1. ICE HW emits 0s even if it has generated an interrupt
+This issue has significant impact on how ICE interrupts are handled. Currently,
+ICE driver does not register for any of the ICE interrupts but enables the
+sources of interrupt. Once storage driver asks to check the status of interrupt,
+it reads and clears the clear status and provide read status to storage driver.
+This mechanism though not optimal but prevents file-system corruption.
+This issue has been fixed in newer chips.
+
+2. ICE HW wipes all crypto data during power collapse
+This issue necessitate that ICE driver on TZ side store the crypto material
+which is not required in the case of general purpose crypto engine.
+This issue has been fixed in newer chips.
+
+Further Improvements
+====================
+Currently, Due to PFE use case, ICE driver is dependent upon dm-req-crypt to
+provide the keys as part of request structure. This couples ICE driver with
+dm-req-crypt based solution. It is under discussion to expose an IOCTL based
+and registration based interface APIs from ICE driver. ICE driver would use
+these two interfaces to find out if any key exists for current request. If
+yes, choose the right key index received from IOCTL or registration based
+APIs. If not, dont set any crypto parameter in the request.
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index a8c4ce0..e40750e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -596,6 +596,16 @@ config CRYPTO_DEV_QCOM_RNG
 	  To compile this driver as a module, choose M here. The
           module will be called qcom-rng. If unsure, say N.
 
+config CRYPTO_DEV_QTI_ICE
+	tristate "Qualcomm inline crypto engine accelerator"
+	default n
+	depends on (ARCH_QCOM || COMPILE_TEST) && BLK_DEV_DM
+	help
+	  This driver supports Inline Crypto Engine for QTI chipsets, MSM8994
+	  and later, to accelerate crypto operations for storage needs.
+	  To compile this driver as a module, choose M here: the
+	  module will be called ice.
+
 config CRYPTO_DEV_VMX
 	bool "Support for VMX cryptographic acceleration instructions"
 	depends on PPC64 && VSX
diff --git a/drivers/crypto/qce/Makefile b/drivers/crypto/qce/Makefile
index 19a7f89..0ca7925 100644
--- a/drivers/crypto/qce/Makefile
+++ b/drivers/crypto/qce/Makefile
@@ -5,3 +5,4 @@ qcrypto-objs := core.o \
 		dma.o \
 		sha.o \
 		ablkcipher.o
+obj-$(CONFIG_CRYPTO_DEV_QTI_ICE) += ice.o
diff --git a/drivers/crypto/qce/ice.c b/drivers/crypto/qce/ice.c
new file mode 100644
index 0000000..0c8819f
--- /dev/null
+++ b/drivers/crypto/qce/ice.c
@@ -0,0 +1,1613 @@
+/* Copyright (c) 2014-2018, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/device-mapper.h>
+#include <linux/clk.h>
+#include <linux/cdev.h>
+#include <linux/regulator/consumer.h>
+#include <linux/qcom_scm.h>
+
+#include <crypto/ice.h>
+
+#include "iceregs.h"
+
+#define TZ_MASK_BITS(h, l)				\
+	((0xffffffff >> (32 - (((h) - (l)) + 1))) << (l))
+
+#define TZ_SYSCALL_PARAM_TYPE_VAL	0x0
+#define TZ_SYSCALL_PARAM_NARGS_MASK	TZ_MASK_BITS(3, 0)
+#define TZ_SYSCALL_PARAM_TYPE_MASK	TZ_MASK_BITS(1, 0)
+
+#define TZ_SYSCALL_CREATE_PARAM_ID(nargs, p1, p2, p3,	\
+	p4, p5, p6, p7, p8, p9, p10)			\
+	(((nargs) & TZ_SYSCALL_PARAM_NARGS_MASK) +	\
+	(((p1) & TZ_SYSCALL_PARAM_TYPE_MASK) << 4) +	\
+	(((p2) & TZ_SYSCALL_PARAM_TYPE_MASK) << 6) +	\
+	(((p3) & TZ_SYSCALL_PARAM_TYPE_MASK) << 8) +	\
+	(((p4) & TZ_SYSCALL_PARAM_TYPE_MASK) << 10) +	\
+	(((p5) & TZ_SYSCALL_PARAM_TYPE_MASK) << 12) +	\
+	(((p6) & TZ_SYSCALL_PARAM_TYPE_MASK) << 14) +	\
+	(((p7) & TZ_SYSCALL_PARAM_TYPE_MASK) << 16) +	\
+	(((p8) & TZ_SYSCALL_PARAM_TYPE_MASK) << 18) +	\
+	(((p9) & TZ_SYSCALL_PARAM_TYPE_MASK) << 20) +	\
+	(((p10) & TZ_SYSCALL_PARAM_TYPE_MASK) << 22))
+
+#define TZ_SYSCALL_CREATE_PARAM_ID_1(p1) \
+	TZ_SYSCALL_CREATE_PARAM_ID(1, (p1), 0, 0, 0, 0, 0, 0, 0, 0, 0)
+
+#define TZ_SYSCALL_CREATE_PARAM_ID_0 0
+
+#define TZ_OS_KS_RESTORE_KEY_ID_PARAM_ID \
+	TZ_SYSCALL_CREATE_PARAM_ID_0
+
+#define TZ_OS_KS_RESTORE_KEY_CONFIG_ID_PARAM_ID \
+	TZ_SYSCALL_CREATE_PARAM_ID_1(TZ_SYSCALL_PARAM_TYPE_VAL)
+
+#define ICE_REV(x, y) (((x) & ICE_CORE_##y##_REV_MASK) >> ICE_CORE_##y##_REV)
+
+#define OF_BUS_MIN_BW			"minimum"
+#define OF_BUS_MAX_BW			"maximum"
+#define ENCRYPT_PARTITION		"userdata"
+#define QTI_UFS_ICE_DEV			"iceufs"
+#define QTI_SDCC_ICE_DEV		"icesdcc"
+#define QTI_SDCC_STORAGE_TYPE		"sdcc"
+#define QTI_UFS_STORAGE_TYPE		"ufs"
+#define QTI_ICE_TYPE_NAME_LEN		8
+#define QTI_ICE_MAX_BIST_CHECK_COUNT	100
+#define QTI_ICE_UFS			10
+#define QTI_ICE_SDCC			20
+#define QTI_ICE_ENCRYPT			0x1
+#define QTI_ICE_DECRYPT			0x2
+#define QTI_SECT_LEN_IN_BYTE		512
+#define QTI_UD_FOOTER_SIZE		0x4000
+#define QTI_UD_FOOTER_SECS		\
+	(QTI_UD_FOOTER_SIZE / QTI_SECT_LEN_IN_BYTE)
+#define RESTORE_SEC_CFG_CMD		0x2
+#define ICE_TZ_DEV_ID			20
+
+
+struct ice_clk_info {
+	struct list_head list;
+	struct clk *clk;
+	const char *name;
+	u32 max_freq;
+	u32 min_freq;
+	u32 curr_freq;
+	bool enabled;
+};
+
+/* scm command buffer structure */
+struct qcom_scm_cmd_buf {
+	unsigned int device_id;
+	unsigned int spare;
+};
+
+/*
+ * ICE HW device structure.
+ */
+struct ice_device {
+	struct list_head	list;
+	struct device		*pdev;
+	struct cdev		cdev;
+	dev_t			device_no;
+	struct class		*driver_class;
+	void __iomem		*mmio;
+	struct resource		*res;
+	int			irq;
+	bool			is_ice_enabled;
+	bool			is_ice_disable_fuse_blown;
+	ice_error_cb		error_cb;
+	void			*host_controller_data; /* UFS/EMMC/other? */
+	struct list_head	clk_list_head;
+	u32			ice_hw_version;
+	bool			is_ice_clk_available;
+	char			ice_instance_type[QTI_ICE_TYPE_NAME_LEN];
+	struct regulator	*reg;
+	bool			is_regulator_available;
+	ktime_t			ice_reset_start_time;
+	ktime_t			ice_reset_complete_time;
+};
+
+static int qcom_ice_enable_clocks(struct ice_device *, bool);
+static LIST_HEAD(ice_devices);
+static int ice_fde_flag;
+
+static int qti_ice_setting_config(struct request *req,
+		struct platform_device *pdev,
+		struct ice_crypto_setting *crypto_data,
+		struct ice_data_setting *setting)
+{
+	struct ice_device *ice_dev = NULL;
+
+	ice_dev = platform_get_drvdata(pdev);
+	if (!ice_dev) {
+		pr_debug("%s(): no ICE device\n", __func__);
+		return 0;
+	}
+
+	if (ice_dev->is_ice_disable_fuse_blown) {
+		pr_err("%s(): ICE disabled fuse is blown\n", __func__);
+		return -EPERM;
+	}
+
+	if (!setting)
+		return -EINVAL;
+
+	if ((short)(crypto_data->key_index) >= 0) {
+		memcpy(&setting->crypto_data, crypto_data,
+				sizeof(setting->crypto_data));
+
+		switch (rq_data_dir(req)) {
+		case WRITE:
+			if (!ice_fde_flag || (ice_fde_flag & QTI_ICE_ENCRYPT))
+				setting->encr_bypass = false;
+			break;
+		case READ:
+			if (!ice_fde_flag || (ice_fde_flag & QTI_ICE_DECRYPT))
+				setting->decr_bypass = false;
+			break;
+		default:
+			/* Should I say BUG_ON */
+			setting->encr_bypass = true;
+			setting->decr_bypass = true;
+			pr_debug("%s(): direction unknown\n", __func__);
+			break;
+		}
+	}
+	return 0;
+}
+
+void qcom_ice_set_fde_flag(int flag)
+{
+	ice_fde_flag = flag;
+}
+EXPORT_SYMBOL(qcom_ice_set_fde_flag);
+
+static int qcom_ice_get_vreg(struct ice_device *ice_dev)
+{
+	int ret = 0;
+
+	if (!ice_dev->is_regulator_available)
+		return 0;
+
+	if (ice_dev->reg)
+		return 0;
+
+	ice_dev->reg = devm_regulator_get(ice_dev->pdev, "vdd-hba");
+	if (IS_ERR(ice_dev->reg)) {
+		ret = PTR_ERR(ice_dev->reg);
+		dev_err(ice_dev->pdev, "%s(): %s get failed, err=%d\n",
+			__func__, "vdd-hba-supply", ret);
+	}
+	return ret;
+}
+
+static void qcom_ice_config_proc_ignore(struct ice_device *ice_dev)
+{
+	u32 regval;
+
+	if (ICE_REV(ice_dev->ice_hw_version, MAJOR) == 2 &&
+	    ICE_REV(ice_dev->ice_hw_version, MINOR) == 0 &&
+	    ICE_REV(ice_dev->ice_hw_version, STEP) == 0) {
+		regval = qcom_ice_readl(ice_dev,
+				QTI_ICE_REGS_ADVANCED_CONTROL);
+		regval |= 0x800;
+		qcom_ice_writel(ice_dev, regval,
+				QTI_ICE_REGS_ADVANCED_CONTROL);
+		/* Ensure register is updated */
+		mb();
+	}
+}
+
+static void qcom_ice_low_power_mode_enable(struct ice_device *ice_dev)
+{
+	u32 regval;
+
+	regval = qcom_ice_readl(ice_dev, QTI_ICE_REGS_ADVANCED_CONTROL);
+	/*
+	 * Enable low power mode sequence
+	 * [0]-0, [1]-0, [2]-0, [3]-E, [4]-0, [5]-0, [6]-0, [7]-0
+	 */
+	regval |= 0x7000;
+	qcom_ice_writel(ice_dev, regval, QTI_ICE_REGS_ADVANCED_CONTROL);
+	/*
+	 * Ensure previous instructions was completed before issuing next
+	 * ICE initialization/optimization instruction
+	 */
+	mb();
+}
+
+static void qcom_ice_enable_test_bus_config(struct ice_device *ice_dev)
+{
+	/*
+	 * Configure & enable ICE_TEST_BUS_REG to reflect ICE intr lines
+	 * MAIN_TEST_BUS_SELECTOR = 0 (ICE_CONFIG)
+	 * TEST_BUS_REG_EN = 1 (ENABLE)
+	 */
+	u32 regval;
+
+	if (ICE_REV(ice_dev->ice_hw_version, MAJOR) >= 2)
+		return;
+
+	regval = qcom_ice_readl(ice_dev, QTI_ICE_REGS_TEST_BUS_CONTROL);
+	regval &= 0x0FFFFFFF;
+	/* TBD: replace 0x2 with define in iceregs.h */
+	regval |= 0x2;
+	qcom_ice_writel(ice_dev, regval, QTI_ICE_REGS_TEST_BUS_CONTROL);
+
+	/*
+	 * Ensure previous instructions was completed before issuing next
+	 * ICE initialization/optimization instruction
+	 */
+	mb();
+}
+
+static void qcom_ice_optimization_enable(struct ice_device *ice_dev)
+{
+	u32 regval;
+
+	regval = qcom_ice_readl(ice_dev, QTI_ICE_REGS_ADVANCED_CONTROL);
+	if (ICE_REV(ice_dev->ice_hw_version, MAJOR) >= 2)
+		regval |= 0xD807100;
+	else if (ICE_REV(ice_dev->ice_hw_version, MAJOR) == 1)
+		regval |= 0x3F007100;
+
+	/* ICE Optimizations Enable Sequence */
+	udelay(5);
+	/* [0]-0, [1]-0, [2]-8, [3]-E, [4]-0, [5]-0, [6]-F, [7]-A */
+	qcom_ice_writel(ice_dev, regval, QTI_ICE_REGS_ADVANCED_CONTROL);
+	/*
+	 * Ensure previous instructions was completed before issuing next
+	 * ICE initialization/optimization instruction
+	 */
+	mb();
+
+	/* ICE HPG requires sleep before writing */
+	udelay(5);
+	if (ICE_REV(ice_dev->ice_hw_version, MAJOR) == 1) {
+		regval = 0;
+		regval = qcom_ice_readl(ice_dev, QTI_ICE_REGS_ENDIAN_SWAP);
+		regval |= 0xF;
+		qcom_ice_writel(ice_dev, regval, QTI_ICE_REGS_ENDIAN_SWAP);
+		/*
+		 * Ensure previous instructions were completed before issue
+		 * next ICE commands
+		 */
+		mb();
+	}
+}
+
+static int qcom_ice_wait_bist_status(struct ice_device *ice_dev)
+{
+	int count;
+	u32 reg;
+
+	/* Poll until all BIST bits are reset */
+	for (count = 0; count < QTI_ICE_MAX_BIST_CHECK_COUNT; count++) {
+		reg = qcom_ice_readl(ice_dev, QTI_ICE_REGS_BIST_STATUS);
+		if (!(reg & ICE_BIST_STATUS_MASK))
+			break;
+		udelay(50);
+	}
+
+	if (reg)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int qcom_ice_enable(struct ice_device *ice_dev)
+{
+	unsigned int reg;
+	int ret = 0;
+
+	if ((ICE_REV(ice_dev->ice_hw_version, MAJOR) > 2) ||
+		((ICE_REV(ice_dev->ice_hw_version, MAJOR) == 2) &&
+		 (ICE_REV(ice_dev->ice_hw_version, MINOR) >= 1)))
+		ret = qcom_ice_wait_bist_status(ice_dev);
+	if (ret) {
+		dev_err(ice_dev->pdev, "BIST status error (%d)\n", ret);
+		return ret;
+	}
+
+	/* Starting ICE v3 enabling is done at storage controller (UFS/SDCC) */
+	if (ICE_REV(ice_dev->ice_hw_version, MAJOR) >= 3)
+		return 0;
+
+	/*
+	 * To enable ICE, perform following
+	 * 1. Set IGNORE_CONTROLLER_RESET to USE in ICE_RESET register
+	 * 2. Disable GLOBAL_BYPASS bit in ICE_CONTROL register
+	 */
+	reg = qcom_ice_readl(ice_dev, QTI_ICE_REGS_RESET);
+
+	if (ICE_REV(ice_dev->ice_hw_version, MAJOR) >= 2)
+		reg &= 0x0;
+	else if (ICE_REV(ice_dev->ice_hw_version, MAJOR) == 1)
+		reg &= ~0x100;
+
+	qcom_ice_writel(ice_dev, reg, QTI_ICE_REGS_RESET);
+
+	/*
+	 * Ensure previous instructions was completed before issuing next
+	 * ICE initialization/optimization instruction
+	 */
+	mb();
+
+	reg = qcom_ice_readl(ice_dev, QTI_ICE_REGS_CONTROL);
+
+	if (ICE_REV(ice_dev->ice_hw_version, MAJOR) >= 2)
+		reg &= 0xFFFE;
+	else if (ICE_REV(ice_dev->ice_hw_version, MAJOR) == 1)
+		reg &= ~0x7;
+	qcom_ice_writel(ice_dev, reg, QTI_ICE_REGS_CONTROL);
+
+	/*
+	 * Ensure previous instructions was completed before issuing next
+	 * ICE initialization/optimization instruction
+	 */
+	mb();
+
+	if ((ICE_REV(ice_dev->ice_hw_version, MAJOR) > 2) ||
+		((ICE_REV(ice_dev->ice_hw_version, MAJOR) == 2) &&
+		 (ICE_REV(ice_dev->ice_hw_version, MINOR) >= 1))) {
+		reg = qcom_ice_readl(ice_dev, QTI_ICE_REGS_BYPASS_STATUS);
+		if ((reg & 0x80000000) != 0x0) {
+			dev_err(ice_dev->pdev,
+				"%s(): Bypass failed for ice = %pK",
+				__func__, (void *)ice_dev);
+			WARN_ON(1);
+		}
+	}
+	return 0;
+}
+
+static int qcom_ice_verify_ice(struct ice_device *ice_dev)
+{
+	unsigned int maj_rev, min_rev, step_rev;
+	unsigned int rev;
+
+	rev = qcom_ice_readl(ice_dev, QTI_ICE_REGS_VERSION);
+	maj_rev = (rev & ICE_CORE_MAJOR_REV_MASK) >> ICE_CORE_MAJOR_REV;
+	min_rev = (rev & ICE_CORE_MINOR_REV_MASK) >> ICE_CORE_MINOR_REV;
+	step_rev = (rev & ICE_CORE_STEP_REV_MASK) >> ICE_CORE_STEP_REV;
+
+	if (maj_rev > ICE_CORE_CURRENT_MAJOR_VERSION) {
+		dev_err(ice_dev->pdev,
+			"%s(): Unknown QTI ICE device at %lu, rev %d.%d.%d\n",
+			__func__, (unsigned long)ice_dev->mmio,
+			maj_rev, min_rev, step_rev);
+		return -ENODEV;
+	}
+	ice_dev->ice_hw_version = rev;
+
+	dev_info(ice_dev->pdev, "QTI ICE %d.%d.%d device found @0x%pK\n",
+					maj_rev, min_rev, step_rev,
+					ice_dev->mmio);
+
+	return 0;
+}
+
+static void qcom_ice_enable_intr(struct ice_device *ice_dev)
+{
+	unsigned int reg;
+
+	reg = qcom_ice_readl(ice_dev, QTI_ICE_REGS_NON_SEC_IRQ_MASK);
+	reg &= ~QTI_ICE_NON_SEC_IRQ_MASK;
+	qcom_ice_writel(ice_dev, reg, QTI_ICE_REGS_NON_SEC_IRQ_MASK);
+	/*
+	 * Ensure previous instructions was completed before issuing next
+	 * ICE initialization/optimization instruction
+	 */
+	mb();
+}
+
+static void qcom_ice_disable_intr(struct ice_device *ice_dev)
+{
+	unsigned int reg;
+
+	reg = qcom_ice_readl(ice_dev, QTI_ICE_REGS_NON_SEC_IRQ_MASK);
+	reg |= QTI_ICE_NON_SEC_IRQ_MASK;
+	qcom_ice_writel(ice_dev, reg, QTI_ICE_REGS_NON_SEC_IRQ_MASK);
+	/*
+	 * Ensure previous instructions was completed before issuing next
+	 * ICE initialization/optimization instruction
+	 */
+	mb();
+}
+
+static irqreturn_t qcom_ice_isr(int isr, void *data)
+{
+	struct ice_device *ice_dev = data;
+	irqreturn_t retval = IRQ_NONE;
+	u32 status;
+
+	status = qcom_ice_readl(ice_dev, QTI_ICE_REGS_NON_SEC_IRQ_STTS);
+	if (status) {
+		ice_dev->error_cb(ice_dev->host_controller_data, status);
+
+		/* Interrupt has been handled. Clear the IRQ */
+		qcom_ice_writel(ice_dev, status, QTI_ICE_REGS_NON_SEC_IRQ_CLR);
+		/* Ensure instruction is completed */
+		mb();
+		retval = IRQ_HANDLED;
+	}
+	return retval;
+}
+
+static void qcom_ice_parse_ice_instance_type(struct platform_device *pdev,
+		struct ice_device *ice_dev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	const char *type;
+	int ret = -1;
+
+	ret = of_property_read_string_index(np, "qcom,instance-type", 0, &type);
+	if (ret) {
+		dev_err(dev,
+			"%s(): Could not get ICE instance type\n", __func__);
+		goto out;
+	}
+	strlcpy(ice_dev->ice_instance_type, type, QTI_ICE_TYPE_NAME_LEN);
+out:
+	return;
+}
+
+static int qcom_ice_parse_clock_info(struct platform_device *pdev,
+		struct ice_device *ice_dev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct ice_clk_info *clki;
+	int ret = -1, cnt, i, len;
+	u32 *clkfreq = NULL;
+	char *name;
+
+	if (!np)
+		goto out;
+
+	cnt = of_property_count_strings(np, "clock-names");
+	if (cnt <= 0) {
+		dev_info(dev, "%s(): Unable to find clocks, assuming enabled\n",
+			__func__);
+		ret = cnt;
+		goto out;
+	}
+
+	if (!of_get_property(np, "qcom,op-freq-hz", &len)) {
+		dev_info(dev, "qcom,op-freq-hz property not specified\n");
+		goto out;
+	}
+
+	len = len/sizeof(*clkfreq);
+	if (len != cnt)
+		goto out;
+
+	clkfreq = devm_kzalloc(dev, len * sizeof(*clkfreq), GFP_KERNEL);
+	if (!clkfreq) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = of_property_read_u32_array(np, "qcom,op-freq-hz", clkfreq, len);
+
+	INIT_LIST_HEAD(&ice_dev->clk_list_head);
+
+	for (i = 0; i < cnt; i++) {
+		ret = of_property_read_string_index(np,
+				"clock-names", i, (const char **)&name);
+		if (ret)
+			goto out;
+
+		clki = devm_kzalloc(dev, sizeof(*clki), GFP_KERNEL);
+		if (!clki) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		clki->max_freq = clkfreq[i];
+		clki->name = kstrdup(name, GFP_KERNEL);
+		list_add_tail(&clki->list, &ice_dev->clk_list_head);
+	}
+out:
+	if (clkfreq)
+		devm_kfree(dev, (void *)clkfreq);
+	return ret;
+}
+
+static int qcom_ice_get_device_tree_data(struct platform_device *pdev,
+		struct ice_device *ice_dev)
+{
+	struct device *dev = &pdev->dev;
+	int rc = -1;
+	int irq;
+
+	ice_dev->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!ice_dev->res) {
+		dev_err(dev,
+			"%s(): No memory available for IORESOURCE\n", __func__);
+		return -ENOMEM;
+	}
+
+	ice_dev->mmio = devm_ioremap_resource(dev, ice_dev->res);
+	if (IS_ERR(ice_dev->mmio)) {
+		rc = PTR_ERR(ice_dev->mmio);
+		dev_err(dev,
+			"%s(): Err = %d mapping ICE io memory\n", __func__, rc);
+		goto out;
+	}
+
+	if (!of_parse_phandle(pdev->dev.of_node, "power-domains", 0)) {
+		dev_err(dev,
+			"%s(): No vdd-hba-supply regulator, assuming not needed\n",
+							 __func__);
+		ice_dev->is_regulator_available = false;
+	} else {
+		ice_dev->is_regulator_available = true;
+	}
+	ice_dev->is_ice_clk_available = of_property_read_bool(
+						(&pdev->dev)->of_node,
+						"qcom,enable-ice-clk");
+
+	if (ice_dev->is_ice_clk_available) {
+		rc = qcom_ice_parse_clock_info(pdev, ice_dev);
+		if (rc) {
+			dev_err(dev,
+				"%s(): qcom_ice_parse_clock_info failed (%d)\n",
+				__func__, rc);
+			goto err_dev;
+		}
+	}
+
+	/* ICE interrupts is only relevant for v2.x */
+	irq = platform_get_irq(pdev, 0);
+	if (irq >= 0) {
+		rc = devm_request_irq(dev, irq, qcom_ice_isr, 0, dev_name(dev),
+				ice_dev);
+		if (rc) {
+			dev_err(dev,
+				"%s(): devm_request_irq irq=%d failed (%d)\n",
+				__func__, irq, rc);
+			goto err_dev;
+		}
+		ice_dev->irq = irq;
+		dev_info(dev, "ICE IRQ = %d\n", ice_dev->irq);
+	} else {
+		dev_dbg(dev, "IRQ resource not available\n");
+	}
+
+	qcom_ice_parse_ice_instance_type(pdev, ice_dev);
+
+	return 0;
+err_dev:
+	if (rc && ice_dev->mmio)
+		devm_iounmap(dev, ice_dev->mmio);
+out:
+	return rc;
+}
+
+static int qcom_ice_restore_key_config(struct ice_device *ice_dev)
+{
+	u32 storage_type = 0;
+	int ret = -1;
+
+	/* For ice 3, key configuration needs to be restored in case of reset */
+	if (!strcmp(ice_dev->ice_instance_type, QTI_SDCC_STORAGE_TYPE))
+		storage_type = QTI_ICE_SDCC;
+
+	if (!strcmp(ice_dev->ice_instance_type, QTI_UFS_STORAGE_TYPE))
+		storage_type = QTI_ICE_UFS;
+
+	ret = qcom_scm_ice_restore_cfg(TZ_OS_KS_RESTORE_KEY_CONFIG_ID_PARAM_ID,
+					storage_type);
+	if (ret)
+		dev_err(ice_dev->pdev, "%s(): Error:  0x%x\n", __func__, ret);
+
+	return ret;
+}
+
+static int qcom_ice_init_clocks(struct ice_device *ice)
+{
+	struct list_head *head = &ice->clk_list_head;
+	struct ice_clk_info *clki = NULL;
+	struct device *dev = ice->pdev;
+	int ret = -EINVAL;
+
+	if (!head || list_empty(head)) {
+		dev_err(dev, "%s(): ICE Clock list null/empty\n", __func__);
+		goto out;
+	}
+
+	list_for_each_entry(clki, head, list) {
+		if (!clki->name)
+			continue;
+
+		clki->clk = devm_clk_get(dev, clki->name);
+		if (IS_ERR(clki->clk)) {
+			ret = PTR_ERR(clki->clk);
+			dev_err(dev, "%s(): %s clk get failed, %d\n",
+					__func__, clki->name, ret);
+			goto out;
+		}
+
+		/* Not all clocks would have a rate to be set */
+		ret = 0;
+		if (clki->max_freq) {
+			ret = clk_set_rate(clki->clk, clki->max_freq);
+			if (ret) {
+				dev_err(dev, "%s(): %s clk set rate(%dHz) failed, %d\n",
+					__func__, clki->name,
+					clki->max_freq, ret);
+				goto out;
+			}
+			clki->curr_freq = clki->max_freq;
+			dev_dbg(dev, "%s(): clk: %s, rate: %lu\n", __func__,
+				clki->name, clk_get_rate(clki->clk));
+		}
+	}
+out:
+	return ret;
+}
+
+static int qcom_ice_enable_clocks(struct ice_device *ice, bool enable)
+{
+	struct list_head *head = &ice->clk_list_head;
+	struct ice_clk_info *clki = NULL;
+	struct device *dev = ice->pdev;
+	int ret = 0;
+
+	if (!head || list_empty(head)) {
+		dev_err(dev, "%s():ICE Clock list null/empty\n", __func__);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!ice->is_ice_clk_available) {
+		dev_err(dev, "%s():ICE Clock not available\n", __func__);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	list_for_each_entry(clki, head, list) {
+		if (!clki->name)
+			continue;
+
+		if (enable)
+			ret = clk_prepare_enable(clki->clk);
+		else
+			clk_disable_unprepare(clki->clk);
+
+		if (ret) {
+			dev_err(dev, "Unable to %s ICE core clk\n",
+				enable?"enable":"disable");
+			goto out;
+		}
+	}
+out:
+	return ret;
+}
+
+static int qcom_ice_secure_ice_init(struct ice_device *ice_dev)
+{
+	unsigned int regval = 0;
+	int ret = 0;
+
+	ret = qcom_scm_io_readl((unsigned long)ice_dev->res +
+			QTI_ICE_LUT_KEYS_ICE_SEC_IRQ_MASK, &regval);
+	if (ret)
+		dev_err(ice_dev->pdev,
+			"%s(): failed(0x%x) to read ICE config\n",
+			__func__, ret);
+
+	regval &= ~QTI_ICE_SEC_IRQ_MASK;
+	ret = qcom_scm_io_writel((unsigned long)ice_dev->res +
+			QTI_ICE_LUT_KEYS_ICE_SEC_IRQ_MASK, regval);
+
+	/*
+	 * Ensure previous instructions was completed before issuing next
+	 * ICE initialization/optimization instruction
+	 */
+	mb();
+
+	if (ret)
+		dev_err(ice_dev->pdev,
+			"%s(): failed(0x%x) to init secure ICE config\n",
+			__func__, ret);
+	return ret;
+}
+
+static int qcom_ice_update_sec_cfg(struct ice_device *ice_dev)
+{
+	struct qcom_scm_cmd_buf cbuf = {0};
+	int ret = 0;
+
+	/*
+	 * Ideally, we should check ICE version to decide whether to proceed or
+	 * or not. Since version wont be available when this function is called
+	 * we need to depend upon is_ice_clk_available to decide
+	 */
+	if (ice_dev->is_ice_clk_available)
+		goto out;
+
+	cbuf.device_id = ICE_TZ_DEV_ID;
+	/*
+	 * Store dev_id in ice_device structure so that emmc/ufs cases can be
+	 * handled properly
+	 */
+	ret = qcom_scm_restore_sec_cfg(cbuf.device_id, cbuf.spare);
+	if (ret)
+		dev_err(ice_dev->pdev, "%s(): failed, ret %d\n", __func__, ret);
+out:
+	return ret;
+}
+
+static int qcom_ice_finish_init(struct ice_device *ice_dev)
+{
+	unsigned int reg;
+	int err = 0;
+
+	if (!ice_dev) {
+		pr_err("%s(): Null data received\n", __func__);
+		err = -ENODEV;
+		goto out;
+	}
+
+	if (ice_dev->is_ice_clk_available) {
+		err = qcom_ice_init_clocks(ice_dev);
+		if (err)
+			goto out;
+	}
+
+	/*
+	 * It is possible that ICE device is not probed when host is probed
+	 * This would cause host probe to be deferred. When probe for host is
+	 * deferred, it can cause power collapse for host and that can wipe
+	 * configurations of host & ice. It is prudent to restore the config
+	 */
+	err = qcom_ice_update_sec_cfg(ice_dev);
+	if (err)
+		goto out;
+
+	err = qcom_ice_verify_ice(ice_dev);
+	if (err)
+		goto out;
+
+	/* if ICE_DISABLE_FUSE is blown, return immediately
+	 * Currently, FORCE HW Keys are also disabled, since
+	 * there is no use case for their usage neither in FDE
+	 * nor in PFE
+	 */
+	reg = qcom_ice_readl(ice_dev, QTI_ICE_REGS_FUSE_SETTING);
+	reg &= (ICE_FUSE_SETTING_MASK |
+		ICE_FORCE_HW_KEY0_SETTING_MASK |
+		ICE_FORCE_HW_KEY1_SETTING_MASK);
+
+	if (reg) {
+		ice_dev->is_ice_disable_fuse_blown = true;
+		dev_err(ice_dev->pdev,
+			"%s(): Error: ICE_ERROR_HW_DISABLE_FUSE_BLOWN\n",
+			__func__);
+		err = -EPERM;
+		goto out;
+	}
+
+	/* TZ side of ICE driver would handle secure init of ICE HW from v2 */
+	if (ICE_REV(ice_dev->ice_hw_version, MAJOR) == 1 &&
+		!qcom_ice_secure_ice_init(ice_dev)) {
+		dev_err(ice_dev->pdev,
+			"%s(): Error: ICE_ERROR_ICE_TZ_INIT_FAILED\n",
+			__func__);
+		err = -EFAULT;
+		goto out;
+	}
+
+	qcom_ice_low_power_mode_enable(ice_dev);
+	qcom_ice_optimization_enable(ice_dev);
+	qcom_ice_config_proc_ignore(ice_dev);
+	qcom_ice_enable_test_bus_config(ice_dev);
+	qcom_ice_enable(ice_dev);
+	ice_dev->is_ice_enabled = true;
+	qcom_ice_enable_intr(ice_dev);
+
+out:
+	return err;
+}
+
+static int qcom_ice_init(struct platform_device *pdev,
+			void *host_controller_data,
+			ice_error_cb error_cb)
+{
+	/*
+	 * A completion event for host controller would be triggered upon
+	 * initialization completion
+	 * When ICE is initialized, it would put ICE into Global Bypass mode
+	 * When any request for data transfer is received, it would enable
+	 * the ICE for that particular request
+	 */
+	struct ice_device *ice_dev;
+
+	ice_dev = platform_get_drvdata(pdev);
+	if (!ice_dev) {
+		pr_err("%s(): invalid device\n", __func__);
+		return -EINVAL;
+	}
+
+	ice_dev->error_cb = error_cb;
+	ice_dev->host_controller_data = host_controller_data;
+
+	return qcom_ice_finish_init(ice_dev);
+}
+
+static int qcom_ice_finish_power_collapse(struct ice_device *ice_dev)
+{
+	int err = 0;
+
+	if (ice_dev->is_ice_disable_fuse_blown) {
+		err = -EPERM;
+		goto out;
+	}
+
+	if (ice_dev->is_ice_enabled) {
+		/*
+		 * ICE resets into global bypass mode with optimization and
+		 * low power mode disabled. Hence we need to redo those seq's.
+		 */
+		qcom_ice_low_power_mode_enable(ice_dev);
+		qcom_ice_enable_test_bus_config(ice_dev);
+		qcom_ice_optimization_enable(ice_dev);
+		qcom_ice_enable(ice_dev);
+		if (ICE_REV(ice_dev->ice_hw_version, MAJOR) == 1) {
+			/*
+			 * When ICE resets, it wipes all of keys from LUTs
+			 * ICE driver should call TZ to restore keys.
+			 *
+			 * TZ would check KEYS_RAM_RESET_COMPLETED status bit
+			 * before processing restore config command. This
+			 * would prevent two calls from HLOS to TZ one to
+			 * check KEYS_RAM_RESET_COMPLETED status bit second
+			 * to restore config.
+			 */
+			if (qcom_scm_ice_restore_cfg(
+					TZ_OS_KS_RESTORE_KEY_ID_PARAM_ID, 0)) {
+				err = -EFAULT;
+				goto out;
+			}
+
+		/*
+		 * ICE looses its key configuration when UFS is reset,
+		 * restore it
+		 */
+		} else if (ICE_REV(ice_dev->ice_hw_version, MAJOR) > 2) {
+			err = qcom_ice_restore_key_config(ice_dev);
+			if (err)
+				goto out;
+		}
+	}
+
+	ice_dev->ice_reset_complete_time = ktime_get();
+out:
+	return err;
+}
+
+static void qcom_ice_dump_test_bus(struct ice_device *ice_dev)
+{
+	u8 stream_selector;
+	u8 bus_selector;
+	u32 reg = 0x1;
+	u32 val;
+
+	dev_err(ice_dev->pdev, "ICE TEST BUS DUMP:\n");
+
+	for (bus_selector = 0; bus_selector <= 0xF;  bus_selector++) {
+		reg = 0x1;	/* enable test bus */
+		reg |= bus_selector << 28;
+		if (bus_selector == 0xD)
+			continue;
+		qcom_ice_writel(ice_dev, reg, QTI_ICE_REGS_TEST_BUS_CONTROL);
+		/*
+		 * make sure test bus selector is written before reading
+		 * the test bus register
+		 */
+		mb();
+		val = qcom_ice_readl(ice_dev, QTI_ICE_REGS_TEST_BUS_REG);
+		dev_err(ice_dev->pdev,
+			"ICE_TEST_BUS_CONTROL: 0x%08x | ICE_TEST_BUS_REG: 0x%08x\n",
+			reg, val);
+	}
+
+	pr_err("ICE TEST BUS DUMP (ICE_STREAM1_DATAPATH_TEST_BUS):\n");
+	for (stream_selector = 0; stream_selector <= 0xF; stream_selector++) {
+		reg = 0xD0000001;	/* enable stream test bus */
+		reg |= stream_selector << 16;
+		qcom_ice_writel(ice_dev, reg, QTI_ICE_REGS_TEST_BUS_CONTROL);
+		/*
+		 * make sure test bus selector is written before reading
+		 * the test bus register
+		 */
+		mb();
+		val = qcom_ice_readl(ice_dev, QTI_ICE_REGS_TEST_BUS_REG);
+		dev_err(ice_dev->pdev,
+			"ICE_TEST_BUS_CONTROL: 0x%08x | ICE_TEST_BUS_REG: 0x%08x\n",
+			reg, val);
+	}
+}
+
+static void qcom_ice_debug(struct platform_device *pdev)
+{
+	struct ice_device *ice_dev;
+
+	if (!pdev) {
+		pr_err("%s(): Invalid params passed\n", __func__);
+		goto out;
+	}
+
+	ice_dev = platform_get_drvdata(pdev);
+	if (!ice_dev) {
+		pr_err("%s(): No ICE device available\n", __func__);
+		goto out;
+	}
+
+	if (!ice_dev->is_ice_enabled) {
+		pr_err("%s(): ICE device is not enabled\n", __func__);
+		goto out;
+	}
+
+	dev_err(ice_dev->pdev,
+		"%s: =========== REGISTER DUMP (%pK)===========\n",
+		ice_dev->ice_instance_type, ice_dev);
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE Control: 0x%08x | ICE Reset: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_CONTROL),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_RESET));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE Version: 0x%08x | ICE FUSE:  0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_VERSION),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_FUSE_SETTING));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE Param1: 0x%08x | ICE Param2:  0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_PARAMETERS_1),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_PARAMETERS_2));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE Param3: 0x%08x | ICE Param4:  0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_PARAMETERS_3),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_PARAMETERS_4));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE Param5: 0x%08x | ICE IRQ STTS:  0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_PARAMETERS_5),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_NON_SEC_IRQ_STTS));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE IRQ MASK: 0x%08x | ICE IRQ CLR:  0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_NON_SEC_IRQ_MASK),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_NON_SEC_IRQ_CLR));
+
+	if (ICE_REV(ice_dev->ice_hw_version, MAJOR) > 2) {
+		dev_err(ice_dev->pdev,
+			"%s: ICE INVALID CCFG ERR STTS: 0x%08x\n",
+			ice_dev->ice_instance_type,
+			qcom_ice_readl(ice_dev,
+				QTI_ICE_INVALID_CCFG_ERR_STTS));
+	}
+
+	if ((ICE_REV(ice_dev->ice_hw_version, MAJOR) > 2) ||
+		((ICE_REV(ice_dev->ice_hw_version, MAJOR) == 2) &&
+		 (ICE_REV(ice_dev->ice_hw_version, MINOR) >= 1))) {
+		dev_err(ice_dev->pdev,
+			"%s: ICE BIST Sts: 0x%08x | ICE Bypass Sts:  0x%08x\n",
+			ice_dev->ice_instance_type,
+			qcom_ice_readl(ice_dev, QTI_ICE_REGS_BIST_STATUS),
+			qcom_ice_readl(ice_dev, QTI_ICE_REGS_BYPASS_STATUS));
+	}
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE ADV CTRL: 0x%08x | ICE ENDIAN SWAP:  0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_ADVANCED_CONTROL),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_ENDIAN_SWAP));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM1_ERR_SYND1: 0x%08x | ICE_STM1_ERR_SYND2: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_ERROR_SYNDROME1),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_ERROR_SYNDROME2));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM2_ERR_SYND1: 0x%08x | ICE_STM2_ERR_SYND2: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_ERROR_SYNDROME1),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_ERROR_SYNDROME2));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM1_COUNTER1: 0x%08x | ICE_STM1_COUNTER2: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS1),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS2));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM1_COUNTER3: 0x%08x | ICE_STM1_COUNTER4: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS3),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS4));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM2_COUNTER1: 0x%08x | ICE_STM2_COUNTER2: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS1),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS2));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM2_COUNTER3: 0x%08x | ICE_STM2_COUNTER4: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS3),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS4));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM1_CTR5_MSB: 0x%08x | ICE_STM1_CTR5_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS5_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS5_LSB));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM1_CTR6_MSB: 0x%08x | ICE_STM1_CTR6_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS6_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS6_LSB));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM1_CTR7_MSB: 0x%08x | ICE_STM1_CTR7_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS7_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS7_LSB));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM1_CTR8_MSB: 0x%08x | ICE_STM1_CTR8_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS8_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS8_LSB));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM1_CTR9_MSB: 0x%08x | ICE_STM1_CTR9_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS9_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM1_COUNTERS9_LSB));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM2_CTR5_MSB: 0x%08x | ICE_STM2_CTR5_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS5_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS5_LSB));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM2_CTR6_MSB: 0x%08x | ICE_STM2_CTR6_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS6_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS6_LSB));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM2_CTR7_MSB: 0x%08x | ICE_STM2_CTR7_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS7_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS7_LSB));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM2_CTR8_MSB: 0x%08x | ICE_STM2_CTR8_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS8_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS8_LSB));
+
+	dev_err(ice_dev->pdev,
+		"%s: ICE_STM2_CTR9_MSB: 0x%08x | ICE_STM2_CTR9_LSB: 0x%08x\n",
+		ice_dev->ice_instance_type,
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS9_MSB),
+		qcom_ice_readl(ice_dev, QTI_ICE_REGS_STREAM2_COUNTERS9_LSB));
+
+	qcom_ice_dump_test_bus(ice_dev);
+	dev_err(ice_dev->pdev,
+		"%s: ICE reset start time: %llu ICE reset done time: %llu\n",
+		ice_dev->ice_instance_type,
+		(unsigned long long)ice_dev->ice_reset_start_time,
+		(unsigned long long)ice_dev->ice_reset_complete_time);
+
+	if (ktime_to_us(ktime_sub(ice_dev->ice_reset_complete_time,
+				  ice_dev->ice_reset_start_time)) > 0)
+		dev_err(ice_dev->pdev, "%s: Time taken for reset: %lu\n",
+			ice_dev->ice_instance_type,
+			(unsigned long)ktime_to_us(ktime_sub(
+					ice_dev->ice_reset_complete_time,
+					ice_dev->ice_reset_start_time)));
+out:
+	return;
+}
+
+static int qcom_ice_reset(struct  platform_device *pdev)
+{
+	struct ice_device *ice_dev;
+
+	ice_dev = platform_get_drvdata(pdev);
+	if (!ice_dev) {
+		pr_err("%s(): INVALID ice_dev\n", __func__);
+		return -EINVAL;
+	}
+
+	ice_dev->ice_reset_start_time = ktime_get();
+
+	return qcom_ice_finish_power_collapse(ice_dev);
+}
+
+static int qcom_ice_config_start(struct platform_device *pdev,
+		struct request *req, struct ice_data_setting *setting)
+{
+	struct ice_crypto_setting ice_data;
+	unsigned long sec_end = 0;
+	sector_t data_size;
+
+	if (!pdev || !req) {
+		pr_err("%s(): Invalid params passed\n", __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * It is not an error to have a request with no bio
+	 * Such requests must bypass ICE. So first set bypass and then
+	 * return if bio is not available in request
+	 */
+	if (setting) {
+		setting->encr_bypass = true;
+		setting->decr_bypass = true;
+	}
+
+	if (!req->bio) {
+		/* It is not an error to have a request with no  bio */
+		return 0;
+	}
+
+	/* bypass ICE if ice_fde_flag is not set */
+	if (!ice_fde_flag)
+		return 0;
+
+	if (req->part && req->part->info && req->part->info->volname[0]) {
+		if (!strcmp(req->part->info->volname, ENCRYPT_PARTITION)) {
+			sec_end = req->part->start_sect +
+				req->part->nr_sects - QTI_UD_FOOTER_SECS;
+			if ((req->__sector >= req->part->start_sect) &&
+				(req->__sector < sec_end)) {
+				data_size = req->__data_len /
+						QTI_SECT_LEN_IN_BYTE;
+
+				if ((req->__sector + data_size) > sec_end)
+					return 0;
+
+				return qti_ice_setting_config(req, pdev,
+						&ice_data, setting);
+			}
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(qcom_ice_config_start);
+
+static int qcom_ice_status(struct platform_device *pdev)
+{
+	unsigned int test_bus_reg_status;
+	struct ice_device *ice_dev;
+
+	if (!pdev) {
+		pr_err("%s(): Invalid params passed\n", __func__);
+		return -EINVAL;
+	}
+
+	ice_dev = platform_get_drvdata(pdev);
+	if (!ice_dev)
+		return -ENODEV;
+
+	if (!ice_dev->is_ice_enabled)
+		return -ENODEV;
+
+	test_bus_reg_status = qcom_ice_readl(ice_dev,
+					QTI_ICE_REGS_TEST_BUS_REG);
+
+	return !!(test_bus_reg_status & QTI_ICE_TEST_BUS_REG_NON_SECURE_INTR);
+
+}
+
+struct platform_device *qcom_ice_get_pdevice(struct device_node *node)
+{
+	struct platform_device *ice_pdev = NULL;
+	struct ice_device *ice_dev = NULL;
+
+	if (!node) {
+		pr_err("%s(): invalid node %pK", __func__, node);
+		goto out;
+	}
+
+	if (!of_device_is_available(node)) {
+		pr_err("%s(): device unavailable\n", __func__);
+		goto out;
+	}
+
+	if (list_empty(&ice_devices)) {
+		pr_err("%s(): invalid device list\n", __func__);
+		ice_pdev = ERR_PTR(-EPROBE_DEFER);
+		goto out;
+	}
+
+	list_for_each_entry(ice_dev, &ice_devices, list) {
+		if (ice_dev->pdev->of_node == node) {
+			pr_info("%s(): found ice device %pK\n", __func__,
+				ice_pdev);
+			ice_pdev = to_platform_device(ice_dev->pdev);
+			break;
+		}
+	}
+
+	if (ice_pdev)
+		pr_info("%s(): matching platform device %pK\n", __func__,
+			ice_pdev);
+out:
+	return ice_pdev;
+}
+
+static struct ice_device *get_ice_device_from_storage_type
+					(const char *storage_type)
+{
+	struct ice_device *ice_dev = NULL;
+
+	if (list_empty(&ice_devices)) {
+		pr_err("%s(): invalid device list\n", __func__);
+		ice_dev = ERR_PTR(-EPROBE_DEFER);
+		goto out;
+	}
+
+	list_for_each_entry(ice_dev, &ice_devices, list) {
+		if (!strcmp(ice_dev->ice_instance_type, storage_type)) {
+			pr_debug("%s(): ice device %pK\n", __func__, ice_dev);
+			return ice_dev;
+		}
+	}
+out:
+	return NULL;
+}
+
+static int enable_ice_setup(struct ice_device *ice_dev)
+{
+	int ret = -1;
+
+	/* Setup Regulator */
+	if (ice_dev->is_regulator_available) {
+		if (qcom_ice_get_vreg(ice_dev)) {
+			dev_err(ice_dev->pdev,
+				"%s(): Could not get regulator\n", __func__);
+			goto out;
+		}
+		ret = regulator_enable(ice_dev->reg);
+		if (ret) {
+			dev_err(ice_dev->pdev,
+				"%s():%pK: Could not enable regulator\n",
+				__func__, ice_dev);
+			goto out;
+		}
+	}
+
+	if (qcom_ice_enable_clocks(ice_dev, true)) {
+		dev_err(ice_dev->pdev,
+			"%s():%pK:%s Could not enable clocks\n", __func__,
+			ice_dev, ice_dev->ice_instance_type);
+		goto out_reg;
+	}
+
+	return ret;
+
+out_reg:
+	if (ice_dev->is_regulator_available) {
+		if (qcom_ice_get_vreg(ice_dev)) {
+			dev_err(ice_dev->pdev,
+				"%s(): Could not get regulator\n", __func__);
+			goto out;
+		}
+		ret = regulator_disable(ice_dev->reg);
+		if (ret) {
+			dev_err(ice_dev->pdev,
+				"%s():%pK: Could not disable regulator\n",
+				__func__, ice_dev);
+			goto out;
+		}
+	}
+out:
+	return ret;
+}
+
+static int disable_ice_setup(struct ice_device *ice_dev)
+{
+	int ret = -1;
+
+	if (qcom_ice_enable_clocks(ice_dev, false))
+		dev_err(ice_dev->pdev,
+			"%s(): %pK: %s Could not disable clocks\n", __func__,
+			ice_dev, ice_dev->ice_instance_type);
+
+	if (ice_dev->is_regulator_available) {
+		if (qcom_ice_get_vreg(ice_dev)) {
+			dev_err(ice_dev->pdev,
+				"%s(): Could not get regulator\n", __func__);
+			goto out;
+		}
+		ret = regulator_disable(ice_dev->reg);
+		if (ret) {
+			dev_err(ice_dev->pdev,
+				"%s():%pK: Could not disable regulator\n",
+				__func__, ice_dev);
+			goto out;
+		}
+	}
+out:
+	return ret;
+}
+
+int qcom_ice_setup_ice_hw(const char *storage_type, int enable)
+{
+	struct ice_device *ice_dev = NULL;
+	int ret = -1;
+
+	ice_dev = get_ice_device_from_storage_type(storage_type);
+	if (ice_dev == ERR_PTR(-EPROBE_DEFER))
+		return -EPROBE_DEFER;
+
+	if (!ice_dev)
+		return ret;
+
+	if (enable)
+		return enable_ice_setup(ice_dev);
+
+	return disable_ice_setup(ice_dev);
+}
+
+/*
+ * ICE HW instance can exist in UFS or eMMC based storage HW
+ * Userspace does not know what kind of ICE it is dealing with.
+ * Though userspace can find which storage device it is booting
+ * from but all kind of storage types dont support ICE from
+ * beginning. So ICE device is created for user space to ping
+ * if ICE exist for that kind of storage
+ */
+static const struct file_operations qcom_ice_fops = {
+	.owner = THIS_MODULE,
+};
+
+static int register_ice_device(struct ice_device *ice_dev)
+{
+	unsigned int baseminor = 0;
+	struct device *class_dev;
+	unsigned int count = 1;
+	int is_sdcc_ice;
+	int rc = 0;
+
+	is_sdcc_ice = !strcmp(ice_dev->ice_instance_type,
+				QTI_SDCC_STORAGE_TYPE);
+
+	rc = alloc_chrdev_region(&ice_dev->device_no, baseminor, count,
+			is_sdcc_ice ? QTI_SDCC_ICE_DEV : QTI_UFS_ICE_DEV);
+	if (rc < 0) {
+		dev_err(ice_dev->pdev,
+			"alloc_chrdev_region failed %d for %s\n", rc,
+			is_sdcc_ice ? QTI_SDCC_ICE_DEV : QTI_UFS_ICE_DEV);
+		return rc;
+	}
+	ice_dev->driver_class = class_create(THIS_MODULE,
+			is_sdcc_ice ? QTI_SDCC_ICE_DEV : QTI_UFS_ICE_DEV);
+	if (IS_ERR(ice_dev->driver_class)) {
+		rc = -ENOMEM;
+		dev_err(ice_dev->pdev, "class_create failed %d for %s\n", rc,
+			is_sdcc_ice ? QTI_SDCC_ICE_DEV : QTI_UFS_ICE_DEV);
+		goto exit_unreg_chrdev_region;
+	}
+	class_dev = device_create(ice_dev->driver_class, NULL,
+					ice_dev->device_no, NULL,
+			is_sdcc_ice ? QTI_SDCC_ICE_DEV : QTI_UFS_ICE_DEV);
+
+	if (!class_dev) {
+		dev_err(ice_dev->pdev, "class_device_create failed %d for %s\n",
+			rc, is_sdcc_ice ? QTI_SDCC_ICE_DEV : QTI_UFS_ICE_DEV);
+		rc = -ENOMEM;
+		goto exit_destroy_class;
+	}
+
+	cdev_init(&ice_dev->cdev, &qcom_ice_fops);
+	ice_dev->cdev.owner = THIS_MODULE;
+
+	rc = cdev_add(&ice_dev->cdev, MKDEV(MAJOR(ice_dev->device_no), 0), 1);
+	if (rc < 0) {
+		dev_err(ice_dev->pdev, "cdev_add failed %d for %s\n", rc,
+			is_sdcc_ice ? QTI_SDCC_ICE_DEV : QTI_UFS_ICE_DEV);
+		goto exit_destroy_device;
+	}
+	return  0;
+
+exit_destroy_device:
+	device_destroy(ice_dev->driver_class, ice_dev->device_no);
+
+exit_destroy_class:
+	class_destroy(ice_dev->driver_class);
+
+exit_unreg_chrdev_region:
+	unregister_chrdev_region(ice_dev->device_no, 1);
+	return rc;
+}
+
+static int qcom_ice_probe(struct platform_device *pdev)
+{
+	struct ice_device *ice_dev;
+	int rc = 0;
+
+	if (!pdev) {
+		pr_err("%s(): Invalid platform_device passed\n", __func__);
+		return -EINVAL;
+	}
+
+	ice_dev = kzalloc(sizeof(struct ice_device), GFP_KERNEL);
+	if (!ice_dev) {
+		rc = -ENOMEM;
+		pr_err("%s(): Error %d allocating memory for ICE device:\n",
+			__func__, rc);
+		goto out;
+	}
+
+	ice_dev->pdev = &pdev->dev;
+	if (!ice_dev->pdev) {
+		rc = -EINVAL;
+		pr_err("%s(): Invalid device passed in platform_device\n",
+			__func__);
+		goto err_ice_dev;
+	}
+
+	if (pdev->dev.of_node) {
+		rc = qcom_ice_get_device_tree_data(pdev, ice_dev);
+	} else {
+		rc = -EINVAL;
+		pr_err("%s(): ICE device node not found\n", __func__);
+	}
+
+	if (rc)
+		goto err_ice_dev;
+
+	pr_debug("%s(): Registering ICE device\n", __func__);
+	rc = register_ice_device(ice_dev);
+	if (rc) {
+		pr_err("create character device failed.\n");
+		goto err_ice_dev;
+	}
+
+	/*
+	 * If ICE is enabled here, it would be waste of power.
+	 * We would enable ICE when first request for crypto
+	 * operation arrives.
+	 */
+	ice_dev->is_ice_enabled = false;
+	platform_set_drvdata(pdev, ice_dev);
+	list_add_tail(&ice_dev->list, &ice_devices);
+
+	goto out;
+
+err_ice_dev:
+	kfree(ice_dev);
+out:
+	return rc;
+}
+
+static int qcom_ice_remove(struct platform_device *pdev)
+{
+	struct ice_device *ice_dev;
+
+	ice_dev = (struct ice_device *)platform_get_drvdata(pdev);
+
+	if (!ice_dev)
+		return 0;
+
+	qcom_ice_disable_intr(ice_dev);
+
+	device_init_wakeup(&pdev->dev, false);
+	if (ice_dev->mmio)
+		iounmap(ice_dev->mmio);
+
+	list_del_init(&ice_dev->list);
+	kfree(ice_dev);
+
+	return 1;
+}
+
+static int qcom_ice_suspend(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int qcom_ice_resume(struct platform_device *pdev)
+{
+	/*
+	 * ICE is power collapsed when storage controller is power collapsed
+	 * ICE resume function is responsible for:
+	 * ICE HW enabling sequence
+	 * Key restoration
+	 * A completion event should be triggered
+	 * upon resume completion
+	 * Storage driver will be fully operational only
+	 * after receiving this event
+	 */
+	struct ice_device *ice_dev;
+
+	ice_dev = platform_get_drvdata(pdev);
+	if (!ice_dev)
+		return -EINVAL;
+
+	if (ice_dev->is_ice_clk_available) {
+		/*
+		 * Storage is calling this function after power collapse which
+		 * would put ICE into GLOBAL_BYPASS mode. Make sure to enable
+		 * ICE
+		 */
+		qcom_ice_enable(ice_dev);
+	}
+
+	return 0;
+}
+
+struct qcom_ice_variant_ops qcom_ice_ops = {
+	.name             = "qcom",
+	.init             = qcom_ice_init,
+	.reset            = qcom_ice_reset,
+	.resume           = qcom_ice_resume,
+	.suspend          = qcom_ice_suspend,
+	.config_start     = qcom_ice_config_start,
+	.status           = qcom_ice_status,
+	.debug            = qcom_ice_debug,
+};
+
+struct qcom_ice_variant_ops *qcom_ice_get_variant_ops(struct device_node *node)
+{
+	return &qcom_ice_ops;
+}
+EXPORT_SYMBOL(qcom_ice_get_variant_ops);
+
+/* Following struct is required to match device with driver from dts file */
+static const struct of_device_id qcom_ice_match[] = {
+	{ .compatible = "qcom,ice" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, qcom_ice_match);
+
+static struct platform_driver qcom_ice_driver = {
+	.probe          = qcom_ice_probe,
+	.remove         = qcom_ice_remove,
+	.driver         = {
+		.name = KBUILD_MODNAME,
+		.of_match_table = qcom_ice_match,
+	},
+};
+module_platform_driver(qcom_ice_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("QTI Inline Crypto Engine driver");
diff --git a/drivers/crypto/qce/iceregs.h b/drivers/crypto/qce/iceregs.h
new file mode 100644
index 0000000..409d0ba
--- /dev/null
+++ b/drivers/crypto/qce/iceregs.h
@@ -0,0 +1,159 @@
+/* Copyright (c) 2014-2018, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _QTI_INLINE_CRYPTO_ENGINE_REGS_H_
+#define _QTI_INLINE_CRYPTO_ENGINE_REGS_H_
+
+/* Register bits for ICE version */
+#define ICE_CORE_CURRENT_MAJOR_VERSION 0x03
+
+#define ICE_CORE_STEP_REV_MASK		0xFFFF
+#define ICE_CORE_STEP_REV		0 /* bit 15-0 */
+#define ICE_CORE_MAJOR_REV_MASK		0xFF000000
+#define ICE_CORE_MAJOR_REV		24 /* bit 31-24 */
+#define ICE_CORE_MINOR_REV_MASK		0xFF0000
+#define ICE_CORE_MINOR_REV		16 /* bit 23-16 */
+
+#define ICE_BIST_STATUS_MASK		(0xF0000000)	/* bits 28-31 */
+
+#define ICE_FUSE_SETTING_MASK			0x1
+#define ICE_FORCE_HW_KEY0_SETTING_MASK		0x2
+#define ICE_FORCE_HW_KEY1_SETTING_MASK		0x4
+
+/* QTI ICE Registers from SWI */
+#define QTI_ICE_REGS_CONTROL			0x0000
+#define QTI_ICE_REGS_RESET			0x0004
+#define QTI_ICE_REGS_VERSION			0x0008
+#define QTI_ICE_REGS_FUSE_SETTING		0x0010
+#define QTI_ICE_REGS_PARAMETERS_1		0x0014
+#define QTI_ICE_REGS_PARAMETERS_2		0x0018
+#define QTI_ICE_REGS_PARAMETERS_3		0x001C
+#define QTI_ICE_REGS_PARAMETERS_4		0x0020
+#define QTI_ICE_REGS_PARAMETERS_5		0x0024
+
+
+/* QTI ICE v3.X only */
+#define QTI_ICE_GENERAL_ERR_STTS		0x0040
+#define QTI_ICE_INVALID_CCFG_ERR_STTS		0x0030
+#define QTI_ICE_GENERAL_ERR_MASK		0x0044
+
+
+/* QTI ICE v2.X only */
+#define QTI_ICE_REGS_NON_SEC_IRQ_STTS		0x0040
+#define QTI_ICE_REGS_NON_SEC_IRQ_MASK		0x0044
+
+
+#define QTI_ICE_REGS_NON_SEC_IRQ_CLR		0x0048
+#define QTI_ICE_REGS_STREAM1_ERROR_SYNDROME1	0x0050
+#define QTI_ICE_REGS_STREAM1_ERROR_SYNDROME2	0x0054
+#define QTI_ICE_REGS_STREAM2_ERROR_SYNDROME1	0x0058
+#define QTI_ICE_REGS_STREAM2_ERROR_SYNDROME2	0x005C
+#define QTI_ICE_REGS_STREAM1_BIST_ERROR_VEC	0x0060
+#define QTI_ICE_REGS_STREAM2_BIST_ERROR_VEC	0x0064
+#define QTI_ICE_REGS_STREAM1_BIST_FINISH_VEC	0x0068
+#define QTI_ICE_REGS_STREAM2_BIST_FINISH_VEC	0x006C
+#define QTI_ICE_REGS_BIST_STATUS		0x0070
+#define QTI_ICE_REGS_BYPASS_STATUS		0x0074
+#define QTI_ICE_REGS_ADVANCED_CONTROL		0x1000
+#define QTI_ICE_REGS_ENDIAN_SWAP		0x1004
+#define QTI_ICE_REGS_TEST_BUS_CONTROL		0x1010
+#define QTI_ICE_REGS_TEST_BUS_REG		0x1014
+#define QTI_ICE_REGS_STREAM1_COUNTERS1		0x1100
+#define QTI_ICE_REGS_STREAM1_COUNTERS2		0x1104
+#define QTI_ICE_REGS_STREAM1_COUNTERS3		0x1108
+#define QTI_ICE_REGS_STREAM1_COUNTERS4		0x110C
+#define QTI_ICE_REGS_STREAM1_COUNTERS5_MSB	0x1110
+#define QTI_ICE_REGS_STREAM1_COUNTERS5_LSB	0x1114
+#define QTI_ICE_REGS_STREAM1_COUNTERS6_MSB	0x1118
+#define QTI_ICE_REGS_STREAM1_COUNTERS6_LSB	0x111C
+#define QTI_ICE_REGS_STREAM1_COUNTERS7_MSB	0x1120
+#define QTI_ICE_REGS_STREAM1_COUNTERS7_LSB	0x1124
+#define QTI_ICE_REGS_STREAM1_COUNTERS8_MSB	0x1128
+#define QTI_ICE_REGS_STREAM1_COUNTERS8_LSB	0x112C
+#define QTI_ICE_REGS_STREAM1_COUNTERS9_MSB	0x1130
+#define QTI_ICE_REGS_STREAM1_COUNTERS9_LSB	0x1134
+#define QTI_ICE_REGS_STREAM2_COUNTERS1		0x1200
+#define QTI_ICE_REGS_STREAM2_COUNTERS2		0x1204
+#define QTI_ICE_REGS_STREAM2_COUNTERS3		0x1208
+#define QTI_ICE_REGS_STREAM2_COUNTERS4		0x120C
+#define QTI_ICE_REGS_STREAM2_COUNTERS5_MSB	0x1210
+#define QTI_ICE_REGS_STREAM2_COUNTERS5_LSB	0x1214
+#define QTI_ICE_REGS_STREAM2_COUNTERS6_MSB	0x1218
+#define QTI_ICE_REGS_STREAM2_COUNTERS6_LSB	0x121C
+#define QTI_ICE_REGS_STREAM2_COUNTERS7_MSB	0x1220
+#define QTI_ICE_REGS_STREAM2_COUNTERS7_LSB	0x1224
+#define QTI_ICE_REGS_STREAM2_COUNTERS8_MSB	0x1228
+#define QTI_ICE_REGS_STREAM2_COUNTERS8_LSB	0x122C
+#define QTI_ICE_REGS_STREAM2_COUNTERS9_MSB	0x1230
+#define QTI_ICE_REGS_STREAM2_COUNTERS9_LSB	0x1234
+
+#define QTI_ICE_STREAM1_PREMATURE_LBA_CHANGE		(1L << 0)
+#define QTI_ICE_STREAM2_PREMATURE_LBA_CHANGE		(1L << 1)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_LBO		(1L << 2)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_LBO		(1L << 3)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_DUN		(1L << 4)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_DUN		(1L << 5)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_DUS		(1L << 6)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_DUS		(1L << 7)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_DBO		(1L << 8)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_DBO		(1L << 9)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_ENC_SEL		(1L << 10)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_ENC_SEL		(1L << 11)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_CONF_IDX		(1L << 12)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_CONF_IDX		(1L << 13)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_NEW_TRNS		(1L << 14)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_NEW_TRNS		(1L << 15)
+
+#define QTI_ICE_NON_SEC_IRQ_MASK				\
+			(QTI_ICE_STREAM1_PREMATURE_LBA_CHANGE |\
+			 QTI_ICE_STREAM2_PREMATURE_LBA_CHANGE |\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_LBO |\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_LBO |\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_DUN |\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_DUN |\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_DUN |\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_DUS |\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_DBO |\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_DBO |\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_ENC_SEL |\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_ENC_SEL |\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_CONF_IDX |\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_NEW_TRNS |\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_NEW_TRNS)
+
+/* QTI ICE registers from secure side */
+#define QTI_ICE_TEST_BUS_REG_SECURE_INTR            (1L << 28)
+#define QTI_ICE_TEST_BUS_REG_NON_SECURE_INTR        (1L << 2)
+
+#define QTI_ICE_LUT_KEYS_ICE_SEC_IRQ_STTS	0x2050
+#define QTI_ICE_LUT_KEYS_ICE_SEC_IRQ_MASK	0x2054
+#define QTI_ICE_LUT_KEYS_ICE_SEC_IRQ_CLR	0x2058
+
+#define QTI_ICE_STREAM1_PARTIALLY_SET_KEY_USED		(1L << 0)
+#define QTI_ICE_STREAM2_PARTIALLY_SET_KEY_USED		(1L << 1)
+#define QTI_ICE_QTIC_DBG_OPEN_EVENT			(1L << 30)
+#define QTI_ICE_KEYS_RAM_RESET_COMPLETED		(1L << 31)
+
+#define QTI_ICE_SEC_IRQ_MASK					  \
+			(QTI_ICE_STREAM1_PARTIALLY_SET_KEY_USED |\
+			 QTI_ICE_STREAM2_PARTIALLY_SET_KEY_USED |\
+			 QTI_ICE_QTIC_DBG_OPEN_EVENT |	  \
+			 QTI_ICE_KEYS_RAM_RESET_COMPLETED)
+
+
+#define qcom_ice_writel(ice, val, reg)	\
+	writel_relaxed((val), (ice)->mmio + (reg))
+#define qcom_ice_readl(ice, reg)	\
+	readl_relaxed((ice)->mmio + (reg))
+
+
+#endif /* _QTI_INLINE_CRYPTO_ENGINE_REGS_H_ */
diff --git a/include/crypto/ice.h b/include/crypto/ice.h
new file mode 100644
index 0000000..105112a
--- /dev/null
+++ b/include/crypto/ice.h
@@ -0,0 +1,80 @@
+/* Copyright (c) 2014-2018, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _QTI_INLINE_CRYPTO_ENGINE_H_
+#define _QTI_INLINE_CRYPTO_ENGINE_H_
+
+#include <linux/platform_device.h>
+
+struct request;
+
+enum ice_cryto_algo_mode {
+	ICE_CRYPTO_ALGO_MODE_AES_ECB = 0x0,
+	ICE_CRYPTO_ALGO_MODE_AES_XTS = 0x3,
+};
+
+enum ice_crpto_key_size {
+	ICE_CRYPTO_KEY_SIZE_128 = 0x0,
+	ICE_CRYPTO_KEY_SIZE_256 = 0x2,
+};
+
+enum ice_crpto_key_mode {
+	ICE_CRYPTO_USE_KEY0_HW_KEY = 0x0,
+	ICE_CRYPTO_USE_KEY1_HW_KEY = 0x1,
+	ICE_CRYPTO_USE_LUT_SW_KEY0 = 0x2,
+	ICE_CRYPTO_USE_LUT_SW_KEY  = 0x3
+};
+
+struct ice_crypto_setting {
+	enum ice_crpto_key_size		key_size;
+	enum ice_cryto_algo_mode	algo_mode;
+	enum ice_crpto_key_mode		key_mode;
+	short				key_index;
+
+};
+
+struct ice_data_setting {
+	struct ice_crypto_setting	crypto_data;
+	bool				sw_forced_context_switch;
+	bool				decr_bypass;
+	bool				encr_bypass;
+};
+
+typedef void (*ice_error_cb)(void *, u32 error);
+
+struct qcom_ice_variant_ops *qcom_ice_get_variant_ops(struct device_node *node);
+struct platform_device *qcom_ice_get_pdevice(struct device_node *node);
+
+#ifdef CONFIG_CRYPTO_DEV_QTI_ICE
+int qcom_ice_setup_ice_hw(const char *storage_type, int enable);
+#else
+static inline int qcom_ice_setup_ice_hw(const char *storage_type, int enable)
+{
+	return 0;
+}
+#endif
+
+struct qcom_ice_variant_ops {
+	const char *name;
+	int	(*init)(struct platform_device *pdev, void *data,
+			ice_error_cb ecb);
+	int	(*reset)(struct platform_device *pdev);
+	int	(*resume)(struct platform_device *pdev);
+	int	(*suspend)(struct platform_device *pdev);
+	int	(*config_start)(struct platform_device *pdev,
+			struct request *req, struct ice_data_setting *ice_data);
+	int	(*config_end)(struct request *req);
+	int	(*status)(struct platform_device *pdev);
+	void	(*debug)(struct platform_device *pdev);
+};
+
+#endif /* _QTI_INLINE_CRYPTO_ENGINE_H_ */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
