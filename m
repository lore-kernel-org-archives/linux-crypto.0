Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCD33D1702;
	Wed,  1 Apr 2026 09:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775035918; cv=none; b=eHt7ioel5dmT1dEUzfTPGJd8pZf1E/xUOaIKkDwdPjMpgIc8kPIl+84VcQuaj4XI4AXQAkgQHxcKmhQVch7wri85YHM0o8mb29L/+Jpo9DnYwlI5WdhBoG24isn6LALjKAgz1X/U8RyjP0Q9WRm+NHWxYeSBLdtJ6UtTXOtwEFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775035918; c=relaxed/simple;
	bh=OKK/7LL62YMlaPAzxkc8qo/IdgFm0bA7lFxJW9F/8e0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r2tFKzpu8JHe5yV/qZ5Ze5hhWRQURlu697XC4stX4mykAOWjHuXBhuY+T6+jJ96PxU1kDN+JxoScfq95iEZo8HIVMmeAH1jZhHGZAaqD+R0g5b4oBZe5ej+OmaTuNMbUnMu7ZnVngER2DixS3IL9p/droMgC39i0Q9vyLvv6juU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XpgHDtZd; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XpgHDtZd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775035916; x=1806571916;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OKK/7LL62YMlaPAzxkc8qo/IdgFm0bA7lFxJW9F/8e0=;
  b=XpgHDtZd8T4flL4fW3VHwllEqkelvreL2W2ltuwdKT1AwYSpe1HOTI/g
   x6+Gfi85yvOge1FrpkCtohkWL5VYvFKUq8u3bEj4UrNdvFM+MYeEy2foH
   2O+XaSHyk+KPd6iGbzzwNlBZejW3/eUdpBOWp5t17TCqwFz7L4akKRg5f
   bS3ekRbTAOAQM5jiRKFLGnVh2iug9fho2W7VEQy2QXsQApUZsiPvyGfN/
   DHtX0MHq9Ue6JGWBDMCPH0YxkhYJaBHQzBBqU3Jmo4D1GvKyIqCpimuF+
   gZmw78ZFRneYTVrPguDSAdI58S+bExYtOx7M6M9744NHqn3n1LHVZvEOI
   A==;
X-CSE-ConnectionGUID: dpzq8mWAQ0uOYVX6WnjtOA==
X-CSE-MsgGUID: gga/7q4ZTCuCIebkARlRww==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="75107893"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="75107893"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 02:31:55 -0700
X-CSE-ConnectionGUID: Qi5NVprmS8ekcM6SFotfnA==
X-CSE-MsgGUID: BVXMpLzZRr6goj26XpvnNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="257114510"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa002.jf.intel.com with ESMTP; 01 Apr 2026 02:31:54 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Ahsan Atta <ahsan.atta@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: [PATCH] crypto: qat - fix IRQ cleanup on 6xxx probe failure
Date: Wed,  1 Apr 2026 10:31:11 +0100
Message-ID: <20260401093146.268157-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

When adf_dev_up() partially completes and then fails, the IRQ
handlers registered during adf_isr_resource_alloc() are not detached
before the MSI-X vectors are released.

Since the device is enabled with pcim_enable_device(), calling
pci_alloc_irq_vectors() internally registers pcim_msi_release() as a
devres action. On probe failure, devres runs pcim_msi_release() which
calls pci_free_irq_vectors(), tearing down the MSI-X vectors while IRQ
handlers (for example 'qat0-bundle0') are still attached. This causes
remove_proc_entry() warnings:

    [   22.163964] remove_proc_entry: removing non-empty directory 'irq/143', leaking at least 'qat0-bundle0'

Moving the devm_add_action_or_reset() before adf_dev_up() does not solve
the problem since devres runs in LIFO order and pcim_msi_release(),
registered later inside adf_dev_up(), would still fire before
adf_device_down().

Fix by calling adf_dev_down() explicitly when adf_dev_up() fails, to
properly free IRQ handlers before devres releases the MSI-X vectors.

Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
---
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
index 0684ea9be2ac..c52462a48c34 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
@@ -209,8 +209,10 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return ret;
 
 	ret = adf_dev_up(accel_dev, true);
-	if (ret)
+	if (ret) {
+		adf_dev_down(accel_dev);
 		return ret;
+	}
 
 	ret = devm_add_action_or_reset(dev, adf_device_down, accel_dev);
 	if (ret)

base-commit: 313ea1d8a965b395d2e1570bd7cc2f4fa25d0e49
-- 
2.53.0

