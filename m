Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963B34597F
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 12:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926016; cv=none; b=RwLVGYVlY8fH/5EMYQs4b1M6YMGcjf6+OziwSV9XRLRTRTvYAPIoD37N3zlAI+UMAVpSRrHT5YJiOTJ7Ro7eCzY50uTac/v/WbrxVfqPZYPmhRWekwP3YU7Xre93F+h9vzydJ1dAfs7CocnHfQQTLcMvG9J1zg4I3h3L+uArfUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926016; c=relaxed/simple;
	bh=TMAnNpExncMeId6E+UrkKF2zB0Zrmi4Jxs43vp03oLE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ow5pGvuHBi0BdRmoZxskkaWbpSl/XTsYnpv862kU/yozNhtTG9VO39HOJIM5mVYUh35CCKemDVnQTz4qCbwYp7lqXH0UEUq7L6TThxsWhXcXZzLwz5bMnLKmcDaeNrYG5BhKMDFUGnWNC34qCagTeBvR+qC74ZS9IU6UNlb4+I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZuK4tTF; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZuK4tTF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712926015; x=1744462015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TMAnNpExncMeId6E+UrkKF2zB0Zrmi4Jxs43vp03oLE=;
  b=IZuK4tTFFxXKYEYqa16bakyoF5k15icZfLwLyXcevtkqPQRtxKFlrbfi
   vmn0BO76rRVfb2rvFWDPw3xFk96RnG9uD5GtsCQGMTCrHg35oxjQec0a6
   CIHEHuxDhLNRIl2L7MyzWOxuuW8N3EqSgu81GjsAHuwI2vD1rJRhMc3T+
   rUPz9X9PNBTMa9q+xamzpoab+hvKGme0LPs+3bW5oqyhuP7V5zyaciD/O
   Q0Y7cT+9O24n9DZDqyX/BTh5WjiTwuzHH+SKZFs2FDvziAPX1D4LVj9rO
   pGPmhOnr/lDxGDO9xCtPuFJyGLJ7QeCjD1iKkk4rwYvfE/5wn+skKsTOO
   w==;
X-CSE-ConnectionGUID: I2Cx88WrSpazRt9Kr+8tZw==
X-CSE-MsgGUID: 0kIBxrHHS2iAI4jtOa9rrg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19529112"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="19529112"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 05:46:54 -0700
X-CSE-ConnectionGUID: o5CU7HX7QUCd1J3liAIPsQ==
X-CSE-MsgGUID: jZ3bwjkcRTmyVTTMOXFgwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="25902122"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by orviesa003.jf.intel.com with ESMTP; 12 Apr 2024 05:46:53 -0700
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 2/2] crypto: qat - improve error logging to be consistent across features
Date: Fri, 12 Apr 2024 13:24:03 +0100
Message-Id: <20240412122401.243378-3-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240412122401.243378-1-adam.guerin@intel.com>
References: <20240412122401.243378-1-adam.guerin@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

Improve error logging in rate limiting feature. Staying consistent with
the error logging found in the telemetry feature.

Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 65f752f4792a..346ef8bee99d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -1125,7 +1125,7 @@ int adf_rl_start(struct adf_accel_dev *accel_dev)
 	}
 
 	if ((fw_caps & RL_CAPABILITY_MASK) != RL_CAPABILITY_VALUE) {
-		dev_info(&GET_DEV(accel_dev), "not supported\n");
+		dev_info(&GET_DEV(accel_dev), "feature not supported by FW\n");
 		ret = -EOPNOTSUPP;
 		goto ret_free;
 	}
-- 
2.40.1

