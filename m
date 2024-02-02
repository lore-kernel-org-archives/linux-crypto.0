Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF4F13BEAE
	for <linux-crypto@vger.kernel.org>; Fri,  2 Feb 2024 10:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706871310; cv=none; b=qTLESVoJb/UY8W8IABWsLerH8DBylmFaQ9zpD/YrKrEjy1dpzuglW6B9HvYOgPj000TwGcnPU5gcPqD2USh9ER4VR5V+Q6w6CYY4aBbVhA/T/4Ye7p5uYdmqCCQTPOmQD0TGKCQlLIctUHguO1gj+u2GTx+ITVkR9sUG03lCI+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706871310; c=relaxed/simple;
	bh=tTcxQM8kmIDo3CaLAzaXTDwkgvDAxFeXC364HbFq7z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZfIuQeIud1W1B8ty0T3Oic0Z1NElR6zT0PbQy5BARwpnUZ0ZYsK3EHhsMfZ9jW4tIxCWO7emi3VzzxqDSm2J93MUSK3bjx656ocY1oxUQrVhVDQ0YoHbLEjxSHts6rdC81xojE4YGr+Vf+ttkFxn1RBNTukK4fiprPyCQDgj+Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AcCQqijC; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AcCQqijC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706871309; x=1738407309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tTcxQM8kmIDo3CaLAzaXTDwkgvDAxFeXC364HbFq7z4=;
  b=AcCQqijCdODB9ydQxW7KfKoGzdGXqe18zVbygkjBZ7R4hH2G1t5TCJIY
   kqIFCcEW7RN5ykCCiFN5582TLEf8xwhW7wMhYe60XVOQjJqz0nciJkDcS
   utMJS8/VWvvN+isVCSeO8VJ1HGAbtBoReyJA7nv9lx9ECaCdnePxm2QVF
   Y+aBUgXlcuTkFD9SOlzXVLOWUiRINI1nbpMOwqKBo1dUD16xn4f0YOTZx
   zf9nK20RcRIrF4tt2gC/BeCPU5ODc7sJdqEQuFcLqvD4sfMQgchJEBAXs
   YR8xr2XfR0rirFsi6nemaHDy4S9eOxbzFmL5rFzYunIYhexQcIsZwfBBF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="10787298"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="10787298"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="53583"
Received: from myep-mobl1.png.intel.com ([10.107.10.166])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:07 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Furong Zhou <furong.zhou@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mun Chun Yep <mun.chun.yep@intel.com>
Subject: [PATCH v2 3/9] crypto: qat - disable arbitration before reset
Date: Fri,  2 Feb 2024 18:53:18 +0800
Message-Id: <20240202105324.50391-4-mun.chun.yep@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240202105324.50391-1-mun.chun.yep@intel.com>
References: <20240202105324.50391-1-mun.chun.yep@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Furong Zhou <furong.zhou@intel.com>

Disable arbitration to avoid new requests to be processed before
resetting a device.

This is needed so that new requests are not fetched when an error is
detected.

Signed-off-by: Furong Zhou <furong.zhou@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Markas Rapoportas <markas.rapoportas@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Mun Chun Yep <mun.chun.yep@intel.com>
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

