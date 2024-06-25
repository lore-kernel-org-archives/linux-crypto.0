Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E44416C6AE
	for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2024 14:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719326518; cv=none; b=YuzWv7y8+4A8Um3dGt0SxWVHiypX4FLZ71Hat0kP/Fu1qbOhhoSEuOSgp9xcWF2leDfFWrJChYiYzBY82/SxVoCja/QUr6NYPRZmK0leu64/FoTJqUaXYHy1aTI5Titrnncmb0rl0+keW1SW8hqBNStJB8HAlLchh2TngEt445g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719326518; c=relaxed/simple;
	bh=wGmnE2+rdmXlGx8/2odHwGZ+Ls8tK5BwMLXdI2hXtNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AKEHrKWCfMDY2fXzCasJ99oMzdxVUxPCGJed27CG5oR9c9Puvmb9OsohY3xS6efAS7HnohG9ktMYRp7yDiihqPL5Gs3/qriuW/pHCT5GKhR14ONxYO63icTTKcAw+fTxFx+msYr83WbsEZt9io99SDe+beYVLqmvJtbTpzUESbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iy7snxQm; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iy7snxQm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719326517; x=1750862517;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wGmnE2+rdmXlGx8/2odHwGZ+Ls8tK5BwMLXdI2hXtNc=;
  b=iy7snxQmAgANHkAuLKo+QXCPA63Cz/jZLD8PNE7ipW5pTS5z79+gHuFc
   uRCqIYnudA7xs2LiS3+YnoTHXxFB2eg2U8YRGA6vxFMTup0REo3evnShT
   DylzNMP3oWPpmxt+pJHY3mHQLn5q7ZgON7NG8lXkrUsq2VtoRyDWfucIs
   qOMhHM+6WJBdjCk1pqqsgIInsW+pfpb+fNL+Xe9f02JY5McT62Fu9fN5C
   FDhXP8vop4q9AozsPkYv9y4kMopnEeZEZPIvtUrjxqeMMcAB6GtlMQxoY
   wtPHMc7PWHKj5LPJzdJw9CLRDycCQpb7V/u2vpjhg3c8D5fwzYDYtqDPh
   g==;
X-CSE-ConnectionGUID: U2GEHmuRQ0yXziXzifccig==
X-CSE-MsgGUID: RaLsPDMBSj6pw32zxhZDvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16226024"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="16226024"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 07:41:43 -0700
X-CSE-ConnectionGUID: iZ8vD7hSTJSfUqwg1Syk2A==
X-CSE-MsgGUID: EH1HCIKYQwi3aHRoHQA0IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="43540629"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmviesa007.fm.intel.com with ESMTP; 25 Jun 2024 07:41:42 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix unintentional re-enabling of error interrupts
Date: Tue, 25 Jun 2024 15:41:19 +0100
Message-ID: <20240625144139.6003-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>

The logic that detects pending VF2PF interrupts unintentionally clears
the section of the error mask register(s) not related to VF2PF.
This might cause interrupts unrelated to VF2PF, reported through
errsou3 and errsou5, to be reported again after the execution
of the function disable_pending_vf2pf_interrupts() in dh895xcc
and GEN2 devices.

Fix by updating only section of errmsk3 and errmsk5 related to VF2PF.

Signed-off-by: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.c       | 4 +++-
 .../crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  | 8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.c
index 70ef11963938..43af81fcab86 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_pfvf.c
@@ -100,7 +100,9 @@ static u32 adf_gen2_disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
 	errmsk3 |= ADF_GEN2_ERR_MSK_VF2PF(ADF_GEN2_VF_MSK);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
 
-	errmsk3 &= ADF_GEN2_ERR_MSK_VF2PF(sources | disabled);
+	/* Update only section of errmsk3 related to VF2PF */
+	errmsk3 &= ~ADF_GEN2_ERR_MSK_VF2PF(ADF_GEN2_VF_MSK);
+	errmsk3 |= ADF_GEN2_ERR_MSK_VF2PF(sources | disabled);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
 
 	/* Return the sources of the (new) interrupt(s) */
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 6e24d57e6b98..c0661ff5e929 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -193,8 +193,12 @@ static u32 disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, errmsk5);
 
-	errmsk3 &= ADF_DH895XCC_ERR_MSK_VF2PF_L(sources | disabled);
-	errmsk5 &= ADF_DH895XCC_ERR_MSK_VF2PF_U(sources | disabled);
+	/* Update only section of errmsk3 and errmsk5 related to VF2PF */
+	errmsk3 &= ~ADF_DH895XCC_ERR_MSK_VF2PF_L(ADF_DH895XCC_VF_MSK);
+	errmsk5 &= ~ADF_DH895XCC_ERR_MSK_VF2PF_U(ADF_DH895XCC_VF_MSK);
+
+	errmsk3 |= ADF_DH895XCC_ERR_MSK_VF2PF_L(sources | disabled);
+	errmsk5 |= ADF_DH895XCC_ERR_MSK_VF2PF_U(sources | disabled);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, errmsk3);
 	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, errmsk5);
 
-- 
2.44.0

