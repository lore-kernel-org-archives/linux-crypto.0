Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E0238CFE1;
	Wed, 13 May 2026 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685615; cv=none; b=OJjKuI4+qlgeIe6g3+BqJK0cBpFX5lfqNDdIpyHPb9WT8x28HZRUehU570ni1eJlF/XVFc/lWz1gqrPBUjFlnKeMtBM+3uoT/t546BzBAenpBnzDnJNKHOcOWlqDBMLZcWQy8/VRoLZ/vkjZ7I/2C9PEyhO3CcJJzTBF/jkZpBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685615; c=relaxed/simple;
	bh=6/g+eI8H7stfXfONoavIPrIxIl64ue63MJvRQtnqoSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKTu/zmnYDu3wU9dxoQ1RfNLkVF7Okc5GKAcsdw0sLv/1UHoa2VVhAT1LxwE+fyqx1qNfZJooofgqEcVlxltEd+8R06P6CG5DbCkhd/8fbcYGxLazWUUhAwnYojQ/irb3b5eGpWGFcaVfpTcKfhyE61ieOJL04KllD5iHYvOWKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O0h5irgE; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O0h5irgE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778685614; x=1810221614;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6/g+eI8H7stfXfONoavIPrIxIl64ue63MJvRQtnqoSQ=;
  b=O0h5irgEWhZzvfVQdLGD8j/Tn/shKIuVx9yxUFE+xO81/IBgV1kC/DCd
   wADk2NSTpf88wvv1YdiVGFq83uAC2NFqdWe6INYeaezMmf6Ia77QNgsCf
   yjvR7rSYBsvNwp1r6h8B+R6nrZ7UrowOPAaZj8vSjTRfsliQvuq+cQI0I
   MDsabqzmAzA+3VjyW3O7DxCLqeLzFPDddYaX9sjoYGz9piRrWIz1NjyS4
   0I4EsfgBBJgEb2rSWXaDiAMcqZs3TdFOKTrahuOfRuiNjyontgXCDnP9g
   dBn0wZaz+pIY468gUWbs8wVMZLa9bN6GySfJWpUIMuZQc69qAduA5VCgq
   w==;
X-CSE-ConnectionGUID: BELmSeumRJGtg0y9tT2pvg==
X-CSE-MsgGUID: 5EAGqTYXTAOemsyP7CPlwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83489453"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="83489453"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 08:20:13 -0700
X-CSE-ConnectionGUID: k7n3W4sxTmqRe04v2+RcZA==
X-CSE-MsgGUID: 9FyglI90Qsae5tJ1S1hRmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="239931463"
Received: from zp3110c001s1504.deacluster.intel.com ([10.219.161.39])
  by fmviesa004.fm.intel.com with ESMTP; 13 May 2026 08:20:12 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 1/6] crypto: qat - keep VFs enabled during reset
Date: Wed, 13 May 2026 17:16:54 +0200
Message-ID: <9d9faa95f1cea5e77afc7f570e478ff0cb9cdc98.1778685152.git.ahsan.atta@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <cover.1778685152.git.ahsan.atta@intel.com>
References: <cover.1778685152.git.ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When a reset is triggered via sysfs, the PCI core invokes the
reset_prepare() callback while holding pci_dev_lock(), which includes
the PCI configuration space access semaphore. If reset_prepare() calls
adf_dev_down(), the call chain adf_dev_stop() -> adf_disable_sriov()
-> pci_disable_sriov() attempts to acquire the same semaphore,
resulting in a deadlock.

Avoid this by skipping pci_disable_sriov() when ADF_STATUS_RESTARTING
is set. During reset the PCI topology is preserved, so VF devices
remain valid and enumerated across the reset. VF notification and the
quiesce handshake via adf_pf2vf_notify_restarting() are still
performed unconditionally so that VFs stop submitting work before the
PF shuts down.

Correspondingly, skip pci_enable_sriov() in adf_enable_sriov() when
VFs are already present, since their PCI devices were preserved from
before the restart.

This is in preparation for adding reset_prepare() and reset_done()
callbacks in adf_aer.c.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_sriov.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index 96939572109e..f2011300a929 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -91,6 +91,10 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 	/* Enable VF to PF interrupts for all VFs */
 	adf_enable_all_vf2pf_interrupts(accel_dev, totalvfs);
 
+	/* Do not enable SR-IOV if already enabled */
+	if (pci_num_vf(pdev))
+		return 0;
+
 	/*
 	 * Due to the hardware design, when SR-IOV and the ring arbiter
 	 * are enabled all the VFs supported in hardware must be enabled in
@@ -260,7 +264,13 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 
 	adf_pf2vf_notify_restarting(accel_dev);
 	adf_pf2vf_wait_for_restarting_complete(accel_dev);
-	pci_disable_sriov(accel_to_pci_dev(accel_dev));
+	/*
+	 * When the device is restarting, preserve VF PCI devices across
+	 * the reset by skipping pci_disable_sriov(). VFs are notified to
+	 * quiesce regardless so the PF can safely shut down.
+	 */
+	if (!test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
+		pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
 	/* Block VF2PF work and disable VF to PF interrupts */
 	adf_disable_all_vf2pf_interrupts(accel_dev);
-- 
2.45.0

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

