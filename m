Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE00D19468
	for <linux-crypto@vger.kernel.org>; Fri, 15 Dec 2023 10:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Chew167s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702634605; x=1734170605;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A1TmGNEIvJUpCjXqubDcrX73rBXoBUOEWsQz3GxhiNs=;
  b=Chew167sDV+LZyGQhubV5Bpxfmvu9X6GgHjcHa5gUhVc2LaLjlvMjAvj
   8fXGVv6FFCWWhP55LYGhBUeZ5RtOTgMpPu71aL1cMH58pUI7RNOg6eFnw
   PY3UBG60gkUH5g5NVf43LBvB8Awuz8rITvR2sLIREibshB0ythuC4ePf7
   +z2vgdjNaZGG/r266MVZPpGdZxasS7mcvN6+cOPr38FlktNnhh+rky29p
   xhBkFaYUKksfKf6d6MnE9tYlqLUWIy5/5YsJMNTq3AGnH/qFMBJ8TPARV
   43PitLSOtO90T2GASi4J5kIR/usaZn80Oh/srIEA1tKhl4dLdLNuklCXQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="374759856"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="374759856"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2023 02:03:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="845074092"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="845074092"
Received: from qat-wangjie-342.sh.intel.com ([10.67.115.171])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2023 02:03:24 -0800
From: Jie Wang <jie.wang@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 2/5] crypto: qat - change signature of uof_get_num_objs()
Date: Fri, 15 Dec 2023 05:01:45 -0500
Message-Id: <20231215100147.1703641-3-jie.wang@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20231215100147.1703641-1-jie.wang@intel.com>
References: <20231215100147.1703641-1-jie.wang@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Asia-Pacific Research & Development Ltd. - No. 880, Zi Xing, Road, Shanghai Zizhu Science Park, Shanghai, 200241, PRC
Content-Transfer-Encoding: 8bit

Add accel_dev as parameter of the function uof_get_num_objs().
This is in preparation for the introduction of the QAT 420xx driver as
it will allow to reconfigure the ae_mask when a configuration that does
not require all AEs is loaded on the device.

This does not introduce any functional change.

Signed-off-by: Jie Wang <jie.wang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c    | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_accel_devices.h | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_accel_engine.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 9763402cd486..f7e8fdc82d38 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -390,7 +390,7 @@ static int adf_init_device(struct adf_accel_dev *accel_dev)
 	return ret;
 }
 
-static u32 uof_get_num_objs(void)
+static u32 uof_get_num_objs(struct adf_accel_dev *accel_dev)
 {
 	return ARRAY_SIZE(adf_fw_cy_config);
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 9d5fdd529a2e..33de8855fd66 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -241,7 +241,7 @@ struct adf_hw_device_data {
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
 	const char *(*uof_get_name)(struct adf_accel_dev *accel_dev, u32 obj_num);
-	u32 (*uof_get_num_objs)(void);
+	u32 (*uof_get_num_objs)(struct adf_accel_dev *accel_dev);
 	u32 (*uof_get_ae_mask)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	int (*dev_config)(struct adf_accel_dev *accel_dev);
 	struct adf_pfvf_ops pfvf_ops;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
index 6be064dc64c8..4b5d0350fc2e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
@@ -19,7 +19,7 @@ static int adf_ae_fw_load_images(struct adf_accel_dev *accel_dev, void *fw_addr,
 	int i;
 
 	loader = loader_data->fw_loader;
-	num_objs = hw_device->uof_get_num_objs();
+	num_objs = hw_device->uof_get_num_objs(accel_dev);
 
 	for (i = 0; i < num_objs; i++) {
 		obj_name = hw_device->uof_get_name(accel_dev, i);
-- 
2.32.0

