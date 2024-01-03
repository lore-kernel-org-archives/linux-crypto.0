Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C80171B4
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jan 2024 04:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HRFhfGQc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704254983; x=1735790983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0V3Cnp5ffigkOemm10iHnLzjCJAf2Q16UKbiSDERbs0=;
  b=HRFhfGQcY3Ca+JxBZmOrSY9zsmBgCeALITQBgDjU/zuFyZqvQWDozt9f
   U/UNeyr3vtft4O6Nu4CN3r14UYbENJMvUm40wHkmGhYOkvvcYSsfXtXu8
   lX0z6VSdGJ25Fg4EbqxNgD80+rinqX2odsRF7gDyPA+A8BTDrMPFw2nxV
   G0Pi0DP7nuj6Uztf26A5osDrK5nnvKmn1YjtQ/AZpTYTe+a+Qejaq0v73
   CsPfcq3Ge1mneJfNRlPaKaBzdQ/m0fjcG3thYJIV1qV7ySEPKWjR9SGPC
   +MK11QKgY5kkqQp1epJ3NcTg9h/YESqUmaPEInW8x1eUWXEpX2GPwisWg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="3725531"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="3725531"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:09:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="1111241929"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="1111241929"
Received: from myep-mobl1.png.intel.com ([10.107.5.97])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:09:39 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Zhou Furong <furong.zhou@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>
Subject: [PATCH 3/9] crypto: qat - disable arbitration before reset
Date: Wed,  3 Jan 2024 12:07:16 +0800
Message-Id: <20240103040722.14467-4-mun.chun.yep@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240103040722.14467-1-mun.chun.yep@intel.com>
References: <20240103040722.14467-1-mun.chun.yep@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhou Furong <furong.zhou@intel.com>

Disable arbitration to avoid new requests to be processed before
resetting a device.

This is needed so that new requests are not fetched when an error is
detected.

Signed-off-by: Zhou Furong <furong.zhou@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Markas Rapoportas <markas.rapoportas@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 22a43b4b8315..acbbd32bd815 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -181,8 +181,16 @@ static void adf_notify_fatal_error_worker(struct work_struct *work)
 	struct adf_fatal_error_data *wq_data =
 			container_of(work, struct adf_fatal_error_data, work);
 	struct adf_accel_dev *accel_dev = wq_data->accel_dev;
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
 
 	adf_error_notifier(accel_dev);
+
+	if (!accel_dev->is_vf) {
+		/* Disable arbitration to stop processing of new requests */
+		if (hw_device->exit_arb)
+			hw_device->exit_arb(accel_dev);
+	}
+
 	kfree(wq_data);
 }
 
-- 
2.34.1

