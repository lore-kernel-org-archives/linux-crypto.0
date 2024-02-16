Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63581132C15
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 17:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708105541; cv=none; b=WJftImsZScCidtKGyRcmTBCli8COH8vLzrNhZDigFwv+HxGjnEzG5egLt9+YDlGfHpmuISs2CTk/bjRqw6xyf9m/lMLNUlbzagXYR2v7jtgrygYcqMgystXzUeQiK8kKsMl+Zcq0ZXChQ3ObIRZ/ft17WPHyEWfQH9x4uyAeS68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708105541; c=relaxed/simple;
	bh=nNpaXMY7wmBj2HBStNwk2DswlF44i6tMv0Vn/yB8Rw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o19SeuUz39KLetWgbElwBtzREDUZ7jaYpUwXLO7GxhADzI2hqUyRBnVbl4Lqn9qrKIexsnvpLRYuL4R5Ii3Tfu6vd8slH5G9PaKejiWWM2s2SnwyiscA12ZQOyFmFw4Rj+a5Mb8oytSjRHYikBPUrj/u72yN12yDgdJYkqQHXzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TuJwAjP6; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TuJwAjP6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708105540; x=1739641540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nNpaXMY7wmBj2HBStNwk2DswlF44i6tMv0Vn/yB8Rw8=;
  b=TuJwAjP6Xu/m92lMeUC/vBFCN9mJPJyOFg8p5zFIbU/6rAcnVTI3SR19
   cXE6YyX5xCz0UdIVrR5h+bXi7KRR5cGY9nhuKc/ERe1G/eK/yQfQtDz57
   QYlUsaIgZJNMpwtF+G1qWoYQqUXVnFeomSQp/KqMjpN2x5KJ8uOPNs7ZB
   Licjw48mBO/bwIOwWLk0H3eGFORBXvqrbYl1l97NVZMNmjIhBA2ICkvU6
   pJprrhfHTDRBQPTM+nVBLaCBC4HQmAgQRE0ibNO9HePjtc/Q8cB+9y5f2
   xyGzdkiyJGSfazZNrs249kDq628sxUgBRTbt/mJJ/cBJA6uZ8ngCdFUs+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="2097832"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="2097832"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 09:45:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="8507272"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmviesa003.fm.intel.com with ESMTP; 16 Feb 2024 09:45:39 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/3] crypto: qat - fix ring to service map for dcc in 4xxx
Date: Fri, 16 Feb 2024 18:21:54 +0100
Message-ID: <20240216172545.177303-2-damian.muszynski@intel.com>
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

Fixes: a238487f7965 ("crypto: qat - fix ring to service map for QAT GEN4")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 94a0ebb03d8c..e171cddf6f02 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -331,6 +331,13 @@ static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
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
@@ -359,6 +366,7 @@ static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
 		}
 	}
 
+set_mask:
 	ring_to_svc_map = rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_0_SHIFT |
 			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_1_SHIFT |
 			  rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_2_SHIFT |
-- 
2.43.0

