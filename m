Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792986912;
	b=utBCoVIohiglf9r4vagiXfk9qByM21TgEemDs/8NIhMkA9j96DPn2iYMxTmWzICrYX6a
	 f6O2vkuHI0nSVsJfcPfDg5tY9lft5eDSRWoijIrVprR62mapjbP49CPzoRnPf85hrSZHQ
	 CNxby/kECmvSrqKJJpSrm7bOdvUF/l72jbYgRzjnXoV9fWWEOLmr+YQIlC5lM4zneJX4P
	 Uir57bHb8Q+A8EFQmVkBq+qoZ7edqO3XapL7apNv51NUb0d/L6HpiK8Db44LuO6eL6EAb
	 5K89isGV5pj33F4jo6IZzkKgggI7ShsuEHXRaYDA2xZKhC1USq5Q6pl/6o6u5dYgTgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792986912;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=14dWeDOlypoFkGAcr83cKQmE+fLUYlTr/maHQJzKGrg=;
	b=fLkBUKzs4XqtwwRRkWUrgkVPiUFgShw8Rt6/UWvcsk7W8LrItsUxM5GhXQImHMm737K1
	 qw5U3OXa4lurqtIbaQh6ps+EJkK2eNJatpk0OGGOuAPfQNh3ElAotJaSZrw0zsY6E81xH
	 ihDvlZRyh3ggBGQLou3r4aPjAb926l7vw0H7LDJgxksMO4tGxhn49QF7u/VXzYapVBpoK
	 B9sX6AG2bc47KlFRTCkEqbBohUj3/c6nMH/e6F/COUW2KFeQYfzMho7utyYka4wholhlv
	 XqnLsNrDl36FK5r2+48jjxS3ryKrH9byoIJ6Ezsns7ujiBBH/I5hue4MN6XKvuTZZaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jbTB5NJy;
	arc=none smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62F7606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 03:55:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C62F7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jbTB5NJy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792986911; x=1824522911;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TG0Z9eINAynPTefEOKC6kYVcR5QdZI29uHXZahxmfQE=;
  b=jbTB5NJyFBk97+EKdHWVf0Dh7fpilk+aguBo2B+LJb+rwJskz17sXbDS
   1aX456MttHLAaBOZWiZOeo1vHokjabbKG4MI/YVw8JVt8mUQ/CpvgOfN1
   nPm9TaJDXeuVMpRtSZLIKBzsg+7FC+lWuaPHpyypSiyScrbbgsYf9QM5u
   uNFHI+3zMn1v3LhRSMBBDWUHs5qKbz4kwfIJmPurIewtoE/Mh8ZiescNk
   WCOj3SM7afHky7wOduCzm+EtDk7CvZxd9xYw+WtDiaiIWZTYLjjFWZTkg
   83oabH6F9bJXBv9cRX6LuFoxlTUlijBeB44lFX4GeoqS9w/tjz0ttxbsY
   Q==;
X-CSE-ConnectionGUID: A0AMpPrlQbCS68VLcPhY+g==
X-CSE-MsgGUID: sYA3x/XtSWmOI51jziXAGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11946"; a="1539591"
X-IronPort-AV: E=Sophos;i="6.27,178,1787036400"; 
   d="scan'208";a="1539591"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2026 20:55:10 -0700
X-CSE-ConnectionGUID: ua7sSsQFSjCmbeDktbvbaw==
X-CSE-MsgGUID: JiCYi7NcRZip0NUvtaHSRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,178,1787036400"; 
   d="scan'208";a="4553546"
Received: from dmr-bkc.iind.intel.com ([10.49.111.58])
  by fmviesa009.fm.intel.com with ESMTP; 25 Oct 2026 20:55:09 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Karthikeyan Gopal <karthikeyan.gopal@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - add support for enhanced decompression mode on GEN6 devices
Date: Mon, 26 Oct 2026 03:55:01 +0000
Message-ID: <20261026035501.1627846-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.52.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

QAT GEN6 devices have a compression engine and a decompression engine.
The compression engine includes a decompression engine that is used to
verify compressed data (compress and verify). In enhanced decompression
mode, the firmware also uses this embedded engine to process
decompression requests, bypassing the compression and translation
stages. This increases decompression throughput, and compression
requests can still be processed at the same time.

Add the firmware admin command ICP_QAT_FW_CNV_BYPASS_MODE_SET to enable
or disable the mode, and send it at device initialization when the mode
is enabled.

Expose the mode through a new sysfs attribute,
/sys/bus/pci/devices/<BDF>/qat/decomp_enhanced, on devices that support
it. A write stores the setting in the device configuration and, if the
device is up, programs the firmware immediately. The setting persists
across down/up transitions and cfg_services changes. If it was never
written, the mode is enabled when the decomp service is configured
without dc, and disabled otherwise.

When decomp is configured without dc, also map the decompression ring
pairs to thread 0 of each compression engine, which is otherwise used
for compression. With the enhanced decompression mode disabled, the
firmware forwards decompression requests received on thread 0 to thread 1.

Co-developed-by: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
Signed-off-by: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat    | 56 ++++++++++++
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 19 +++-
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 .../crypto/intel/qat/qat_common/adf_admin.c   | 22 +++++
 .../crypto/intel/qat/qat_common/adf_admin.h   |  1 +
 .../intel/qat/qat_common/adf_cfg_services.c   | 25 ++++++
 .../intel/qat/qat_common/adf_cfg_services.h   |  1 +
 .../intel/qat/qat_common/adf_cfg_strings.h    |  1 +
 .../crypto/intel/qat/qat_common/adf_sysfs.c   | 87 +++++++++++++++++++
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  5 ++
 10 files changed, 217 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index b0561b9fc4eb..d1c07b83d601 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -165,3 +165,59 @@ Description:	(RW) Reports the current state of the autoreset feature
 		  unrecoverable error, it will not be reset.
 
 		This attribute is available for qat_4xxx and qat_6xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat/decomp_enhanced
+Date:		Oct 2026
+KernelVersion:	7.4
+Contact:	qat-linux@intel.com
+Description:	(RW) Reports and controls the enhanced decompression mode of a
+		QAT device.
+
+		The compression engine includes a decompression engine that
+		is normally used only to verify compressed data (compress and
+		verify). Enhanced decompression is a firmware operating mode
+		that also uses this embedded engine to process decompression
+		requests, in addition to the dedicated decompression engine.
+		This increases decompression throughput. Compression requests
+		are still processed while the mode is enabled.
+
+		The values are:
+
+		* on: enhanced decompression mode is enabled.
+		* off: enhanced decompression mode is disabled. Decompression
+		  requests are processed only by the dedicated decompression
+		  engine.
+
+		The attribute accepts any value understood by kstrtobool(),
+		i.e. 0/1, y/n, Y/N, on/off, true/false.
+
+		Write constraints:
+
+		* Enhanced decompression can only be enabled when the device
+		  is configured with a service set that includes `dc` or
+		  `decomp` (see /sys/bus/pci/devices/<BDF>/qat/cfg_services).
+		  Attempting to enable it under any other configuration is
+		  rejected with -EINVAL.
+		* The selected value is persisted in the driver configuration
+		  and reapplied automatically across `down`/`up` transitions
+		  and `cfg_services` changes. It has no effect while neither
+		  `dc` nor `decomp` is configured.
+
+		Default value:
+
+		* If never written, the value follows `cfg_services`: on when
+		  `decomp` is configured without `dc`, off otherwise.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat/state
+			up
+			# cat /sys/bus/pci/devices/<BDF>/qat/cfg_services
+			dc
+			# cat /sys/bus/pci/devices/<BDF>/qat/decomp_enhanced
+			off
+			# echo 1 > /sys/bus/pci/devices/<BDF>/qat/decomp_enhanced
+			# cat /sys/bus/pci/devices/<BDF>/qat/decomp_enhanced
+			on
+
+		This attribute is available for qat_6xxx devices.
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index 27c813d1c6c3..7bab04d8b761 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -80,6 +80,10 @@ static const unsigned long thrd_mask_dcc[ADF_6XXX_MAX_ACCELENGINES] = {
 	0x00, 0x00, 0x00, 0x00, 0x07, 0x07, 0x03, 0x03, 0x00
 };
 
+static const unsigned long thrd_mask_enh_dcpr[ADF_6XXX_MAX_ACCELENGINES] = {
+	0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x00
+};
+
 static const unsigned long thrd_mask_dcpr[ADF_6XXX_MAX_ACCELENGINES] = {
 	0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x00
 };
@@ -174,6 +178,16 @@ static enum adf_cfg_service_type get_ring_type(unsigned int service)
 	}
 }
 
+static bool adf_gen6_is_decomp_without_dc(struct adf_accel_dev *accel_dev)
+{
+	unsigned long mask;
+
+	if (adf_get_service_mask(accel_dev, &mask))
+		return false;
+
+	return test_bit(SVC_DECOMP, &mask) && !test_bit(SVC_DC, &mask);
+}
+
 static const unsigned long *get_thrd_mask(struct adf_accel_dev *accel_dev,
 					  unsigned int service)
 {
@@ -190,6 +204,8 @@ static const unsigned long *get_thrd_mask(struct adf_accel_dev *accel_dev,
 	case SVC_DCC:
 		return thrd_mask_dcc;
 	case SVC_DECOMP:
+		if (adf_gen6_is_decomp_without_dc(accel_dev))
+			return thrd_mask_enh_dcpr;
 		return thrd_mask_dcpr;
 	default:
 		return NULL;
@@ -1080,7 +1096,8 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	hw_data->num_rps = ADF_GEN6_ETR_MAX_BANKS;
 	hw_data->clock_frequency = ADF_6XXX_AE_FREQ;
 	hw_data->get_svc_slice_cnt = adf_gen6_get_svc_slice_cnt;
-	hw_data->accel_capabilities_ext_mask = ADF_ACCEL_CAPABILITIES_EXT_ZSTD;
+	hw_data->accel_capabilities_ext_mask = ADF_ACCEL_CAPABILITIES_EXT_ZSTD |
+					       ADF_ACCEL_CAPABILITIES_EXT_ENHANCED_DECOMP;
 
 	adf_gen6_init_services_supported(hw_data);
 	adf_gen6_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index b77f461e8583..799376ad99a0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -58,6 +58,7 @@ enum adf_accel_capabilities {
 enum adf_accel_capabilities_ext {
 	ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S = BIT(0),
 	ADF_ACCEL_CAPABILITIES_EXT_ZSTD = BIT(1),
+	ADF_ACCEL_CAPABILITIES_EXT_ENHANCED_DECOMP = BIT(2),
 };
 
 enum adf_fuses {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 1eea74c2a8a5..2312ad9c0e84 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -12,6 +12,7 @@
 #include "adf_anti_rb.h"
 #include "adf_common_drv.h"
 #include "adf_cfg.h"
+#include "adf_cfg_services.h"
 #include "adf_heartbeat.h"
 #include "adf_kpt.h"
 #include "icp_qat_fw_init_admin.h"
@@ -229,6 +230,18 @@ static int adf_set_chaining(struct adf_accel_dev *accel_dev)
 	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
 
+int adf_send_admin_decomp_enhanced(struct adf_accel_dev *accel_dev, bool enabled)
+{
+	u32 ae_mask = GET_HW_DATA(accel_dev)->ae_mask;
+	struct icp_qat_fw_init_admin_resp resp = { };
+	struct icp_qat_fw_init_admin_req req = { };
+
+	req.cmd_id = ICP_QAT_FW_CNV_BYPASS_MODE_SET;
+	req.cnv_bypass_mode_val = enabled;
+
+	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
+}
+
 static int adf_get_dc_capabilities(struct adf_accel_dev *accel_dev,
 				   u32 *capabilities)
 {
@@ -412,6 +425,15 @@ int adf_send_admin_init(struct adf_accel_dev *accel_dev)
 	}
 	accel_dev->hw_device->extended_dc_capabilities = dc_capabilities;
 
+	if (adf_is_decomp_enhanced(accel_dev)) {
+		ret = adf_send_admin_decomp_enhanced(accel_dev, true);
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev),
+				"Cannot set enhanced decompression mode\n");
+			return ret;
+		}
+	}
+
 	adf_get_fw_capabilities(accel_dev, &hw_data->fw_capabilities);
 
 	return adf_init_ae(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.h b/drivers/crypto/intel/qat/qat_common/adf_admin.h
index 44eb6dc92e45..126a19a98b80 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.h
@@ -11,6 +11,7 @@ int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
 void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
 int adf_send_admin_init(struct adf_accel_dev *accel_dev);
 int adf_get_ae_fw_counters(struct adf_accel_dev *accel_dev, u16 ae, u64 *reqs, u64 *resps);
+int adf_send_admin_decomp_enhanced(struct adf_accel_dev *accel_dev, bool enabled);
 int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay);
 int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt);
 int adf_send_admin_hb_timer(struct adf_accel_dev *accel_dev, uint32_t ticks);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index f7237c7ef2b1..b5cf99607049 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -206,3 +206,28 @@ bool adf_is_service_enabled(struct adf_accel_dev *accel_dev, enum adf_base_servi
 
 	return false;
 }
+
+bool adf_is_decomp_enhanced(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = { };
+	unsigned long mask;
+	u32 caps;
+
+	caps = hw_data->accel_capabilities_ext_mask;
+	if (!(caps & ADF_ACCEL_CAPABILITIES_EXT_ENHANCED_DECOMP))
+		return false;
+
+	if (adf_get_service_mask(accel_dev, &mask))
+		return false;
+
+	if (!test_bit(SVC_DC, &mask) && !test_bit(SVC_DECOMP, &mask))
+		return false;
+
+	/* Not set via sysfs: default to on for decomp without dc */
+	if (adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
+				    ADF_DECOMP_ENHANCED, val))
+		return !test_bit(SVC_DC, &mask);
+
+	return !strcmp(val, "1");
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
index 89be2f2c7233..e7f6561280dc 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -40,5 +40,6 @@ int adf_get_service_enabled(struct adf_accel_dev *accel_dev);
 int adf_get_service_mask(struct adf_accel_dev *accel_dev, unsigned long *mask);
 enum adf_cfg_service_type adf_srv_to_cfg_svc_type(enum adf_base_services svc);
 bool adf_is_service_enabled(struct adf_accel_dev *accel_dev, enum adf_base_services svc);
+bool adf_is_decomp_enhanced(struct adf_accel_dev *accel_dev);
 
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
index 30107a02ee7f..49e68555f6a0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
@@ -47,5 +47,6 @@
 #define ADF_ACCEL_STR "Accelerator%d"
 #define ADF_HEARTBEAT_TIMER  "HeartbeatTimer"
 #define ADF_SRIOV_ENABLED "SriovEnabled"
+#define ADF_DECOMP_ENHANCED "DecompEnhanced"
 
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 8daa69a76b01..ab3f17c878bb 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -5,6 +5,7 @@
 #include <linux/pci.h>
 #include <linux/string_choices.h>
 #include "adf_accel_devices.h"
+#include "adf_admin.h"
 #include "adf_cfg.h"
 #include "adf_cfg_services.h"
 #include "adf_common_drv.h"
@@ -321,6 +322,70 @@ static ssize_t num_rps_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(num_rps);
 
+static ssize_t decomp_enhanced_show(struct device *dev, struct device_attribute *attr,
+				    char *buf)
+{
+	struct adf_accel_dev *accel_dev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	return sysfs_emit(buf, "%s\n", str_on_off(adf_is_decomp_enhanced(accel_dev)));
+}
+
+static ssize_t decomp_enhanced_store(struct device *dev, struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct adf_accel_dev *accel_dev;
+	unsigned long mask;
+	bool enabled;
+	int ret;
+
+	ret = kstrtobool(buf, &enabled);
+	if (ret)
+		return ret;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	if (adf_devmgr_in_reset(accel_dev))
+		return -EBUSY;
+
+	if (enabled) {
+		ret = adf_get_service_mask(accel_dev, &mask);
+		if (ret)
+			return ret;
+
+		if (!(mask & (BIT(SVC_DC) | BIT(SVC_DECOMP)))) {
+			dev_err(&GET_DEV(accel_dev),
+				"decomp_enhanced requires dc or decomp service\n");
+			return -EINVAL;
+		}
+	}
+
+	/* If the device is down the value is picked up by adf_send_admin_init(). */
+	if (adf_dev_started(accel_dev)) {
+		ret = adf_send_admin_decomp_enhanced(accel_dev, enabled);
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to program enhanced decompression: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
+					  ADF_DECOMP_ENHANCED,
+					  enabled ? "1" : "0", ADF_STR);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR_RW(decomp_enhanced);
+
 static struct attribute *qat_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_cfg_services.attr,
@@ -328,11 +393,33 @@ static struct attribute *qat_attrs[] = {
 	&dev_attr_rp2srv.attr,
 	&dev_attr_num_rps.attr,
 	&dev_attr_auto_reset.attr,
+	&dev_attr_decomp_enhanced.attr,
 	NULL,
 };
 
+static umode_t qat_attr_is_visible(struct kobject *kobj, struct attribute *attr,
+				   int index)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct adf_accel_dev *accel_dev;
+	u32 caps;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return 0;
+
+	if (attr == &dev_attr_decomp_enhanced.attr) {
+		caps = GET_HW_DATA(accel_dev)->accel_capabilities_ext_mask;
+		if (!(caps & ADF_ACCEL_CAPABILITIES_EXT_ENHANCED_DECOMP))
+			return 0;
+	}
+
+	return attr->mode;
+}
+
 static struct attribute_group qat_group = {
 	.attrs = qat_attrs,
+	.is_visible = qat_attr_is_visible,
 	.name = "qat",
 };
 
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
index 95f7f514cb63..2adca91ec69a 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
@@ -24,6 +24,7 @@ enum icp_qat_fw_init_admin_cmd_id {
 	ICP_QAT_FW_RL_INIT = 15,
 	ICP_QAT_FW_TIMER_GET = 19,
 	ICP_QAT_FW_CNV_STATS_GET = 20,
+	ICP_QAT_FW_CNV_BYPASS_MODE_SET = 24,
 	ICP_QAT_FW_PM_STATE_CONFIG = 128,
 	ICP_QAT_FW_PM_INFO = 129,
 	ICP_QAT_FW_RL_ADD = 134,
@@ -83,6 +84,10 @@ struct icp_qat_fw_init_admin_req {
 	__u64 init_cfg_ptr;
 
 	union {
+		struct {
+			__u8 cnv_bypass_mode_val;
+			__u8 resrvd6[7];
+		};
 		struct {
 			__u16 ibuf_size_in_kb;
 			__u16 resrvd3;

base-commit: 9c5d66e1ea78912b8a43ce16a1c14db1357e0ae0
-- 
2.52.0

