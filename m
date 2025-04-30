Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238A825B1E8
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 11:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746012915; cv=none; b=LwSsOXiFKJgmUfZsngNRBNucVgrVw1MvKlCpPv9d8M2D3QyljBavd1bqceBSltb6XGMdxBVKv4f18SSpJRcKPr/C/o/l1ROlpBPEZEnNOUjebqc9A+V69R9QYtOZSpfHjrr5Kd0AZe+9JhZz66pI1CEOzHQp4o/W30ft2zBnGnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746012915; c=relaxed/simple;
	bh=E1txipOVkEw8OVXhi7SL+BN/OV+6jxipDQzCBnuSkVw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ucML5Ox3j5r1NcoClU85/10GYOhbwVpJL0qp5IRziyMnEIrnj8vZkRCdCbVsiu13nQSiPXQKcuD66SbS46lj9YBsCBtDH/pe49aHivzmisED/S0diT+zz+5s1jNNQnIBmHpED2aM+cOd7ImTnlVlMOgfLLupzB9CVYaJBhIoHak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HTPZFM21; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HTPZFM21"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746012914; x=1777548914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E1txipOVkEw8OVXhi7SL+BN/OV+6jxipDQzCBnuSkVw=;
  b=HTPZFM21PINNsUzgh48YFT6nENZYjMOjOB6N1YBJGCkhrpLaKGyHe211
   RnQBoJ9X81nkH1wVWD5Ket2nrNATCTvhsK1oDPoVJWXrxF0EL7i+6Q/pg
   ErbyYa+MCuzgb2UYvF1h1uo0qqIdLHG+AGXU7GD2XY7nWJRyu4VmOYhAj
   5aZSan11ZQmU4aoA9rOlxldt8w2YAd40T051zguOFDmULMRE3P4Liaw+j
   Y5NxCxc7iYwSLCdnGBNVMssOkGDMNIPhsq+9LWxjKNEbuj17c7oyWN3zg
   QWb3AK4lXrg61V2b5zCwfKl3YuvsNZsLawE/ceFID+QFbcMQ2lrFSq8x0
   A==;
X-CSE-ConnectionGUID: 1c/KiWhzS52iSqST0q18vw==
X-CSE-MsgGUID: nG4ynfpESfeC4irutYp2Yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51331154"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="51331154"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 04:35:14 -0700
X-CSE-ConnectionGUID: r/8xUQW0SYOd1iJvhImh0g==
X-CSE-MsgGUID: Ccpt4kbPQSu4xsXJLn6ruQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133812539"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa009.jf.intel.com with ESMTP; 30 Apr 2025 04:35:12 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 06/11] crypto: qat - export adf_get_service_mask()
Date: Wed, 30 Apr 2025 12:34:48 +0100
Message-Id: <20250430113453.1587497-7-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
References: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Export the function adf_get_service_mask() as it will be used by the
qat_6xxx driver to configure the device.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg_services.c | 3 ++-
 drivers/crypto/intel/qat/qat_common/adf_cfg_services.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index 30abcd9e1283..c39871291da7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -116,7 +116,7 @@ int adf_parse_service_string(struct adf_accel_dev *accel_dev, const char *in,
 	return adf_service_mask_to_string(mask, out, out_len);
 }
 
-static int adf_get_service_mask(struct adf_accel_dev *accel_dev, unsigned long *mask)
+int adf_get_service_mask(struct adf_accel_dev *accel_dev, unsigned long *mask)
 {
 	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = { };
 	size_t len;
@@ -138,6 +138,7 @@ static int adf_get_service_mask(struct adf_accel_dev *accel_dev, unsigned long *
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(adf_get_service_mask);
 
 int adf_get_service_enabled(struct adf_accel_dev *accel_dev)
 {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
index f6bafc15cbc6..3742c450878f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -32,5 +32,6 @@ enum {
 int adf_parse_service_string(struct adf_accel_dev *accel_dev, const char *in,
 			     size_t in_len, char *out, size_t out_len);
 int adf_get_service_enabled(struct adf_accel_dev *accel_dev);
+int adf_get_service_mask(struct adf_accel_dev *accel_dev, unsigned long *mask);
 
 #endif
-- 
2.40.1

