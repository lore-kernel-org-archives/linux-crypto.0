Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46545465D
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 15:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097898; cv=none; b=BBUYiEpHgREqvsew5bcE9rlnx10w94McFgPvjn3t+J5DR7BqvUmwTU6csCd+x75Ytje/yianmePF15JiMV9ZKHiiL4t1CF28E5sM+iv+HehQFgvTXOtdnYYgMcOF6kPLvsgozORJ/NCbAK4OXJ5DV/aZw6uskKOEo0WGrgD7TbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097898; c=relaxed/simple;
	bh=fKN7swly9kCLnMN+x7Qml4YUZNloWLqFtukJhVFq36I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lcFeXuxb34/ouQTJsX+Nltqh7luOVl+efdHiTEs5SWdNwW8T4SrDqkPl/FCwZ36YSLxAhpS3LS8E+9Pn5LSaFuQKDgK1QUBAdmDqyVVfzaoEub1ZM5GBJOiNPWX4EmJOgodF7UT1tGh1cGBEBPxgrdfc9DewIBrXAvnBTG/Vifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VDzyFcjr; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VDzyFcjr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708097897; x=1739633897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fKN7swly9kCLnMN+x7Qml4YUZNloWLqFtukJhVFq36I=;
  b=VDzyFcjrcam8D+X2G5fUe32MNw1CNPTWeRUjqqpaxTuFL1kdkHUga4cz
   kehV5OTUyDDMosd69/o15TZbYPEsXDO5pwt1b+PeDoHCK0DmoCZkJ0h01
   FA7HDHoWxo90UtCGAwcjrSgj44qgidU2R3/20Rvh7cVNOdKRIavMyoXoj
   AMEVTJDkcAejEYS2/Np3L3RtjJwub+1VNgvBgAly9I+T2Tb8Ag6/s/Vmu
   FLs9KIlm/D0tYYxEQfbKs+Vswymu5zlNgKtOb7apShRZnfTZ6bxH5uk4t
   Spz8qmXlQFR9XNJZyUxvzdUyRngSaAx040ljv1nWl+glF1vFBlELra0U+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="13622742"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="13622742"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 07:38:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="935861475"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="935861475"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2024 07:38:15 -0800
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 3/6] crypto: qat - avoid division by zero
Date: Fri, 16 Feb 2024 15:19:57 +0000
Message-Id: <20240216151959.19382-4-adam.guerin@intel.com>
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

Check if delta_us is not zero and return -EINVAL if it is.
delta_us is unlikely to be zero as there is a sleep between the reads of
the two timestamps.

This is to fix the following warning when compiling the QAT driver
using clang scan-build:
    drivers/crypto/intel/qat/qat_common/adf_clock.c:87:9: warning: Division by zero [core.DivideZero]
       87 |         temp = DIV_ROUND_CLOSEST_ULL(temp, delta_us);
          |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: e2980ba57e79 ("crypto: qat - add measure clock frequency")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_clock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_clock.c b/drivers/crypto/intel/qat/qat_common/adf_clock.c
index 01e0a389e462..cf89f57de2a7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_clock.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_clock.c
@@ -83,6 +83,9 @@ static int measure_clock(struct adf_accel_dev *accel_dev, u32 *frequency)
 	}
 
 	delta_us = timespec_to_us(&ts3) - timespec_to_us(&ts1);
+	if (!delta_us)
+		return -EINVAL;
+
 	temp = (timestamp2 - timestamp1) * ME_CLK_DIVIDER * 10;
 	temp = DIV_ROUND_CLOSEST_ULL(temp, delta_us);
 	/*
-- 
2.40.1

