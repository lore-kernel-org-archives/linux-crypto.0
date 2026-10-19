Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422881;
	b=Woah/MeQhcPzUgpWvAX2HHj2OY4kF3jcUTYF6Oct1/E4+YwY8feZPpbH3A6QEgitg5jy
	 e6jh42svcKVELy8RHHolCsenR0GIqFxOXC+DAxBwrAiP7icWpHV/0M2HhVpZv0hYE8rNg
	 1c4NQyk+NZzZnjnBoEKpVdZk9wj3VQfJKSJLXjMptNS1whzjIoBb3j1orAYhTydIGpXfE
	 9jowowlyjzI+3uhhdMZvKlbpCsO8t8vprIIvb4l0e3cd9t9+qvH+LAeVFcCZh8yAGAkiL
	 GdfAhmWP75n6Oh3wxSycOu1gEs8rZyJIOU/eo7RnUUEClHaChdACNgQVh3C8jZnWItQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422881;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QBSucmfJw9xuBbx9/KpuocBa1kU7q1+yPsaBqG6Kv9g=;
	b=KNsoXQ/JQcZtOl/vM0cB5kstNdOmSjUHPGn8I4MVlwNag+xQihRhDYIgtg6KpHFH3JMf
	 LbOkIcc1Pda5sSeKnQs1J9qrOM6GOUuGI16Si0et0t65vb1TBEr8NysILwvptZeRbpide
	 k/OAOa4Fh5pPsM9Yllo3wSyJk+Hh20m1dq3BT/v57gq2DTA7gi9yuIf5XhPif/g5vnp7C
	 GkwfUiVnp1y5QIU5WgKeMFbGu1kLycgA9lheaDJsn8gjpHMwX8POm5T8mzxzOA3JruJvh
	 WEvUbYBp59lYorbr63Nb5BhI8Fg1VMSVY5XGuEirad1AUgSBNuNy5LUGkwxLRkIMEvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dyszr3lg;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA11609CEDB;
	Mon, 19 Oct 2026 15:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BA11609CEDB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dyszr3lg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422881; x=1823958881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HrFbAe56yxHEGdqsvuNCyX8nFEz/y0cGDlfYHNwbpkc=;
  b=dyszr3lg1NEqNQUTTHn/hePEN5qVUU1PJ2MWPGF9X0J5iNEMwZaht2Lj
   /OQaD/qnE1WGOjIEaXO5w6L3CN6ajkzhgMrRpm2KsW0ixmxKD4apd54WK
   sC4lQ12Rc6T77k8CX1JOE1YwakDnZI4AKn0iahx+xtu/tR4iCcTkp6Ldw
   0dQfy+Ltd1V0S0ZNJz9djNWJAaRN9l17EtaAdq3DtXFVutrBBlhz/XQmu
   Q77Mhtqzzkw0CSuWVGQuXOQ/Ztc3lYDNMerwXGP1nVpkXYmgYWvH64HMj
   eYic8UjkUbr8NVoHUDyMVajeX8UcmgNVA8xHPzGj11TMXxBswzS9JWjpi
   A==;
X-CSE-ConnectionGUID: LI1NP5p3RVu9kptPwHKeQw==
X-CSE-MsgGUID: OTol2+f/RLGlNqGAgE5Rtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986939"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986939"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:35 -0700
X-CSE-ConnectionGUID: LG8U2tw0Tf+WDKate79NXQ==
X-CSE-MsgGUID: k5OmeCe2TJyB/TMohfYb7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2537003"
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
Subject: [PATCH 16/17] dmaengine: idxd: keep client callbacks on a halt flush and cancel resubmissions after a terminate
Date: Mon, 19 Oct 2026 08:06:29 -0700
Message-ID: <20261019150630.4026341-17-daniel1.byrne@intel.com>
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

idxd_flush_pending_descs() strips every callback unconditionally. That
is right when a work queue is torn down with nobody left to call, since
the callback may point into an unloaded module, and wrong when the
device halts with a client still holding the channel: the client then
waits on descriptors that were quietly completed without it.

Take the choice as a parameter. Teardown paths and a client's own
terminate_all keep stripping; the halt flush keeps the callbacks when
the channel has a client. That flush runs under wq_lock, and a callback
may terminate the channel, which takes that lock, so the flush does not
run the callbacks itself: it marks every descriptor the halted device
never finished as aborted, leaves it on the work list with the finished
ones, and wakes the queue's interrupt thread, which completes them
without the lock. The client sees DMA_TRANS_WRITE_FAILED for a
descriptor the halt killed, as for every abort the driver marks.

llist_abort_desc() has the mirror problem. A failed submission is
reported to the client by idxd_submit_desc()'s return value and the
client frees the descriptor, so a callback on top of that completes it
twice. The driver's own interrupt-handle resubmission has no return
path to the client at all, and there the abort must go through the
callback. Split the submit helper: idxd_submit_desc() keeps the
caller-cleans-up contract and strips the callbacks of a found
descriptor, and the new idxd_resubmit_desc() is what the resubmit
worker uses so that a failure there still reaches the client.

Since "dmaengine: idxd: keep the interrupt handle across terminate_all"
such a resubmission really runs, and a terminate_sync() no longer
covers it. A flush that strips the callbacks therefore completes a
descriptor that reports a revoked handle as aborted instead of
resubmitting it. A descriptor submitted before a terminate can still
reach the resubmit work after the flush, from a work item queued
earlier or from the interrupt thread. terminate_all bumps a per-queue
generation under wq_lock before its kill, an interrupt-armed client
submission stamps it into the descriptor, and a resubmission whose
stamp is older is cancelled once it holds wq_active and completed
without its callback.

Assisted-by: Claude:claude-opus-5
Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/device.c | 54 ++++++++++++++++++++++++++++++++------
 drivers/dma/idxd/dma.c    | 12 ++++++++-
 drivers/dma/idxd/idxd.h   | 13 +++++++--
 drivers/dma/idxd/irq.c    | 27 +++++++++++--------
 drivers/dma/idxd/submit.c | 55 ++++++++++++++++++++++++++++++++++-----
 5 files changed, 132 insertions(+), 29 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 158c141650e3..5ccdc5ff8d53 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1527,7 +1527,7 @@ int idxd_device_load_config(struct idxd_device *idxd)
 }
 
 static void idxd_flush_pending_descs(struct idxd_irq_entry *ie,
-				     bool quarantine)
+				     bool keep_callbacks, bool quarantine)
 {
 	struct idxd_wq *wq = ie_to_wq(ie);
 	struct idxd_desc *desc, *itr;
@@ -1543,6 +1543,28 @@ static void idxd_flush_pending_descs(struct idxd_irq_entry *ie,
 			list_add_tail(&desc->list, &ie->work_list);
 	}
 
+	/*
+	 * A halt flush that delivers the callbacks of a dmaengine queue
+	 * leaves its descriptors to the interrupt thread, which runs them
+	 * without wq_lock, as it runs every completion. A callback may
+	 * terminate the channel, which takes that lock, and the halt flush
+	 * holds it. The halted device writes no record any more, so one it
+	 * never finished is marked aborted for the thread to complete.
+	 */
+	if (keep_callbacks && idxd_wq_has_txd(wq)) {
+		bool wake = false;
+
+		list_for_each_entry(desc, &ie->work_list, list) {
+			if (!desc->completion->status)
+				desc->completion->status = IDXD_COMP_DESC_ABORT;
+			wake = true;
+		}
+		spin_unlock(&ie->list_lock);
+		if (wake)
+			irq_wake_thread(ie->vector, ie);
+		return;
+	}
+
 	list_for_each_entry_safe(desc, itr, &ie->work_list, list)
 		list_move_tail(&desc->list, &flist);
 	spin_unlock(&ie->list_lock);
@@ -1571,7 +1593,8 @@ static void idxd_flush_pending_descs(struct idxd_irq_entry *ie,
 		 * descriptors are likely to be stuck and can be dropped.
 		 * With no client left the callback could point to code that
 		 * is no longer accessible (dmatest unloaded), and a client's
-		 * own terminate must not get it, so it is stripped.
+		 * own terminate must not get it, so it is stripped. A halt
+		 * that delivers the callbacks left them to the thread above.
 		 */
 		tx = &desc->txd;
 		tx->callback = NULL;
@@ -1595,7 +1618,14 @@ static void idxd_flush_pending_descs(struct idxd_irq_entry *ie,
 			list_add_tail(&desc->list, &qlist);
 			continue;
 		}
-		idxd_dma_complete_txd(desc, ctype, true, NULL, NULL);
+		/*
+		 * The abort type keeps a record that reports a revoked
+		 * interrupt handle from being resubmitted. The device is done
+		 * with it, and with the handle kept across a terminate the
+		 * copy would run once the client may have freed its memory.
+		 */
+		idxd_dma_complete_txd(desc, IDXD_COMPLETE_ABORT, true, NULL,
+				      NULL);
 	}
 
 	if (list_empty(&qlist))
@@ -1693,7 +1723,7 @@ void idxd_wq_free_irq(struct idxd_wq *wq)
 		return;
 
 	free_irq(ie->vector, ie);
-	idxd_flush_pending_descs(ie, false);
+	idxd_flush_pending_descs(ie, false, false);
 
 	/* FLR revokes every handle; the halt path marks them invalid. */
 	if (ie->int_handle == INVALID_INT_HANDLE)
@@ -1714,12 +1744,19 @@ void idxd_wq_free_irq(struct idxd_wq *wq)
 }
 
 /*
+ * @keep_callbacks: deliver the flushed descriptors' completions to the
+ * client, aborted, or with their hardware status where the device had
+ * already finished them. A client's own terminate_all must not get them
+ * (the dmaengine contract); a device halt with a client still holding the
+ * channel must, or the client waits for them forever. The interrupt
+ * thread delivers them, outside wq_lock.
  * @quarantine: the device keeps running, so the slots of the descriptors
  * it has not finished stay out of use until a drain covers them. A halt
  * has killed them and frees their slots at once.
  * The caller holds wq_lock.
  */
-void __idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine)
+void __idxd_wq_flush_descs(struct idxd_wq *wq, bool keep_callbacks,
+			   bool quarantine)
 {
 	struct idxd_irq_entry *ie = &wq->ie;
 	bool killed = false;
@@ -1737,17 +1774,18 @@ void __idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine)
 	 */
 	if (quarantine)
 		killed = idxd_wq_kill(wq);
-	idxd_flush_pending_descs(ie, quarantine);
+	idxd_flush_pending_descs(ie, keep_callbacks, quarantine);
 	if (killed) {
 		percpu_ref_reinit(&wq->wq_active);
 		complete_all(&wq->wq_resurrect);
 	}
 }
 
-void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine)
+void idxd_wq_flush_descs(struct idxd_wq *wq, bool keep_callbacks,
+			 bool quarantine)
 {
 	guard(mutex)(&wq->wq_lock);
-	__idxd_wq_flush_descs(wq, quarantine);
+	__idxd_wq_flush_descs(wq, keep_callbacks, quarantine);
 }
 
 int idxd_wq_request_irq(struct idxd_wq *wq)
diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index 1d08856f5c4e..0a7517cb51f2 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -199,8 +199,18 @@ static int idxd_dma_terminate_all(struct dma_chan *c)
 {
 	struct idxd_wq *wq = to_idxd_wq(c);
 
+	guard(mutex)(&wq->wq_lock);
+	/*
+	 * A descriptor that completed with a revoked interrupt handle is
+	 * resubmitted by a work item. One submitted before this terminate
+	 * may reach that work after the flush, from the interrupt thread or
+	 * from a work item queued earlier, and is cancelled there rather
+	 * than run with its callback once the client may have freed its
+	 * memory.
+	 */
+	WRITE_ONCE(wq->terminate_gen, wq->terminate_gen + 1);
 	/* The device keeps running what the lists held. See synchronize. */
-	idxd_wq_flush_descs(wq, true);
+	__idxd_wq_flush_descs(wq, false, true);
 
 	return 0;
 }
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 0ad61bc233e8..b0cfd7101174 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -229,6 +229,9 @@ struct idxd_wq {
 				 * time, so no slot is reused until a later
 				 * drain completes or a halt kills them
 				 */
+	u16 terminate_gen;	/* bumps on every terminate_all, under
+				 * wq_lock before its kill
+				 */
 	struct list_head quarantine;	/* descriptors a terminate_all took
 					 * off the lists while the device
 					 * still held them. Their slots, with
@@ -444,6 +447,9 @@ struct idxd_desc {
 	struct list_head list;
 	int id;
 	int cpu;
+	u16 terminate_gen;	/* the queue's terminate_gen at an
+				 * interrupt-armed submit
+				 */
 	struct idxd_wq *wq;
 };
 
@@ -832,8 +838,10 @@ void idxd_wq_quiesce(struct idxd_wq *wq);
 int idxd_wq_init_percpu_ref(struct idxd_wq *wq);
 void idxd_wq_free_irq(struct idxd_wq *wq);
 int idxd_wq_request_irq(struct idxd_wq *wq);
-void __idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine);
-void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine);
+void __idxd_wq_flush_descs(struct idxd_wq *wq, bool keep_callbacks,
+			   bool quarantine);
+void idxd_wq_flush_descs(struct idxd_wq *wq, bool keep_callbacks,
+			 bool quarantine);
 void idxd_wq_quarantine_take(struct idxd_wq *wq, struct list_head *list);
 void idxd_wq_quarantine_put_back(struct idxd_wq *wq, struct list_head *list);
 void idxd_wq_quarantine_free(struct idxd_wq *wq, struct list_head *list);
@@ -841,6 +849,7 @@ void idxd_wq_halt_release(struct idxd_wq *wq);
 
 /* submission */
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc);
+int idxd_resubmit_desc(struct idxd_wq *wq, struct idxd_desc *desc);
 struct idxd_desc *idxd_alloc_desc(struct idxd_wq *wq, enum idxd_op_type optype);
 int idxd_enqcmds(struct idxd_wq *wq, void __iomem *portal, const void *desc);
 
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 99b2df7fc2de..4517a09fcf1b 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -452,7 +452,7 @@ static void idxd_wqs_halt_flush(struct idxd_device *idxd, bool resurrect)
 			continue;
 		}
 		killed = idxd_wq_kill(wq);
-		__idxd_wq_flush_descs(wq, false);
+		__idxd_wq_flush_descs(wq, idxd_wq_refcount(wq) > 0, false);
 		idxd_wq_halt_release(wq);
 
 		if (resurrect) {
@@ -659,22 +659,27 @@ static void idxd_int_handle_resubmit_work(struct work_struct *work)
 	int rc;
 
 	desc->completion->status = 0;
-	rc = idxd_submit_desc(wq, desc);
+	rc = idxd_resubmit_desc(wq, desc);
 	if (rc < 0) {
 		dev_dbg(&wq->idxd->pdev->dev, "Failed to resubmit desc %d to wq %d.\n",
 			desc->id, wq->id);
 		/*
-		 * If the error is not -EAGAIN, it means the submission failed due to wq
-		 * has been killed instead of ENQCMDS failure. Here the driver needs to
-		 * notify the submitter of the failure by reporting abort status.
-		 *
-		 * -EAGAIN comes from ENQCMDS failure. idxd_submit_desc() will handle the
-		 * abort.
+		 * The submission failed because the device is not enabled,
+		 * because the wq has been killed or because ENQCMDS failed,
+		 * and in each case the descriptor is on no list. Here the
+		 * driver needs to notify the submitter of the failure by
+		 * reporting abort status. The submit has dropped its
+		 * wq_active reference by now, so a callback that submits or
+		 * terminates does not wait for it. A descriptor submitted
+		 * before a terminate_all, which cancels its resubmission,
+		 * gets no callback, since its client terminated it.
 		 */
-		if (rc != -EAGAIN) {
-			desc->completion->status = IDXD_COMP_DESC_ABORT;
-			idxd_desc_complete(desc, IDXD_COMPLETE_ABORT, false);
+		if (desc->terminate_gen != READ_ONCE(wq->terminate_gen)) {
+			desc->txd.callback = NULL;
+			desc->txd.callback_result = NULL;
 		}
+		desc->completion->status = IDXD_COMP_DESC_ABORT;
+		idxd_desc_complete(desc, IDXD_COMPLETE_ABORT, false);
 		idxd_free_desc(wq, desc);
 	}
 	kfree(irw);
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index cf8536e94c15..469a0cadb984 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -112,7 +112,7 @@ static struct idxd_desc *list_abort_desc(struct idxd_wq *wq, struct idxd_irq_ent
 }
 
 static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
-			     struct idxd_desc *desc)
+			     struct idxd_desc *desc, bool submitter_cleans)
 {
 	struct idxd_desc *d, *t, *found = NULL;
 	struct llist_node *head;
@@ -175,13 +175,23 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 	 */
 	WARN_ON_ONCE(!found);
 	/*
-	 * Another driver's submitter cleans up all of its own: it learns
-	 * of the failure from the return value and its descriptor carries
-	 * its request where a dmaengine descriptor has its txd.
+	 * When the failing submission is a client's tx_submit(), the
+	 * client learns of it from the return value and owns the cleanup,
+	 * and a callback on top of that would complete the descriptor
+	 * twice. A dmaengine descriptor then only has its cookie completed
+	 * and its unmap data released here, with the callbacks stripped.
+	 * Nothing reads its record before the caller frees it, so it is
+	 * not marked. An internal resubmission reports the abort through
+	 * the callback, which its worker runs once the submit has dropped
+	 * its reference. Another driver's submitter cleans up all of its
+	 * own, and only dmaengine descriptors are resubmitted.
 	 */
-	if (found && idxd_wq_has_txd(wq))
+	if (found && submitter_cleans && idxd_wq_has_txd(wq)) {
+		desc->txd.callback = NULL;
+		desc->txd.callback_result = NULL;
 		idxd_dma_complete_txd(desc, IDXD_COMPLETE_ABORT, false,
 				      NULL, NULL);
+	}
 }
 
 /*
@@ -208,7 +218,8 @@ int idxd_enqcmds(struct idxd_wq *wq, void __iomem *portal, const void *desc)
 	return rc;
 }
 
-int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
+static int __idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc,
+			      bool submitter_cleans)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct idxd_irq_entry *ie = NULL;
@@ -240,6 +251,19 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 		percpu_ref_put(&wq->wq_active);
 		return -EIO;
 	}
+	/*
+	 * A resubmission of a descriptor first submitted before a
+	 * terminate_all is cancelled. The terminate bumps the generation
+	 * before its kill, so the barrier above orders this read too. A
+	 * resubmission that read the old one is on the pending list when
+	 * the terminate's flush runs, since the kill waits for it, or has
+	 * failed with its stamp unchanged.
+	 */
+	if (!submitter_cleans &&
+	    desc->terminate_gen != READ_ONCE(wq->terminate_gen)) {
+		percpu_ref_put(&wq->wq_active);
+		return -ECANCELED;
+	}
 
 	portal = idxd_wq_portal_addr(wq);
 
@@ -250,6 +274,12 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 	if (desc_flags & IDXD_OP_FLAG_RCI) {
 		ie = &wq->ie;
 		desc->hw->int_handle = ie->int_handle;
+		/*
+		 * A resubmission keeps the stamp of the client's submit, so
+		 * the resubmit work sees every terminate since then.
+		 */
+		if (submitter_cleans)
+			desc->terminate_gen = READ_ONCE(wq->terminate_gen);
 		llist_add(&desc->llnode, &ie->pending_llist);
 	}
 
@@ -275,7 +305,7 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 			 * frees the descriptor.
 			 */
 			if (ie)
-				llist_abort_desc(wq, ie, desc);
+				llist_abort_desc(wq, ie, desc, submitter_cleans);
 			percpu_ref_put(&wq->wq_active);
 			return rc;
 		}
@@ -284,4 +314,15 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 	percpu_ref_put(&wq->wq_active);
 	return 0;
 }
+/* A client submission: on failure the return value is the notification. */
+int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
+{
+	return __idxd_submit_desc(wq, desc, true);
+}
 EXPORT_SYMBOL_NS_GPL(idxd_submit_desc, "IDXD");
+
+/* The driver's own resubmission: a failure must still call the client back. */
+int idxd_resubmit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
+{
+	return __idxd_submit_desc(wq, desc, false);
+}
-- 
2.43.0

