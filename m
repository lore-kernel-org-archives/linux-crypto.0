Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADFEC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhLPJMJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:12:09 -0500
Received: from mga12.intel.com ([192.55.52.136]:9719 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233030AbhLPJMF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:12:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645925; x=1671181925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FD6bqyN6serEZorcW21894NEtI/t3N7DtVoXMR74Nd8=;
  b=TWNNedKGmYmmtnfLtD7W7mP3BHdNllaCPI+dNffLiFHXrfe7hGWcfSrU
   5F1xVIw4er9z/B1yNjB4+KYwsg1SNv4w7XDEXegDufJC+gNjdPCUu55s4
   NJNFGMxVoipP59oIM2hRq3ncAz80QktBI7KV8NLnDaVuKRsYDxneiD/03
   3XCR91vewOWGOBws+kPDzjMZcggUfiVpJvhHr1iZn5TRgHb5O613ZzWDy
   mGdHwlIZ1OfrEfIp+47sWHUKwioCcYcvx1Wqmyk9lWpnyxpV0nlWEoC1J
   VJFRL6XpX4Ylss4vXF47Lxcv3JuutCbvJXzlfzy0D87HWdt+8N/aGs0KC
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458484"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458484"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968643"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:48 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 20/24] crypto: qat - config VFs based on ring-to-svc mapping
Date:   Thu, 16 Dec 2021 09:13:30 +0000
Message-Id: <20211216091334.402420-21-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change the configuration logic for the VF driver to leverage the
ring-to-service mappings now received via PFVF.

While the driver config logic is not yet capable of supporting
configurations other than the default mapping, make sure that both VF
and PF share the same default configuration in order to work properly.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |  4 ---
 drivers/crypto/qat/qat_c62xvf/adf_drv.c       |  4 ---
 .../crypto/qat/qat_common/adf_common_drv.h    |  1 +
 drivers/crypto/qat/qat_common/adf_init.c      |  9 ++++++-
 drivers/crypto/qat/qat_common/qat_crypto.c    | 25 +++++++++++++++++++
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |  4 ---
 6 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 0ba1d293bb81..fa18d8009f53 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -173,10 +173,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
-	ret = qat_crypto_dev_config(accel_dev);
-	if (ret)
-		goto out_err_free_reg;
-
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index 176d8e2786f4..686ec752d0e9 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -173,10 +173,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
-	ret = qat_crypto_dev_config(accel_dev);
-	if (ret)
-		goto out_err_free_reg;
-
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 5212891344a9..76f4f96ec5eb 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -114,6 +114,7 @@ void adf_cleanup_etr_data(struct adf_accel_dev *accel_dev);
 int qat_crypto_register(void);
 int qat_crypto_unregister(void);
 int qat_crypto_dev_config(struct adf_accel_dev *accel_dev);
+int qat_crypto_vf_dev_config(struct adf_accel_dev *accel_dev);
 struct qat_crypto_instance *qat_crypto_get_instance_node(int node);
 void qat_crypto_put_instance(struct qat_crypto_instance *inst);
 void qat_alg_callback(void *resp);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 391d82a64a93..2edc63c6b6ca 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -69,7 +69,8 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
-	if (!test_bit(ADF_STATUS_CONFIGURED, &accel_dev->status)) {
+	if (!test_bit(ADF_STATUS_CONFIGURED, &accel_dev->status) &&
+	    !accel_dev->is_vf) {
 		dev_err(&GET_DEV(accel_dev), "Device not configured\n");
 		return -EFAULT;
 	}
@@ -121,6 +122,12 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	if (ret)
 		return ret;
 
+	if (!test_bit(ADF_STATUS_CONFIGURED, &accel_dev->status) &&
+	    accel_dev->is_vf) {
+		if (qat_crypto_vf_dev_config(accel_dev))
+			return -EFAULT;
+	}
+
 	/*
 	 * Subservice initialisation is divided into two stages: init and start.
 	 * This is to facilitate any ordering dependencies between services
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index ece6776fbd53..7234c4940fae 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -8,6 +8,7 @@
 #include "adf_transport_access_macros.h"
 #include "adf_cfg.h"
 #include "adf_cfg_strings.h"
+#include "adf_gen2_hw_data.h"
 #include "qat_crypto.h"
 #include "icp_qat_fw.h"
 
@@ -104,6 +105,30 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 	return inst;
 }
 
+/**
+ * qat_crypto_vf_dev_config()
+ *     create dev config required to create crypto inst.
+ *
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * Function creates device configuration required to create
+ * asym, sym or, crypto instances
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int qat_crypto_vf_dev_config(struct adf_accel_dev *accel_dev)
+{
+	u16 ring_to_svc_map = GET_HW_DATA(accel_dev)->ring_to_svc_map;
+
+	if (ring_to_svc_map != ADF_GEN2_DEFAULT_RING_TO_SRV_MAP) {
+		dev_err(&GET_DEV(accel_dev),
+			"Unsupported ring/service mapping present on PF");
+		return -EFAULT;
+	}
+
+	return qat_crypto_dev_config(accel_dev);
+}
+
 /**
  * qat_crypto_dev_config() - create dev config required to create crypto inst.
  *
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index ee45d688b5d7..18756b2e1c91 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -173,10 +173,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
-	ret = qat_crypto_dev_config(accel_dev);
-	if (ret)
-		goto out_err_free_reg;
-
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
-- 
2.31.1

