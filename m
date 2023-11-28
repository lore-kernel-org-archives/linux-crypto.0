Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gVuf14B6"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A1419BC
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 09:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701194313; x=1732730313;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mwIB5m3wu/n6AhYUpJiPbBD+ig/ptoxTgVFtM5xU7qc=;
  b=gVuf14B6QUUqGcIZUDAM2aGd9QOC/SL8odbPjzw4ue20RvOC3X3hUlPc
   vV/9njHlblDTMpwMLXsz1RErkIdYIu9g6YcIz/LtDuE1K4LakjHCMaVs2
   FUYVihkQXvexzGbO4EYHE6Z9oaEsV0IaqxgPVgv1mQ3IrO2qMXFw7jj7S
   QvjNimqSkOY1TZG/77LktvhyGopEp5Xjci5xKWj6A1Ggr3gsExtZV3puz
   dzxSsyrB4GxnKKJzOErDseh4BRd4povLPpomzopegvW7anCDo+DR5wGqN
   Zoe3MHddYrdecM2Qyv5zjqu9oih8OpzjBlOVneP8VCUBmv0hppfg0k0Ld
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="392729683"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="392729683"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 09:58:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="16687600"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by orviesa001.jf.intel.com with ESMTP; 28 Nov 2023 09:58:31 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix mutex ordering in adf_rl
Date: Tue, 28 Nov 2023 18:39:30 +0100
Message-ID: <20231128174053.84356-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

If the function validate_user_input() returns an error, the error path
attempts to unlock an unacquired mutex.
Acquire the mutex before calling validate_user_input(). This is not
strictly necessary but simplifies the code.

Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index f2de3cd7d05d..de1b214dba1f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -815,13 +815,13 @@ static int add_update_sla(struct adf_accel_dev *accel_dev,
 		return -EFAULT;
 	}
 
+	mutex_lock(&rl_data->rl_lock);
+
 	/* Input validation */
 	ret = validate_user_input(accel_dev, sla_in, is_update);
 	if (ret)
 		goto ret_err;
 
-	mutex_lock(&rl_data->rl_lock);
-
 	if (is_update) {
 		ret = validate_sla_id(accel_dev, sla_in->sla_id);
 		if (ret)

base-commit: ed628a28e67c93d65400e7f00e0ff5d4f7a87070
-- 
2.41.0

