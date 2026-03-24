Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A861F3DFC9D
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774350681; cv=none; b=W3OR9HXUeU48jvwZ4eD6iarPc+5bB3vkhjRqiLmVGh5vp24ooe7f0CW7jBgKIsq7OPYPauCmyCj2++kYDbgUnxbhhBmirxhdFs+Yk7KqybKjNLvHhEGZotPevygw3kgac879HmI9FgzmAVw/E+vuoDYU9tuGxQsb1Qkg7h471ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774350681; c=relaxed/simple;
	bh=C/R2vr8NFSLflsvG9YOykJy05GHUw2nImRAUCVrR5BM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bYtpSwKc/KghYnlUco1824fvpBBRk8cU25cECvHU7emZkHBm7i48rpXeYlNoiJj1uAL5GWA7eF6ejzX5pnfPAlqk7M2583czDNDQVEF7vBNBWavhnkejtm4RarYi65bFoR8/Yvt2DI7bUFk6032Pe6zf3hPwfQniRsbufD1ELYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ilsAL1+O; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ilsAL1+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774350680; x=1805886680;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C/R2vr8NFSLflsvG9YOykJy05GHUw2nImRAUCVrR5BM=;
  b=ilsAL1+Oh9HmZFfzq5OlHEWBM5PiZfm3c49st/C26hM/srQuU5dCOe/N
   kKP53F7QNvRZvkZhEOch1CblEiNHkpgsHXzc46Pm5mez1YwTGOgkgIZE/
   RvzHmy+IXLlXSZHnp0Kb/KaMkUvxS3/FXS5Qnz8wjaQ4p4hOYF5DK7YJ7
   L/PzWVWd/by9EYGWh3EC0C0hDSUs5yXPdYOiExIN4al0yHQuQR2WQEzcK
   PSqTptPFD0GvI8Uv0AasZt/XrIniLGgo/ttgZJmsE7JQq6AfWB0vg0PPz
   rqHDEeQCCEqU7BDyF29W32DmFA5tsh203gp/vuwJFXs5eohRFtHDzaVH2
   w==;
X-CSE-ConnectionGUID: W3ITbFyJQPSiAKPGVytZVg==
X-CSE-MsgGUID: /Ct1ohQNSlGyozPN2tmL/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="79271721"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="79271721"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 04:11:20 -0700
X-CSE-ConnectionGUID: PjFfTj6sQxqg4h7XASZ5bw==
X-CSE-MsgGUID: K05nOfJsRTmq2JyZBaT1tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="224292744"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa009.jf.intel.com with ESMTP; 24 Mar 2026 04:11:19 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - disable 4xxx AE cluster when lead engine is fused off
Date: Tue, 24 Mar 2026 11:11:12 +0000
Message-ID: <20260324111112.227158-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Corporation....
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The get_ae_mask() function only disables individual engines based on
the fuse register, but engines are organized in clusters of 4. If the
lead engine of a cluster is fused off, the entire cluster must be
disabled.

Replace the single bitmask inversion with explicit test_bit() checks
on the lead engine of each group, disabling the full ADF_AE_GROUP
when the lead bit is set.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Fixes: 8c8268166e834 ("crypto: qat - add qat_4xxx driver")
---
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 740f68a36ac5..900f19b90b2d 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -100,9 +100,19 @@ static struct adf_hw_device_class adf_4xxx_class = {
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	u32 me_disable = self->fuses[ADF_FUSECTL4];
+	unsigned long fuses = self->fuses[ADF_FUSECTL4];
+	u32 mask = ADF_4XXX_ACCELENGINES_MASK;
 
-	return ~me_disable & ADF_4XXX_ACCELENGINES_MASK;
+	if (test_bit(0, &fuses))
+		mask &= ~ADF_AE_GROUP_0;
+
+	if (test_bit(4, &fuses))
+		mask &= ~ADF_AE_GROUP_1;
+
+	if (test_bit(8, &fuses))
+		mask &= ~ADF_AE_GROUP_2;
+
+	return mask;
 }
 
 static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
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

