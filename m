Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E99CC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 17 May 2022 14:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343711AbiEQOK0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 May 2022 10:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243867AbiEQOKT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 May 2022 10:10:19 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5D44A3F5
        for <linux-crypto@vger.kernel.org>; Tue, 17 May 2022 07:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652796618; x=1684332618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FmVCP4ZOgkPTIhHx9ZRJQDicKXa+kof2ExDVWbvuk9k=;
  b=WDx59cEAdiHper/w5Kv9JwmWFw0UPah+mkx2AXRfP7k7Dm4FKbGuNx2x
   8SpzRKpVHuID7RpRYzPaj2meBfGY1aHYswzfAxDu+CB6iWnz+w5qf+nne
   hl4tv4Oh9VBqn611TXbdJG33TXR0yZ7/vTJRTIDMB1aHZnCaPCWESo1uC
   eLneZmAAcOa6Z8C8ZfISF51sCia0oGmeeSuGvynvGZ84gsUd00l2+ohDM
   psdb4SgJASi/7Q0dd2uJqAn3j1TVRSO5pfNWmCY88zfSS1CLlwNPRP85+
   qXIolqMM7oqcTtcz1KVsVkx1G32sQWV7Gadp239QkX5ujIk3qM/jueYZb
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="268777821"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="268777821"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 07:10:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="816916491"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 May 2022 07:10:15 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tomasz Kowallik <tomaszx.kowalik@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH 4/4] crypto: qat - expose device config through sysfs for 4xxx
Date:   Tue, 17 May 2022 15:10:02 +0100
Message-Id: <20220517141002.32385-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220517141002.32385-1-giovanni.cabiddu@intel.com>
References: <20220517141002.32385-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

qat_4xxx devices can be configured to allow either crypto or compression
operations. At the moment, devices are configured statically according to
the following rule:
- odd numbered devices assigned to compression services
- even numbered devices assigned to crypto services

Expose the sysfs attribute /sys/bus/pci/devices/<BDF>/qat/cfg_services
to allow to detect the configuration of a device and to change it.

The `cfg_service` attribute is only exposed for qat_4xxx devices and it
is limited to two configurations: (1) "sym;asym" for crypto services and
"dc" for compression services.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Co-developed-by: Tomasz Kowallik <tomaszx.kowalik@intel.com>
Signed-off-by: Tomasz Kowallik <tomaszx.kowalik@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat | 37 ++++++++++
 drivers/crypto/qat/qat_common/adf_sysfs.c  | 80 ++++++++++++++++++++--
 2 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index 0915253efaa3..58a4152f5180 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -19,3 +19,40 @@ Description:	Reports the current state of the QAT device and allows to
 		if the device is up and vice versa.
 
 		This attribute is only available for qat_4xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat/cfg_services
+Date:		June 2022
+KernelVersion:	5.19
+Contact:	qat-linux@intel.com
+Description:	Reports the current configuration of the QAT device and allows
+		to change it.
+
+		This attribute is RW.
+
+		Returned values:
+			sym;asym:	the device is configured for running
+					crypto services
+			dc:		the device is configured for running
+					compression services
+
+		Allowed values:
+			sym;asym:	configure the device for running
+					crypto services
+			dc:		configure the device for running
+					compression services
+
+		It is possible to set the configuration only if the device
+		is in the `down` state (see /sys/bus/pci/devices/<BDF>/qat/state)
+
+		The following example shows how to change the configuration of
+		a device configured for running crypto services in order to
+		run data compression:
+			# cat /sys/bus/pci/devices/<BDF>/qat/state
+			up
+			# cat /sys/bus/pci/devices/<BDF>/qat/cfg_services
+			sym;asym
+			# echo down > /sys/bus/pci/devices/<BDF>/qat/state
+			# echo dc > /sys/bus/pci/devices/<BDF>/qat/cfg_services
+			# echo up > /sys/bus/pci/devices/<BDF>/qat/state
+
+		This attribute is only available for qat_4xxx devices.
diff --git a/drivers/crypto/qat/qat_common/adf_sysfs.c b/drivers/crypto/qat/qat_common/adf_sysfs.c
index 8f47a5694dd7..e8b078e719c2 100644
--- a/drivers/crypto/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/qat/qat_common/adf_sysfs.c
@@ -58,8 +58,9 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 
 		dev_info(dev, "Stopping device qat_dev%d\n", accel_id);
 
-		adf_dev_stop(accel_dev);
-		adf_dev_shutdown(accel_dev);
+		ret = adf_dev_shutdown_cache_cfg(accel_dev);
+		if (ret < 0)
+			return -EINVAL;
 
 		break;
 	case DEV_UP:
@@ -80,8 +81,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		if (ret < 0) {
 			dev_err(dev, "Failed to start device qat_dev%d\n",
 				accel_id);
-			adf_dev_stop(accel_dev);
-			adf_dev_shutdown(accel_dev);
+			adf_dev_shutdown_cache_cfg(accel_dev);
 			return ret;
 		}
 		break;
@@ -92,10 +92,82 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+static const char * const services_operations[] = {
+	ADF_CFG_CY,
+	ADF_CFG_DC,
+};
+
+static ssize_t cfg_services_show(struct device *dev, struct device_attribute *attr,
+				 char *buf)
+{
+	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
+	struct adf_accel_dev *accel_dev;
+	int ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
+				      ADF_SERVICES_ENABLED, services);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%s\n", services);
+}
+
+static int adf_sysfs_update_dev_config(struct adf_accel_dev *accel_dev,
+				       const char *services)
+{
+	return adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
+					   ADF_SERVICES_ENABLED, services,
+					   ADF_STR);
+}
+
+static ssize_t cfg_services_store(struct device *dev, struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct adf_hw_device_data *hw_data;
+	struct adf_accel_dev *accel_dev;
+	int ret;
+
+	ret = sysfs_match_string(services_operations, buf);
+	if (ret < 0)
+		return ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	if (adf_dev_started(accel_dev)) {
+		dev_info(dev, "Device qat_dev%d must be down to reconfigure the service.\n",
+			 accel_dev->accel_id);
+		return -EINVAL;
+	}
+
+	ret = adf_sysfs_update_dev_config(accel_dev, services_operations[ret]);
+	if (ret < 0)
+		return ret;
+
+	hw_data = GET_HW_DATA(accel_dev);
+
+	/* Update capabilities mask after change in configuration.
+	 * A call to this function is required as capabilities are, at the
+	 * moment, tied to configuration
+	 */
+	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
+	if (!hw_data->accel_capabilities_mask)
+		return -EINVAL;
+
+	return count;
+}
+
 static DEVICE_ATTR_RW(state);
+static DEVICE_ATTR_RW(cfg_services);
 
 static struct attribute *qat_attrs[] = {
 	&dev_attr_state.attr,
+	&dev_attr_cfg_services.attr,
 	NULL,
 };
 
-- 
2.36.1

