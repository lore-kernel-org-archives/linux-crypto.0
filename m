Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8458132C3B
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 17:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708105544; cv=none; b=bhHybe2MXkaUHCezb4fJKmm3i+SXe/m8uhXkCLzYHHriC1ktlWZoxT0pBLzPODPBeC88Gy8KASppNbS9hTFybv7Z6SiogLELqwK6uidF4/hDCP94BpW2zyyptgV6U/Cv145Ija/Y9cNoqXZji5Ip/WVprQoJNaVJjvrnzHzDm/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708105544; c=relaxed/simple;
	bh=uS8qX+DnJ96dXIhMxMu1q5NaH+mtHmUFkB4wj+myIhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7vAWt651lmj0fEVjT4mV+zxDelNMRBUh7t8n2PIHv1bRJBajPdw6rqOQy2Zi3ZMpeVbf2nFqQVgbMHaiudFlyCfbqBk1uvH3T2cJwk8Xktm2wM+OOxgeBHIYUkcue1fBn81zK4LgGGCdq/qyvnAKD7lbnaH70a9h0Kk2SFD0fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yj/1QrZd; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yj/1QrZd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708105543; x=1739641543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uS8qX+DnJ96dXIhMxMu1q5NaH+mtHmUFkB4wj+myIhw=;
  b=Yj/1QrZdYanKUisCOi9PUf1nl9P9/9X6CuSeGKYrZbXUkrmeYeWa1+8h
   Lkyn0iO/tBj5S2YGbLOfVVwspiNL1VhPjM25lbTXL9X66bIUJI+75UeXy
   JL2r0JmiB724Wlh8xpAxB1DhxZMiGLGIGQhiJWu3+duJtEsK4z7GrA8HN
   cWAvUQZjxmIPS1cAEd6lYbcS7fXv3RBcBp77rDpOJdWcnzT7EbJOM+tSJ
   wMzN84+r8Q939DSGcW7GYcbFSE3FXaDtBH789lpkLjPFxSVIAnKta3aHk
   DOylJbzIppzDWdd2kr87QyTdYCMkAtgCPhIBE2Tq6PByncH88ufZCL1Uq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="2097840"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="2097840"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 09:45:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="8507286"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmviesa003.fm.intel.com with ESMTP; 16 Feb 2024 09:45:42 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/3] crypto: qat - fix ring to service map for dcc in 420xx
Date: Fri, 16 Feb 2024 18:21:55 +0100
Message-ID: <20240216172545.177303-3-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240216172545.177303-1-damian.muszynski@intel.com>
References: <20240216172545.177303-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

If a device is configured for data compression chaining (dcc), half of the
engines are loaded with the symmetric crypto image and the rest are loaded
with the compression image.
However, in such configuration all rings can handle compression requests.

Fix the ring to service mapping so that when a device is configured for
dcc, the ring to service mapping reports that all rings in a bank can
be used for compression.

Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index a87d29ae724f..7909b51e97c3 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -372,6 +372,13 @@ static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
 	if (!fw_config)
 		return 0;
 
+	/* If dcc, all rings handle compression requests */
+	if (adf_get_service_enabled(accel_dev) == SVC_DCC) {
+		for (i = 0; i < RP_GROUP_COUNT; i++)
+			rps[i] = COMP;
+		goto set_mask;
+	}
+
 	for (i = 0; i < RP_GROUP_COUNT; i++) {
 		switch (fw_config[i].ae_mask) {
 		case ADF_AE_GROUP_0:
@@ -400,6 +407,7 @@ static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
 		}
 	}
 
+set_mask:
 	ring_to_svc_map = rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_0_SHIFT |
 			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_1_SHIFT |
 			  rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_2_SHIFT |
-- 
2.43.0

