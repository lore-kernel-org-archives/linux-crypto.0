Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A3FC7EE2E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 17:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjFIRGb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 13:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFIRGa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 13:06:30 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5965B1BD
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 10:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686330389; x=1717866389;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3F4+6JlUaJXswln0W5Wql+Q+Rmx1OYen8cLhRB8PThw=;
  b=TtcBAkeAUR0a3r4ydRWZXkyrC0EQYXgi4OjQv59X5TFeBpZKR46SxHt7
   fzudnZtVYUjvrMIRyFiOGGZLoHb0snDi+K2qGOzXkNjTiFXFM1Xm96Kgb
   a+3yqOCe5p4cLJ8lbJm+dBwgpxmbPBdL2b9bGQLFz2NMkkwwoNeANpRPv
   dOknALei8RfQzMpzUB+mrJNrDZ0gYR6DCUuNPPsXAtL1YcY2SmferMhfi
   kz4xnHXLnL0EL7maUkEzLXSzZgMqxO32jTAm+DTg/iXqv9DHcPNwUzsWz
   iweqI+KK+q2jUExvsOMIDnhcOGYTSRQG1eH2vEXCyGbPyRz9AOMlAkD3y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="347290718"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="347290718"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 10:06:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="834697438"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="834697438"
Received: from sdpcloudhostegs034.jf.intel.com ([10.165.126.39])
  by orsmga004.jf.intel.com with ESMTP; 09 Jun 2023 10:06:28 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] crypto: qat - expose pm_idle_enabled through sysfs
Date:   Fri,  9 Jun 2023 19:06:14 +0200
Message-Id: <20230609170614.28237-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose 'pm_idle_enabled' sysfs attribute. This attribute controls how
idle conditions are handled. If it is set to 1 (idle support enabled)
when the device detects an idle condition, the driver will transition
the device to the 'MIN' power configuration.

In order to set the value of this attribute for a device, the device
must be in the 'down' state.

This only applies to qat_4xxx generation.

Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat    | 35 ++++++++++++
 .../intel/qat/qat_common/adf_cfg_strings.h    |  1 +
 .../crypto/intel/qat/qat_common/adf_gen4_pm.c | 12 ++++-
 .../crypto/intel/qat/qat_common/adf_gen4_pm.h |  1 +
 .../crypto/intel/qat/qat_common/adf_sysfs.c   | 53 +++++++++++++++++++
 5 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index 087842b1969e..ed4b7b2d1b6c 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -47,3 +47,38 @@ Description:	(RW) Reports the current configuration of the QAT device.
 			dc
 
 		This attribute is only available for qat_4xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat/pm_idle_enabled
+Date:		June 2023
+KernelVersion:	6.5
+Contact:	qat-linux@intel.com
+Description:	(RW) This configuration option provides a way to force the device into remaining in
+		the MAX power state.
+		If idle support is enabled the device will transition to the `MIN` power state when
+		idle, otherwise will stay in the MAX power state.
+		Write to the file to enable or disable idle support.
+
+		The values are:
+
+		* 0: idle support is disabled
+		* 1: idle support is enabled
+
+		Default value is 1.
+
+		It is possible to set the pm_idle_enabled value only if the device
+		is in the `down` state (see /sys/bus/pci/devices/<BDF>/qat/state)
+
+		The following example shows how to change the pm_idle_enabled of
+		a device::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat/state
+			up
+			# cat /sys/bus/pci/devices/<BDF>/qat/pm_idle_enabled
+			1
+			# echo down > /sys/bus/pci/devices/<BDF>/qat/state
+			# echo 0 > /sys/bus/pci/devices/<BDF>/qat/pm_idle_enabled
+			# echo up > /sys/bus/pci/devices/<BDF>/qat/state
+			# cat /sys/bus/pci/devices/<BDF>/qat/pm_idle_enabled
+			0
+
+		This attribute is only available for qat_4xxx devices.
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
index 5d8c3bdb258c..96d0db41f1e2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
@@ -26,6 +26,7 @@
 #define ADF_CFG_DC "dc"
 #define ADF_CFG_CY "sym;asym"
 #define ADF_SERVICES_ENABLED "ServicesEnabled"
+#define ADF_PM_IDLE_SUPPORT "PmIdleSupport"
 #define ADF_ETRMGR_COALESCING_ENABLED "InterruptCoalescingEnabled"
 #define ADF_ETRMGR_COALESCING_ENABLED_FORMAT \
 	ADF_ETRMGR_BANK "%d" ADF_ETRMGR_COALESCING_ENABLED
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
index 7037c0892a8a..34c6cd8e27c0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
@@ -23,15 +23,25 @@ struct adf_gen4_pm_data {
 
 static int send_host_msg(struct adf_accel_dev *accel_dev)
 {
+	char pm_idle_support_cfg[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {};
 	void __iomem *pmisc = adf_get_pmisc_base(accel_dev);
+	bool pm_idle_support;
 	u32 msg;
+	int ret;
 
 	msg = ADF_CSR_RD(pmisc, ADF_GEN4_PM_HOST_MSG);
 	if (msg & ADF_GEN4_PM_MSG_PENDING)
 		return -EBUSY;
 
+	adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
+				ADF_PM_IDLE_SUPPORT, pm_idle_support_cfg);
+	ret = kstrtobool(pm_idle_support_cfg, &pm_idle_support);
+	if (ret)
+		pm_idle_support = true;
+
 	/* Send HOST_MSG */
-	msg = FIELD_PREP(ADF_GEN4_PM_MSG_PAYLOAD_BIT_MASK, PM_SET_MIN);
+	msg = FIELD_PREP(ADF_GEN4_PM_MSG_PAYLOAD_BIT_MASK,
+			 pm_idle_support ? PM_SET_MIN : PM_NO_CHANGE);
 	msg |= ADF_GEN4_PM_MSG_PENDING;
 	ADF_CSR_WR(pmisc, ADF_GEN4_PM_HOST_MSG, msg);
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
index f8f8a9ee29e5..dd112923e006 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
@@ -37,6 +37,7 @@
 
 #define ADF_GEN4_PM_DEFAULT_IDLE_FILTER		(0x0)
 #define ADF_GEN4_PM_MAX_IDLE_FILTER		(0x7)
+#define ADF_GEN4_PM_DEFAULT_IDLE_SUPPORT	(0x1)
 
 int adf_gen4_enable_pm(struct adf_accel_dev *accel_dev);
 bool adf_gen4_handle_pm_interrupt(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 3eb6611ab1b1..9515da11deb7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -145,12 +145,65 @@ static ssize_t cfg_services_store(struct device *dev, struct device_attribute *a
 	return count;
 }
 
+static ssize_t pm_idle_enabled_show(struct device *dev, struct device_attribute *attr,
+				    char *buf)
+{
+	char pm_idle_enabled[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {};
+	struct adf_accel_dev *accel_dev;
+	int ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
+				      ADF_PM_IDLE_SUPPORT, pm_idle_enabled);
+	if (ret)
+		return sysfs_emit(buf, "1\n");
+
+	return sysfs_emit(buf, "%s\n", pm_idle_enabled);
+}
+
+static ssize_t pm_idle_enabled_store(struct device *dev, struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	unsigned long pm_idle_enabled_cfg_val;
+	struct adf_accel_dev *accel_dev;
+	bool pm_idle_enabled;
+	int ret;
+
+	ret = kstrtobool(buf, &pm_idle_enabled);
+	if (ret)
+		return ret;
+
+	pm_idle_enabled_cfg_val = pm_idle_enabled;
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	if (adf_dev_started(accel_dev)) {
+		dev_info(dev, "Device qat_dev%d must be down to set pm_idle_enabled.\n",
+			 accel_dev->accel_id);
+		return -EINVAL;
+	}
+
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
+					  ADF_PM_IDLE_SUPPORT, &pm_idle_enabled_cfg_val,
+					  ADF_DEC);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR_RW(pm_idle_enabled);
+
 static DEVICE_ATTR_RW(state);
 static DEVICE_ATTR_RW(cfg_services);
 
 static struct attribute *qat_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_cfg_services.attr,
+	&dev_attr_pm_idle_enabled.attr,
 	NULL,
 };
 

base-commit: 6b5755b35497de5e8ed17772f7b0dd1bbe19cbee
-- 
2.39.2

