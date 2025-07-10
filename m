Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EED2874F9
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 06:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752129597; cv=none; b=R1xmocF2fwft+jHTT0aI2TVZI24zRN3LnYJEI0s9XUaMUXaJfP578W5TZNy6bkgMSmQlZwEqz7gak7YfSWe2NB+9AOPk0S5FOm/srnNYPsoliMoQeyCBTC593iVBHlEPySVTmfon2NUgDwQYBnlyDS6oef87K1LJjUf5pvotVaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752129597; c=relaxed/simple;
	bh=d+LTDUtU8Ru8BkSx7fRT3D/9s5COZBUYEVHS7x/ITFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hkTM7p878VrB5mP+AtL2GONEnLBG6Z3NepKoj7O0/VSbTRC+7wxv6y0AG+nfe9TkqyMKlOli+RD8zPaXQsTvB9RCOP4NpCdcsTbbioP+bfoiNSCw7Hfde6oHfMnew6qXja8Lnxk3DNg9dchAz+B6ENaPTSkcNmz48VH1si65v7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GzGQTokT; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GzGQTokT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752129596; x=1783665596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d+LTDUtU8Ru8BkSx7fRT3D/9s5COZBUYEVHS7x/ITFY=;
  b=GzGQTokT2Fw1cyAoj9vCzZXKoAKyZbqDJmztsxLR1gAv091Eo9RBDLcQ
   wWHpw+gpsBxrCpBEMswk7XZOXnOOkloodIckOvzw0ylKXHgXjLOWzfvyX
   C8yIuk6fd6dfJkuz38TeOR3V/3q/x+kkkrqP3lKv7NFtu3owWrFg5vZZ1
   UuXC3/7uWbpcZBOl+0HLqTucHXe0LX1qYRf2MnpSVvayjzS6yQwXvmqJV
   9YyjTuhkZxny7aQZ2DIt5nzTj7N25ZTZ6iavRCcJ/AxMggIizLSak5PdD
   6PizzaqQEb46RXlqwOKvO2q2KOBbo08qFglWg5f1uTQnO50U2lx8WUAwa
   Q==;
X-CSE-ConnectionGUID: ppsqPf8vTb+q+BoIFDV4Rg==
X-CSE-MsgGUID: YoLP4jAWRYmexl0EQRyAYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="53512244"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="53512244"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 23:39:55 -0700
X-CSE-ConnectionGUID: mq/dopnFTViyk+QMRuq3Ug==
X-CSE-MsgGUID: 5qBLx+daSyymios5mXRUVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155632195"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa007.fm.intel.com with ESMTP; 09 Jul 2025 23:39:54 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 1/3] crypto: qat - add decompression service to telemetry
Date: Thu, 10 Jul 2025 07:39:43 +0100
Message-Id: <20250710063945.516678-2-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250710063945.516678-1-suman.kumar.chakraborty@intel.com>
References: <20250710063945.516678-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>

QAT GEN6 devices offer decompression as an additional service.

Update the telemetry ring pair service interface to support monitoring
decompression operations.

Co-developed-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
index f20ae7e35a0d..a32db273842a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
@@ -538,6 +538,9 @@ static void tl_print_rp_srv(struct adf_accel_dev *accel_dev, struct seq_file *s,
 	case ASYM:
 		seq_printf(s, "%*s\n", TL_VALUE_MIN_PADDING, ADF_CFG_ASYM);
 		break;
+	case DECOMP:
+		seq_printf(s, "%*s\n", TL_VALUE_MIN_PADDING, ADF_CFG_DECOMP);
+		break;
 	default:
 		seq_printf(s, "%*s\n", TL_VALUE_MIN_PADDING, TL_RP_SRV_UNKNOWN);
 		break;
-- 
2.40.1

