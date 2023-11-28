Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZMn+ZwjG"
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9E7210C
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 09:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701194186; x=1732730186;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jANSly3SCs0KMx1UgUvYj11BDQWDzndCBmMmO7qQydo=;
  b=ZMn+ZwjG/HYIUTKi738nHUsAOZol3rdkRC9FFE1xrvkQIuLmrashb1Ia
   zlOp9Xi99Gpz+r/k93Ar1vr84uMaCO3wgoVBFC73kBuIDblsUvbncMxsm
   Bs6HRQtR5eLq+0rbW4FZhiL1x6IDp+FE8URGykJjuxXqdo7kQ/deWBPSP
   tlTClE6Mibc1im/JvPTAN1lWBZsVVYs2awYGy5HlJ6zZLBHc7pq7caeED
   H1rC2eSf2LrobpfH5mwOQrASP11o2TnaxXqYpw3I/fYBKfmSbIiwhqQak
   E0QjE9rqB1L9Opd09iEnWiNMftuIeXZHZ3qQqX4T3U4/nruRwNxHaBtaq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="383367885"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="383367885"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 09:56:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="886489477"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="886489477"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 28 Nov 2023 09:56:24 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix error path in add_update_sla()
Date: Tue, 28 Nov 2023 18:37:32 +0100
Message-ID: <20231128173828.84083-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

The input argument `sla_in` is a pointer to a structure that contains
the parameters of the SLA which is being added or updated.
If this pointer is NULL, the function should return an error as
the data required for the algorithm is not available.
By mistake, the logic jumps to the error path which dereferences
the pointer.

This results in a warnings reported by the static analyzer Smatch when
executed without a database:

    drivers/crypto/intel/qat/qat_common/adf_rl.c:871 add_update_sla()
    error: we previously assumed 'sla_in' could be null (see line 812)

This issue was not found in internal testing as the pointer cannot be
NULL. The function add_update_sla() is only called (indirectly) by
the rate limiting sysfs interface implementation in adf_sysfs_rl.c
which ensures that the data structure is allocated and valid. This is
also proven by the fact that Smatch executed with a database does not
report such error.

Fix it by returning with error if the pointer `sla_in` is NULL.

Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 86e3e2152b1b..f2de3cd7d05d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -812,8 +812,7 @@ static int add_update_sla(struct adf_accel_dev *accel_dev,
 	if (!sla_in) {
 		dev_warn(&GET_DEV(accel_dev),
 			 "SLA input data pointer is missing\n");
-		ret = -EFAULT;
-		goto ret_err;
+		return -EFAULT;
 	}
 
 	/* Input validation */

base-commit: 27265511a765f4380257319b0c088097b9cf1a71
-- 
2.41.0

