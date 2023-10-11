Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25BFCD6E5D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjJKMgp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjJKMgg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9B491
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027795; x=1728563795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I976ztSclNG6sPo7Z2/hjv/9c2fSfhFu3rlQ+FFDKxo=;
  b=BzpH94032l8FpKfC8oL4hVpPFnxBBaQLvkXW0dlBkK2C3pxjvSzRJeMl
   vTIVSusC1YePAkT91jI8kv1BNc+unKm1ISHkiN4SQ//GmSnrUwc9MFuHI
   N/Se9DooKYxiUX2NQOEr6PTGKazmpbu8ktkKNW8VeqXc+pExaLmnd9ieU
   Jos9b9q5Qhdrgnlu3xfMyf+tu2IYr1XgZBrJfHgmpBJ8d5Uhu7JzqExIG
   4NqCvc1Uzb+4y6vjuBAjrYunuElmPkREIFcS7iUfhbTARci2N/Df8co22
   18dP/6eyJePw5Pu/FyHXwtBQwq4G0x481ILNzvUw0JGJuGrGdp3wmCL33
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992953"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992953"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124794"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124794"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:36:33 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Ciunas Bennett <ciunas.bennett@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 10/11] crypto: qat - add rp2svc sysfs attribute
Date:   Wed, 11 Oct 2023 14:15:08 +0200
Message-ID: <20231011121934.45255-11-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011121934.45255-1-damian.muszynski@intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ciunas Bennett <ciunas.bennett@intel.com>

Add the attribute `rp2svc` to the `qat` attribute group. This provides a
way for a user to query a specific ring pair for the type of service
that is currently configured for.

When read, the service will be returned for the defined ring pair.
When written to this value will be stored as the ring pair to return
the service of.

Signed-off-by: Ciunas Bennett <ciunas.bennett@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat    | 32 +++++++++
 .../intel/qat/qat_common/adf_accel_devices.h  |  6 ++
 .../crypto/intel/qat/qat_common/adf_sysfs.c   | 66 +++++++++++++++++++
 3 files changed, 104 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index 96834d103a09..f24a5ddca94b 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -95,3 +95,35 @@ Description:	(RW) This configuration option provides a way to force the device i
 			0
 
 		This attribute is only available for qat_4xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat/rp2srv
+Date:		January 2024
+KernelVersion:	6.7
+Contact:	qat-linux@intel.com
+Description:
+		(RW) This attribute provides a way for a user to query a
+		specific ring pair for the type of service that it is currently
+		configured for.
+
+		When written to, the value is cached and used to perform the
+		read operation. Allowed values are in the range 0 to N-1, where
+		N is the max number of ring pairs supported by a device. This
+		can be queried using the attribute qat/num_rps.
+
+		A read returns the service associated to the ring pair queried.
+
+		The values are:
+
+		* dc: the ring pair is configured for running compression services
+		* sym: the ring pair is configured for running symmetric crypto
+		  services
+		* asym: the ring pair is configured for running asymmetric crypto
+		  services
+
+		Example usage::
+
+			# echo 1 > /sys/bus/pci/devices/<BDF>/qat/rp2srv
+			# cat /sys/bus/pci/devices/<BDF>/qat/rp2srv
+			sym
+
+		This attribute is only available for qat_4xxx devices.
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 35b805b9a136..9bb9e30eb456 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -307,6 +307,11 @@ struct adf_pm {
 				   char __user *buf, size_t count, loff_t *pos);
 };
 
+struct adf_sysfs {
+	int ring_num;
+	struct rw_semaphore lock; /* protects access to the fields in this struct */
+};
+
 struct adf_accel_dev {
 	struct adf_etr_data *transport;
 	struct adf_hw_device_data *hw_device;
@@ -328,6 +333,7 @@ struct adf_accel_dev {
 	struct adf_timer *timer;
 	struct adf_heartbeat *heartbeat;
 	struct adf_rl *rate_limiting;
+	struct adf_sysfs sysfs;
 	union {
 		struct {
 			/* protects VF2PF interrupts access */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index f4a89f7ed4e9..9317127128a9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -8,6 +8,8 @@
 #include "adf_cfg_services.h"
 #include "adf_common_drv.h"
 
+#define UNSET_RING_NUM -1
+
 static const char * const state_operations[] = {
 	[DEV_DOWN] = "down",
 	[DEV_UP] = "up",
@@ -205,10 +207,72 @@ static DEVICE_ATTR_RW(pm_idle_enabled);
 static DEVICE_ATTR_RW(state);
 static DEVICE_ATTR_RW(cfg_services);
 
+static ssize_t rp2srv_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct adf_hw_device_data *hw_data;
+	struct adf_accel_dev *accel_dev;
+	enum adf_cfg_service_type svc;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	hw_data = GET_HW_DATA(accel_dev);
+
+	if (accel_dev->sysfs.ring_num == UNSET_RING_NUM)
+		return -EINVAL;
+
+	down_read(&accel_dev->sysfs.lock);
+	svc = GET_SRV_TYPE(accel_dev, accel_dev->sysfs.ring_num %
+					      hw_data->num_banks_per_vf);
+	up_read(&accel_dev->sysfs.lock);
+
+	switch (svc) {
+	case COMP:
+		return sysfs_emit(buf, "%s\n", ADF_CFG_DC);
+	case SYM:
+		return sysfs_emit(buf, "%s\n", ADF_CFG_SYM);
+	case ASYM:
+		return sysfs_emit(buf, "%s\n", ADF_CFG_ASYM);
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
+static ssize_t rp2srv_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct adf_accel_dev *accel_dev;
+	int ring, num_rings, ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	ret = kstrtouint(buf, 10, &ring);
+	if (ret)
+		return ret;
+
+	num_rings = GET_MAX_BANKS(accel_dev);
+	if (ring >= num_rings) {
+		dev_err(&GET_DEV(accel_dev),
+			"Device does not support more than %u ring pairs\n",
+			num_rings);
+		return -EINVAL;
+	}
+
+	down_write(&accel_dev->sysfs.lock);
+	accel_dev->sysfs.ring_num = ring;
+	up_write(&accel_dev->sysfs.lock);
+
+	return count;
+}
+static DEVICE_ATTR_RW(rp2srv);
+
 static struct attribute *qat_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_cfg_services.attr,
 	&dev_attr_pm_idle_enabled.attr,
+	&dev_attr_rp2srv.attr,
 	NULL,
 };
 
@@ -227,6 +291,8 @@ int adf_sysfs_init(struct adf_accel_dev *accel_dev)
 			"Failed to create qat attribute group: %d\n", ret);
 	}
 
+	accel_dev->sysfs.ring_num = UNSET_RING_NUM;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_sysfs_init);
-- 
2.41.0

