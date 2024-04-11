Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ABEDDD2
	for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2024 15:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712849455; cv=none; b=j8zA01b6N7LrT6iUMMFfMTEFN8CxLV9pyuZA979aIfpf2F6nIsL5tkwumExB0bmhPGz9UqwP2xvWXIvNlhKyoYm2c9UzWHB2+FyfVxi2Qq0ON2kjcy6KJNFYKvZegIFA+MJrJXWSSNksnlcodf2a1mqlJzSTSMKKHxPlON/Q4J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712849455; c=relaxed/simple;
	bh=bnqZLK1O/GH9Cl1N3XLcUoE2Qzj5ttpdC3dH5/Q4WFE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RWUhJ7HG12YbQ9eGjdl913xXwdliyPLT8IEfUM3NkCqrTvJg6WldTW9HwmXTOQPrAd/IZFxp95vooOA4BmHwScrqpiWKsWRCvIuVOwQJkstwksOj04cWA5d99F6MUDRYF27LBlkl0x5iNq3UuuIlam3rLEYO9WCHR9MpmpAIHgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DUzYfnnH; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DUzYfnnH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712849453; x=1744385453;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bnqZLK1O/GH9Cl1N3XLcUoE2Qzj5ttpdC3dH5/Q4WFE=;
  b=DUzYfnnHTFcEdShkhpICOggpwaS1a5tYtKeTGQp225qQ8ykdBvqfMwh+
   ohJFoUYSkric+n7LTlMU3V/tuSVV5awXvHcH0IXHFQKXIb8eTd8Lx9EG9
   LL0rt1kP1Em3bcUH3pVFm9yLqE2Y5QVSz4Wf9UFTR4MezS4CvW4y77wNo
   QCf1lI8MZiIobjOUgUFkpw3JGSFWhD7UwXFVAThRoI5gUkLFqM2xAXnkC
   C1hbXqhCXqK4zGto8lrLDtdKZCaQWbt3oIYhaGtLJlk3M5C2dWQQG0eYh
   sDdy4D+9wl0lvdVSYspDj4gQUeDkgr+Gf/Yl3D5c1EZSXtbSRRt1BAvUR
   g==;
X-CSE-ConnectionGUID: /tTmfbNqTM6Dm6Pm8vT7AA==
X-CSE-MsgGUID: DlC/xAw+Tqmvfh9alojvEg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8142521"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="8142521"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 08:30:53 -0700
X-CSE-ConnectionGUID: /lshN0PtSDKihqk3ZdMwwg==
X-CSE-MsgGUID: C+2dd2eVTlSUbW5cMsSU+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25584750"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by orviesa003.jf.intel.com with ESMTP; 11 Apr 2024 08:30:52 -0700
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/2] crypto: qat - improve error message in adf_get_arbiter_mapping()
Date: Thu, 11 Apr 2024 16:08:19 +0100
Message-Id: <20240411150819.240050-1-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

Improve error message to be more readable.

Fixes: 5da6a2d ("crypto: qat - generate dynamically arbiter mappings")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 2 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index d255cb3ebd9c..78f0ea49254d 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -298,7 +298,7 @@ static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
 	if (adf_gen4_init_thd2arb_map(accel_dev))
 		dev_warn(&GET_DEV(accel_dev),
-			 "Generate of the thread to arbiter map failed");
+			 "Failed to generate thread to arbiter mapping");
 
 	return GET_HW_DATA(accel_dev)->thd_to_arb_map;
 }
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 1e77e189a938..9fd7ec53b9f3 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -210,7 +210,7 @@ static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
 	if (adf_gen4_init_thd2arb_map(accel_dev))
 		dev_warn(&GET_DEV(accel_dev),
-			 "Generate of the thread to arbiter map failed");
+			 "Failed to generate thread to arbiter mapping");
 
 	return GET_HW_DATA(accel_dev)->thd_to_arb_map;
 }

base-commit: 0419fa6732b2b98ea185ac05f2a3c430b7de2abb
-- 
2.40.1

