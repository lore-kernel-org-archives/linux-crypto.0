Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZGpYHbMm"
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B842412C
	for <linux-crypto@vger.kernel.org>; Tue, 21 Nov 2023 09:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700586984; x=1732122984;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=378f8ZfeWKP+BLdvDXl3gC8NgLBp3YBizx6o3f+VOg4=;
  b=ZGpYHbMmynsF8UuAYvO/5k9gKGdTUBNfSbwJ7AysPb60gjau8R0O0AcF
   t/cBYSNZheLtITjceS1fZs7O1efINEzn1eztAQM5iu3rGYyj0eCVsKABD
   8aWZ8URhjCy8uIe5IFsuW9kAKCYfNSA3pgzWqkSRJplQzeS2hJ2i4QwUJ
   9PdKDZfp5WCmikIqKvXYTK+Hk2xVEnKXrRbJlHVwbQorATZg5ILF3eVVp
   Q9ZZupfKz4uRtln1bHk9VrwPgf/ozI/k7zE9B5p2Lrc0HwW/83e3UjuOv
   rQzrPpWxaALi0Y3ntDlfDXcdIMRQqkP6LoxfDGS4mtkuAAUbsTWOaBeLJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="5081530"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="5081530"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 09:16:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="940159258"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="940159258"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by orsmga005.jf.intel.com with ESMTP; 21 Nov 2023 09:16:22 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - add sysfs_added flag for ras
Date: Tue, 21 Nov 2023 17:59:45 +0100
Message-ID: <20231121170046.8097-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

The qat_ras sysfs attribute group is registered within the
adf_dev_start() function, alongside other driver components.
If any of the functions preceding the group registration fails,
the adf_dev_start() function returns, and the caller, to undo the
operation, invokes adf_dev_stop() followed by adf_dev_shutdown().
However, the current flow lacks information about whether the
registration of the qat_ras attribute group was successful or not.

In cases where this condition is encountered, an error similar to
the following might be reported:

    4xxx 0000:6b:00.0: Starting device qat_dev0
    4xxx 0000:6b:00.0: qat_dev0 started 9 acceleration engines
    4xxx 0000:6b:00.0: Failed to send init message
    4xxx 0000:6b:00.0: Failed to start device qat_dev0
    sysfs group 'qat_ras' not found for kobject '0000:6b:00.0'
    ...
    sysfs_remove_groups+0x29/0x50
    adf_sysfs_stop_ras+0x4b/0x80 [intel_qat]
    adf_dev_stop+0x43/0x1d0 [intel_qat]
    adf_dev_down+0x4b/0x150 [intel_qat]
    ...
    4xxx 0000:6b:00.0: qat_dev0 stopped 9 acceleration engines
    4xxx 0000:6b:00.0: Resetting device qat_dev0

To prevent attempting to remove attributes from a group that has not
been added yet, a flag named 'sysfs_added' is introduced. This flag
is set to true upon the successful registration of the attribute group.

Fixes: 532d7f6bc458 ("crypto: qat - add error counters")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_accel_devices.h    | 1 +
 .../crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c   | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 4ff5729a3496..9d5fdd529a2e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -92,6 +92,7 @@ enum ras_errors {
 
 struct adf_error_counters {
 	atomic_t counter[ADF_RAS_ERRORS];
+	bool sysfs_added;
 	bool enabled;
 };
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
index cffe2d722995..e97c67c87b3c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
@@ -99,6 +99,8 @@ void adf_sysfs_start_ras(struct adf_accel_dev *accel_dev)
 	if (device_add_group(&GET_DEV(accel_dev), &qat_ras_group))
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to create qat_ras attribute group.\n");
+
+	accel_dev->ras_errors.sysfs_added = true;
 }
 
 void adf_sysfs_stop_ras(struct adf_accel_dev *accel_dev)
@@ -106,7 +108,10 @@ void adf_sysfs_stop_ras(struct adf_accel_dev *accel_dev)
 	if (!accel_dev->ras_errors.enabled)
 		return;
 
-	device_remove_group(&GET_DEV(accel_dev), &qat_ras_group);
+	if (accel_dev->ras_errors.sysfs_added) {
+		device_remove_group(&GET_DEV(accel_dev), &qat_ras_group);
+		accel_dev->ras_errors.sysfs_added = false;
+	}
 
 	ADF_RAS_ERR_CTR_CLEAR(accel_dev->ras_errors);
 }

base-commit: f36285cc1e99472bb4c6741981594a5934ad4c4e
prerequisite-patch-id: 1375fd7754ab07f7e90594b4f4893487400a7052
-- 
2.41.0

