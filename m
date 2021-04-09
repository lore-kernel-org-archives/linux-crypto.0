Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF9DC433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 13:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6714610A8
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 13:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhDIN4p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 09:56:45 -0400
Received: from mga12.intel.com ([192.55.52.136]:7852 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232615AbhDIN4n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 09:56:43 -0400
IronPort-SDR: Wal/s9kU+ueZk+xhP3VBefOVnxXQvfz9R6POJFaEcYT7eEav97mvi6sLbNWgVjq1lWIrhO3r4O
 QFUk/1//xxaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="173244635"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="173244635"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 06:56:28 -0700
IronPort-SDR: UsdFo8lZha/0ML9RlH/TEx+geal8Wi1lhR3bUuWDKrezcnxInxUTd1JE/y4QxPN9y6ZczX44no
 CKOWNS7aEVaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="397486418"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 09 Apr 2021 06:56:26 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - enable detection of accelerators hang
Date:   Fri,  9 Apr 2021 14:56:19 +0100
Message-Id: <20210409135619.3879-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wojciech Ziemba <wojciech.ziemba@intel.com>

Enable the detection of hangs by setting watchdog timers (WDTs) on
generations that supports that feature.

The default timeout value comes from HW specs. WTDs are reset each time
an accelerator wins arbitration and is able to send/read a command to/from
an accelerator.

The value has added significant margin to make sure there are no spurious
timeouts. The scope of watchdog is per QAT device.

If a timeout is detected, the firmware resets the accelerator and
returns a response descriptor with an appropriate error code.

Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  1 +
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  1 +
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  1 +
 .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  | 25 ++++++++++++
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  | 13 ++++++
 .../crypto/qat/qat_common/adf_gen4_hw_data.c  | 40 +++++++++++++++++++
 .../crypto/qat/qat_common/adf_gen4_hw_data.h  | 14 ++++++-
 drivers/crypto/qat/qat_common/adf_init.c      |  4 ++
 9 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 6a9be01fdf33..3524ddd48930 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -224,6 +224,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->uof_get_name = uof_get_name;
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
+	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
 
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
 }
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index f5990d042c9a..1dd64af22bea 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -212,6 +212,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
+	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index cadcf12884c8..30337390513c 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -214,6 +214,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
+	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 5527344546e5..ac435b44f1d2 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -173,6 +173,7 @@ struct adf_hw_device_data {
 	void (*configure_iov_threads)(struct adf_accel_dev *accel_dev,
 				      bool enable);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
+	void (*set_ssm_wdtimer)(struct adf_accel_dev *accel_dev);
 	int (*enable_vf2pf_comms)(struct adf_accel_dev *accel_dev);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 1aa17303838d..9e560c7d4163 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -179,3 +179,28 @@ u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
 	return capabilities;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_get_accel_cap);
+
+void adf_gen2_set_ssm_wdtimer(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 timer_val_pke = ADF_SSM_WDT_PKE_DEFAULT_VALUE;
+	u32 timer_val = ADF_SSM_WDT_DEFAULT_VALUE;
+	unsigned long accel_mask = hw_data->accel_mask;
+	void __iomem *pmisc_addr;
+	struct adf_bar *pmisc;
+	int pmisc_id;
+	u32 i = 0;
+
+	pmisc_id = hw_data->get_misc_bar_id(hw_data);
+	pmisc = &GET_BARS(accel_dev)[pmisc_id];
+	pmisc_addr = pmisc->virt_addr;
+
+	/* Configures WDT timers */
+	for_each_set_bit(i, &accel_mask, hw_data->num_accel) {
+		/* Enable WDT for sym and dc */
+		ADF_CSR_WR(pmisc_addr, ADF_SSMWDT(i), timer_val);
+		/* Enable WDT for pke */
+		ADF_CSR_WR(pmisc_addr, ADF_SSMWDTPKE(i), timer_val_pke);
+	}
+}
+EXPORT_SYMBOL_GPL(adf_gen2_set_ssm_wdtimer);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index 3816e6500352..756b0ddfac5e 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -113,11 +113,24 @@ do { \
 /* Power gating */
 #define ADF_POWERGATE_PKE		BIT(24)
 
+/* WDT timers
+ *
+ * Timeout is in cycles. Clock speed may vary across products but this
+ * value should be a few milli-seconds.
+ */
+#define ADF_SSM_WDT_DEFAULT_VALUE	0x200000
+#define ADF_SSM_WDT_PKE_DEFAULT_VALUE	0x2000000
+#define ADF_SSMWDT_OFFSET		0x54
+#define ADF_SSMWDTPKE_OFFSET		0x58
+#define ADF_SSMWDT(i)		(ADF_SSMWDT_OFFSET + ((i) * 0x4000))
+#define ADF_SSMWDTPKE(i)	(ADF_SSMWDTPKE_OFFSET + ((i) * 0x4000))
+
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs);
 void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
 void adf_gen2_get_admin_info(struct admin_info *admin_csrs_info);
 void adf_gen2_get_arb_info(struct arb_info *arb_info);
 u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev);
+void adf_gen2_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
 
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.c
index b72ff58e0bc7..000528327b29 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.c
@@ -99,3 +99,43 @@ void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 	csr_ops->write_csr_ring_srv_arb_en = write_csr_ring_srv_arb_en;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_init_hw_csr_ops);
+
+static inline void adf_gen4_unpack_ssm_wdtimer(u64 value, u32 *upper,
+					       u32 *lower)
+{
+	*lower = lower_32_bits(value);
+	*upper = upper_32_bits(value);
+}
+
+void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u64 timer_val_pke = ADF_SSM_WDT_PKE_DEFAULT_VALUE;
+	u64 timer_val = ADF_SSM_WDT_DEFAULT_VALUE;
+	u32 ssm_wdt_pke_high = 0;
+	u32 ssm_wdt_pke_low = 0;
+	u32 ssm_wdt_high = 0;
+	u32 ssm_wdt_low = 0;
+	void __iomem *pmisc_addr;
+	struct adf_bar *pmisc;
+	int pmisc_id;
+
+	pmisc_id = hw_data->get_misc_bar_id(hw_data);
+	pmisc = &GET_BARS(accel_dev)[pmisc_id];
+	pmisc_addr = pmisc->virt_addr;
+
+	/* Convert 64bit WDT timer value into 32bit values for
+	 * mmio write to 32bit CSRs.
+	 */
+	adf_gen4_unpack_ssm_wdtimer(timer_val, &ssm_wdt_high, &ssm_wdt_low);
+	adf_gen4_unpack_ssm_wdtimer(timer_val_pke, &ssm_wdt_pke_high,
+				    &ssm_wdt_pke_low);
+
+	/* Enable WDT for sym and dc */
+	ADF_CSR_WR(pmisc_addr, ADF_SSMWDTL_OFFSET, ssm_wdt_low);
+	ADF_CSR_WR(pmisc_addr, ADF_SSMWDTH_OFFSET, ssm_wdt_high);
+	/* Enable WDT for pke */
+	ADF_CSR_WR(pmisc_addr, ADF_SSMWDTPKEL_OFFSET, ssm_wdt_pke_low);
+	ADF_CSR_WR(pmisc_addr, ADF_SSMWDTPKEH_OFFSET, ssm_wdt_pke_high);
+}
+EXPORT_SYMBOL_GPL(adf_gen4_set_ssm_wdtimer);
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
index 8ab62b2ac311..b8fca1ff7aab 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
@@ -94,6 +94,18 @@ do { \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_RING_SRV_ARB_EN, (value))
 
-void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
+/* WDT timers
+ *
+ * Timeout is in cycles. Clock speed may vary across products but this
+ * value should be a few milli-seconds.
+ */
+#define ADF_SSM_WDT_DEFAULT_VALUE	0x200000
+#define ADF_SSM_WDT_PKE_DEFAULT_VALUE	0x8000000
+#define ADF_SSMWDTL_OFFSET		0x54
+#define ADF_SSMWDTH_OFFSET		0x5C
+#define ADF_SSMWDTPKEL_OFFSET		0x58
+#define ADF_SSMWDTPKEH_OFFSET		0x60
 
+void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
+void adf_gen4_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 42029153408e..744c40351428 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -162,6 +162,10 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	/* Set ssm watch dog timer */
+	if (hw_data->set_ssm_wdtimer)
+		hw_data->set_ssm_wdtimer(accel_dev);
+
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
-- 
2.30.2

