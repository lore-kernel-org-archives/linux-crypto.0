Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A120242D77
	for <linux-crypto@vger.kernel.org>; Thu, 22 May 2025 08:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747902113; cv=none; b=LvymX2FOemp91LWHbRiIpxbjpTrWfti96f4jUlyQB31g67Yr4+vjmd7XPOs8RMEe9vWeQmzW0n5q+qbAOcHCOHmquv7Qh9AFlegU5+t9sQNjgSt6UKAs0djS/giKFKEeRQoeaMnXCihilUK0jWYDMjI+iB1bY4FChxphyUUmL1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747902113; c=relaxed/simple;
	bh=/smFB71iK/1/DLBAzk2VYnS3SY0BqznfGZpDITP2Bmw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JbIYqej6n+pDqx+5NdJ+vDTrgpNLeDpAfhq4wbpJZekHfnsEDtFLoJQBEOgPVQDXKmutf36aK92aUpw1vzbZPDxtoQQy6YUeWIb0TH7+uDv0ZisjbiRJXa3Sbm8AvquHUAG3eAnOcwbO8RQXIlguZxIp4IUGpr0/rADKIi9hRhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAVWRL0I; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAVWRL0I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747902112; x=1779438112;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/smFB71iK/1/DLBAzk2VYnS3SY0BqznfGZpDITP2Bmw=;
  b=LAVWRL0IdpM9KPXEtv3Z06UN8dzP3jq1F+Os9qgybL6w49O43qL5I+GN
   Xf0ItMwqkqkaXacKdTNtIl5jgmxT9uOjllkXwkgpHGohJsm+LGb7I51mN
   d6XLFQVe341VhALP0lxBcsGeP6M71V7sxiHTAb1VqhuTpBQ21TzWBt04j
   Xuzdbi5Tmw8IaeWBV909rJUA8CGY6gnNZobbEyg91vTFQxLY+1N/rmDYQ
   riFspTJ2OX9/qCW9OC67dvOdDDflFRcxJYyR4MOQX1OIEtRaN206/vD+K
   5dBzyduNZxaA3bZAwZAq41O08WyD0wgV5YIur2L7XSW0GcjWXdEVly3T3
   g==;
X-CSE-ConnectionGUID: B2urLEVvTq+CB5nGsnnAvQ==
X-CSE-MsgGUID: 5+rzOlcAT/yD3l5VpyBXsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="67467707"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="67467707"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 01:21:51 -0700
X-CSE-ConnectionGUID: PrFrXjX4TSO3Rf78qEad/g==
X-CSE-MsgGUID: 4EXoGyazRqiOGX/BMK+cSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="144430719"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa003.fm.intel.com with ESMTP; 22 May 2025 01:21:50 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH] crypto: qat - use unmanaged allocation for dc_data
Date: Thu, 22 May 2025 09:21:41 +0100
Message-Id: <20250522082141.3726551-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dc_data structure holds data required for handling compression
operations, such as overflow buffers. In this context, the use of
managed memory allocation APIs (devm_kzalloc() and devm_kfree())
is not necessary, as these data structures are freed and
re-allocated when a device is restarted in adf_dev_down() and
adf_dev_up().

Additionally, managed APIs automatically handle memory cleanup when the
device is detached, which can lead to conflicts with manual cleanup
processes. Specifically, if a device driver invokes the adf_dev_down()
function as part of the cleanup registered with
devm_add_action_or_reset(), it may attempt to free memory that is also
managed by the device's resource management system, potentially leading
to a double-free.

This might result in a warning similar to the following when unloading
the device specific driver, for example qat_6xxx.ko:

    qat_free_dc_data+0x4f/0x60 [intel_qat]
    qat_compression_event_handler+0x3d/0x1d0 [intel_qat]
    adf_dev_shutdown+0x6d/0x1a0 [intel_qat]
    adf_dev_down+0x32/0x50 [intel_qat]
    devres_release_all+0xb8/0x110
    device_unbind_cleanup+0xe/0x70
    device_release_driver_internal+0x1c1/0x200
    driver_detach+0x48/0x90
    bus_remove_driver+0x74/0xf0
    pci_unregister_driver+0x2e/0xb0

Use unmanaged memory allocation APIs (kzalloc_node() and kfree()) for
the dc_data structure. This ensures that memory is explicitly allocated
and freed under the control of the driver code, preventing manual
deallocation from interfering with automatic cleanup.

Fixes: 1198ae56c9a5 ("crypto: qat - expose deflate through acomp api for QAT GEN2")
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_compression.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index c285b45b8679..0a77ca65c8d4 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -196,7 +196,7 @@ static int qat_compression_alloc_dc_data(struct adf_accel_dev *accel_dev)
 	struct adf_dc_data *dc_data = NULL;
 	u8 *obuff = NULL;
 
-	dc_data = devm_kzalloc(dev, sizeof(*dc_data), GFP_KERNEL);
+	dc_data = kzalloc_node(sizeof(*dc_data), GFP_KERNEL, dev_to_node(dev));
 	if (!dc_data)
 		goto err;
 
@@ -234,7 +234,7 @@ static void qat_free_dc_data(struct adf_accel_dev *accel_dev)
 	dma_unmap_single(dev, dc_data->ovf_buff_p, dc_data->ovf_buff_sz,
 			 DMA_FROM_DEVICE);
 	kfree_sensitive(dc_data->ovf_buff);
-	devm_kfree(dev, dc_data);
+	kfree(dc_data);
 	accel_dev->dc_data = NULL;
 }
 

base-commit: d86499800d16eb1e91191a09e58c698432ed2f48
-- 
2.40.1

