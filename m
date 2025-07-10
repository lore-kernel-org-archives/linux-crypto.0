Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFAA2594B4
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 13:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154436; cv=none; b=k9m73Xz5m07HTkbFneuIER/1Tp0HUcHfz6KdMxP9yGv7L65+PqAzY2JOZNf9UeYy9FnGjI0e61Rjrdf0/CU4gXxI6IrDo/fgfPSYZhQCp81Ta4LCbeXdWUnGwG55M8cfhyTpY9wFIVIZ5cGOMW/zfnDxtg2sxbhmkiAz9+Oz6FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154436; c=relaxed/simple;
	bh=L1KaUrr0pdhsBJSpXTQSdegW2GfCwkBb6oLF7mmqbHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qMEC8iVUfd8cWnFLyvpFF6UU+EsWALXD9vNnDSO9r3NnCIE9k7Nd0DLnvlPxXllB35QallwNJFHadOn6FMujiVs1nrgRImaEo5jR51TOR0bMpRDszzJeo1U+YFiKBXSqS4xykirPh4Ejy3err17uRbbg73nrVW1DEM1SC7GmjdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G2KRWYLw; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G2KRWYLw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752154434; x=1783690434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L1KaUrr0pdhsBJSpXTQSdegW2GfCwkBb6oLF7mmqbHg=;
  b=G2KRWYLwy5NrqH+VqfAATdndYW6IkkWjUxN4fl09HkhoibjfOwG0BDZi
   +7f6kIonLDE1GkDNIprbLW8Kg1Oo/Gk1n9/eyZ26nHKbXgEhkBlaQnLP2
   GKd4Ld/PFroW4TP3cLXIVTam9g7pL9e0tXn+GHUhdY+8/J6X4Lia59Lmc
   Ump6qjlgdoVvIbWbQN813fX0kcxQBGctiO9lrWTVFlf+TGR4ZuQZq2PKG
   e5Iw04qhVdyRdwvbworN2CKRs3giHrO34b2ci0uhPamqNEttOcbewKy4+
   dDhxKnRZDep5ihzAVdk5FmVNQCARUdZH3GBPkRjGXrferQkSilEIakUh2
   Q==;
X-CSE-ConnectionGUID: rxP9OsD4RqSqgdRi0cjLJQ==
X-CSE-MsgGUID: 3EK/FU3xRNqqbtiJ/dcj3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="58241831"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="58241831"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 06:33:53 -0700
X-CSE-ConnectionGUID: kB9Pb5ysSDihV6cjEYB72A==
X-CSE-MsgGUID: zo8aNVyeTMu3LbgWBg73vA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155494642"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa006.jf.intel.com with ESMTP; 10 Jul 2025 06:33:52 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 1/8] crypto: qat - validate service in rate limiting sysfs api
Date: Thu, 10 Jul 2025 14:33:40 +0100
Message-Id: <20250710133347.566310-2-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
References: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sysfs interface 'qat_rl/srv' currently allows all valid services,
even if a service is not configured for the device. This leads to a failure
when attempting to add the SLA using 'qat_rl/sla_op'.

Add a check using is_service_enabled() to ensure the requested service is
enabled. If not, return -EINVAL to prevent invalid configurations.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c       | 3 +--
 drivers/crypto/intel/qat/qat_common/adf_rl.h       | 1 +
 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c | 8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index e782c23fc1bf..d320bfcb9919 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -209,8 +209,7 @@ u32 adf_rl_get_sla_arr_of_type(struct adf_rl *rl_data, enum rl_node_type type,
 	}
 }
 
-static bool is_service_enabled(struct adf_accel_dev *accel_dev,
-			       enum adf_base_services rl_srv)
+bool is_service_enabled(struct adf_accel_dev *accel_dev, enum adf_base_services rl_srv)
 {
 	enum adf_cfg_service_type arb_srv = srv_to_cfg_svc_type(rl_srv);
 	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.h b/drivers/crypto/intel/qat/qat_common/adf_rl.h
index bfe750ea0e83..9b4678cee1fd 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.h
@@ -175,5 +175,6 @@ u32 adf_rl_calculate_ae_cycles(struct adf_accel_dev *accel_dev, u32 sla_val,
 			       enum adf_base_services svc_type);
 u32 adf_rl_calculate_slice_tokens(struct adf_accel_dev *accel_dev, u32 sla_val,
 				  enum adf_base_services svc_type);
+bool is_service_enabled(struct adf_accel_dev *accel_dev, enum adf_base_services rl_srv);
 
 #endif /* ADF_RL_H_ */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
index bedb514d4e30..a8c3be24b3b4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
@@ -291,14 +291,22 @@ static ssize_t srv_show(struct device *dev, struct device_attribute *attr,
 static ssize_t srv_store(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
+	struct adf_accel_dev *accel_dev;
 	unsigned int val;
 	int ret;
 
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
 	ret = sysfs_match_string(rl_services, buf);
 	if (ret < 0)
 		return ret;
 
 	val = ret;
+	if (!is_service_enabled(accel_dev, val))
+		return -EINVAL;
+
 	ret = set_param_u(dev, SRV, val);
 	if (ret)
 		return ret;
-- 
2.40.1

