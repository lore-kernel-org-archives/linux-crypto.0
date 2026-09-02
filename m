Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928251A7264
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 10:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788343939; cv=none; b=QTLL9AiszRO1zaKcKdVfQzIatY3VijwyWThVAw2Tk84fqPJAhoaQE0rAuqZSEsY7Z9lguBjRi9zUVKLBroHIsY/57AakmaiihZeaVUnhPx1mwi8s8xrcSD4i8bE3pHEp4NLCL9/XUulE8s74VQOkNFZM50YLTQVWzatBv5sGxy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788343939; c=relaxed/simple;
	bh=98y3SDW5/1hnS3c2nCUyhv7egyfP1HvZnn78zfe5bzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ru8/UpAZm0rYkKED1KPtil415nSMi01LdnjgxVFv5ccGECbjIU56YEC5EfIIha7D1rHmmKWbO3H15X7Mv5WnsyrO9KpxGf3NLuNlb/iaMGZb3MKKRaFB9tbZCX8Ob4UGCgOI2FtZja+AcG/rryBmeyycPHnDrQ1QWMXzF9xZ4YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X6+sEojy; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X6+sEojy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788343935; x=1819879935;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=98y3SDW5/1hnS3c2nCUyhv7egyfP1HvZnn78zfe5bzU=;
  b=X6+sEojyv0PbJKxj+tftX9gtr5vfy2ZV2gkVNAeGjmZSCcoMO4RkLPVi
   Xd7p8aoGH6fdmFVpPBw+RVEuhgDR0Ks9iCuLR2JOoowBBw2Jgy6LXEIwj
   tEKkKQfa4f+lifO82VEtYMUXa7nrjnvb3MW25VDR9yGD7WUorVixbMQDK
   ucCTdrI3bpzmOmMm8ZyMSoYXVis1Lp+rjWBPIjKFHzVv0gjdPTrXJwuY4
   FKaTKHKhyT9gMDGtLigJfU/o5V5gdLDDtgKCNPCf/Fx+eXai1JawidpAw
   JbwBt0QBqzx0GH7G6xMIX6NPVHSsJSljPa13RSeDUYKV1L/9PP/k5k7Z6
   w==;
X-CSE-ConnectionGUID: Xva+3NVfShqs/yFGRuqsaA==
X-CSE-MsgGUID: bkHBIq/rQxWYuL2Qe/VHng==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="99131578"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="99131578"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 03:12:14 -0700
X-CSE-ConnectionGUID: KgMbs1nsSc+Zuc9XeBguCg==
X-CSE-MsgGUID: AOhnbwJRRh6bwnt5cqog8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="272869617"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa003.jf.intel.com with ESMTP; 02 Sep 2026 03:12:09 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix active_devs leak on crypto alg registration failure
Date: Wed,  2 Sep 2026 11:12:16 +0100
Message-ID: <20260902101216.1226292-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

adf_dev_start() registered both alg sets in a single condition.
If qat_algs_register() succeeds but qat_asym_algs_register() fails,
ADF_STATUS_CRYPTO_ALGS_REGISTERED is left clear, so adf_dev_stop() skips
qat_algs_unregister(): the skciphers and aeads stay registered with
active_devs stuck at 1, pinning the module.

Both helpers leak active_devs internally as well - they increment it and
return without decrementing when a crypto_register_*() call fails, and
the asym path also leaves the already-registered akcipher behind.

Split the registration in adf_dev_start() so that an asym failure
unregisters qat_algs, and unwind active_devs (and the akcipher) on the
error paths of both register helpers.

Fixes: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_init.c    | 22 +++++++++++-----
 .../crypto/intel/qat/qat_common/qat_algs.c    | 15 ++++++-----
 .../intel/qat/qat_common/qat_asym_algs.c      | 26 ++++++++++++++-----
 3 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 3e39c53814de..558467dea1a5 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -260,13 +260,21 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	set_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
-	if (!list_empty(&accel_dev->crypto_list) &&
-	    (qat_algs_register() || qat_asym_algs_register())) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to register crypto algs\n");
-		set_bit(ADF_STATUS_STARTING, &accel_dev->status);
-		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
-		return -EFAULT;
+	if (!list_empty(&accel_dev->crypto_list)) {
+		if (qat_algs_register()) {
+			dev_err(&GET_DEV(accel_dev), "Failed to register crypto algs\n");
+			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
+			return -EFAULT;
+		}
+
+		if (qat_asym_algs_register()) {
+			dev_err(&GET_DEV(accel_dev), "Failed to register crypto asym algs\n");
+			qat_algs_unregister();
+			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
+			return -EFAULT;
+		}
 	}
 	set_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 91663805d9e6..f954e7c0e4d0 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -1320,19 +1320,22 @@ int qat_algs_register(void)
 	ret = crypto_register_skciphers(qat_skciphers,
 					ARRAY_SIZE(qat_skciphers));
 	if (ret)
-		goto unlock;
+		goto err_dec;
 
 	ret = crypto_register_aeads(qat_aeads, ARRAY_SIZE(qat_aeads));
 	if (ret)
-		goto unreg_algs;
+		goto err_unreg_skciphers;
 
-unlock:
 	mutex_unlock(&algs_lock);
-	return ret;
+	return 0;
 
-unreg_algs:
+err_unreg_skciphers:
 	crypto_unregister_skciphers(qat_skciphers, ARRAY_SIZE(qat_skciphers));
-	goto unlock;
+err_dec:
+	active_devs--;
+unlock:
+	mutex_unlock(&algs_lock);
+	return ret;
 }
 
 void qat_algs_unregister(void)
diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 1049c583f84f..77d59e977472 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -1340,13 +1340,25 @@ int qat_asym_algs_register(void)
 	int ret = 0;
 
 	mutex_lock(&algs_lock);
-	if (++active_devs == 1) {
-		rsa.base.cra_flags = 0;
-		ret = crypto_register_akcipher(&rsa);
-		if (ret)
-			goto unlock;
-		ret = crypto_register_kpp(&dh);
-	}
+	if (++active_devs != 1)
+		goto unlock;
+
+	rsa.base.cra_flags = 0;
+	ret = crypto_register_akcipher(&rsa);
+	if (ret)
+		goto err_dec;
+
+	ret = crypto_register_kpp(&dh);
+	if (ret)
+		goto err_unreg_akcipher;
+
+	mutex_unlock(&algs_lock);
+	return 0;
+
+err_unreg_akcipher:
+	crypto_unregister_akcipher(&rsa);
+err_dec:
+	active_devs--;
 unlock:
 	mutex_unlock(&algs_lock);
 	return ret;
-- 
2.50.1

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

