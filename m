Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C3A246799
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 11:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746012918; cv=none; b=n9BZJi8X6ZAlOxaeQdGL/6sHANkso048UchyqXIQD/GdzMWN4uzj5+IT8laBZNAx+7aR+VdOcFsdpatqjpviUwOe9W4r6/Aa5m5jZJ7Z0QLhCLbWATbf6+zbxHbzikbm2AwqPesOnMYakT0+x78BuRnBiZArHTUPDG6A5oQLxj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746012918; c=relaxed/simple;
	bh=wQd4Wo6aGykoa0ObO1XiM7MHW833x9izyDBEZxVGSRk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pM1pm9QGhxREWBZr5fpPOwRcm7OmijnqN4idMdWGaLdap1X0C5B5B9aKdaWn2b7pVvZBGm1yYQETYKnXUjPW6pJQei++IfvfsvV0S2GhZFW/qdHfCOQtoWkSDR1HPQg8SPd5eD8ykcuyUJYbiSs/F4pLbBJNwK+coMeSHalL62o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SDFiS30/; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SDFiS30/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746012917; x=1777548917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wQd4Wo6aGykoa0ObO1XiM7MHW833x9izyDBEZxVGSRk=;
  b=SDFiS30/0aPPejMXkSE/4k6KPjIvu+rebpnFpHY72QyGkoeDQi3fqS/9
   6wr54r8fyqu2VLDsl10fWRPIjaXnj2HROZFuHoLavLR/rXH5ysKSD8pUf
   8fvNOwDl9ezJyNmsjMu5tlhMKraxm2B1WgvblTlaeJ3omGva2PAnK37UV
   xCccngsKNR/78AzbFJK44EV7ozGvd0TsW8YEt2/NeSEaydHs0rJgqRgl7
   GHpuf59/3b5DJB8+WOUA8FLqsuKQsh4xU5dN71W28berilYzMNQZOVZ8H
   oNkGjpHc8IVpOql2AiQey9Wkkk30Of38//ytb4wUyreIACFZgTMctL8x9
   A==;
X-CSE-ConnectionGUID: p3pEOKmFQv+yvUjr1hzRHw==
X-CSE-MsgGUID: Xo7XiT1ATzy82mdJsaMq9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51331160"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="51331160"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 04:35:17 -0700
X-CSE-ConnectionGUID: d3KsSuDzSCieQE2BCwqr8A==
X-CSE-MsgGUID: HGkKXLJXQqGfqXjCuLGMig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133812551"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa009.jf.intel.com with ESMTP; 30 Apr 2025 04:35:15 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 08/11] crypto: qat - export adf_init_admin_pm()
Date: Wed, 30 Apr 2025 12:34:50 +0100
Message-Id: <20250430113453.1587497-9-suman.kumar.chakraborty@intel.com>
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

Export the function adf_init_admin_pm() as it will be used by the
qat_6xxx driver to send the power management initialization messages
to the firmware.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_admin.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index acad526eb741..573388c37100 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -449,6 +449,7 @@ int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay)
 
 	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
+EXPORT_SYMBOL_GPL(adf_init_admin_pm);
 
 int adf_get_pm_info(struct adf_accel_dev *accel_dev, dma_addr_t p_state_addr,
 		    size_t buff_size)
-- 
2.40.1

