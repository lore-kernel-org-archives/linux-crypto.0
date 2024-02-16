Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A091413473B
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 15:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097892; cv=none; b=pShqEBtodaZO05bmbqPjhcZWOz5drvUeQxe7cn35bkHkMXYiVCFaJrHpcHPL/R7tVME40KsusxNkbMgDNKQhetNATtLDji4Zyz8QbyPnSw9bKj75O4WXQbR3GWXhFxCcVgozIzVyTGH41cQvMVB6Gf7kCoS7bnp09mMQ0bYI9lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097892; c=relaxed/simple;
	bh=sZ2C3mne6OTjQqtXyrDf/zHkt8Aoei4vrNF3BTSqarw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J/tBX8wieBMslM+0W9BNg07uoZYzLnrpLkUxA6ZzsYVH3Kax9rEIhbfT2CRqTJ4WrTR5SQ4uD3FFUe1W7+bqSHzaLDuyqLxyv/ZCTjLUScFYM0j9+tk8ZfBLPO8ayZgX6q4SqoIR6pclur2XJPaFvaA7kZlkwWjn9dXM170xuaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Go3nNHgv; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Go3nNHgv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708097891; x=1739633891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sZ2C3mne6OTjQqtXyrDf/zHkt8Aoei4vrNF3BTSqarw=;
  b=Go3nNHgv2dAgw+asfeZsXEmKcMJ7NT2EQuM49ccd1vkkH/rXmpsb2s5t
   JoWdjVr6+lhll3HhrTa51jg85N/Ub5tf+i8+ThZbAWGzAGZM9BBuRbL1k
   qU5TZjmNhWPkQZc9kaMugmyTfJEoX+jJBWvF15H3hZ+IYUMmjqpMqXXNY
   eb0TUHWICu/ZFj/WLvwKPn+hfhf/pEB+SgYt04jgaICwXZmHu9HJSLHxy
   M+93g/MxaktWoBPsxpCaKnrCjuJTSESngovewE4JAeOC1iEDtQN23TZ02
   nJpA+An4ONSGqCRSOpMN5EtyqV1JjbBHoQxTG2fFHtBWSvojgtHu+ZGGk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="13622734"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="13622734"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 07:38:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="935861470"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="935861470"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2024 07:38:09 -0800
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/6] crypto: qat - removed unused macro in adf_cnv_dbgfs.c
Date: Fri, 16 Feb 2024 15:19:56 +0000
Message-Id: <20240216151959.19382-3-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240216151959.19382-1-adam.guerin@intel.com>
References: <20240216151959.19382-1-adam.guerin@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

This macro was added but never used, remove it.

This is to fix the following warning when compiling the QAT driver
using the clang compiler with CC=clang W=2:
    drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c:19:9: warning: macro is not used [-Wunused-macros]
       19 | #define CNV_SLICE_ERR_MASK              GENMASK(7, 0)
          |         ^

Fixes: d807f0240c71 ("crypto: qat - add cnv_errors debugfs file")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
index 07119c487da0..627953a72d47 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c
@@ -16,7 +16,6 @@
 
 #define CNV_ERR_INFO_MASK		GENMASK(11, 0)
 #define CNV_ERR_TYPE_MASK		GENMASK(15, 12)
-#define CNV_SLICE_ERR_MASK		GENMASK(7, 0)
 #define CNV_SLICE_ERR_SIGN_BIT_INDEX	7
 #define CNV_DELTA_ERR_SIGN_BIT_INDEX	11
 
-- 
2.40.1

