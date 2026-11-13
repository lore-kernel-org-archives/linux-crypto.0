Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794581724;
	b=1K21uFFCERkZus0xvMMTUVuHHe56PnoHWTnNjwbmw9BT+cLua6/S7FWPEMgUwKOTnh4y
	 S+XFcBujbtyjTJ01KPMqNX713wZeIq3R/nkqSEH8NRXVE+A/ZEN4iFXFDGnwrt/fthNLi
	 QLdIBcNMuYFSPK8miIx+P8f13TZhSRL1QC0yDr+V4rw/Rf4bKzCYkHGT94pnVtIXsmI+R
	 7906rpUdiDtBQdgTs5Qxrpc1XSnp2nK5IHu1q4E9OLwrKZjD4O7sKG8AlboyEsFkfaSZD
	 WKX8z2MlwU8GphYks+mF3Fnw+a6+c/rdYv2ZLMA1q7qLUSsiX3G8n4nHBhDXZHKmZEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794581724;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Organization:
	 Content-Transfer-Encoding;
	bh=LsZnmx3YW5eVsMoHjRJ1l1g8K8e7e/4UvhlDu5yO8W0=;
	b=Xs2e6P9rf0irRsRUlDcFs+WuG8oux6T1lZXhSHC0Qwj2I9AXEgMrvsZa7QjSz663ORbF
	 9GF/uAcHuQhuratcfc7iVLpfodnDgRm50Jqm/uMKdS0FPNTP2jwD2nOnEA+DyzfuUIcZj
	 BU/lyR1/36lH5GtZ50M/SPmsOA5EeK0QQjHS8LotkHzV7/b/rZoA7CwuUPiudQSCO5smK
	 FZYELAT37gMf4pnFVShGu0i3v+i4H+11ug9prlaBQ+3WaxZTfwZvGUtVwNDTnDfztpLEd
	 tCrGspmZqEFWXiQ4x2W3LINuy+GocLD5+E+mWpfW9wPXMzaGljYBmFBEI4ibMrgfSUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GGSvk4GM;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4E7606A323
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 14:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A4E7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GGSvk4GM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794581723; x=1826117723;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BdoM3Yn83NMmlhul06sQlWk2nLWMDdReHA49zonPld4=;
  b=GGSvk4GMceGJIxgdvTzd3VzI+0D19UdlLl/b3BVvxGXj/DtyvITFmKeJ
   6+q10D68oZXEDSqQqfQVXMj8ptKN/pgVAOFsNQEthx/CScFwa8Hu9E/k2
   f602Sf/udKeFSzpoG/lbecsjyDOMD94DHQOOWOOT30bXdSAsuyBEhIUY+
   zGvZGzBzAPtl7QjTpXhcmmxMU0n4zkUsYTjSyHgXBGZb7aTkeMbQQkH5f
   4qRMCaeYSlLSVajv618aUKFwKqmflkK/SsbC2g57RzzWjy+JMNsksz7GQ
   UEeKh07L952xdbf6j0onB02UnyHJZxJev6I375XQzD3tj9SCLNd25Qr8Q
   Q==;
X-CSE-ConnectionGUID: UVTe8FlYSmiJE2dbP6tcUw==
X-CSE-MsgGUID: KEinM1/aTOKQmGwERoboyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3401248"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3401248"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 06:55:23 -0800
X-CSE-ConnectionGUID: 6CPDmvN9RkumJXZAFR8LAw==
X-CSE-MsgGUID: G0mbjz/cTVWZZo1xzpSG6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="8850497"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa007.jf.intel.com with ESMTP; 13 Nov 2026 06:55:21 -0800
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH RESEND] crypto: qat - clear fw_loader pointer on adf_ae_init() failure
Date: Fri, 13 Nov 2026 14:55:08 +0000
Message-ID: <20261113145508.1556307-1-ahsan.atta@intel.com>
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
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

base-commit: 8ba9044ff0bf4a5789216496019fad614eeafd45
-- 
2.50.1

