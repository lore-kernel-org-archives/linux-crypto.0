Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422881;
	b=bc4eHX5SCDiuMGjV84l7OMYzh2VcKnIGXRqSiyhPzpI3+Eedpim8pzX21iWfUx/F7Qcb
	 RGloAz5OW5W6pRPbdaKcBYhRdBAEylRmuUoHbPdtZRA7Zh7xIcO9hfonsRNRxxPncvz4X
	 kI5V2qdcK3F2IHU+BSmHXD392sK5gT1ZteWnvMRJW706JqFM6j+a7qA7K8gwVI+EQLvx/
	 FptWG3zTdAvh/q7VEr3C6kbBIoKXIkdEjc9ur6UW965NY+RZKLJTzsPlpgMAkr4Vplksx
	 KOEUuPFzX+5dKhHx2NLeeoGkwPtJycCYvHk1oqyW7HKON99OlXjFvWPD6Ox/J3VhpVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422881;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-Ironport-Invalid-End-Of-Message:X-ExtLoop1:
	 X-IronPort-AV:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MQb8B/qhw+4yCI3Cj8R+lrtVqs8STV1i2INQuKnCvNw=;
	b=0EhfHbKk18cIZDpB+Dnm54WrxFIaLmQf86sgRuGvaCjycoCs60yytX4KkhrUKhKQNAZ3
	 +FD5ThRA7owWble/dk8+DtCXo0xeeWw5VxdJPEoIViL8mSyD8fmpnjgKLOyWzUMpYYCeJ
	 Zq5s8KNQkRCgZHDoTRm6KsBkDyRlCz8PMQrn6R3LqcY9FfrIuob8DCXOapJHom4Vvn72d
	 o/N8MmmRB+fE2rRlXemDDmYru3lAxQlyYBvuoGeNe1JdDkuwKO97LQ8rBOIsQiST+TBPF
	 RGh6apuc+PAcEQgkVFLB4t7lTdeVnlFC0i9bAtXrJL2HHvaL+psB260T1CnNmN8c+hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CC46qBE9;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2458E609CEEA;
	Mon, 19 Oct 2026 15:14:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2458E609CEEA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CC46qBE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422882; x=1823958882;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z0SkwW//ef7ZJBaFBPaI8edP8HDdXv5L0ptXLFoUlhA=;
  b=CC46qBE90hvWXyDls/cD7sZtX1nDBEZzDiu1IfzRY2SDWrrI6HQvW46l
   GznsHv2cXs5YUyTYVzNiSOjW5hkmweiIvQSg8fpDbbAE79otYhcppbJrq
   V3HqfL+Q36wMJti9qrEOc6d+87FNjcorJEhY+VQoXKvkDXsvnxv7MH1In
   +pZqkWPxkgvrcjJ1AWLnF8Tcex4SF8ko2UZFMSW1VI8KMUEyAqDZdG8Ah
   ojKh0NRNJ4O90Ioe7oOlCHtK+BiwhLXdv9GhpAMxDiv9lyBzF2gBUxQjA
   lq60KGjBzm/Y8GGr77dnc45Yt0nOgesx4M9+dUcjflZnpYu5LOCNu1o0/
   g==;
X-CSE-ConnectionGUID: jgmDl+l3SGq+yGwnXGQ8WQ==
X-CSE-MsgGUID: JRqmPQ4DR0OLsLrOPgztqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986942"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986942"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:35 -0700
X-CSE-ConnectionGUID: GGDSOwEDQZ61D8gwWWlfYQ==
X-CSE-MsgGUID: qXaD5L4/QjeN7C8PwD3kgA==
X-Ironport-Invalid-End-Of-Message: True
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2537007"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:35 -0700
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
Subject: [PATCH 17/17] dmaengine: idxd: run the interrupt-handle revoke under the queue lock
Date: Mon, 19 Oct 2026 08:06:30 -0700
Message-ID: <20261019150630.4026341-18-daniel1.byrne@intel.com>
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

The interrupt-handle revoke worker requests each new handle without
wq_lock, so that a reset can end the request, and the queue may be
unbound while it waits. It reads the queue's state without the lock,
submits the drain after unlocking, and on a failed request quiesces the
queue and completes the descriptors that carry the revoked handle
outside the lock, so an unbind can unmap the portal under the drain, or
free the descriptors, the allocator and the driver under the
completions.

The unbind invalidates the handle in the same wq_lock hold that tears
the queue down, so after the request the worker takes wq_lock and goes
on only if the handle is still valid. The handle swap and the drain, or
the quiesce and the completions after a failed request, then run in
that hold. A queue a halt already killed and did not revive is left
dead rather than revived behind the halt.

Assisted-by: Claude:claude-opus-5
Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/irq.c | 45 +++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 4517a09fcf1b..8217698056bb 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -115,6 +115,11 @@ static void idxd_abort_invalid_int_handle_descs(struct idxd_irq_entry *ie)
 	struct idxd_desc *d, *t;
 	struct llist_node *head;
 
+	/*
+	 * An unbind frees the descriptors and the allocator under
+	 * wq_lock, so they are completed under it as well.
+	 */
+	lockdep_assert_held(&ie_to_wq(ie)->wq_lock);
 	spin_lock(&ie->list_lock);
 	head = llist_del_all(&ie->pending_llist);
 	if (head) {
@@ -142,6 +147,7 @@ static void idxd_int_handle_revoke(struct work_struct *work)
 	struct pci_dev *pdev = idxd->pdev;
 	struct device *dev = &pdev->dev;
 	int i, new_handle, rc;
+	bool killed;
 
 	if (!idxd->request_int_handles) {
 		kfree(revoke);
@@ -166,15 +172,31 @@ static void idxd_int_handle_revoke(struct work_struct *work)
 			continue;
 
 		rc = idxd_device_request_int_handle(idxd, i, &new_handle, IDXD_IRQ_MSIX);
-		if (rc < 0) {
+		if (rc < 0)
 			dev_warn(dev, "get int handle %d failed: %d\n", i, rc);
+
+		/*
+		 * The request runs without wq_lock, so that a reset can end
+		 * it, and the queue may have been unbound meanwhile. An
+		 * unbind invalidates the handle in the same wq_lock hold
+		 * that unmaps the portal and frees the descriptors, so a
+		 * handle still valid under the lock means that the queue
+		 * still has its portal, its descriptors and its completion
+		 * handler. Everything below, the drain included, stays in
+		 * this hold.
+		 */
+		guard(mutex)(&wq->wq_lock);
+		if (ie->int_handle == INVALID_INT_HANDLE)
+			continue;
+
+		if (rc < 0) {
 			/*
 			 * Failed to acquire new interrupt handle. Kill the WQ
 			 * and release all the pending submitters. The submitters will
 			 * get error return code and handle appropriately.
 			 */
 			ie->int_handle = INVALID_INT_HANDLE;
-			idxd_wq_quiesce(wq);
+			__idxd_wq_quiesce(wq);
 			idxd_abort_invalid_int_handle_descs(ie);
 			continue;
 		}
@@ -193,21 +215,20 @@ static void idxd_int_handle_revoke(struct work_struct *work)
 			continue;
 		}
 
-		mutex_lock(&wq->wq_lock);
-		reinit_completion(&wq->wq_resurrect);
-
-		/* Kill percpu_ref to pause additional descriptor submissions */
-		percpu_ref_kill(&wq->wq_active);
-
-		/* Wait for all submitters quiesce before we change interrupt handle */
-		wait_for_completion(&wq->wq_dead);
+		/*
+		 * Kill percpu_ref to pause additional descriptor submissions
+		 * and wait for all submitters to quiesce before we change
+		 * the interrupt handle. A queue a halt already killed and did
+		 * not revive is left dead.
+		 */
+		killed = idxd_wq_kill(wq);
 
 		ie->int_handle = new_handle;
 
 		/* Revive percpu ref and wake up all the waiting submitters */
-		percpu_ref_reinit(&wq->wq_active);
+		if (killed)
+			percpu_ref_reinit(&wq->wq_active);
 		complete_all(&wq->wq_resurrect);
-		mutex_unlock(&wq->wq_lock);
 
 		/*
 		 * The delay here is to wait for all possible MOVDIR64B that
-- 
2.43.0

