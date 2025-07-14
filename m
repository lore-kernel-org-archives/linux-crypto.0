Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A917E0E8
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 07:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752476895; cv=none; b=Aqyy6gqw5BJqrOgFSIPhOI18prCLlya+mt26D7lhYBXC1O/RuV1tZdvTUFf/GHbINmroYDIBHA3MuyrWEpzirjHhelBLis6JTqQBEpPt2mKYc/QcQH/xg93002PDaeVULLJYL9URuCHhpVx8Ns7uFBd4NEkRyw8qKZNX8BmMJQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752476895; c=relaxed/simple;
	bh=Sr5AC9VW2+26t+m5xdfYLvL0Za33jfuAqIaLSVR5Gfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qIt31g2BsUjBZD6D+g4MHuQQF0KXqe1L9zGBC/9MRFXWRwbscyVR/fnzwUFJ6UJCwosj2Rpmrgeh0r4YfGJ+1UF4OKCHHLIamzQ6R5PTD6R0M2BcMEWJ9y36O0/mjteEhubRGx3A7qwnQURgzRlG/ObQu5pPhgfaN99Esia4x4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AMWd0Hhe; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AMWd0Hhe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752476893; x=1784012893;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Sr5AC9VW2+26t+m5xdfYLvL0Za33jfuAqIaLSVR5Gfo=;
  b=AMWd0Hhep4vVsp0nUHsNb2y0zZA1yvontglc31i3uEGbGF+MKwFsMR1K
   CN60/PrUmtnMpiW1uAstx1oiFvsugTCMqMyh/p4B+oxMR9wDKRlVEabC/
   AztAm8Hhxse+/rEEoSQ4hJKz5zfp/Uj9OYF+GpBrNjtR7TotVn4VBMRRj
   KoCn70l+/wVjQpa9DnKDl37OFGNOSEA9dd2TZCtgfHnB2t1qeIS2U+CNZ
   YEBnh1eOFAI//+Ip49Qik6aAgsrPUoXTzJ632qUn7xdMjBdfAs0lTQEHS
   6qNHyqSrQ+mXN8RZGOLX3458M+CM1FWSlr/+SgBA7UnY66kbCmvfygLTX
   w==;
X-CSE-ConnectionGUID: WLvXp2xbSRii1xShAcUhrg==
X-CSE-MsgGUID: HYxcyCVuT2OIL0SxkLvl1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72108168"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="72108168"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 00:08:12 -0700
X-CSE-ConnectionGUID: 2xi61JsvQDW+jhdO6u3EAA==
X-CSE-MsgGUID: PrSusZ81TTia0HaE3Zbhjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="157414936"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa008.fm.intel.com with ESMTP; 14 Jul 2025 00:08:11 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - fix DMA direction for compression on GEN2 devices
Date: Mon, 14 Jul 2025 08:07:49 +0100
Message-ID: <20250714070806.5694-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

QAT devices perform an additional integrity check during compression by
decompressing the output. Starting from QAT GEN4, this verification is
done in-line by the hardware. However, on GEN2 devices, the hardware
reads back the compressed output from the destination buffer and performs
a decompression operation using it as the source.

In the current QAT driver, destination buffers are always marked as
write-only. This is incorrect for QAT GEN2 compression, where the buffer
is also read during verification. Since commit 6f5dc7658094
("iommu/vt-d: Restore WO permissions on second-level paging entries"),
merged in v6.16-rc1, write-only permissions are strictly enforced, leading
to DMAR errors when using QAT GEN2 devices for compression, if VT-d is
enabled.

Mark the destination buffers as DMA_BIDIRECTIONAL. This ensures
compatibility with GEN2 devices, even though it is not required for
QAT GEN4 and later.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Fixes: cf5bb835b7c8 ("crypto: qat - fix DMA transfer direction")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_bl.c          | 6 +++---
 drivers/crypto/intel/qat/qat_common/qat_compression.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_bl.c b/drivers/crypto/intel/qat/qat_common/qat_bl.c
index 5e4dad4693ca..9b2338f58d97 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_bl.c
@@ -38,7 +38,7 @@ void qat_bl_free_bufl(struct adf_accel_dev *accel_dev,
 		for (i = 0; i < blout->num_mapped_bufs; i++) {
 			dma_unmap_single(dev, blout->buffers[i].addr,
 					 blout->buffers[i].len,
-					 DMA_FROM_DEVICE);
+					 DMA_BIDIRECTIONAL);
 		}
 		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
 
@@ -162,7 +162,7 @@ static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 			}
 			buffers[y].addr = dma_map_single(dev, sg_virt(sg) + left,
 							 sg->length - left,
-							 DMA_FROM_DEVICE);
+							 DMA_BIDIRECTIONAL);
 			if (unlikely(dma_mapping_error(dev, buffers[y].addr)))
 				goto err_out;
 			buffers[y].len = sg->length;
@@ -204,7 +204,7 @@ static int __qat_bl_sgl_to_bufl(struct adf_accel_dev *accel_dev,
 		if (!dma_mapping_error(dev, buflout->buffers[i].addr))
 			dma_unmap_single(dev, buflout->buffers[i].addr,
 					 buflout->buffers[i].len,
-					 DMA_FROM_DEVICE);
+					 DMA_BIDIRECTIONAL);
 	}
 
 	if (!buf->sgl_dst_valid)
diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index 0a77ca65c8d4..53a4db5507ec 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -204,7 +204,7 @@ static int qat_compression_alloc_dc_data(struct adf_accel_dev *accel_dev)
 	if (!obuff)
 		goto err;
 
-	obuff_p = dma_map_single(dev, obuff, ovf_buff_sz, DMA_FROM_DEVICE);
+	obuff_p = dma_map_single(dev, obuff, ovf_buff_sz, DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(dev, obuff_p)))
 		goto err;
 
@@ -232,7 +232,7 @@ static void qat_free_dc_data(struct adf_accel_dev *accel_dev)
 		return;
 
 	dma_unmap_single(dev, dc_data->ovf_buff_p, dc_data->ovf_buff_sz,
-			 DMA_FROM_DEVICE);
+			 DMA_BIDIRECTIONAL);
 	kfree_sensitive(dc_data->ovf_buff);
 	kfree(dc_data);
 	accel_dev->dc_data = NULL;

base-commit: 60a2ff0c7e1bc0615558a4f4c65f031bcd00200d
-- 
2.50.0

