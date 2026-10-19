Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422882;
	b=c9vG1k1qa61APJHQSEMYLx33MbBe3dTI6wL9yGuI29qUGUay8IgzNUnOqi3h7lrsgteX
	 hWZVpDzZOmULN1cyaC3JgByoPfM1TV9qGPwRdCd2rYiGp8VKTKp/QNYlu6AF14dvmPFeJ
	 LimCiwMnH9DfzHZH212rFAesqXmRk59Kb1Jt3EOrXa69KA2PpJTOGZ+q5jowCkYgfdRgV
	 q3Bg6H4DGsvs/+1BYKoVbMsOytTLmB2vHz487dP4/1tK6UVWfpjlTCg5ou2wJwbQFq+kU
	 L06zsDQg65/Leo4pOlGZ2n4nzXsVWmvA/VC/uVHfCUcXENPyVzsyraCKTDXRdQbcpsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422882;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=O9DFPRtsvFa1wF4eZGI4Ud3A05lAczg6QVi/FUJ5XMw=;
	b=e5ab+d9D/eW05t7amjD+OVpwzgaSyuktGusyF7oBQ51nzCqEI1POQFY5igBfidQaqKGI
	 kmiLxpOjagzxN8N891oOQv4+u9p695eZqK5yHKc3xKA4Hql6+2cbaFj9I1Ms80FQPCAxV
	 kjX2LivmpT+byLmQzWQcfJYQL4/oJIotSGuLjGw0cEbXQX9vUaGaWk/QIL0lb9hF8HQCR
	 0vLdvlrjSCVJEN5JYjel7A3lZWPOAWGyeVrreRaTLTrvhV3F/hVhGrDGeJ2aj9mVvHBjS
	 6ZLE68MoTyV0pfFrrIBjhEYjV8WhwaJVVeTFOO2w2bztghc85zjPkySwiRfI+g3057w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WpHIvtzw;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBF1609CEE5;
	Mon, 19 Oct 2026 15:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DBF1609CEE5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WpHIvtzw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422881; x=1823958881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xpv4f6XP1D6XhVQhRlWNeBRPenANWbW+HGesP3n05aQ=;
  b=WpHIvtzw6Z1v31YMnuwVjlQ3EYKH3HpZyrNKXc6ojRcrPaLBmmnmca2I
   pN+KSjhD4fKsCGCmknMbkc1bE1VmjOzr07N4NZ+gSfy1oCDUAZhPCIbww
   pJnR4Itt6glYXLe6atxcRaBzbH6OJh5I1s3jfllDtTJKflD7tMoxzqpJ3
   dMS9pk/sGydMEFD+6CEaLzUD0d3sa0GRSKRSIuhwC5vZWgsmGjytwOL72
   mEj3x71MY3tM2a7jOhsCoLgNN5k4vVQuOiRDN9+n2tLJJ6F3AWIPVlRT0
   Xndgefe2vDJGy1TXIrYJK6r3pbmvlpNtycP5Q4bg7VKZbRFRlhX3Oway7
   w==;
X-CSE-ConnectionGUID: 1eBNpD7kTwu8nd1fC8Sx8A==
X-CSE-MsgGUID: NYo4SZctQlWlHn191BQj2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986936"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986936"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:35 -0700
X-CSE-ConnectionGUID: qdidTF+eSdqLLnpMq7JVzw==
X-CSE-MsgGUID: aZ8vhuKzTWKrSaueGeo0pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536999"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:34 -0700
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
Subject: [PATCH 15/17] dmaengine: idxd: flush the work queues on every halt type
Date: Mon, 19 Oct 2026 08:06:28 -0700
Message-ID: <20261019150630.4026341-16-daniel1.byrne@intel.com>
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

A device halt ends the engines, so nothing in flight completes and a
client waiting on one of those descriptors waits forever. Only the FLR
branch of idxd_halt() flushed the kernel work queues. The software-reset
branch only queued the reinit, which re-enables the queues with the dead
descriptors still on their lists and their slots held, and the
system-reset branch only quiesced the queues.

Flush on every halt type. The flush hands descriptors back, so no
submitter may still own one: a submitter that passed the state check
before the halt holds its descriptor on the pending list while ENQCMDS
retries, and aborts and frees it itself when the submit fails. Every
halt branch therefore kills wq_active and waits for the last submitter
before it flushes, and the abort now runs before the submitter drops
its reference, so the wait covers it. Each queue is handled in one hold
of wq_lock, from the state check through the revive. The software reset
revives the queues afterwards, but only what its own flush killed and
only a queue whose interrupt handle a failed revoke has not
invalidated. That revive comes before the reinit enables the device
again, so the submit checks the state again once it holds the reference
and fails with -EIO while the device is not enabled.

Every killer of wq_active runs under wq_lock and waits for the last
reference before it unlocks, so a reference found dying under the lock
is already dead and the kill is idempotent. A halt branch that does not
revive the queue leaves the reference dead, and the recovery's unbind
and a later halt skip the kill rather than drop the count below zero
and wait forever for a release that cannot come.

The software-reset branch flushes queues that its reinit enables again
without requesting new interrupt handles, which is safe only because
the flush no longer releases them since "dmaengine: idxd: keep the
interrupt handle across terminate_all".

Fixes: f019d7814bce ("dmaengine: idxd: Flush kernel workqueues on Function Level Reset")
Assisted-by: Claude:claude-opus-5
Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/device.c | 49 ++++++++++++++++++++++++---------
 drivers/dma/idxd/idxd.h   |  2 ++
 drivers/dma/idxd/irq.c    | 57 ++++++++++++++++++++++++++++++++++++---
 drivers/dma/idxd/submit.c | 54 ++++++++++++++++++++++++++++++-------
 4 files changed, 135 insertions(+), 27 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index a33c4309f5d4..158c141650e3 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -483,13 +483,32 @@ int idxd_wq_init_percpu_ref(struct idxd_wq *wq)
 }
 EXPORT_SYMBOL_NS_GPL(idxd_wq_init_percpu_ref, "IDXD");
 
-void __idxd_wq_quiesce(struct idxd_wq *wq)
+/*
+ * Kill wq_active and wait for the last submitter to drop its reference.
+ * Every killer runs under wq_lock and waits before it unlocks, so a
+ * reference found dying here was killed and waited out by an earlier
+ * caller, such as a halt flush that did not revive the queue. Killing
+ * it again would drop the count below zero and wait forever. A
+ * reference that percpu_ref_exit() released reads as dying too, so a
+ * queue the device re-enabled behind an unbind is skipped as well.
+ * Returns whether this call killed the reference.
+ */
+bool idxd_wq_kill(struct idxd_wq *wq)
 {
 	lockdep_assert_held(&wq->wq_lock);
+	if (percpu_ref_is_dying(&wq->wq_active))
+		return false;
 	reinit_completion(&wq->wq_resurrect);
 	percpu_ref_kill(&wq->wq_active);
-	complete_all(&wq->wq_resurrect);
 	wait_for_completion(&wq->wq_dead);
+	return true;
+}
+
+void __idxd_wq_quiesce(struct idxd_wq *wq)
+{
+	idxd_wq_kill(wq);
+	/* Let parked submitters retry and fail on the dead reference. */
+	complete_all(&wq->wq_resurrect);
 }
 EXPORT_SYMBOL_NS_GPL(__idxd_wq_quiesce, "IDXD");
 
@@ -1627,14 +1646,15 @@ void idxd_wq_quarantine_free(struct idxd_wq *wq, struct list_head *list)
 
 /*
  * A halt killed every descriptor the device held: the quarantined slots
- * are free, and the fence a failed drain raised can be lifted. Under
- * wq_lock, since an unbind racing the halt may free the pool.
+ * are free, and the fence a failed drain raised can be lifted. The halt
+ * flush calls this under wq_lock, since an unbind racing the halt may
+ * free the pool.
  */
 void idxd_wq_halt_release(struct idxd_wq *wq)
 {
 	LIST_HEAD(dead_descs);
 
-	guard(mutex)(&wq->wq_lock);
+	lockdep_assert_held(&wq->wq_lock);
 
 	if (wq->state != IDXD_WQ_ENABLED || wq->type != IDXD_WQT_KERNEL)
 		return;
@@ -1697,13 +1717,14 @@ void idxd_wq_free_irq(struct idxd_wq *wq)
  * @quarantine: the device keeps running, so the slots of the descriptors
  * it has not finished stay out of use until a drain covers them. A halt
  * has killed them and frees their slots at once.
+ * The caller holds wq_lock.
  */
-void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine)
+void __idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine)
 {
 	struct idxd_irq_entry *ie = &wq->ie;
 	bool killed = false;
 
-	guard(mutex)(&wq->wq_lock);
+	lockdep_assert_held(&wq->wq_lock);
 
 	if (wq->state != IDXD_WQ_ENABLED || wq->type != IDXD_WQT_KERNEL)
 		return;
@@ -1714,12 +1735,8 @@ void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine)
 	 * descriptor in the device, where the drain that frees the
 	 * quarantine covers it. A halt flush has done this itself.
 	 */
-	if (quarantine && !percpu_ref_is_dying(&wq->wq_active)) {
-		reinit_completion(&wq->wq_resurrect);
-		percpu_ref_kill(&wq->wq_active);
-		wait_for_completion(&wq->wq_dead);
-		killed = true;
-	}
+	if (quarantine)
+		killed = idxd_wq_kill(wq);
 	idxd_flush_pending_descs(ie, quarantine);
 	if (killed) {
 		percpu_ref_reinit(&wq->wq_active);
@@ -1727,6 +1744,12 @@ void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine)
 	}
 }
 
+void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine)
+{
+	guard(mutex)(&wq->wq_lock);
+	__idxd_wq_flush_descs(wq, quarantine);
+}
+
 int idxd_wq_request_irq(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 3caf9fc00f83..0ad61bc233e8 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -826,11 +826,13 @@ int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
 int idxd_wq_disable_pasid(struct idxd_wq *wq);
+bool idxd_wq_kill(struct idxd_wq *wq);
 void __idxd_wq_quiesce(struct idxd_wq *wq);
 void idxd_wq_quiesce(struct idxd_wq *wq);
 int idxd_wq_init_percpu_ref(struct idxd_wq *wq);
 void idxd_wq_free_irq(struct idxd_wq *wq);
 int idxd_wq_request_irq(struct idxd_wq *wq);
+void __idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine);
 void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine);
 void idxd_wq_quarantine_take(struct idxd_wq *wq, struct list_head *list);
 void idxd_wq_quarantine_put_back(struct idxd_wq *wq, struct list_head *list);
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 1ec3d360eea8..99b2df7fc2de 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -422,15 +422,61 @@ static void idxd_device_flr(struct work_struct *work)
 		dev_err(&idxd->pdev->dev, "FLR failed\n");
 }
 
-static void idxd_wqs_flush_descs(struct idxd_device *idxd)
+/*
+ * Complete what the halted engines will never finish, or a client waiting
+ * on one of those descriptors waits forever. The flush hands descriptors
+ * back, so no submitter may still own one: a submitter that passed the
+ * state check before the halt can hold a descriptor on the pending list
+ * while its ENQCMDS retries, and it aborts and frees that descriptor
+ * itself when the submit fails. Killing wq_active and waiting for the
+ * last submitter to drop its reference orders the flush after that.
+ * Each queue is handled in one hold of wq_lock, from the state check
+ * through the revive. A driver remove that quiesces the queue in one
+ * hold and disables it in another, as iaa_crypto's does, would otherwise
+ * find the reference dying between the kill and the revive, skip its
+ * own kill, and have the revive undo its quiesce before its disable
+ * frees the queue.
+ * @resurrect: revive the queues afterwards for a reset that keeps them.
+ */
+static void idxd_wqs_halt_flush(struct idxd_device *idxd, bool resurrect)
 {
+	bool killed;
 	int i;
 
 	for (i = 0; i < idxd->max_wqs; i++) {
 		struct idxd_wq *wq = idxd->wqs[i];
 
-		idxd_wq_flush_descs(wq, false);
+		mutex_lock(&wq->wq_lock);
+		if (wq->state != IDXD_WQ_ENABLED || wq->type != IDXD_WQT_KERNEL) {
+			mutex_unlock(&wq->wq_lock);
+			continue;
+		}
+		killed = idxd_wq_kill(wq);
+		__idxd_wq_flush_descs(wq, false);
 		idxd_wq_halt_release(wq);
+
+		if (resurrect) {
+			/*
+			 * Revive only what this flush killed, and only if no
+			 * failed interrupt handle revoke killed it for good,
+			 * which leaves the handle invalid. The state changes
+			 * without the lock only to enabled, in the reinit of
+			 * an earlier halt, or on a queue that an FLR recovery
+			 * has unbound, whose reference reads as dying, so this
+			 * flush did not kill it. A reference an earlier halt
+			 * left dead stays dead, since that halt's recovery
+			 * unbinds the queue. The revive has to stay in this
+			 * hold: moved to the reinit, it would reopen the
+			 * window described above.
+			 */
+			if (killed && wq->ie.int_handle != INVALID_INT_HANDLE)
+				percpu_ref_reinit(&wq->wq_active);
+			complete_all(&wq->wq_resurrect);
+		} else {
+			/* Let blocked submitters retry and fail on the state. */
+			complete_all(&wq->wq_resurrect);
+		}
+		mutex_unlock(&wq->wq_lock);
 	}
 }
 
@@ -442,6 +488,8 @@ static irqreturn_t idxd_halt(struct idxd_device *idxd)
 	if (gensts.state == IDXD_DEVICE_STATE_HALT) {
 		idxd->state = IDXD_DEV_HALTED;
 		if (gensts.reset_type == IDXD_DEVICE_RESET_SOFTWARE) {
+			/* The reinit below re-enables the queues, so revive them. */
+			idxd_wqs_halt_flush(idxd, true);
 			/*
 			 * If we need a software reset, we will throw the work
 			 * on a system workqueue in order to allow interrupts
@@ -460,7 +508,7 @@ static irqreturn_t idxd_halt(struct idxd_device *idxd)
 			 * device command; they are requested again when a work
 			 * queue is re-enabled after the reset.
 			 */
-			idxd_wqs_flush_descs(idxd);
+			idxd_wqs_halt_flush(idxd, false);
 			for (i = 0; i < idxd->max_wqs; i++) {
 				struct idxd_wq *wq = idxd->wqs[i];
 
@@ -474,7 +522,8 @@ static irqreturn_t idxd_halt(struct idxd_device *idxd)
 
 		} else {
 			idxd->state = IDXD_DEV_HALTED;
-			idxd_wqs_quiesce(idxd);
+			/* Same as above: nothing in flight will ever complete. */
+			idxd_wqs_halt_flush(idxd, false);
 			idxd_wqs_unmap_portal(idxd);
 			idxd_device_clear_state(idxd);
 			dev_err(&idxd->pdev->dev,
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index fab3e0176cba..cf8536e94c15 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -132,10 +132,14 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 			}
 
 			/*
-			 * A finished descriptor goes on the work list for
-			 * the interrupt thread, as one still in flight does,
-			 * rather than being completed in the submitter's
-			 * context.
+			 * A completion runs a client's callback or another
+			 * driver's handler, and either may submit or terminate
+			 * and so wait for a killer, which waits for this
+			 * submitter's wq_active reference. iaa_crypto's verify
+			 * of a compression may also wait for a free descriptor
+			 * while this submitter holds one. A finished
+			 * descriptor therefore goes on the work list for the
+			 * interrupt thread, as one still in flight does.
 			 */
 			if (d->completion->status)
 				wake = true;
@@ -156,10 +160,16 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 
 	/*
 	 * The device never took the descriptor, so its record is still
-	 * clear. The interrupt thread and another submitter's abort sort
-	 * the lists under the list lock and leave one with a clear record
-	 * on a list, so the search finds the descriptor, and once off the
-	 * lists it is the submitter's alone. Marking it aborted before
+	 * clear. While this submitter holds wq_active, only the interrupt
+	 * thread and another submitter's abort may take descriptors off
+	 * the lists, and both sort them under the list lock and leave one
+	 * with a clear record on a list. A flush takes them all, so every
+	 * flusher must kill wq_active and wait for this reference before
+	 * it takes the lists, and nothing may revive the reference before
+	 * the flush runs. The error path of iaa_crypto_probe() breaks the
+	 * rule: it disables a queue it has already published without a
+	 * quiesce. Otherwise the search finds the descriptor, and once off
+	 * the lists it is the submitter's alone. Marking it aborted before
 	 * that would let another context that saw the mark on a list
 	 * complete and free it, and the caller frees it as well.
 	 */
@@ -215,6 +225,22 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 			return -ENXIO;
 	}
 
+	/*
+	 * A software-reset halt revives wq_active before its reinit enables
+	 * the device again. A submitter that passed the check above before
+	 * the halt and got its reference after the revive would post to the
+	 * halted device, which drops the descriptor, and nothing would
+	 * complete an interrupt-armed one. The halt stores the state before
+	 * its kill and revives the reference after the wait. The barrier
+	 * pairs with the release in percpu_ref_reinit() and orders this
+	 * read after the tryget that saw the revive.
+	 */
+	smp_rmb();
+	if (idxd->state != IDXD_DEV_ENABLED) {
+		percpu_ref_put(&wq->wq_active);
+		return -EIO;
+	}
+
 	portal = idxd_wq_portal_addr(wq);
 
 	/*
@@ -239,10 +265,18 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 	} else {
 		rc = idxd_enqcmds(wq, portal, desc->hw);
 		if (rc < 0) {
-			percpu_ref_put(&wq->wq_active);
-			/* abort operation frees the descriptor */
+			/*
+			 * Abort before dropping the reference: a halt flush
+			 * waits for wq_active to die before it takes the
+			 * pending descriptors, and this one must not still be
+			 * listed when it does. The abort takes the descriptor
+			 * off the lists and runs no callback, which could wait
+			 * for this reference to die. The caller completes or
+			 * frees the descriptor.
+			 */
 			if (ie)
 				llist_abort_desc(wq, ie, desc);
+			percpu_ref_put(&wq->wq_active);
 			return rc;
 		}
 	}
-- 
2.43.0

