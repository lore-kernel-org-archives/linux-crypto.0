Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAF24B1D11
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 11:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792408068; cv=none; b=tLQXOw6CPPfYZuEdu+1EcPTiFUVs8DW53O3beFiEoV4TW4ImtikqbKGnCGzTSKbYdgMIZ9Jdi6eYXXtUIt/2sCw9YNKp5WGPv9P0lhoIWpsdvLtklENNovADYwCzEaiQEW4u5lRNcSzrv+BqPlHOKoyGMSXFDHL/Uzcv3ocytDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792408068; c=relaxed/simple;
	bh=Pz2Tl6OWI+OLHva69WSGHQUYuZ5OwaTb95AqnAqI3Gk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fK0rjVPGY6WySr99PLLART0fuyxokuVVlxcoY1ctEI2qpniH6pzuMmna8dhLjDkRdtJHItortShweoHdCmou8326qZkJz/F2SHSzZBgTrGnbQSbOawiMBbbW0kkkIq8DtirjIQd+4bN4dWW0TRvZO+d6UQH7DIvMsFU3cYFR9g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AFp61BVr; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AFp61BVr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792408068; x=1823944068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pz2Tl6OWI+OLHva69WSGHQUYuZ5OwaTb95AqnAqI3Gk=;
  b=AFp61BVriqPeI8KuWJgbQdkhkv0CdibMWymXwSJqp8XcpOPCaya4Gbv4
   /7DK5VR4RGm6uZ6a3wgrizH3pl8xx8XWlrzZEamoawk1zPVumGJT8ttMK
   gbAxWn9Mwf0LiE+6iTvpcGP9fKQ2RH6tMvev4EJAloMWMsajnjheXjskW
   0+/EIcumZRTprxW7MYeI8vjMHhjuc68BfE/9jRsbclXeg0y+QYUKZH2Xo
   F4VjKxQvTNszWZ0b52yyxOPLCuQITmMLXlIYp1nV16Xw2vUeXWJns5jrE
   UwrS9QFYx5hdCujGJ7Uc30LnCUEL4oB7ynBF3N4Eww1EbfEsFD1yKFbnV
   w==;
X-CSE-ConnectionGUID: MyGVV1ntTpuHjyKxdxfITw==
X-CSE-MsgGUID: QG8AzwYURFuS6cbxu2niFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="1088250"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1088250"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 04:07:46 -0700
X-CSE-ConnectionGUID: DeJexhD9TomWNXjsr6FF+w==
X-CSE-MsgGUID: Ov7eXwMPQDamGAi5oq/hrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="4267839"
Received: from indlpbc065983.iind.intel.com ([10.49.120.87])
  by fmviesa012.fm.intel.com with ESMTP; 19 Oct 2026 04:07:44 -0700
From: George Abraham P <george.abraham.p@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	George Abraham P <george.abraham.p@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 1/3] crypto: qat - validate rate limiting only for enabled services
Date: Mon, 19 Oct 2026 16:33:54 +0530
Message-Id: <20261019110356.3781949-2-george.abraham.p@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20261019110356.3781949-1-george.abraham.p@intel.com>
References: <20261019110356.3781949-1-george.abraham.p@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rate limiting validates the throughput limits for asymmetric, symmetric
and compression services unconditionally. Devices that support only a
subset of these services (for example, QAT GEN6 wireless) can leave unused
throughput limits unset, causing rate limiting initialization to fail.

Validate the throughput limit for each enabled base service instead,
skipping services that are not enabled. The check also covers the
decompression service.

Fixes: 464da0bf19fd ("crypto: qat - add wireless mode support for QAT GEN6")
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 997ef448a4df..d083276f69cb 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -1050,14 +1050,19 @@ int adf_rl_init(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
 	struct adf_rl_hw_data *rl_hw_data = &hw_data->rl_data;
+	enum adf_base_services svc;
 	struct adf_rl *rl;
 	int ret = 0;
 
-	/* Validate device parameters */
-	if (RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[SVC_ASYM]) ||
-	    RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[SVC_SYM]) ||
-	    RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[SVC_DC]) ||
-	    RL_VALIDATE_NON_ZERO(rl_hw_data->scan_interval) ||
+	for (svc = 0; svc < SVC_BASE_COUNT; svc++) {
+		if (adf_is_service_enabled(accel_dev, svc) &&
+		    RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[svc])) {
+			ret = -EOPNOTSUPP;
+			goto err_ret;
+		}
+	}
+
+	if (RL_VALIDATE_NON_ZERO(rl_hw_data->scan_interval) ||
 	    RL_VALIDATE_NON_ZERO(rl_hw_data->pcie_scale_div) ||
 	    RL_VALIDATE_NON_ZERO(rl_hw_data->pcie_scale_mul) ||
 	    RL_VALIDATE_NON_ZERO(rl_hw_data->scale_ref)) {
-- 
2.40.1

