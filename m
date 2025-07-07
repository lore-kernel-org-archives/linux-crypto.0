Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB231FF5E3
	for <linux-crypto@vger.kernel.org>; Mon,  7 Jul 2025 08:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751878468; cv=none; b=a10pCGbeXQZUw9YZUVUQv7CwYbACKW9Q9DPlR3fPqeXhHpULM1zAwON6v2S4BDgN5EDXA6G83spWWqzuG0stN21H2/tlKvoqOgMszoD7z0UkqfkFKGl+WcvTOetNS5JSmHtgez/7Jee8QLEcZGFsitzBZ9znAqhh4JsnfjCREGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751878468; c=relaxed/simple;
	bh=x8rAFjiOt9sQv5yeADGH4CTRlkIXKAuH8E9mZOCCjl0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=EFe1aWNerBrzxV1mkduc/UdwRO6b9/jAbGiT8Hb8bqiCGiAjZaBSB0ce3t59uuGUJTOZ9QHJko/E9KIw5Qaw6owpPQQjHg/inft1EyGrKTfrHolgi+bPbFfM2T/6WksVvv6bSgEDF/+tzjsympwjnQE5ZI/gyWqM29yrG+Lq5BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IDH3/RIs; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IDH3/RIs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751878467; x=1783414467;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x8rAFjiOt9sQv5yeADGH4CTRlkIXKAuH8E9mZOCCjl0=;
  b=IDH3/RIs/QZjQNcrnMSNMb8Tf2Ma9JU9SnUR8Vl4jyTpjmuYl6Xs1jW0
   t1U+MJsIMh+b1ugy81nHCWKrnHgg3Zcynw5Zr0pJ513zwPJiHHhyG3KF0
   Ljm81KXsC3IPnUJGTXoesDej5zL78hMjkafonF9UZ9HH+4xT8822s5UvL
   da28eXkmwBldbhCj1aPOTgfqlcLkKJdZLraV3B7LrSX50qT4pEexT9Js3
   T48PK3lunPFpG5P8rAr/Ww1yVDN9oXcK3rvFtZWy4bBVSiE/9WazdhwFB
   uGGQ2/cB9BhTGB8ElVU8huy5BZCLDd9xIS7apukgW26Dagd6qMbia6qRc
   g==;
X-CSE-ConnectionGUID: gOu1Ypi+TcOGzWBISMW1xw==
X-CSE-MsgGUID: 2Cr7CyGATxOEWQuLshqn6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11486"; a="65545819"
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="65545819"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 01:54:27 -0700
X-CSE-ConnectionGUID: /EDxkHbvR2Op7Y1WVZiSnA==
X-CSE-MsgGUID: aPbs7HoXQfmANIuqhyP9gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="155514229"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa009.fm.intel.com with ESMTP; 07 Jul 2025 01:54:25 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH] crypto: qat - fix virtual channel configuration for GEN6 devices
Date: Mon,  7 Jul 2025 09:54:17 +0100
Message-Id: <20250707085417.1286691-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The TCVCMAP (Traffic Class to Virtual Channel Mapping) field in the
PVC0CTL and PVC1CTL register controls how traffic classes are mapped to
virtual channels in QAT GEN6 hardware.

The driver previously wrote a default TCVCMAP value to this register, but
this configuration was incorrect.

Modify the TCVCMAP configuration to explicitly enable both VC0 and VC1,
and map Traffic Classes 0 to 7 → VC0 and Traffic Class 8 → VC1.
Replace FIELD_PREP() with FIELD_MODIFY() to ensure that only the intended
TCVCMAP field is updated, preserving other bits in the register. This
prevents unintended overwrites of unrelated configuration fields when
modifying TC to VC mappings.

Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c | 10 +++++-----
 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index 4d93d5a56ba3..a21a10a8338f 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -532,8 +532,8 @@ static void set_vc_csr_for_bank(void __iomem *csr, u32 bank_number)
 	 * driver must program the ringmodectl CSRs.
 	 */
 	value = ADF_CSR_RD(csr, ADF_GEN6_CSR_RINGMODECTL(bank_number));
-	value |= FIELD_PREP(ADF_GEN6_RINGMODECTL_TC_MASK, ADF_GEN6_RINGMODECTL_TC_DEFAULT);
-	value |= FIELD_PREP(ADF_GEN6_RINGMODECTL_TC_EN_MASK, ADF_GEN6_RINGMODECTL_TC_EN_OP1);
+	FIELD_MODIFY(ADF_GEN6_RINGMODECTL_TC_MASK, &value, ADF_GEN6_RINGMODECTL_TC_DEFAULT);
+	FIELD_MODIFY(ADF_GEN6_RINGMODECTL_TC_EN_MASK, &value, ADF_GEN6_RINGMODECTL_TC_EN_OP1);
 	ADF_CSR_WR(csr, ADF_GEN6_CSR_RINGMODECTL(bank_number), value);
 }
 
@@ -549,7 +549,7 @@ static int set_vc_config(struct adf_accel_dev *accel_dev)
 	 * Read PVC0CTL then write the masked values.
 	 */
 	pci_read_config_dword(pdev, ADF_GEN6_PVC0CTL_OFFSET, &value);
-	value |= FIELD_PREP(ADF_GEN6_PVC0CTL_TCVCMAP_MASK, ADF_GEN6_PVC0CTL_TCVCMAP_DEFAULT);
+	FIELD_MODIFY(ADF_GEN6_PVC0CTL_TCVCMAP_MASK, &value, ADF_GEN6_PVC0CTL_TCVCMAP_DEFAULT);
 	err = pci_write_config_dword(pdev, ADF_GEN6_PVC0CTL_OFFSET, value);
 	if (err) {
 		dev_err(&GET_DEV(accel_dev), "pci write to PVC0CTL failed\n");
@@ -558,8 +558,8 @@ static int set_vc_config(struct adf_accel_dev *accel_dev)
 
 	/* Read PVC1CTL then write masked values */
 	pci_read_config_dword(pdev, ADF_GEN6_PVC1CTL_OFFSET, &value);
-	value |= FIELD_PREP(ADF_GEN6_PVC1CTL_TCVCMAP_MASK, ADF_GEN6_PVC1CTL_TCVCMAP_DEFAULT);
-	value |= FIELD_PREP(ADF_GEN6_PVC1CTL_VCEN_MASK, ADF_GEN6_PVC1CTL_VCEN_ON);
+	FIELD_MODIFY(ADF_GEN6_PVC1CTL_TCVCMAP_MASK, &value, ADF_GEN6_PVC1CTL_TCVCMAP_DEFAULT);
+	FIELD_MODIFY(ADF_GEN6_PVC1CTL_VCEN_MASK, &value, ADF_GEN6_PVC1CTL_VCEN_ON);
 	err = pci_write_config_dword(pdev, ADF_GEN6_PVC1CTL_OFFSET, value);
 	if (err)
 		dev_err(&GET_DEV(accel_dev), "pci write to PVC1CTL failed\n");
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
index 78e2e2c5816e..8824958527c4 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
@@ -99,7 +99,7 @@
 #define ADF_GEN6_PVC0CTL_OFFSET			0x204
 #define ADF_GEN6_PVC0CTL_TCVCMAP_OFFSET		1
 #define ADF_GEN6_PVC0CTL_TCVCMAP_MASK		GENMASK(7, 1)
-#define ADF_GEN6_PVC0CTL_TCVCMAP_DEFAULT	0x7F
+#define ADF_GEN6_PVC0CTL_TCVCMAP_DEFAULT	0x3F
 
 /* VC1 Resource Control Register */
 #define ADF_GEN6_PVC1CTL_OFFSET			0x210

base-commit: e60a1d75144ab93ad528fa1457bc9ae704d51ab0
-- 
2.40.1

