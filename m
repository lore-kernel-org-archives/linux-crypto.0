Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7527723F405
	for <linux-crypto@vger.kernel.org>; Mon, 30 Jun 2025 09:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751275313; cv=none; b=ggenWMp0RXrYfo4CTAxWQLeTx2EDKmGJlC0d8Cl8eqgj789qvTLr85AyZJ8bipGBQJmyo/Ezor/9wZpXrDg+cNrSdIRVsplyrFPriRowCuI7oc2VZVBUgE6Q37iDaBMI2YV+aSPhkAIHzO6w8BUufZGtkbGtVU18E9LA37tw1VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751275313; c=relaxed/simple;
	bh=0Ra7ZREU2UOx+Y2diWLUE/UBYL2lGgw+yYgJGgIaejA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G//U4BZUnY2N/eWwk2XgU84JFg5kGz/R+uToHnv1QVZ/tUeEx5odnOjVjw4MBcNT7r3iqO+nx1vzqeSXJLQxqm7TcXidGpKdSMyiVuzlnFZMrqjUffsRmx9ogoxj/iLqh0Q/ZoyIN8vYghUy5SiGzI+3tsUgUti7ZIVaMK5cxI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LWZHzc4a; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LWZHzc4a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751275311; x=1782811311;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0Ra7ZREU2UOx+Y2diWLUE/UBYL2lGgw+yYgJGgIaejA=;
  b=LWZHzc4a+qF8LKW8rs5vxcKZYU6vwTQPbHgnbETylerQ+b3DKhKhf47K
   HH01+vRFGm+zWCChOYYatjE/GgHxtKOLB54PPPl5K/SfQZv7LuqiQqn7l
   nWmQpnHQOsdtwoDFZbhYPeixWDNmijRymCQRr5OM90KPjK0jFkG3nEAGS
   ctqKUTAOnPhY7qxqp9VNjZ/0t2QybVQ1k2s7OvBPydNbjRCMHTyJtETel
   HuSaZ9VlmHCMMMJG/vm2EDuIHKs6aWlnpKwUeNXDhtDZj3pm3Hx4StuXr
   fQHPjHpLjKIS/Ra6vEzibKH5wPsYsNCbPApIVvd/K2NIlRomgd5ZgZkEO
   w==;
X-CSE-ConnectionGUID: 5XlKY3+MRyuL5F0WlXCBEA==
X-CSE-MsgGUID: 84pDtuvqSdqtcNHUz3FAzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="64091275"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="64091275"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 02:21:50 -0700
X-CSE-ConnectionGUID: F9mNJbEBSHqe7ZUzfDme8g==
X-CSE-MsgGUID: EnwxdKnUSEWtvasJWnRXuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="153949321"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa008.fm.intel.com with ESMTP; 30 Jun 2025 02:21:47 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - disable ZUC-256 capability for QAT GEN5
Date: Mon, 30 Jun 2025 10:20:49 +0100
Message-ID: <20250630092103.17721-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

The ZUC-256 EEA (encryption) and EIA (integrity) algorithms are not
supported on QAT GEN5 devices, as their current implementation does not
align with the NIST specification. Earlier versions of the ZUC-256
specification used a different initialization scheme, which has since
been revised to comply with the 5G specification.

Due to this misalignment with the updated specification, remove support
for ZUC-256 EEA and EIA for QAT GEN5 by masking out the ZUC-256
capability.

Fixes: fcf60f4bcf549 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 7c3c0f561c95..8340b5e8a947 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -191,7 +191,6 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 			  ICP_ACCEL_CAPABILITIES_SM4 |
 			  ICP_ACCEL_CAPABILITIES_AES_V2 |
 			  ICP_ACCEL_CAPABILITIES_ZUC |
-			  ICP_ACCEL_CAPABILITIES_ZUC_256 |
 			  ICP_ACCEL_CAPABILITIES_WIRELESS_CRYPTO_EXT |
 			  ICP_ACCEL_CAPABILITIES_EXT_ALGCHAIN;
 
@@ -223,17 +222,11 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 
 	if (fusectl1 & ICP_ACCEL_GEN4_MASK_WCP_WAT_SLICE) {
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC;
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_WIRELESS_CRYPTO_EXT;
 	}
 
-	if (fusectl1 & ICP_ACCEL_GEN4_MASK_EIA3_SLICE) {
+	if (fusectl1 & ICP_ACCEL_GEN4_MASK_EIA3_SLICE)
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC;
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
-	}
-
-	if (fusectl1 & ICP_ACCEL_GEN4_MASK_ZUC_256_SLICE)
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
 
 	capabilities_asym = ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
 			  ICP_ACCEL_CAPABILITIES_SM2 |

base-commit: 864453d2e854790ec8bfe7e05f84ecdb0167026d
-- 
2.50.0

