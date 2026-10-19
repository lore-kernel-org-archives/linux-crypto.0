Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422876;
	b=OZSf+mp8H0KvT0cYWVO4dxmcI6b6mZCTMQniamBsuPOGk5EBD7hAXbXPf4swQi2Ht2c2
	 vGDawWg2swheuuCmHdWgUqxHUsVVtpU4o2NZp36iGJu/I+HyX5nQ18JQCwds23478Io86
	 PfjJJhJ00CTjGXOg7TU4OQuOeD9A6d2WzB8e7+lh8/xQo3ly0k3//DyU8tIljmW0CG9a2
	 7YAE53NAVaLXCvI3WQwZeon36205DdL/Rp0lenMeL4P91LU9jDkDdGNnYoyV0T2Jcf0vy
	 a/1eZQ/M6ePhMxXCeBgzoWgHAAvrotSUoULlI1g4qBIONEeT09HjILgJS6ivdKDkzFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422876;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vUJLscG8XSSHQFg2sviQyqrV2fKWzSk1RRNuPFKLxmg=;
	b=lhfbz2XMw3jcspQEMn9k4mkqJAxmTvwjkzm5nRYzjMuCIKPGfnpziIH4ubm3ImeZiUFy
	 yYNeqlveHAOKK7arvXlKRBtxs88mmnt0f7NxsvMe4BmJIvvDdl5Q8VLRv49DUjyHGJZiQ
	 isMki4E5nUi5n1fDSbItA6081zgBQMPmyHF2vdLLD1doZU3uQ1mvjIqHrhbrfye4PoNDe
	 ol+Vd5AWx0CIiWVgiRFnnmQwc9uKpXaYILgjVGWGK469oSbPqHYMPXaPG+mHuci0EMFNw
	 LXZiTj3u+jLBt1HCkjTAMXWfxt9iPJlJEnegww3RPnyqf6ex37qbNKT0jgiSf+1DZkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NUBrfE3D;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2145609CED3;
	Mon, 19 Oct 2026 15:14:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2145609CED3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NUBrfE3D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422876; x=1823958876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wWYDKmOpaDXM/8DgQbmgTptDV+gFVhwrFPGHfjTFFto=;
  b=NUBrfE3Dw2iQphMm/jaHZmiBxTjTS5TTF1Sb3FuvqiGF3MPa22RKMONm
   FY9yCJOtqiElIITNk+V7OB1hVyWBQ7wN+vzhFusvVJD5YgcLrGVnPk0cx
   hvKDXqvplmvZidfF5KKgrYcW11Ho67OI2iXtOFlIeoojTXEquHjqtz46W
   x7piycCdei8cMl7WSwj6cqPGN9BRIEY+7dXfKG9fDWeP1O7aInpCNPbji
   PB3sNpEZGamS0Z4xzN20u70pWfk6FEs43RjVcZ1YLrbkDL/PXiBxY3i3K
   jN9kl8I3D8yJKP321brVYz6jla5OfPOCtJ2Z+dd4cGlOUrZS8kJxFX58J
   g==;
X-CSE-ConnectionGUID: NQYFMmXQTAmASIVp33Pyrw==
X-CSE-MsgGUID: om0wE/myQziLeefq9s6oCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986909"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986909"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: gt2nOSQrRxuQcHt8XBKOlw==
X-CSE-MsgGUID: XZu2InRrR7SnegWPwfk/vA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536962"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:33 -0700
From: Daniel Byrne <daniel1.byrne@intel.com>
To: Vinod Koul <vkoul@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	dmaengine@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 06/17] dmaengine: idxd: keep the interrupt handle across terminate_all
Date: Mon, 19 Oct 2026 08:06:19 -0700
Message-ID: <20261019150630.4026341-7-daniel1.byrne@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019150630.4026341-1-daniel1.byrne@intel.com>
References: <20261019150630.4026341-1-daniel1.byrne@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

idxd_wq_flush_descs(), the device_terminate_all() implementation,
released the work queue's interrupt handle and cleared its permission
entry after flushing the pending descriptors. The handle is only
requested again when the driver rebinds. On a live channel every
descriptor submitted with a completion interrupt after a terminate
therefore fails with DSA_COMP_INT_HANDLE_INVAL, and since no
interrupt is raised for such a descriptor the client never learns of
it and waits forever. A single dmaengine_terminate_sync() on an error
path, which the API allows, disabled the channel for good.

Flush the pending descriptors only. Releasing the handle and clearing
the permission entry belong to idxd_wq_free_irq(), which already does
both when the interrupt is torn down. idxd_wq_flush_descs() is also the
flush of the FLR halt path, which relied on it to mark the handles
invalid. The FLR revokes every handle, so that path now marks them
invalid itself, without a device command, and the teardown after the
reset skips the release of a handle the reset has already revoked.

At this point idxd_flush_pending_descs() still frees the slots of
in-flight interrupt-armed descriptors while the device may hold them.
A later patch in this series, "dmaengine: idxd: quarantine
terminate_all's descriptor slots until the device has drained",
addresses that.

Fixes: 2a93f5747d0e ("dmaengine: idxd: Flush all pending descriptors")
Cc: stable@vger.kernel.org # 7.0+
Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/device.c |  7 +------
 drivers/dma/idxd/irq.c    | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index a83b5da88f8c..a461cae7a409 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1336,7 +1336,7 @@ void idxd_wq_free_irq(struct idxd_wq *wq)
 	free_irq(ie->vector, ie);
 	idxd_flush_pending_descs(ie);
 
-	/* The interrupt might have been already released by FLR */
+	/* FLR revokes every handle; the halt path marks them invalid. */
 	if (ie->int_handle == INVALID_INT_HANDLE)
 		return;
 
@@ -1351,7 +1351,6 @@ void idxd_wq_free_irq(struct idxd_wq *wq)
 void idxd_wq_flush_descs(struct idxd_wq *wq)
 {
 	struct idxd_irq_entry *ie = &wq->ie;
-	struct idxd_device *idxd = wq->idxd;
 
 	guard(mutex)(&wq->wq_lock);
 
@@ -1359,10 +1358,6 @@ void idxd_wq_flush_descs(struct idxd_wq *wq)
 		return;
 
 	idxd_flush_pending_descs(ie);
-	if (idxd->request_int_handles)
-		idxd_device_release_int_handle(idxd, ie->int_handle, IDXD_IRQ_MSIX);
-	idxd_device_clear_perm_entry(idxd, ie);
-	ie->int_handle = INVALID_INT_HANDLE;
 }
 
 int idxd_wq_request_irq(struct idxd_wq *wq)
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 647969920a06..915304ee7099 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -442,13 +442,23 @@ static irqreturn_t idxd_halt(struct idxd_device *idxd)
 			INIT_WORK(&idxd->work, idxd_device_reinit);
 			queue_work(idxd->wq, &idxd->work);
 		} else if (gensts.reset_type == IDXD_DEVICE_RESET_FLR) {
+			int i;
+
 			idxd->state = IDXD_DEV_HALTED;
 			idxd_mask_error_interrupts(idxd);
-			/* Flush all pending descriptors, and disable
-			 * interrupts, they will be re-enabled when FLR
-			 * concludes.
+			/*
+			 * Flush all pending descriptors. The FLR revokes every
+			 * interrupt handle, so mark them invalid here without a
+			 * device command; they are requested again when a work
+			 * queue is re-enabled after the reset.
 			 */
 			idxd_wqs_flush_descs(idxd);
+			for (i = 0; i < idxd->max_wqs; i++) {
+				struct idxd_wq *wq = idxd->wqs[i];
+
+				if (wq->type == IDXD_WQT_KERNEL)
+					WRITE_ONCE(wq->ie.int_handle, INVALID_INT_HANDLE);
+			}
 			dev_dbg(&idxd->pdev->dev,
 				"idxd halted, doing FLR. After FLR, configs are restored\n");
 			INIT_WORK(&idxd->work, idxd_device_flr);
-- 
2.43.0

