Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C09258CF6
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 13:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154437; cv=none; b=den7ClFZPC+Cse34csSPabprAai22U2nhYQLNiE6hx16nHafqFqGmtzhbpA1GVA/Kwqp7rvcSyFNFTrzZfAFl8ZXFWkEbX3GKGraCJ7+w+ZJFANo/6bsynWZ3l3cJZA5SRE/zObGEqx4b6zBgFUqo0vhfNNhDGNopgSnDuybK6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154437; c=relaxed/simple;
	bh=q9pMQPXMFg+H7xa5R0pdDTfZV30sIa/Jqj98uEaEH6s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KF31FzMTuySo4pxO7zZgskfWWQ2mo49sUN4dXYU7ylmUBvoBbt2SzTIV3ZkpUEcml95jJGn8e2JKRm84ULN7T0Zm5vvjpI/y7V3o2CPJxT3f1C4odEicsocHWpvxdiIBSZaZYEdJaGi/DQi2913lJwCbhK/QsJ7DBm6dkC6TDVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UAiHAIMS; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UAiHAIMS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752154436; x=1783690436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q9pMQPXMFg+H7xa5R0pdDTfZV30sIa/Jqj98uEaEH6s=;
  b=UAiHAIMSyr3SFwf5M8eSCN99BZpmHdTRWseq3FIq/k3YwhMW60Us5S06
   66VNLAODPovStDONh5aNc2H2tTJ2XeAuLYmkEiLQ1diETy+wPiVKtgQs1
   +i8BQVRgQTIEPBJi3RXxQMVpWpXydzPxNlk8MQ56XWOu2MK4DAijkk6eI
   uS30Ua+BBmuVV54zgogQAnm7w5kAxMy6miVFN8l5u9JM5f/KVa/oSh0QW
   ocoXz1a1syKUfZMelbCdmG88RPDRpjgkTEoRDznM3WK5TIL+eFueh91/A
   VxIw0A6pPFtLXqxL4n+d15wtjXzzEen1AAlPx17rSnKUZdlNiA9MYr/lB
   g==;
X-CSE-ConnectionGUID: bTx1BklnRw+1NHUGMBK82w==
X-CSE-MsgGUID: iatOVfgBRbC9LrLsROhSVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="58241833"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="58241833"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 06:33:55 -0700
X-CSE-ConnectionGUID: IJwziRGMQeWNU225qdb3Jw==
X-CSE-MsgGUID: 3qFmNW8/SKmoy/g5J+BX9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155494645"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa006.jf.intel.com with ESMTP; 10 Jul 2025 06:33:54 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 2/8] crypto: qat - add decompression service for rate limiting
Date: Thu, 10 Jul 2025 14:33:41 +0100
Message-Id: <20250710133347.566310-3-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
References: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new base service type ADF_SVC_DECOMP to the QAT rate limiting (RL)
infrastructure. This enables RL support for the decompression (DECOMP)
service type, allowing service-level agreements (SLAs) to be enforced
when decompression is configured.

The new service is exposed in the sysfs RL service list for visibility.
Note that this support is applicable only to devices that provide the
decompression service, such as QAT GEN6 devices.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c       | 2 ++
 drivers/crypto/intel/qat/qat_common/adf_rl.h       | 1 +
 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index d320bfcb9919..03c394d8c066 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -177,6 +177,8 @@ static enum adf_cfg_service_type srv_to_cfg_svc_type(enum adf_base_services rl_s
 		return SYM;
 	case ADF_SVC_DC:
 		return COMP;
+	case ADF_SVC_DECOMP:
+		return DECOMP;
 	default:
 		return UNUSED;
 	}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.h b/drivers/crypto/intel/qat/qat_common/adf_rl.h
index 9b4678cee1fd..62cc47d1218a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.h
@@ -28,6 +28,7 @@ enum adf_base_services {
 	ADF_SVC_ASYM = 0,
 	ADF_SVC_SYM,
 	ADF_SVC_DC,
+	ADF_SVC_DECOMP,
 	ADF_SVC_NONE,
 };
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
index a8c3be24b3b4..43df32df0dc5 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
@@ -35,6 +35,7 @@ static const char *const rl_services[] = {
 	[ADF_SVC_ASYM] = "asym",
 	[ADF_SVC_SYM] = "sym",
 	[ADF_SVC_DC] = "dc",
+	[ADF_SVC_DECOMP] = "decomp",
 };
 
 static const char *const rl_operations[] = {
-- 
2.40.1

