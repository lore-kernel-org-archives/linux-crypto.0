Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614A07CF02
	for <linux-crypto@vger.kernel.org>; Fri,  2 Feb 2024 10:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706871309; cv=none; b=TG5XXNiXDDVKtWaHY2l+Cb+e5yfDUkkixw/1O4yn+soN+Ou8Roauzcvr7QsVgSa7s+PYU2VtFF+hLJssfhdohfsE/BHM754eIW4jNZhm+qHBup2swTUwXpyxI3ETddb2CwEEn8L3WEYgizepHi+6NV8S0way0ZE+NF4BbRIdcfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706871309; c=relaxed/simple;
	bh=yqIOeHWNH6R8ce78erp1JUeBQuApZbpPiCUmsHB1hd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VrLu5R253ZAHs0X+0YwBObf6aGBVGSQN60WOnyuIUb86nr+4PTEhy9+9h1+NBovV8TxqLp3+GKDptC3FUhp8DZSQu0Fp40oZqjwmfJL625eqll5JU77VF2j2rd9kRVkD+ybvk526PAQcBHg7gb2PcehQGL0E9+ExyigCSJajrqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hVMMjPAH; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hVMMjPAH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706871307; x=1738407307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yqIOeHWNH6R8ce78erp1JUeBQuApZbpPiCUmsHB1hd8=;
  b=hVMMjPAHo1k00ftavZPlp+mMqnkzHNO8eNaCxZNVdhDm28bAcshi77zl
   R/0XhDK30n46UzBMIM1x6FqC14b79XnhLAnaGgcmugJVO7nV8CVMLBtaR
   QrxP4WwrfgRMw1BCEK/U21vdtVyITFO2ksA0uaJQtUhNf9Uwm9w5Wc5MC
   PFqqrPrL1MNqdjDWtaMtcIAUl5KSOmYTcE1JqggNohWSOeGDsjzK7gG2K
   UHIbH6Y6KhWoOyzDhU3MCgBzXBx6fVNPvq1v7FgdGEA5JED3Xutcn+q6U
   c6HXkzMMKVvi1N6iKMyn5lTZ8oEOU4zKxsSghhc8vUrq+ER96s7uupVEW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="10787286"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="10787286"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="53566"
Received: from myep-mobl1.png.intel.com ([10.107.10.166])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:04 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Furong Zhou <furong.zhou@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mun Chun Yep <mun.chun.yep@intel.com>
Subject: [PATCH v2 2/9] crypto: qat - add fatal error notify method
Date: Fri,  2 Feb 2024 18:53:17 +0800
Message-Id: <20240202105324.50391-3-mun.chun.yep@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240202105324.50391-1-mun.chun.yep@intel.com>
References: <20240202105324.50391-1-mun.chun.yep@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Furong Zhou <furong.zhou@intel.com>

Add error notify method to report a fatal error event to all the
subsystems registered. In addition expose an API,
adf_notify_fatal_error(), that allows to trigger a fatal error
notification asynchronously in the context of a workqueue.

This will be invoked when a fatal error is detected by the ISR or
through Heartbeat.

Signed-off-by: Furong Zhou <furong.zhou@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Markas Rapoportas <markas.rapoportas@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Mun Chun Yep <mun.chun.yep@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 30 +++++++++++++++++++
 .../intel/qat/qat_common/adf_common_drv.h     |  3 ++
 .../crypto/intel/qat/qat_common/adf_init.c    | 12 ++++++++
 3 files changed, 45 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index a39e70bd4b21..22a43b4b8315 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -8,6 +8,11 @@
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 
+struct adf_fatal_error_data {
+	struct adf_accel_dev *accel_dev;
+	struct work_struct work;
+};
+
 static struct workqueue_struct *device_reset_wq;
 
 static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
@@ -171,6 +176,31 @@ const struct pci_error_handlers adf_err_handler = {
 };
 EXPORT_SYMBOL_GPL(adf_err_handler);
 
+static void adf_notify_fatal_error_worker(struct work_struct *work)
+{
+	struct adf_fatal_error_data *wq_data =
+			container_of(work, struct adf_fatal_error_data, work);
+	struct adf_accel_dev *accel_dev = wq_data->accel_dev;
+
+	adf_error_notifier(accel_dev);
+	kfree(wq_data);
+}
+
+int adf_notify_fatal_error(struct adf_accel_dev *accel_dev)
+{
+	struct adf_fatal_error_data *wq_data;
+
+	wq_data = kzalloc(sizeof(*wq_data), GFP_ATOMIC);
+	if (!wq_data)
+		return -ENOMEM;
+
+	wq_data->accel_dev = accel_dev;
+	INIT_WORK(&wq_data->work, adf_notify_fatal_error_worker);
+	adf_misc_wq_queue_work(&wq_data->work);
+
+	return 0;
+}
+
 int adf_init_aer(void)
 {
 	device_reset_wq = alloc_workqueue("qat_device_reset_wq",
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 0baae42deb3a..8c062d5a8db2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -40,6 +40,7 @@ enum adf_event {
 	ADF_EVENT_SHUTDOWN,
 	ADF_EVENT_RESTARTING,
 	ADF_EVENT_RESTARTED,
+	ADF_EVENT_FATAL_ERROR,
 };
 
 struct service_hndl {
@@ -60,6 +61,8 @@ int adf_dev_restart(struct adf_accel_dev *accel_dev);
 
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
 void adf_clean_vf_map(bool);
+int adf_notify_fatal_error(struct adf_accel_dev *accel_dev);
+void adf_error_notifier(struct adf_accel_dev *accel_dev);
 int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 		       struct adf_accel_dev *pf);
 void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index f43ae9111553..74f0818c0703 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -433,6 +433,18 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 	return 0;
 }
 
+void adf_error_notifier(struct adf_accel_dev *accel_dev)
+{
+	struct service_hndl *service;
+
+	list_for_each_entry(service, &service_table, list) {
+		if (service->event_hld(accel_dev, ADF_EVENT_FATAL_ERROR))
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to send error event to %s.\n",
+				service->name);
+	}
+}
+
 static int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev)
 {
 	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
-- 
2.34.1

