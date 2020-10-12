Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9503C433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E9720FC3
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgJLUjJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:33900 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgJLUjI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:08 -0400
IronPort-SDR: oYSLH1HjWXuznVy1EFJPyCWr2MyKFWuOcCewaKebTBrNgr/bZWNQy0Ru1AVp4ITNNjnQDy3yiT
 iSKL73QoKQsw==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913062"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913062"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:08 -0700
IronPort-SDR: odCxxjqI4kdPjNB1kZtU6dBdivOwgy1b9yB622APTxLJ0ev7dl4ovu0zz0s7LbcP+wPhcZvo8+
 KIMcbUkQ9yxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328128"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:06 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Ahsan Atta <ahsan.atta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 03/31] crypto: qat - num_rings_per_bank is device dependent
Date:   Mon, 12 Oct 2020 21:38:19 +0100
Message-Id: <20201012203847.340030-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ahsan Atta <ahsan.atta@intel.com>

This change is to allow support for QAT devices that may not have 16
rings per bank.
The rings structure in bank is allocated dynamically based on the number
of banks supported by a device.

Note that in the error path in adf_init_bank(), ring->inflights is set
to NULL after the free to silence a false positive double free reported
by clang scan-build.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  1 +
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |  1 +
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  1 +
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |  1 +
 .../crypto/qat/qat_common/adf_accel_devices.h |  3 ++
 drivers/crypto/qat/qat_common/adf_transport.c | 42 +++++++++++++------
 .../qat/qat_common/adf_transport_debug.c      | 10 ++++-
 .../qat/qat_common/adf_transport_internal.h   |  2 +-
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  1 +
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |  1 +
 10 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 4b2f5aa83391..62b0b290ff85 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -176,6 +176,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->dev_class = &c3xxx_class;
 	hw_data->instance_id = c3xxx_class.instances++;
 	hw_data->num_banks = ADF_C3XXX_ETR_MAX_BANKS;
+	hw_data->num_rings_per_bank = ADF_ETR_MAX_RINGS_PER_BANK;
 	hw_data->num_accel = ADF_C3XXX_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_C3XXX_MAX_ACCELENGINES;
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index cdf8c500ef2a..80a355e85a72 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -69,6 +69,7 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &c3xxxiov_class;
 	hw_data->num_banks = ADF_C3XXXIOV_ETR_MAX_BANKS;
+	hw_data->num_rings_per_bank = ADF_ETR_MAX_RINGS_PER_BANK;
 	hw_data->num_accel = ADF_C3XXXIOV_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_C3XXXIOV_MAX_ACCELENGINES;
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index c0b5751e9682..1334b43e46e4 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -186,6 +186,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->dev_class = &c62x_class;
 	hw_data->instance_id = c62x_class.instances++;
 	hw_data->num_banks = ADF_C62X_ETR_MAX_BANKS;
+	hw_data->num_rings_per_bank = ADF_ETR_MAX_RINGS_PER_BANK;
 	hw_data->num_accel = ADF_C62X_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_C62X_MAX_ACCELENGINES;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index a2543f75e81f..7725387e58f8 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -69,6 +69,7 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &c62xiov_class;
 	hw_data->num_banks = ADF_C62XIOV_ETR_MAX_BANKS;
+	hw_data->num_rings_per_bank = ADF_ETR_MAX_RINGS_PER_BANK;
 	hw_data->num_accel = ADF_C62XIOV_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_C62XIOV_MAX_ACCELENGINES;
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 411a505e1f59..85b423d28f77 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -139,6 +139,7 @@ struct adf_hw_device_data {
 	u16 tx_rings_mask;
 	u8 tx_rx_gap;
 	u8 num_banks;
+	u8 num_rings_per_bank;
 	u8 num_accel;
 	u8 num_logical_accel;
 	u8 num_engines;
@@ -156,6 +157,8 @@ struct adf_hw_device_data {
 #define GET_BARS(accel_dev) ((accel_dev)->accel_pci_dev.pci_bars)
 #define GET_HW_DATA(accel_dev) (accel_dev->hw_device)
 #define GET_MAX_BANKS(accel_dev) (GET_HW_DATA(accel_dev)->num_banks)
+#define GET_NUM_RINGS_PER_BANK(accel_dev) \
+	GET_HW_DATA(accel_dev)->num_rings_per_bank
 #define GET_MAX_ACCELENGINES(accel_dev) (GET_HW_DATA(accel_dev)->num_engines)
 #define accel_to_pci_dev(accel_ptr) accel_ptr->accel_pci_dev.pci_dev
 
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 2ad774017200..24ddaaaa55b1 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -190,6 +190,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 		    struct adf_etr_ring_data **ring_ptr)
 {
 	struct adf_etr_data *transport_data = accel_dev->transport;
+	u8 num_rings_per_bank = GET_NUM_RINGS_PER_BANK(accel_dev);
 	struct adf_etr_bank_data *bank;
 	struct adf_etr_ring_data *ring;
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
@@ -219,7 +220,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 		dev_err(&GET_DEV(accel_dev), "Can't get ring number\n");
 		return -EFAULT;
 	}
-	if (ring_num >= ADF_ETR_MAX_RINGS_PER_BANK) {
+	if (ring_num >= num_rings_per_bank) {
 		dev_err(&GET_DEV(accel_dev), "Invalid ring number\n");
 		return -EFAULT;
 	}
@@ -286,15 +287,15 @@ void adf_remove_ring(struct adf_etr_ring_data *ring)
 
 static void adf_ring_response_handler(struct adf_etr_bank_data *bank)
 {
-	u32 empty_rings, i;
+	u8 num_rings_per_bank = GET_NUM_RINGS_PER_BANK(bank->accel_dev);
+	unsigned long empty_rings;
+	int i;
 
 	empty_rings = READ_CSR_E_STAT(bank->csr_addr, bank->bank_number);
 	empty_rings = ~empty_rings & bank->irq_mask;
 
-	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; ++i) {
-		if (empty_rings & (1 << i))
-			adf_handle_response(&bank->rings[i]);
-	}
+	for_each_set_bit(i, &empty_rings, num_rings_per_bank)
+		adf_handle_response(&bank->rings[i]);
 }
 
 void adf_response_handler(uintptr_t bank_addr)
@@ -343,9 +344,12 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 			 u32 bank_num, void __iomem *csr_addr)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u8 num_rings_per_bank = hw_data->num_rings_per_bank;
 	struct adf_etr_ring_data *ring;
 	struct adf_etr_ring_data *tx_ring;
 	u32 i, coalesc_enabled = 0;
+	unsigned long ring_mask;
+	int size;
 
 	memset(bank, 0, sizeof(*bank));
 	bank->bank_number = bank_num;
@@ -353,6 +357,13 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 	bank->accel_dev = accel_dev;
 	spin_lock_init(&bank->lock);
 
+	/* Allocate the rings in the bank */
+	size = num_rings_per_bank * sizeof(struct adf_etr_ring_data);
+	bank->rings = kzalloc_node(size, GFP_KERNEL,
+				   dev_to_node(&GET_DEV(accel_dev)));
+	if (!bank->rings)
+		return -ENOMEM;
+
 	/* Enable IRQ coalescing always. This will allow to use
 	 * the optimised flag and coalesc register.
 	 * If it is disabled in the config file just use min time value */
@@ -363,7 +374,7 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 	else
 		bank->irq_coalesc_timer = ADF_COALESCING_MIN_TIME;
 
-	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; i++) {
+	for (i = 0; i < num_rings_per_bank; i++) {
 		WRITE_CSR_RING_CONFIG(csr_addr, bank_num, i, 0);
 		WRITE_CSR_RING_BASE(csr_addr, bank_num, i, 0);
 		ring = &bank->rings[i];
@@ -394,11 +405,13 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 	WRITE_CSR_INT_SRCSEL(csr_addr, bank_num);
 	return 0;
 err:
-	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; i++) {
+	ring_mask = hw_data->tx_rings_mask;
+	for_each_set_bit(i, &ring_mask, num_rings_per_bank) {
 		ring = &bank->rings[i];
-		if (hw_data->tx_rings_mask & (1 << i))
-			kfree(ring->inflights);
+		kfree(ring->inflights);
+		ring->inflights = NULL;
 	}
+	kfree(bank->rings);
 	return -ENOMEM;
 }
 
@@ -464,11 +477,12 @@ EXPORT_SYMBOL_GPL(adf_init_etr_data);
 
 static void cleanup_bank(struct adf_etr_bank_data *bank)
 {
+	struct adf_accel_dev *accel_dev = bank->accel_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u8 num_rings_per_bank = hw_data->num_rings_per_bank;
 	u32 i;
 
-	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; i++) {
-		struct adf_accel_dev *accel_dev = bank->accel_dev;
-		struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	for (i = 0; i < num_rings_per_bank; i++) {
 		struct adf_etr_ring_data *ring = &bank->rings[i];
 
 		if (bank->ring_mask & (1 << i))
@@ -477,6 +491,7 @@ static void cleanup_bank(struct adf_etr_bank_data *bank)
 		if (hw_data->tx_rings_mask & (1 << i))
 			kfree(ring->inflights);
 	}
+	kfree(bank->rings);
 	adf_bank_debugfs_rm(bank);
 	memset(bank, 0, sizeof(*bank));
 }
@@ -507,6 +522,7 @@ void adf_cleanup_etr_data(struct adf_accel_dev *accel_dev)
 	if (etr_data) {
 		adf_cleanup_etr_handles(accel_dev);
 		debugfs_remove(etr_data->debug);
+		kfree(etr_data->banks->rings);
 		kfree(etr_data->banks);
 		kfree(etr_data);
 		accel_dev->transport = NULL;
diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
index dac25ba47260..da79d734c035 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -117,11 +117,14 @@ void adf_ring_debugfs_rm(struct adf_etr_ring_data *ring)
 
 static void *adf_bank_start(struct seq_file *sfile, loff_t *pos)
 {
+	struct adf_etr_bank_data *bank = sfile->private;
+	u8 num_rings_per_bank = GET_NUM_RINGS_PER_BANK(bank->accel_dev);
+
 	mutex_lock(&bank_read_lock);
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	if (*pos >= ADF_ETR_MAX_RINGS_PER_BANK)
+	if (*pos >= num_rings_per_bank)
 		return NULL;
 
 	return pos;
@@ -129,7 +132,10 @@ static void *adf_bank_start(struct seq_file *sfile, loff_t *pos)
 
 static void *adf_bank_next(struct seq_file *sfile, void *v, loff_t *pos)
 {
-	if (++(*pos) >= ADF_ETR_MAX_RINGS_PER_BANK)
+	struct adf_etr_bank_data *bank = sfile->private;
+	u8 num_rings_per_bank = GET_NUM_RINGS_PER_BANK(bank->accel_dev);
+
+	if (++(*pos) >= num_rings_per_bank)
 		return NULL;
 
 	return pos;
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index c7faf4e2d302..501bcf0f1809 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -28,7 +28,7 @@ struct adf_etr_ring_data {
 };
 
 struct adf_etr_bank_data {
-	struct adf_etr_ring_data rings[ADF_ETR_MAX_RINGS_PER_BANK];
+	struct adf_etr_ring_data *rings;
 	struct tasklet_struct resp_handler;
 	void __iomem *csr_addr;
 	u32 irq_coalesc_timer;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 6a0d01103136..1f3ea3ba1cee 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -185,6 +185,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->dev_class = &dh895xcc_class;
 	hw_data->instance_id = dh895xcc_class.instances++;
 	hw_data->num_banks = ADF_DH895XCC_ETR_MAX_BANKS;
+	hw_data->num_rings_per_bank = ADF_ETR_MAX_RINGS_PER_BANK;
 	hw_data->num_accel = ADF_DH895XCC_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_DH895XCC_MAX_ACCELENGINES;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 737f9132f71a..eca144bc1d67 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -69,6 +69,7 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &dh895xcciov_class;
 	hw_data->num_banks = ADF_DH895XCCIOV_ETR_MAX_BANKS;
+	hw_data->num_rings_per_bank = ADF_ETR_MAX_RINGS_PER_BANK;
 	hw_data->num_accel = ADF_DH895XCCIOV_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_DH895XCCIOV_MAX_ACCELENGINES;
-- 
2.26.2

