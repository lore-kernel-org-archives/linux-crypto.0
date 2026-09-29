Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14696439320
	for <linux-crypto@vger.kernel.org>; Tue, 29 Sep 2026 08:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790671412; cv=none; b=jiwzGQ49H8dW3j72T0R0tiOG1ofWKvVAAow5BHg4eUzZ7erMLFcRIEHyZfm4Kkf0SFsaN6J36cPJMsYq9NXXn6ZCeDzAqr5DlJLVhkmk6c4dZJiylxmMRPaCUc11ogoNLU4mSgIbuqcllLknHxYVlwObzJH6dSP6K/a1cimS6wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790671412; c=relaxed/simple;
	bh=hjd5StbBx18MsfdA/z7jrKaatk0ZBOrl9N2x/nuKCyE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z7DNBJB9XO1XVbUczIDQZzSi93NkuydcScge+jyTyPth2Op59NlIvUrZktyRyrOxk/LjsiLM4WhqgTa3+nYUTExWFTibO1yHL0bBk426GFwDqaTsoJlEaIFFi06Wp6vIW8ZCj2U7uf9P7VIu+Z+I1NU8sRVR5zDS5XEvZmwVCdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WDLDElCb; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WDLDElCb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790671410; x=1822207410;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hjd5StbBx18MsfdA/z7jrKaatk0ZBOrl9N2x/nuKCyE=;
  b=WDLDElCbGAeDg2wKMKtMu5H2n8UCkZeDowoTnGJ3HEofDgROkbHYpVBs
   DCKlo2yDX7+en57umXflIKyhvgLS5EYAt17PkUne1AH0stfwFu7KFn4GI
   q1O3kNULzK9G7YUrTC/+NmhyZw2on4JfxbfiOsk3610ZfN4YhSFuky0jS
   XuBEaGObi62nGGZqHUgsb546KtOes8ujofTx36E5ehUy6wj0+pPD6kTRv
   O3G4KaCks6yvDxmRc6OIjjzHsPmRli9C0uplLtMFQ1Ii3Hm6ztpXL5VXa
   4N/mIoAmPFdt+QQJoXgb7sHn3F7Idso3qNEBEqA+Qz+I7ovxFkuGXzNeL
   A==;
X-CSE-ConnectionGUID: aKKIm0NrQqCJLChuQERXaQ==
X-CSE-MsgGUID: eVxWEq7FTN2KT2Xe3exlWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="91481737"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="91481737"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 01:43:29 -0700
X-CSE-ConnectionGUID: q4+1JuAoTWa9soD0EuMbGA==
X-CSE-MsgGUID: 1GxCFc0UTnKUAHtQ3wrGWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="273439548"
Received: from indlpbc065983.iind.intel.com ([10.49.120.87])
  by orviesa010.jf.intel.com with ESMTP; 29 Sep 2026 01:43:27 -0700
From: George Abraham P <george.abraham.p@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	George Abraham P <george.abraham.p@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - force an edge when re-enabling all VF2PF interrupts
Date: Tue, 29 Sep 2026 14:08:37 +0530
Message-Id: <20260929083837.2102260-1-george.abraham.p@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

VF2PF interrupts are edge-triggered: a source only fires on a
masked -> unmasked transition of VM2PF_MSK, not by being unmasked.
adf_enable_all_vf2pf_interrupts() does a plain read-modify-write
unmask, assuming VM2PF_MSK still holds the all-masked value left by
adf_disable_all_vf2pf_interrupts().

That breaks across a device reset: adf_dev_autoreset() (and AER
recovery) FLR the PF while VFs stay alive, so a VF can latch a source
in VM2PF_SOU with no vectors set up to deliver it. The FLR then resets
VM2PF_MSK to its power-on default of 0 (unmasked) without a software
write, so the following RMW unmask writes 0 over an already-0
register: no edge occurs and the latched VF2PF message is never
delivered.

Fix by having adf_enable_all_vf2pf_interrupts() mask all sources
immediately before unmasking them, mirroring the idiom already used in
adf_gen4_disable_pending_vf2pf_interrupts(), forcing the required edge
regardless of the prior state of VM2PF_MSK.

Fixes: 575185000539 ("crypto: qat - keep VFs enabled during reset")
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_isr.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
index 159e91a50106..0df4b398508e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -70,6 +70,7 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 void adf_enable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 num_vfs)
 {
 	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
+	struct adf_pfvf_ops *pfvf_ops = GET_PFVF_OPS(accel_dev);
 	unsigned long flags;
 	u32 vf_mask;
 
@@ -79,7 +80,19 @@ void adf_enable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 num_vf
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
 	WRITE_ONCE(accel_dev->pf.vf2pf_disabled, false);
-	GET_PFVF_OPS(accel_dev)->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	/*
+	 * A VF2PF interrupt is only generated when a source transitions from
+	 * masked to unmasked. A VF may write to its VF2PF CSR while the source
+	 * is masked or while the MSI-X vectors are torn down, for example
+	 * during a device reset, leaving the source latched with no interrupt
+	 * pending. The FLR performed as part of a device reset returns the mask
+	 * register to its default value, which leaves all the sources unmasked,
+	 * so simply unmasking is not guaranteed to be a transition. Mask all the
+	 * sources first, so that unmasking always generates an interrupt for
+	 * the sources latched in the meantime.
+	 */
+	pfvf_ops->disable_all_vf2pf_interrupts(pmisc_addr);
+	pfvf_ops->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
 
-- 
2.40.1

