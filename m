Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400C31799F;
	Sat,  9 May 2026 07:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778310626; cv=none; b=emfBgulrPWIS384S8qdV0SkkfN1wuFHr5Hcz2AJAm2FNC8Jwl0hMfusXdGhbOUlTbCIyapHdNcQd1qgg+hi1XmyADcvEjjwIqQw0wxSpx8stXygutHW8V5qgxdQMGjtaO6lv2jSTFj76bStjiyiyQdIgYnbrUHUeNMDEluzH8GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778310626; c=relaxed/simple;
	bh=f3RFkqSdYIkxr3rUqS/vXv49ucwTjeFJ7mExOMGu49c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X+TX6heZkcE9Kj4N9h7L1nCxm0Jc2xRfrZG0lPGQM4dXF08gmPrPMGxUEJe3qL5peD46DfnvNoULY4HeGDFc45ug9885nrLHvjkzciJrg9di24COmWq7IpbdIz1mjLs8ept7Eq/qFQ+KdhVKCeVor8tu/EMmgEQKtn0Hq6ua6/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dlz607us; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dlz607us"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778310626; x=1809846626;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f3RFkqSdYIkxr3rUqS/vXv49ucwTjeFJ7mExOMGu49c=;
  b=dlz607uscpF6NbFlj+D/TU6TF2NF6x+TLemrb4X3LzQJIlzUwsdrkjbg
   voC9hqTRJ+AZSWlwEc2fOVBjeBvYqfdk8n3wZfOuLdYlGEBI5WjSdD32N
   beLZHVoPf05tPsAK6OaIgu8uwHnGf3S8I/AGX4gCCXTEUmcIADBZ4EJpw
   dw/t8JXQrJ4j4erdFyiRBG4zTnTCgBSv9tlR9IVg+X5y1NHe6Eot3STq2
   KyeLvL4KUXdAJwrUfSrlwgVzF4b3PJZkVOTUf01WoWqECbYaBZStg+xrr
   oG0FVbV6ptv1/iiJqJ62dVCgtqTdR0qGadtmYgEOtEh6uZ4NOq8XinfEA
   A==;
X-CSE-ConnectionGUID: nxHQbrv8QDOtvWqFW3s+9w==
X-CSE-MsgGUID: PDRMhUBWTRGt6CnlnWv+OA==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="90745885"
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="90745885"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 00:10:23 -0700
X-CSE-ConnectionGUID: ixee1jYkTIO0uvFw1SjO7A==
X-CSE-MsgGUID: hAIB2fPPSMaqeRSnPADtUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="241322888"
Received: from unknown (HELO fedora.iind.intel.com) ([10.49.0.89])
  by orviesa004.jf.intel.com with ESMTP; 09 May 2026 00:10:20 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	vdronov@redhat.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - fix VF2PF work teardown race in adf_disable_sriov()
Date: Sat,  9 May 2026 08:09:35 +0100
Message-ID: <20260509071017.13189-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The VF2PF interrupt handler queues PF-side response work that stores a
raw pointer to per-VF state (struct adf_accel_vf_info). Currently,
adf_disable_sriov() destroys per-VF mutexes and frees vf_info without
stopping new VF2PF work or waiting for in-flight workers to complete. A
concurrently scheduled or already queued worker can then dereference
freed memory.

This manifests as a use-after-free when KASAN is enabled:

  BUG: KASAN: null-ptr-deref in mutex_lock+0x76/0xe0
  Write of size 8 at addr 0000000000000260 by task kworker/24:2/...
  Workqueue: qat_pf2vf_resp_wq adf_iov_send_resp [intel_qat]
  Call Trace:
    kasan_report+0x119/0x140
    mutex_lock+0x76/0xe0
    adf_gen4_pfvf_send+0xd4/0x1f0 [intel_qat]
    adf_recv_and_handle_vf2pf_msg+0x290/0x360 [intel_qat]
    adf_iov_send_resp+0x8c/0xe0 [intel_qat]
    process_one_work+0x6ac/0xfd0
    worker_thread+0x4dd/0xd30
    kthread+0x326/0x410
    ret_from_fork+0x33b/0x670

Add a PF-local flag, vf2pf_disabled, that gates work queueing, worker
processing, and interrupt re-enabling during teardown. Set this flag
atomically with the hardware interrupt mask inside
adf_disable_all_vf2pf_interrupts(). After masking, synchronize the AE
cluster MSI-X interrupt and flush the PF response workqueue before
tearing down per-VF locks and state so all in-flight work completes
before vf_info is destroyed.

Introduce adf_enable_all_vf2pf_interrupts() to clear the flag and
unmask all VF2PF interrupts under the same lock when SR-IOV is
re-enabled. This ensures the software flag and hardware state transition
atomically on both the enable and disable paths.

Cc: stable@vger.kernel.org
Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 .../intel/qat/qat_common/adf_accel_devices.h  |  2 +
 .../intel/qat/qat_common/adf_common_drv.h     |  2 +
 drivers/crypto/intel/qat/qat_common/adf_isr.c | 40 +++++++++++++++++++
 .../crypto/intel/qat/qat_common/adf_sriov.c   | 24 +++++++++--
 4 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 03a4e9690208..d9b2a1cf474e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -480,6 +480,8 @@ struct adf_accel_dev {
 		struct {
 			/* protects VF2PF interrupts access */
 			spinlock_t vf2pf_ints_lock;
+			/* prevents VF2PF handling from racing with VF state teardown */
+			bool vf2pf_disabled;
 			/* vf_info is non-zero when SR-IOV is init'ed */
 			struct adf_accel_vf_info *vf_info;
 		} pf;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index e918d9b5e4f2..955934a8dd03 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -118,6 +118,7 @@ void qat_comp_alg_callback(void *resp);
 
 int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
 void adf_isr_resource_free(struct adf_accel_dev *accel_dev);
+void adf_isr_sync_ae_cluster(struct adf_accel_dev *accel_dev);
 int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
 void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev);
 
@@ -191,6 +192,7 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
 void adf_reenable_sriov(struct adf_accel_dev *accel_dev);
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask);
+void adf_enable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 num_vfs);
 void adf_disable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
index 4639d7fd93e6..01be0f166efc 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -62,6 +62,24 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 	unsigned long flags;
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	if (!READ_ONCE(accel_dev->pf.vf2pf_disabled))
+		GET_PFVF_OPS(accel_dev)->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
+}
+
+void adf_enable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 num_vfs)
+{
+	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
+	unsigned long flags;
+	u32 vf_mask;
+
+	if (!num_vfs)
+		return;
+
+	vf_mask = BIT_ULL(num_vfs) - 1;
+
+	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	WRITE_ONCE(accel_dev->pf.vf2pf_disabled, false);
 	GET_PFVF_OPS(accel_dev)->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
@@ -72,6 +90,7 @@ void adf_disable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	WRITE_ONCE(accel_dev->pf.vf2pf_disabled, true);
 	GET_PFVF_OPS(accel_dev)->disable_all_vf2pf_interrupts(pmisc_addr);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
@@ -174,6 +193,27 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 	return IRQ_NONE;
 }
 
+void adf_isr_sync_ae_cluster(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	u32 num_entries = pci_dev_info->msix_entries.num_entries;
+	struct adf_irq *irqs = pci_dev_info->msix_entries.irqs;
+	u32 irq_idx;
+	int irq;
+
+	if (!test_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status) || !irqs)
+		return;
+
+	irq_idx = num_entries > 1 ? hw_data->num_banks : 0;
+	if (irq_idx >= num_entries || !irqs[irq_idx].enabled)
+		return;
+
+	irq = pci_irq_vector(pci_dev_info->pci_dev, hw_data->num_banks);
+	if (irq >= 0)
+		synchronize_irq(irq);
+}
+
 static void adf_free_irqs(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index 8bf0fe1fcb4d..646f78009ccc 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -26,6 +26,9 @@ static void adf_iov_send_resp(struct work_struct *work)
 	u32 vf_nr = vf_info->vf_nr;
 	bool ret;
 
+	if (READ_ONCE(accel_dev->pf.vf2pf_disabled))
+		goto out;
+
 	mutex_lock(&vf_info->pfvf_mig_lock);
 	ret = adf_recv_and_handle_vf2pf_msg(accel_dev, vf_nr);
 	if (ret)
@@ -33,20 +36,33 @@ static void adf_iov_send_resp(struct work_struct *work)
 		adf_enable_vf2pf_interrupts(accel_dev, 1 << vf_nr);
 	mutex_unlock(&vf_info->pfvf_mig_lock);
 
+out:
 	kfree(pf2vf_resp);
 }
 
 void adf_schedule_vf2pf_handler(struct adf_accel_vf_info *vf_info)
 {
+	struct adf_accel_dev *accel_dev = vf_info->accel_dev;
 	struct adf_pf2vf_resp *pf2vf_resp;
 
+	if (READ_ONCE(accel_dev->pf.vf2pf_disabled))
+		return;
+
 	pf2vf_resp = kzalloc_obj(*pf2vf_resp, GFP_ATOMIC);
 	if (!pf2vf_resp)
 		return;
 
 	pf2vf_resp->vf_info = vf_info;
 	INIT_WORK(&pf2vf_resp->pf2vf_resp_work, adf_iov_send_resp);
-	queue_work(pf2vf_resp_wq, &pf2vf_resp->pf2vf_resp_work);
+
+	if (!queue_work(pf2vf_resp_wq, &pf2vf_resp->pf2vf_resp_work))
+		kfree(pf2vf_resp);
+}
+
+static void adf_flush_pf2vf_resp_wq(void)
+{
+	if (pf2vf_resp_wq)
+		flush_workqueue(pf2vf_resp_wq);
 }
 
 static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
@@ -75,7 +91,7 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 		hw_data->configure_iov_threads(accel_dev, true);
 
 	/* Enable VF to PF interrupts for all VFs */
-	adf_enable_vf2pf_interrupts(accel_dev, BIT_ULL(totalvfs) - 1);
+	adf_enable_all_vf2pf_interrupts(accel_dev, totalvfs);
 
 	/*
 	 * Due to the hardware design, when SR-IOV and the ring arbiter
@@ -248,8 +264,10 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 	adf_pf2vf_wait_for_restarting_complete(accel_dev);
 	pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
-	/* Disable VF to PF interrupts */
+	/* Block VF2PF work and disable VF to PF interrupts */
 	adf_disable_all_vf2pf_interrupts(accel_dev);
+	adf_isr_sync_ae_cluster(accel_dev);
+	adf_flush_pf2vf_resp_wq();
 
 	/* Clear Valid bits in AE Thread to PCIe Function Mapping */
 	if (hw_data->configure_iov_threads)

base-commit: 1e0613cd5cfb9fc6d622f0ae5ed33fafd184d259
-- 
2.54.0

