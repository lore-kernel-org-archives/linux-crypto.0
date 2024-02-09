Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54940374F8;
	Fri,  9 Feb 2024 13:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707483860; cv=none; b=CFTivHRXOUad9eNcuOAZPqYgbPcxmXwycBpK7ZnQEzUFvT+LVV85NytAVCA8IWEA+mDX0+eORBfz7XBTvqmEvR2O1NExwM0tUT2xfoIutSiy+pZV+YoCfN/8S63XDq5SM8up5DmZkeRditU5jfXOzbZCqtrihqSqMjlTv56RJaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707483860; c=relaxed/simple;
	bh=nugzDsB6Q+f9z8qPXPTyJX7QccnEmmXny29RETfpCs8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TqFnlM3tZwZz/DhavYtuvv7D9rc1RMpTpSxVw5qsVIXv2Jd6M036akVDcBQN6vhhSkk4PYms9OkM+bR6JSZiU4ak+NEAG7enz9f/BbLthyOEnOdhnEC61s1FdAvlSxfTVjLkQ1LNiTdzymAmvdL9UFdgd3PVravuTG/W23uQgdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2VuWLWd; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2VuWLWd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707483859; x=1739019859;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nugzDsB6Q+f9z8qPXPTyJX7QccnEmmXny29RETfpCs8=;
  b=j2VuWLWdploFPPXfJoPcWhT9ZfQp9U8xDk0bYq2+LfS4dSP786o0UgE+
   633HlfW4EIF98b3ihZ6j3FE1WO34gvj83o+0KOUDKyZWHFHsT3Hvow/Ep
   Hbo0bA/hlTl4LkrY/d6H2aifUqsXOu7LXksWjsOGmr7Hw8nW4xo1NWsHP
   4KJ/Ek4dre8Qr2BIieZwkNgyA6sRPea3Ep+NQa5HN+KVg4+3hm19wmSvc
   3X7F5Ru1gACO3u7wMWMu18aBRnWah/wrHeySrpeqlGFnmBwN0rVjEAVek
   UrNGaQk3I/28NEWJnqa+bLiozIfbs85qqaCrtCrU8kFuuPzVravnv1ojv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="5241347"
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="5241347"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 05:04:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="6553030"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmviesa003.fm.intel.com with ESMTP; 09 Feb 2024 05:04:16 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - resolve race condition during AER recovery
Date: Fri,  9 Feb 2024 13:43:42 +0100
Message-ID: <20240209124403.44781-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

During the PCI AER system's error recovery process, the kernel driver
may encounter a race condition with freeing the reset_data structure's
memory. If the device restart will take more than 10 seconds the function
scheduling that restart will exit due to a timeout, and the reset_data
structure will be freed. However, this data structure is used for
completion notification after the restart is completed, which leads
to a UAF bug.

This results in a KFENCE bug notice.

  BUG: KFENCE: use-after-free read in adf_device_reset_worker+0x38/0xa0 [intel_qat]
  Use-after-free read at 0x00000000bc56fddf (in kfence-#142):
  adf_device_reset_worker+0x38/0xa0 [intel_qat]
  process_one_work+0x173/0x340

To resolve this race condition, the memory associated to the container
of the work_struct is freed on the worker if the timeout expired,
otherwise on the function that schedules the worker.
The timeout detection can be done by checking if the caller is
still waiting for completion or not by using completion_done() function.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 3597e7605a14..9da2278bd5b7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -130,7 +130,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	if (adf_dev_restart(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
+		    completion_done(&reset_data->compl))
 			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
@@ -146,11 +147,19 @@ static void adf_device_reset_worker(struct work_struct *work)
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 
-	/* The dev is back alive. Notify the caller if in sync mode */
-	if (reset_data->mode == ADF_DEV_RESET_SYNC)
-		complete(&reset_data->compl);
-	else
+	/*
+	 * The dev is back alive. Notify the caller if in sync mode
+	 *
+	 * If device restart will take a more time than expected,
+	 * the schedule_reset() function can timeout and exit. This can be
+	 * detected by calling the completion_done() function. In this case
+	 * the reset_data structure needs to be freed here.
+	 */
+	if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
+	    completion_done(&reset_data->compl))
 		kfree(reset_data);
+	else
+		complete(&reset_data->compl);
 }
 
 static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
@@ -183,8 +192,9 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
 			dev_err(&GET_DEV(accel_dev),
 				"Reset device timeout expired\n");
 			ret = -EFAULT;
+		} else {
+			kfree(reset_data);
 		}
-		kfree(reset_data);
 		return ret;
 	}
 	return 0;

base-commit: 86f2ff2d4ec09a7eea931a56fbed2105037ba2ee
-- 
2.43.0

