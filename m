Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741803DBD74;
	Wed, 20 May 2026 12:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280336; cv=none; b=fCVWIbdaG5BRGJDFQu0yRpm1sYeFRbRCXTXL0XXy2+O2qq1Y/NUTkJxUCm2Ag/VxcGXaVFTlfEcj+HKQknvtnwdmJrs3ILa5wxnaHvaKGgD8BJ4MBK3CaRIjxx3Np9VH0sq39xX9juU0IHsOzdFOu8/3r0qiahJbaAVTjdNgA38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280336; c=relaxed/simple;
	bh=j45hF3TbE2ckhDdgGSpYmjgf0nuwDYmtOhNC8EqphcM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=I876i6m2y7K9IVO5zdAJ6+BwQew8/myj4Y/2L+yn7LNmbwh0FZTTIoQqw6v7axUXeKptBIo+7uOl+SoLHkbXfVT3pOcb/1G66vp6gmkfLz3gkoNOkTWx2ZxF61yh/7ql9wY2ghliqxqf4ceSIxOJ7RVUeazqxYH0kwlvQND2u4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n6KoLBmI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n6KoLBmI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779280336; x=1810816336;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=j45hF3TbE2ckhDdgGSpYmjgf0nuwDYmtOhNC8EqphcM=;
  b=n6KoLBmI2kLufrQvNzEQy94+MNhBIHTfEOi/nWwxfUjiZggmmUkYqL2l
   tuX0nE/fWU2r0EX+OLvWyZpy3Xg71EMZUAwkc7MPaShguDRr59Kgi0dml
   pTkPva6ylwrC2Rqd4UEp3uuo590DK9dbXn4sh5E+JHhIk5typjo1MNlst
   ADdCw32dAndUmYSAP4Vk57PD87AgCrMesop9nz/puFIDDeWpfxDZA8Qv4
   mX64FKIJyItOS8XjZHKAGW0/fXk+J2bOgFX+eyd7B5I5of+kmfvHecrVa
   EAjXM+uxlR7YF4JbRPby1wi4aJ4Sr7/Yf1DbGtHPg5vTY2FM6HtQuIlww
   g==;
X-CSE-ConnectionGUID: C2fnL1BAS3KFDcooVFCtZw==
X-CSE-MsgGUID: 3Pe6fd94SjC6gxpN7pNBvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="90473643"
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="90473643"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 05:32:15 -0700
X-CSE-ConnectionGUID: 0Zh5g+8WRj6cEGzm1a7rmg==
X-CSE-MsgGUID: 6Itc0urkSuiT5PRuscATiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="235902473"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa010.fm.intel.com with ESMTP; 20 May 2026 05:32:13 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	stable@vger.kernel.org,
	Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix restarting state leak on allocation failure
Date: Wed, 20 May 2026 13:33:00 +0100
Message-ID: <20260520123300.210290-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In adf_dev_aer_schedule_reset(), ADF_STATUS_RESTARTING is set before
allocating reset_data. If the allocation fails, the function returns
-ENOMEM without queuing reset work, so nothing ever clears the bit.
This leaves the device permanently stuck in the restarting state,
causing all subsequent reset attempts to be silently skipped.

Fix this by using test_and_set_bit() to atomically claim the
RESTARTING state, preventing duplicate reset scheduling races under
concurrent fatal error reporting. If the subsequent allocation fails,
clear the bit to restore clean state so future reset attempts can
proceed.

Cc: stable@vger.kernel.org
Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Co-developed-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index af028488e660..3fc7d13e882c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -207,13 +207,14 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
 	struct adf_reset_dev_data *reset_data;
 
 	if (!adf_dev_started(accel_dev) ||
-	    test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
+	    test_and_set_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
 		return 0;
 
-	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 	reset_data = kzalloc_obj(*reset_data);
-	if (!reset_data)
+	if (!reset_data) {
+		clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 		return -ENOMEM;
+	}
 	reset_data->accel_dev = accel_dev;
 	init_completion(&reset_data->compl);
 	reset_data->mode = mode;
-- 
2.50.1

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

