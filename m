Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5243AB5B2
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 06:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158114; cv=none; b=WClCXuVhh8niIOgefkNR+8tj+2xtH26RQyvklwbKnhh7I49vrDLwg8IULReEezLR49md/R0wh0zg5R2VO85dK/waAdvNrkLcdGegCuybGJXO6wzBfgwRVZSdF7hUj7Dj1z+694yMQJZzhRdT5Y1Lri9TWRJOYafZIn9nim7HfRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158114; c=relaxed/simple;
	bh=Oj6uQv0RhwW5i8cmQPyzpndezdfG6D32e+A8v7NNpHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bg4tbbZM14QjjS9s8V28NKqE1RZiM6xzbaBPDTnb3AqaR9bqbq2z08cKVojH5OACBGgO/nNLVkhVc9o+XWIGC0w8Ko5b0qv/COECEJ7/RmOuarblf0f3jkNhoi5dlMr8uHlX7AMWALqqcEFh9+P7/2rOOCw7p06lud+W6d+8aPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G7IsmudQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G7IsmudQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788158113; x=1819694113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oj6uQv0RhwW5i8cmQPyzpndezdfG6D32e+A8v7NNpHw=;
  b=G7IsmudQtL/ij+AGNPf29gJtlhoxguTuPH44N8rI7DXCTWqQZLMLYGoS
   djPmi75Zfspr2YExKrGv9dnPn6yE9PXzIhr8RaTDmBAVHjmagAKMzoq2u
   zOzJO9PphzGsywCLgI3PsgpH6gIZd3jVT+Qh3bO5nOr0owI345MBY3xwv
   oIm574oC2lMUzi/ECsqrGiw9r2j+H00/mXrAmFKGn0skVS6SkeYn4r9vi
   UI3JX5pbmiZeLLQDu3qhweJCLooQGBpBZyvUgzl8f6G1QWprI+nbtcmgB
   +pmOUklJ8uPA6LVlELtkkgeo0uQ2sWaQq5aInaYkHGOHtFlwiu+5weSLq
   g==;
X-CSE-ConnectionGUID: Yqim6b/bQGqgfDF3M7l6kA==
X-CSE-MsgGUID: fxSctUUiT8u5xu/RltEkOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="105930210"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="105930210"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 23:35:13 -0700
X-CSE-ConnectionGUID: ZwEWHDRWRtOSPn0UOQCQAA==
X-CSE-MsgGUID: S7Awd0H6TziQ3G35B6UMqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="267377678"
Received: from dmr-bkc.iind.intel.com ([10.49.111.53])
  by orviesa010.jf.intel.com with ESMTP; 30 Aug 2026 23:35:12 -0700
From: nitesh.venkatesh@intel.com
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Nitesh Venkatesh <nitesh.venkatesh@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 1/2] crypto: qat - allow KPT disable when service is not asym
Date: Mon, 31 Aug 2026 06:32:33 +0000
Message-ID: <20260831063355.668528-2-nitesh.venkatesh@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260831063355.668528-1-nitesh.venkatesh@intel.com>
References: <20260831063355.668528-1-nitesh.venkatesh@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nitesh Venkatesh <nitesh.venkatesh@intel.com>

The KPT (Key Protection Technology) enable sysfs attribute rejects any
write when the currently enabled service is not 'asym', including writes
that disable KPT. This blocks a legitimate recovery flow:

  1. Configure the 'asym' service and enable KPT.
  2. Bring the device up, then down.
  3. Reconfigure the service to 'sym' and bring the device up.
  4. KPT is still reported as enabled, but is not active because the
     asymmetric service is no longer configured.
  5. Bring the device back down so the KPT enable attribute becomes
     writable.
  6. Writing '0' to the KPT enable attribute to clear the stale flag
     fails with:
       "KPT can only be enabled when the asymmetric service is enabled"

The asym-service check is only meaningful when enabling KPT; disabling
must always be permitted so a stale enable flag can be cleared after
the service configuration has changed.

Parse the user-supplied boolean before the service check and gate the
check on the enable direction. Disable requests are now accepted
regardless of the currently configured service, provided the device is
in the down state (which the attribute already requires for any write).

Fixes: fb98254a5eb9 ("crypto: qat - add KPT support for GEN6 devices")
Signed-off-by: Nitesh Venkatesh <nitesh.venkatesh@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 .../intel/qat/qat_common/adf_sysfs_kpt.c      | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
index 1f733ae80bdf..a0db98f33f1f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_kpt.c
@@ -31,6 +31,7 @@ static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 	struct adf_hw_device_data *hw_data;
 	struct adf_accel_dev *accel_dev;
 	bool enable;
+	int svc;
 	int ret;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
@@ -38,14 +39,25 @@ static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	if (adf_dev_started(accel_dev)) {
-		dev_info(dev, "Device qat_dev%d must be down before enabling KPT\n",
+		dev_info(dev, "Device qat_dev%d must be down before changing KPT state\n",
 			 accel_dev->accel_id);
 		return -EINVAL;
 	}
 
-	if (adf_get_service_enabled(accel_dev) != SVC_ASYM) {
-		dev_info(dev, "KPT can only be enabled when the asymmetric service is enabled\n");
-		return -EINVAL;
+	ret = kstrtobool(buf, &enable);
+	if (ret)
+		return ret;
+
+	if (enable) {
+		svc = adf_get_service_enabled(accel_dev);
+		if (svc < 0)
+			return svc;
+
+		if (svc != SVC_ASYM) {
+			dev_info(dev,
+				 "KPT can only be enabled when the asymmetric crypto service is enabled\n");
+			return -EINVAL;
+		}
 	}
 
 	hw_data = GET_HW_DATA(accel_dev);
@@ -59,10 +71,6 @@ static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 	if (!hw_data->accel_capabilities_mask)
 		return -EINVAL;
 
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
-
 	user_data = GET_KPT_USER_DATA(accel_dev);
 	user_data->enable = enable;
 
-- 
2.52.0

