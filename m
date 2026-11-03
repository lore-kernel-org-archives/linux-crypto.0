Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700094;
	b=MDigovi/RKoVgaJryCrWFCoGgSW3OR3MlLW3GKRnxLPHhNlY1u/DTupwvxcwQMQmDMTx
	 9yQlVMVOGgr2uSyTaWgLj/SKdTFXARux/euwFIdid2Y4/Vc8k/F5j9mHefomf+YLJW1oX
	 Fqv8aUZzkwPh828ItLYm6f+GwOMSyuifSVmN9lD7YYexMhAAy7IiMTYU0LS0wC/Q1Yus7
	 xImYjL4JVgFemW+HK+N4T1OtdoYOc12bFtCWMaqKAp7pVBBo3Hikz2oturu+kROMI1W+i
	 IxvceZNa3660SBH5bvUK6eij/45bUQ41eV+aY8TSvSmWmuJKHy/jL+sR6OwkbZJ2/zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700094;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Organization:
	 Content-Transfer-Encoding;
	bh=/cZarQjH1y0CBToPTGhEP5ehftCHfa2MCFRykyXHFVs=;
	b=yF+HG18SsTPEABRuPFs2zf0Tgn6qNQo84/K1SEr1/4zVggJxRgCuQJ73D3qJlgANi2lk
	 OHY7GctIl+r1Iv84UjtuXpyAj6h1uoK5NHGQn6ZxsNW8LRKgUX1xHKQPo1aq7thtug0c6
	 puvQ2J76TTNPUIytWs422gzgN9nOIv1VdWFWtBf0trEek6VIgZBD2Tg5SyovKzbriGI6p
	 hlgGtD8XDc0+we4zdQw8BHq5sXfLbi/p8aWWeJOcgJhglDPHMSfSOB2XTCOe43IjSkp1p
	 s9hXttiJtKHekSEDNef5VbI1PrD2D/CP4luy0dpf5AEGimrIgBdyvdsGHipjs0mP5xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YfDmaQJw;
	arc=none smtp.remote-ip=192.198.163.8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B68606B36E
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 10:01:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02B68606B36E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YfDmaQJw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793700095; x=1825236095;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ip7ru0I7gw9h8NfRyoaa8v1qjbE8zEp6sWW7A6MsRBY=;
  b=YfDmaQJwhJY7ho5TCxUsX98mHlkHvet/yGvRDQ/zEX+jRtzuFRSlGNtt
   nTW1BZBQ5LcwT62fHnvsUP5Ny+O0zs1suJgkxQJIufSMaoWrRzsRx3/Cp
   0bCfqXC1Bdh3xvJ6RhMnvz+9S/mZrU4K1DvnxAmn5rCOwK838+qajkXwo
   f+z1CJIXLEImr0mYmW6QgRgGteEXPOBbRqjeE9mT65S+hIsJzkLvV/+H0
   rrDHUEtn2seSSmym00fp0vUktgJ32Qk9pYLkqlp5z8jA/nk6JpJLC5Ew5
   oF3IzbK9+BYce6rbu9Sxs1z4yOeiHDqUs0Kc89YRODEQBIUjp1rM2IZsU
   g==;
X-CSE-ConnectionGUID: IaDRfPhwRDG9yfO2cCsJ2A==
X-CSE-MsgGUID: TgflFyv0Q3aMXSwfmXcS1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2307656"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2307656"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 02:01:34 -0800
X-CSE-ConnectionGUID: QkGJDt+tSTSlbbeHV8WfaQ==
X-CSE-MsgGUID: SsfCpm43QDOJ50rZS/augQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6488711"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa003.fm.intel.com with ESMTP; 03 Nov 2026 02:01:32 -0800
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - clear fw_loader pointer on adf_ae_init() failure
Date: Tue,  3 Nov 2026 10:01:26 +0000
Message-ID: <20261103100126.534424-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

adf_ae_init() stores the newly allocated loader data in
accel_dev->fw_loader before calling qat_hal_init(), as the latter
publishes the HAL handle through that pointer. If either
qat_hal_init() or adf_ae_reset() fails, the error paths free the
allocation but leave accel_dev->fw_loader pointing at freed memory,
so the device is left holding a dangling pointer.

No code path dereferences that stale pointer today. This is therefore
a robustness improvement with no observable failure behind it, hence
no Fixes tag.

Clear accel_dev->fw_loader when the allocation is released, and fold
the duplicated error handling into a cascading goto chain. Report the
error returned by the callee rather than a generic -EFAULT;
adf_dev_init() still maps any failure to -EFAULT, so this is a
readability improvement and not a functional change.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/adf_accel_engine.c   | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
index bb97bbedbb8a..2db74b055201 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
@@ -181,6 +181,7 @@ int adf_ae_init(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data;
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	int ret;
 
 	if (!hw_device->fw_name)
 		return 0;
@@ -190,18 +191,24 @@ int adf_ae_init(struct adf_accel_dev *accel_dev)
 		return -ENOMEM;
 
 	accel_dev->fw_loader = loader_data;
-	if (qat_hal_init(accel_dev)) {
+	ret = qat_hal_init(accel_dev);
+	if (ret) {
 		dev_err(&GET_DEV(accel_dev), "Failed to init the AEs\n");
-		kfree(loader_data);
-		return -EFAULT;
+		goto err_free_loader_data;
 	}
-	if (adf_ae_reset(accel_dev, 0)) {
+	ret = adf_ae_reset(accel_dev, 0);
+	if (ret) {
 		dev_err(&GET_DEV(accel_dev), "Failed to reset the AEs\n");
-		qat_hal_deinit(loader_data->fw_loader);
-		kfree(loader_data);
-		return -EFAULT;
+		goto err_hal_deinit;
 	}
 	return 0;
+
+err_hal_deinit:
+	qat_hal_deinit(loader_data->fw_loader);
+err_free_loader_data:
+	kfree(loader_data);
+	accel_dev->fw_loader = NULL;
+	return ret;
 }
 
 void adf_ae_shutdown(struct adf_accel_dev *accel_dev)
-- 
2.50.1

