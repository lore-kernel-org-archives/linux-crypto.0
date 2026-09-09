Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E972157266D
	for <linux-crypto@vger.kernel.org>; Wed,  9 Sep 2026 14:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963302; cv=none; b=O67Uqs5GlCf8s2kXCejn6StVoNrOzFsIxxFI2Hdrne68ejeooXq9kh1SD/hvDWzpNyijyMdvnS0PhHlljErIUxbjjN3JZM7Ae9E+/p7VAUgEfMwLMMgIgOHpCZcT8Of8QR6O6Uox24AGtdqfvY+pDeBEwnsIONR8x/+Mex4/ZXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963302; c=relaxed/simple;
	bh=1mmv9SUJrh2Qx1Udfn/iunbjNIEPsbxrznYo8XhDt3c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kZ2kCIKh9qaMD6r5ovxyB/FUr2/FeKYzrQaN2QlRUzsK9Ue+WAheXteTX8BYsU2zCp8yEju6UU1NkM232gbMBSxLQv9f80k8w5sqcn4vBmRg6RNDslfSHvhUKCPDF0m01bdFTanJNJiDFjVamUiZ/xdzhZ++Ss1c5/Nw2Lawf/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JYnWJ0Qp; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JYnWJ0Qp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788963301; x=1820499301;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1mmv9SUJrh2Qx1Udfn/iunbjNIEPsbxrznYo8XhDt3c=;
  b=JYnWJ0QpYpwwPs92kicRqknHVgKRzo6H/vzKwDQMoJm67/F/GgPLI2bV
   /9daJIDWcoeRbeyIWRtCg/5QTnuq26/p0u5upq6Wf+/pauNw2iiiYJiDB
   VRHX9tfGhZl8xPPqt1xqXj5b/0UOEbKMuI6GMUyx0wkAHad+m+GLqBi00
   tMub7L2fDkeBSZBs5+HF2YNqn3UNWD2F/cu/hKFt6qnl8HvspGBD9sNYD
   P/6QHkArVP9nDzXAIK/+bMmujLWgsBE4YoVROllSyzSV6vYbbVkjP6Cm8
   VxaZ2kLwApy2HyxjqBhKPlmjyvqU+tRZOyY74GDwrVI5KTI1kzGWl05op
   Q==;
X-CSE-ConnectionGUID: v8hk/Kj7SAGLuwndD4sTBw==
X-CSE-MsgGUID: nrtGY7/5Q2m9Bj+UyuHBvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89260001"
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="89260001"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 07:15:00 -0700
X-CSE-ConnectionGUID: 2oyzhpk2TvOXXkERWZYDZw==
X-CSE-MsgGUID: bWDt9nC6QKO3J62Gjr0iVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="269565819"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa006.jf.intel.com with ESMTP; 09 Sep 2026 07:14:58 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v3] crypto: qat - fix active_devs leak on crypto alg registration failure
Date: Wed,  9 Sep 2026 15:15:21 +0100
Message-ID: <20260909141521.1821101-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

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
error paths of both register helpers. While at it, propagate the error
code returned by the register helpers instead of a blanket -EFAULT.

Fixes: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
Changes in v3:
- Added Reviewed-by tag from Thomas Huth.

Changes in v2:
- adf_dev_start(): propagate the error code returned by qat_algs_register()
  and qat_asym_algs_register() instead of returning a blanket -EFAULT.

 .../crypto/intel/qat/qat_common/adf_init.c    | 24 ++++++++++++-----
 .../crypto/intel/qat/qat_common/qat_algs.c    | 15 ++++++-----
 .../intel/qat/qat_common/qat_asym_algs.c      | 26 ++++++++++++++-----
 3 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 3e39c53814de..81cb5e6c9f4a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -260,13 +260,23 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
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
+		ret = qat_algs_register();
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev), "Failed to register crypto algs\n");
+			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
+			return ret;
+		}
+
+		ret = qat_asym_algs_register();
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev), "Failed to register crypto asym algs\n");
+			qat_algs_unregister();
+			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
+			return ret;
+		}
 	}
 	set_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index cb669fb66162..2ec19104787f 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -1319,19 +1319,22 @@ int qat_algs_register(void)
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

