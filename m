Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3872726A0B9
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 05:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765950370; cv=none; b=nZ6QrhNduU62Lpr+J5X/0MRWCBl7lOyyYqiyH5zhJVnbDPLSRXu712yu+CCqElmOrRFWZJgZZW8qaxgi91f4U73tFOQfGqPooNOyfIO/d6I69haUsblmro7OqkRP7Zgg7oURfF65eCLSea8Ka1yRyJ+IGULIESRq4zzmd1UnodA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765950370; c=relaxed/simple;
	bh=J2kfXDwFVwttGpcDI37wFStcZogwWLSrAk0CCMBg0xc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J8V2scms+lxQcqjcTNnQbtbL4zS4v6+ay6NA5opkgv2zfUP9j24TuPj1ZCfuhh1sLLOAC2yb3JC9v6YxdM6ePcHH6c7Tie9hjU6WWWrV4jr/v5YAufDL8gG4gEICok0rvpMtvdHiO++DRrIawQZIhrBRBwy+mi83GB5IShhGDhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E3d37eCW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E3d37eCW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765950367; x=1797486367;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J2kfXDwFVwttGpcDI37wFStcZogwWLSrAk0CCMBg0xc=;
  b=E3d37eCWQGnD2FQyStFoNi3CZTKh7Ab3a4r6ho7L8cSrS2+TsnHcV7+W
   wCLXq0rlb6DEIfhbgwFW1ELw4EI4jLawQk+Wg2BiSkog6p3cbjtHQXo46
   gQQv9wtounaCyw6mHaMmCeR9fpcv2amv4pZwrfyUqzh/sX+pOx8A4sVJB
   fWw8WVuwT6b8P9xidP/l1RmFFC4izSZBODFKmNSQHicf3dDB0GYlK/aQS
   oLPPnPjcB1s38S2MNqXRpRr0bfgRD4MbThPtG5VNJP43YcMxGEZjPufLS
   x1sMF49oXnptynui3shH20yYDpvYHpLCt6yEWxNfkaFAEnBhc/z2b+w/W
   A==;
X-CSE-ConnectionGUID: 9VQ0U2UqRJqRukm6mH/XcQ==
X-CSE-MsgGUID: g652nitCRr+VgsDyYSnaKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="93354473"
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="93354473"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 21:46:04 -0800
X-CSE-ConnectionGUID: uyp561/6RiCyqlTz9Q2chg==
X-CSE-MsgGUID: acfCIXIdREKTSQVkiagkAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="202712116"
Received: from basrr2harshitaintel-z390-ud.iind.intel.com ([10.49.44.173])
  by orviesa004.jf.intel.com with ESMTP; 16 Dec 2025 21:46:03 -0800
From: Harshita Bhilwaria <harshita.bhilwaria@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	harshita.bhilwaria@intel.com
Subject: [PATCH] crypto: qat - fix duplicate restarting msg during AER error
Date: Wed, 17 Dec 2025 11:16:06 +0530
Message-ID: <20251217054606.430300-1-harshita.bhilwaria@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The restarting message from PF to VF is sent twice during AER error
handling: once from adf_error_detected() and again from
adf_disable_sriov().
This causes userspace subservices to shutdown unexpectedly when they
receive a duplicate restarting message after already being restarted.

Avoid calling adf_pf2vf_notify_restarting() and
adf_pf2vf_wait_for_restarting_complete() from adf_error_detected() so
that the restarting msg is sent only once from PF to VF.

Fixes: 9567d3dc760931 ("crypto: qat - improve aer error reset handling")
Signed-off-by: Harshita Bhilwaria <harshita.bhilwaria@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Ravikumar PM <ravikumar.pm@intel.com>
Reviewed-by: Srikanth Thokala <srikanth.thokala@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 11728cf32653..a5964fd8204c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -41,8 +41,6 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 	adf_error_notifier(accel_dev);
 	adf_pf2vf_notify_fatal_error(accel_dev);
 	adf_dev_restarting_notify(accel_dev);
-	adf_pf2vf_notify_restarting(accel_dev);
-	adf_pf2vf_wait_for_restarting_complete(accel_dev);
 	pci_clear_master(pdev);
 	adf_dev_down(accel_dev);
 
-- 
2.43.0

