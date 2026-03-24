Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEB13E6DE1
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774350772; cv=none; b=c0u4rfhMiIxuQ+Omt7mS6LgIPQO57PwpIg66lBPNVxKEtIpwH5eZoDGDyNAW2RBR75DcCKlGrw4aVrsXdTrkmA8vODoxEhrZcxJb6mj9qst/FuxBjHWCrMQeMQx0DPxLgmYBBdEicRhF66koU6Zk7qy5PMVqSizlWF53kvQcvCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774350772; c=relaxed/simple;
	bh=cddc3tnx8VIEeDiR+s9ZvIptZDljE4Shkj8TPlaHS0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XXUNU49vOMF0GKRa9t0RZ9+dWnz4p60ni3hWHE9WBCBPzGBWP6xQHbiPzi0pSgg0GkBKB/OXkOUCC8okMn6fkK78ilXQiVLNBe8bn78vfxOKodGpQyarCbaOYNXWCAQqOa+MHola62np3RKiHxySiYlWrieP9yOHMO/c39K18FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TmEzk208; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TmEzk208"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774350770; x=1805886770;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cddc3tnx8VIEeDiR+s9ZvIptZDljE4Shkj8TPlaHS0k=;
  b=TmEzk208LPorqzLyRxCT/0y7D+PlS/BsxzZyrJm8RbmYqEgJiEGT8CjL
   UQDZc6TA7TUNQ+ZG1IUMfZMKJVrbKm7v5+Gg+cAt/I8CMIwx96/P+Mu91
   1qaTVX1GleljQtWPfNIjR6W4voIIqzKuqAAlBJ0mszGZscU7jGjcZBon5
   qfcWJhStqOiHm7F5uil6AFEDynJroYKovOyI+oNdTlPZia/sG2BL8RPgr
   u31unZRMuOYIOP53AzuhRUJt4AfZ40TVQ46ECThc2rcqsYNr9raP/FFNY
   /e8bCoaQ/m0N1PwaP9GIbbJ7ZC6opKq6QaHWOUQ34Z8eGjaHhYZEZpNyg
   g==;
X-CSE-ConnectionGUID: WCqXl3w9Sp+lFWv8CwaWZQ==
X-CSE-MsgGUID: 7lVsEJF5RtOx+VtXBgHJgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="86732932"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="86732932"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 04:12:49 -0700
X-CSE-ConnectionGUID: iY962mm8TLycApP/TQwDwA==
X-CSE-MsgGUID: doK/vPjkR6u59cmolBuo8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="223392912"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa006.jf.intel.com with ESMTP; 24 Mar 2026 04:12:39 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - disable 420xx AE cluster when lead engine is fused off
Date: Tue, 24 Mar 2026 11:12:34 +0000
Message-ID: <20260324111234.227329-1-ahsan.atta@intel.com>
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
Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 35105213d40c..0002122219bc 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -97,9 +97,25 @@ static struct adf_hw_device_class adf_420xx_class = {
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	u32 me_disable = self->fuses[ADF_FUSECTL4];
+	unsigned long fuses = self->fuses[ADF_FUSECTL4];
+	u32 mask = ADF_420XX_ACCELENGINES_MASK;
 
-	return ~me_disable & ADF_420XX_ACCELENGINES_MASK;
+	if (test_bit(0, &fuses))
+		mask &= ~ADF_AE_GROUP_0;
+
+	if (test_bit(4, &fuses))
+		mask &= ~ADF_AE_GROUP_1;
+
+	if (test_bit(8, &fuses))
+		mask &= ~ADF_AE_GROUP_2;
+
+	if (test_bit(12, &fuses))
+		mask &= ~ADF_AE_GROUP_3;
+
+	if (test_bit(16, &fuses))
+		mask &= ~ADF_AE_GROUP_4;
+
+	return mask;
 }
 
 static u32 uof_get_num_objs(struct adf_accel_dev *accel_dev)
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

