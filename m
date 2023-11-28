Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hm1ZsD3E"
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D8A170B
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 11:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701199056; x=1732735056;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JaaRU6eJOUifiBK2iS8tZDc7FvXFNJCBvXxcDQYoXUs=;
  b=hm1ZsD3E8/zT2JrdYsyGoQirSvo3YLY/KuGclWjqWsU4BSF7CnBtp5PW
   7X7/qBxWtawqG+LTGg703VNN4Uoj/sX+f5+nin47M7moyhP/+NHvHGoKy
   wUML81Wt1pcjFU/p3SxCmso7zA9Lr4N9CXsHYvX7NCBSejlWgjMUPeJkR
   K9FEaqXulxPESRTiJ8POEJQzEPy8MVpTFGnVLwzPBgVdB7pNqFiZYlLf0
   6uwQpZOJIH50QlBhbWh/2/UL7Mzh988u/5PnXnMRy5Adt7Lo4sh1xH4Qk
   ijOT5ppVl1ysMAbN0DQAd1v7HS2UCUd+sdc9O2WkndsM6yxpNDaVXP8cq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="459508565"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="459508565"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 11:17:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="797681461"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="797681461"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by orsmga008.jf.intel.com with ESMTP; 28 Nov 2023 11:17:34 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	David Guckian <david.guckian@intel.com>
Subject: [PATCH] crypto: qat - add NULL pointer check
Date: Tue, 28 Nov 2023 19:17:25 +0000
Message-ID: <20231128191731.10575-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

There is a possibility that the function adf_devmgr_pci_to_accel_dev()
might return a NULL pointer.
Add a NULL pointer check in the function rp2srv_show().

Fixes: dbc8876dd873 ("crypto: qat - add rp2svc sysfs attribute")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: David Guckian <david.guckian@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 6f0b3629da13..d450dad32c9e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -215,6 +215,9 @@ static ssize_t rp2srv_show(struct device *dev, struct device_attribute *attr,
 	enum adf_cfg_service_type svc;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
 	hw_data = GET_HW_DATA(accel_dev);
 
 	if (accel_dev->sysfs.ring_num == UNSET_RING_NUM)
-- 
2.42.0

