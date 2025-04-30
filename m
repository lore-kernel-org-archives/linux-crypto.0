Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961AA25B1D3
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 11:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746012918; cv=none; b=GBenMz9RivDzekr5acwecDpwamsUliWPjezsrD+nAnpSVANy+IJzSk3nSD2vbaacD3iIalLPGwjjelWmr9ao72kdkFPOFejGBLZHBxbT/DSGCeXdfJGxrRj8sly22/XQRNlH37/3Qp3CM/aNB63TTD19cszN1fwx/ZSlNi69oqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746012918; c=relaxed/simple;
	bh=MDsLmT19NKC6X6jFNhUxgM3IO5pWep9RfqekO5yTV70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CcDPcsdJhkuWJ+nY5sjyWNwNiR1KyZbZbC4tqW6XeoVMEwkt9IXPjHfLvyTiIiKyQmpVvzmcju6KYcxtopDqEij0ws3jayOiv5DUeXFI/BD9qyYkLlg31pdBGhItEVO5OofU/npm8DrH6y+Iw6clphJaZIXjXbWcTnyCwGNuCmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bipq/QmT; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bipq/QmT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746012916; x=1777548916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MDsLmT19NKC6X6jFNhUxgM3IO5pWep9RfqekO5yTV70=;
  b=Bipq/QmTb+eCdgzy1aG5Er4TxFR9JzmAs/DgZTOdSi/l7rp5cFeoCrhS
   KcFO0jW49UBCWxwiepthB1WTcaUZaSKpXDYrxQzaXjOlw+3+Yfh3QXG4z
   a6ddNOt6ZZPWZkWYcrcKRHCkcK8R4rzfX48hrdmcKiytzIjw60/3EflIj
   0iGd6jF51BdENi2tcWjsOVGsK7zqikin/LW82g56rx/17/KGqXgeFPhmA
   h14gRIVak5itl+dqK32ZNSTtV+iq1Jr5er6a7mqenWJLt01JKAtC2V7aF
   YP/hiFsVPAQ0srk/h236LYLPKpNF2KANDGj9XrzellaaLRm8C/Qbi5g54
   w==;
X-CSE-ConnectionGUID: 1hRVoiBYTYaTUC/AJbtDnA==
X-CSE-MsgGUID: T7lOtRl1R/6ZcjhS/mUQEw==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51331157"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="51331157"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 04:35:15 -0700
X-CSE-ConnectionGUID: zAHhSTK/Sdy4X9HJmRYjcg==
X-CSE-MsgGUID: 2PLN3t7oR0+6wXUTZPTtfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133812544"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa009.jf.intel.com with ESMTP; 30 Apr 2025 04:35:14 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 07/11] crypto: qat - expose configuration functions
Date: Wed, 30 Apr 2025 12:34:49 +0100
Message-Id: <20250430113453.1587497-8-suman.kumar.chakraborty@intel.com>
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

The functions related to compression and crypto configurations were
previously declared static, restricting the visibility to the defining
source file. Remove the static qualifier, allowing it to be used in other
files as needed. This is necessary for sharing this configuration functions
with other QAT generations.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_config.c | 6 +++---
 drivers/crypto/intel/qat/qat_common/adf_gen4_config.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_config.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_config.c
index f97e7a880f3a..afcdfdd0a37a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_config.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_config.c
@@ -11,7 +11,7 @@
 #include "qat_compression.h"
 #include "qat_crypto.h"
 
-static int adf_crypto_dev_config(struct adf_accel_dev *accel_dev)
+int adf_crypto_dev_config(struct adf_accel_dev *accel_dev)
 {
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
 	int banks = GET_MAX_BANKS(accel_dev);
@@ -117,7 +117,7 @@ static int adf_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	return ret;
 }
 
-static int adf_comp_dev_config(struct adf_accel_dev *accel_dev)
+int adf_comp_dev_config(struct adf_accel_dev *accel_dev)
 {
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
 	int banks = GET_MAX_BANKS(accel_dev);
@@ -187,7 +187,7 @@ static int adf_comp_dev_config(struct adf_accel_dev *accel_dev)
 	return ret;
 }
 
-static int adf_no_dev_config(struct adf_accel_dev *accel_dev)
+int adf_no_dev_config(struct adf_accel_dev *accel_dev)
 {
 	unsigned long val;
 	int ret;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_config.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_config.h
index bb87655f69a8..38a674c27e40 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_config.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_config.h
@@ -7,5 +7,8 @@
 
 int adf_gen4_dev_config(struct adf_accel_dev *accel_dev);
 int adf_gen4_cfg_dev_init(struct adf_accel_dev *accel_dev);
+int adf_crypto_dev_config(struct adf_accel_dev *accel_dev);
+int adf_comp_dev_config(struct adf_accel_dev *accel_dev);
+int adf_no_dev_config(struct adf_accel_dev *accel_dev);
 
 #endif
-- 
2.40.1

