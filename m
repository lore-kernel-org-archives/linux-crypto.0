Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0004FCD6E63
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjJKMgo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbjJKMgi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99CF98
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027796; x=1728563796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=36ymWLhVvEMjsEotoJ8krqW/vH9q5lGSkdbU26jCUso=;
  b=TqG1Z5dXJlfy18IKkldA6exH4jXxL3K/VHDxQ693hNQVZayyS9V3k4Dh
   o/HKZ/v4zeCE1y1CoqmkuSMRotb6d2ZF93ZHCegll7rW4aGZU69NIdWWA
   N8mT2AOb1vAW4Si4cVrFNQUkOW93unmwWanlBiPlbKLfZQ7/UF45GAlzH
   c3yQ1Vfb5rF8/R6Hz37/N319Pm8DqnLhBvfXqcZm/Hx6UfjdA9REt1GBh
   Umg4mEUtPgVm1M1cuuAm683qdotPqHfIbyyzKjbbpdEjmSPQD9/EmRjoZ
   SS8ILuBYFcy1WLYBcjqrtRA3oIZYREk2FkVXUgR18KoQDknP8Qc5TC7Hr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992959"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992959"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124811"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124811"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:36:35 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Ciunas Bennett <ciunas.bennett@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 11/11] crypto: qat - add num_rps sysfs attribute
Date:   Wed, 11 Oct 2023 14:15:09 +0200
Message-ID: <20231011121934.45255-12-damian.muszynski@intel.com>
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

Add the attribute `num_rps` to the `qat` attribute group. This returns
the number of ring pairs that a single device has. This allows to know
the maximum value that can be set to the attribute `rp2svc`.

Signed-off-by: Ciunas Bennett <ciunas.bennett@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat      | 14 ++++++++++++++
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index f24a5ddca94b..bbf329cf0d67 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -127,3 +127,17 @@ Description:
 			sym
 
 		This attribute is only available for qat_4xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat/num_rps
+Date:		January 2024
+KernelVersion:	6.7
+Contact:	qat-linux@intel.com
+Description:
+		(RO) Returns the number of ring pairs that a single device has.
+
+		Example usage::
+
+			# cat /sys/bus/pci/devices/<BDF>/qat/num_rps
+			64
+
+		This attribute is only available for qat_4xxx devices.
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 9317127128a9..ddffc98119c6 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -268,11 +268,25 @@ static ssize_t rp2srv_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(rp2srv);
 
+static ssize_t num_rps_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct adf_accel_dev *accel_dev;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	return sysfs_emit(buf, "%u\n", GET_MAX_BANKS(accel_dev));
+}
+static DEVICE_ATTR_RO(num_rps);
+
 static struct attribute *qat_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_cfg_services.attr,
 	&dev_attr_pm_idle_enabled.attr,
 	&dev_attr_rp2srv.attr,
+	&dev_attr_num_rps.attr,
 	NULL,
 };
 
-- 
2.41.0

