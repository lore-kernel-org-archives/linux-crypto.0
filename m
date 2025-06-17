Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2AC28C5D9
	for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 11:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750159645; cv=none; b=ZFMhLgZJmzDMWTf5cGg2vt7YVFpWvSCsk8F1oJ3JOIuCQkQOm5Q9TQsw9xmxsbY9z9uurTzdxmFSr23N2enqrMNgwzDlJrHdo5KFlOxhFSSTLGjM9gFZLsP3AL7cKSIWeysHbFlZ2xuJ9PQRsk0hbKQlPji11N9Kwd8maaFjwNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750159645; c=relaxed/simple;
	bh=Ob/h0EN6NheUWwQJYZB0ULIT5kjBJeHJ8hBc/zHnj0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o4it+146gppK8C1XwAjO+9Z9BCP9F3jQe94dcKbh3/9iZqof6Dz78ZEaFwc17+OpfrhKlWkgV3Msqj/3YZ4mah7PWTAuUjCvll4UiWeksTY7fAwsgNT+IfCU0pt4XFqqjnGOzTUmbFWGbzYNnkg3tPEl+DeH2BzrPO1Hh80VYPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZrX/KWDp; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZrX/KWDp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750159644; x=1781695644;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ob/h0EN6NheUWwQJYZB0ULIT5kjBJeHJ8hBc/zHnj0Y=;
  b=ZrX/KWDpXRp3Uz91NCq/6kJXzAU+T6qhVS9adx1ZE71FO8JvQ+tVLtyb
   0LD/xzivGCDyTW2d+PnbmdZX7zuS6exsNTwY25PHo0wbg/is01N+ap65j
   wDkJa0hQFG08QLayAbj/vTciPmcWmAoNgQFXj168RrIGFaaWgQGsN6ldg
   t11iUw7pVp4u2UxNFG0tnxPhRKqlEDREUY+PfPLsvEfJfgfU8UwLeN19y
   IOvBjkXmmxOtuV3fG2G7nNIhINo2zvzARDMPwDt8BcP3eECe7V44rr+x/
   05xZJajeQWd0UFIpzgf6dfTiPPTWFqwm0cfA0CioKYKfdF1mJN2f1dCPf
   g==;
X-CSE-ConnectionGUID: rQn8tyoRTe+6g3icM1p6Dg==
X-CSE-MsgGUID: 8+eg77GrTv6oVKUz++bWBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="56009793"
X-IronPort-AV: E=Sophos;i="6.16,243,1744095600"; 
   d="scan'208";a="56009793"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 04:27:23 -0700
X-CSE-ConnectionGUID: wdWjHeiASKOP5mbOxr/Wrw==
X-CSE-MsgGUID: coFEAypORUWGw0Okibguqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,243,1744095600"; 
   d="scan'208";a="154044331"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa005.jf.intel.com with ESMTP; 17 Jun 2025 04:27:21 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH] crypto: qat - restore ASYM service support for GEN6 devices
Date: Tue, 17 Jun 2025 12:27:12 +0100
Message-Id: <20250617112712.982605-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support for asymmetric crypto services was not included in the qat_6xxx
by explicitly setting the asymmetric capabilities to 0 to allow for
additional testing.

Enable asymmetric crypto services on QAT GEN6 devices by setting the
appropriate capability flags.

Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index cc8554c65d0b..435d2ff38ab3 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -637,7 +637,15 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
 	}
 
-	capabilities_asym = 0;
+	capabilities_asym = ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
+			    ICP_ACCEL_CAPABILITIES_SM2 |
+			    ICP_ACCEL_CAPABILITIES_ECEDMONT;
+
+	if (fusectl1 & ICP_ACCEL_GEN6_MASK_PKE_SLICE) {
+		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
+		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_SM2;
+		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_ECEDMONT;
+	}
 
 	capabilities_dc = ICP_ACCEL_CAPABILITIES_COMPRESSION |
 			  ICP_ACCEL_CAPABILITIES_LZ4_COMPRESSION |

base-commit: 42ef77e0ed1a7e2113d68524f4b6c3e891d5699c
-- 
2.40.1

