Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422878;
	b=umPVcKQs95dRzQjOEHoWzSMM41hFTslD20oGyQ4w69T8L16mM+Ms7wYoHBvuvFOXD66i
	 tBGdjNgE4usCzfu7nu25nT7NPBY0zaCfvfJ3xOVlS4zNQctbYrn0ZI0q+RZ1CzWwa/FCb
	 Q5H3KYjP93Kc7FqhN31ZYQZOZaKDnAapt3/UNCXjyLnrRpq+YiovtFaQM/K9kNvIMeGsw
	 DAEiU4UcMO4eq59pWNAC3vrgM1WihC75oswz/wgZaApTlT+fF1c8Ami2S9Jm/gV6zvskz
	 cY/P5JsV4TQavityW4C1Q8vCuBvH9tsNwRtUjVBzzoA9yZSPT2bayDgblyeSzhtG/TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422878;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wyMNmoV7LLQCe5NBcl4HLsDDXaPs+fkB0uZvlmUvPpk=;
	b=5lDqgc6hMpBPjErUHEwp7FRZfiV+SJske6njyALFB+CCJGtE+XSsdijHVotkx9uIFFlt
	 ZM8QxskjEiE1waWHSynDx4GwVpE2Zx/ehfwJ5zJ8ixafmBw62BtbLGh24nvs7IgzlVsEq
	 88pX0Sf6rjbCvI4nivG6F9ulvs9xZOvbovziQjojHG86m2NP4OTKN4mX6FQBLYcmWC75Y
	 ei/z5LlfLVRNAyhkFlgUCLFOtyh2A22HhpVeDNu9RmXdWBuFSNkDta1/GKJlmve5JiMSZ
	 be5grZ+wsGTFMJfnP+StWGjyKKnHkWK3IhwmsxJlMHWBgOjLHUEig+OSRQTC54qvMeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Rl9D987c;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C82609CEDD;
	Mon, 19 Oct 2026 15:14:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21C82609CEDD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Rl9D987c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422878; x=1823958878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QgVVF5Nil8kjcN6fX6wTMPSDsxBuQH1tWzFFSyv8gGU=;
  b=Rl9D987cQLXUlIl6L+kbGyP9YFXcJAIF7UsdkcdlNhsN8C4DxrgXKqSc
   /vXoNejC8cwe0TGp7bzXJrBJo3SR5EkeNywCh2NyOvlMPPtR0EP3XaKmX
   dpOAy0ZRFH421XM1ulKtAGSYGX7aUNm8mhtaMXtU6jKGFdp1TTG60/nWH
   nrilSJrvDHW1JKLze5OJHYQ7fZkVCdhKjM8nuWh2jE8UU1CyJ1ow4ouCi
   betzTIhNq7D9Uyh0Zx67Et2IVP1XEaQd1YxS1CSs88SJw8atXX6IzC9NR
   OWs6dIzr65dObfPif81fpmxmK6cUI8/UMg9+UlrbPjEYbV7V/R3xhzey7
   A==;
X-CSE-ConnectionGUID: yhvr66Z5Re6Q5pKqsMBoHA==
X-CSE-MsgGUID: ofFD/Pj0QVW1byhtQMBtYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986918"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986918"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: AaLch5cvQiq1SnRJDFgN6Q==
X-CSE-MsgGUID: XyYt6r+vSMi0J3gzW3jB6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536974"
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
Subject: [PATCH 09/17] dmaengine: idxd: quarantine terminate_all's descriptor slots until the device has drained
Date: Mon, 19 Oct 2026 08:06:22 -0700
Message-ID: <20261019150630.4026341-10-daniel1.byrne@intel.com>
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

idxd_dma_terminate_all() flushes the pending descriptors and frees their
slots while the device still holds them. A late completion record then
lands on the slot's next owner and completes it with the old
descriptor's status, and the unmap data the client attached is released
while the device may still access the memory it maps; with an IOMMU
another mapping can reuse the released address and take the late
access.

Keep those slots out of use instead. terminate_all now waits for the
submitters in flight, so that every descriptor on the lists is in the
device, and the flush moves the descriptors the device has not finished
to a per-queue quarantine, with their unmap data, after it has completed
their cookies. device_synchronize() takes the quarantine, drains the
queue, which covers everything the device held when the drain was
issued, and only then frees the slots and the unmap data. A descriptor
terminated after the take waits for the next synchronize. The halt flush
frees the quarantine itself, since the halt killed every descriptor the
device held, and so does the queue disable once its drain and reset
have completed.

Fixes: 2a93f5747d0e ("dmaengine: idxd: Flush all pending descriptors")
Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/device.c | 117 ++++++++++++++++++++++++++++++++++++--
 drivers/dma/idxd/dma.c    |  12 +++-
 drivers/dma/idxd/idxd.h   |  12 +++-
 drivers/dma/idxd/init.c   |   1 +
 drivers/dma/idxd/irq.c    |   3 +-
 5 files changed, 138 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 41223d2e20af..09475f5ea026 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -118,6 +118,8 @@ int idxd_wq_alloc_resources(struct idxd_wq *wq)
 	if (wq->type != IDXD_WQT_KERNEL)
 		return 0;
 
+	/* A fresh pool: nothing outstanding can land in it. */
+	INIT_LIST_HEAD(&wq->quarantine);
 	num_descs = wq_dedicated(wq) ? wq->size : wq->threshold;
 	wq->num_descs = num_descs;
 
@@ -170,10 +172,18 @@ EXPORT_SYMBOL_NS_GPL(idxd_wq_alloc_resources, "IDXD");
 void idxd_wq_free_resources(struct idxd_wq *wq)
 {
 	struct device *dev = &wq->idxd->pdev->dev;
+	LIST_HEAD(dead_descs);
 
 	if (wq->type != IDXD_WQT_KERNEL)
 		return;
 
+	/*
+	 * The disable frees the pool only after its drain and its reset
+	 * completed, and a failed enable has run nothing, so the device no
+	 * longer reaches what a quarantined descriptor maps.
+	 */
+	idxd_wq_quarantine_take(wq, &dead_descs);
+	idxd_wq_quarantine_free(wq, &dead_descs);
 	free_hw_descs(wq);
 	free_descs(wq);
 	dma_free_coherent(dev, wq->compls_size, wq->compls, wq->compls_addr);
@@ -1391,11 +1401,14 @@ int idxd_device_load_config(struct idxd_device *idxd)
 	return 0;
 }
 
-static void idxd_flush_pending_descs(struct idxd_irq_entry *ie)
+static void idxd_flush_pending_descs(struct idxd_irq_entry *ie,
+				     bool quarantine)
 {
+	struct idxd_wq *wq = ie_to_wq(ie);
 	struct idxd_desc *desc, *itr;
 	struct llist_node *head;
 	LIST_HEAD(flist);
+	LIST_HEAD(qlist);
 	enum idxd_complete_type ctype;
 
 	spin_lock(&ie->list_lock);
@@ -1423,8 +1436,82 @@ static void idxd_flush_pending_descs(struct idxd_irq_entry *ie)
 		tx = &desc->txd;
 		tx->callback = NULL;
 		tx->callback_result = NULL;
+		/*
+		 * A descriptor the device has not finished still has its
+		 * completion record to write. A flush that leaves the
+		 * device running keeps its slot out of use, or the record
+		 * would land on the slot's next owner and complete it with
+		 * this descriptor's status. Its unmap data stays with the
+		 * slot as well, since the device may still access what it
+		 * maps, and an address released now could be mapped again
+		 * for someone else before the late access.
+		 */
+		if (quarantine && ctype == IDXD_COMPLETE_ABORT) {
+			struct dmaengine_unmap_data *unmap = tx->unmap;
+
+			tx->unmap = NULL;
+			idxd_dma_complete_txd(desc, ctype, false, NULL, NULL);
+			tx->unmap = unmap;
+			list_add_tail(&desc->list, &qlist);
+			continue;
+		}
 		idxd_dma_complete_txd(desc, ctype, true, NULL, NULL);
 	}
+
+	if (list_empty(&qlist))
+		return;
+	spin_lock(&ie->list_lock);
+	list_splice_tail(&qlist, &wq->quarantine);
+	spin_unlock(&ie->list_lock);
+}
+
+/*
+ * Take what terminate_all has quarantined so far. A drain covers only
+ * what the device held when it was issued, so a synchronize takes the
+ * quarantine before it drains and frees it if the drain completed. A
+ * descriptor terminated meanwhile waits for the next one. The list lock
+ * serialises this with the flush that adds to the quarantine and with a
+ * halt or a teardown that frees it all.
+ */
+void idxd_wq_quarantine_take(struct idxd_wq *wq, struct list_head *list)
+{
+	spin_lock(&wq->ie.list_lock);
+	list_splice_init(&wq->quarantine, list);
+	spin_unlock(&wq->ie.list_lock);
+}
+
+/*
+ * Nothing the device holds can write their completion records, or reach
+ * the memory their unmap data maps, any more. The unmap data goes before
+ * the slot, which a new owner may take at once.
+ */
+void idxd_wq_quarantine_free(struct idxd_wq *wq, struct list_head *list)
+{
+	struct idxd_desc *desc, *itr;
+
+	list_for_each_entry_safe(desc, itr, list, list) {
+		list_del(&desc->list);
+		dma_descriptor_unmap(&desc->txd);
+		idxd_free_desc(wq, desc);
+	}
+}
+
+/*
+ * A halt killed every descriptor the device held: the quarantined slots
+ * are free. Under wq_lock, since an unbind racing the halt may free the
+ * pool.
+ */
+void idxd_wq_halt_release(struct idxd_wq *wq)
+{
+	LIST_HEAD(dead_descs);
+
+	guard(mutex)(&wq->wq_lock);
+
+	if (wq->state != IDXD_WQ_ENABLED || wq->type != IDXD_WQT_KERNEL)
+		return;
+
+	idxd_wq_quarantine_take(wq, &dead_descs);
+	idxd_wq_quarantine_free(wq, &dead_descs);
 }
 
 static void idxd_device_set_perm_entry(struct idxd_device *idxd,
@@ -1456,7 +1543,7 @@ void idxd_wq_free_irq(struct idxd_wq *wq)
 		return;
 
 	free_irq(ie->vector, ie);
-	idxd_flush_pending_descs(ie);
+	idxd_flush_pending_descs(ie, false);
 
 	/* FLR revokes every handle; the halt path marks them invalid. */
 	if (ie->int_handle == INVALID_INT_HANDLE)
@@ -1476,16 +1563,38 @@ void idxd_wq_free_irq(struct idxd_wq *wq)
 	ie->pasid = IOMMU_PASID_INVALID;
 }
 
-void idxd_wq_flush_descs(struct idxd_wq *wq)
+/*
+ * @quarantine: the device keeps running, so the slots of the descriptors
+ * it has not finished stay out of use until a drain covers them. A halt
+ * has killed them and frees their slots at once.
+ */
+void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine)
 {
 	struct idxd_irq_entry *ie = &wq->ie;
+	bool killed = false;
 
 	guard(mutex)(&wq->wq_lock);
 
 	if (wq->state != IDXD_WQ_ENABLED || wq->type != IDXD_WQT_KERNEL)
 		return;
 
-	idxd_flush_pending_descs(ie);
+	/*
+	 * A submitter between its list add and its portal write holds
+	 * wq_active. Waiting for the reference to die puts every listed
+	 * descriptor in the device, where the drain that frees the
+	 * quarantine covers it. A halt flush has done this itself.
+	 */
+	if (quarantine && !percpu_ref_is_dying(&wq->wq_active)) {
+		reinit_completion(&wq->wq_resurrect);
+		percpu_ref_kill(&wq->wq_active);
+		wait_for_completion(&wq->wq_dead);
+		killed = true;
+	}
+	idxd_flush_pending_descs(ie, quarantine);
+	if (killed) {
+		percpu_ref_reinit(&wq->wq_active);
+		complete_all(&wq->wq_resurrect);
+	}
 }
 
 int idxd_wq_request_irq(struct idxd_wq *wq)
diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index defd1af74c0a..196045cb9ef2 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -199,7 +199,8 @@ static int idxd_dma_terminate_all(struct dma_chan *c)
 {
 	struct idxd_wq *wq = to_idxd_wq(c);
 
-	idxd_wq_flush_descs(wq);
+	/* The device keeps running what the lists held. See synchronize. */
+	idxd_wq_flush_descs(wq, true);
 
 	return 0;
 }
@@ -207,8 +208,17 @@ static int idxd_dma_terminate_all(struct dma_chan *c)
 static void idxd_dma_synchronize(struct dma_chan *c)
 {
 	struct idxd_wq *wq = to_idxd_wq(c);
+	LIST_HEAD(quarantined);
 
+	/*
+	 * dmaengine_synchronize() promises the client that its memory may
+	 * be freed afterwards. The drain keeps that promise, and nothing
+	 * the device held before it is left to write a completion record,
+	 * so the slots terminate_all quarantined are free again.
+	 */
+	idxd_wq_quarantine_take(wq, &quarantined);
 	idxd_wq_drain(wq);
+	idxd_wq_quarantine_free(wq, &quarantined);
 }
 
 int idxd_register_dma_device(struct idxd_device *idxd)
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 221a7302bb0c..31bc4a506225 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -224,6 +224,13 @@ struct idxd_wq {
 	struct idxd_desc **descs;
 	struct sbitmap_queue sbq;
 	struct idxd_dma_chan *idxd_chan;
+	struct list_head quarantine;	/* descriptors a terminate_all took
+					 * off the lists while the device
+					 * still held them. Their slots, with
+					 * their unmap data, are freed once a
+					 * drain that covers them completes or
+					 * the device stops. Under ie.list_lock.
+					 */
 	char name[WQ_NAME_SIZE + 1];
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
@@ -807,7 +814,10 @@ void idxd_wq_quiesce(struct idxd_wq *wq);
 int idxd_wq_init_percpu_ref(struct idxd_wq *wq);
 void idxd_wq_free_irq(struct idxd_wq *wq);
 int idxd_wq_request_irq(struct idxd_wq *wq);
-void idxd_wq_flush_descs(struct idxd_wq *wq);
+void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine);
+void idxd_wq_quarantine_take(struct idxd_wq *wq, struct list_head *list);
+void idxd_wq_quarantine_free(struct idxd_wq *wq, struct list_head *list);
+void idxd_wq_halt_release(struct idxd_wq *wq);
 
 /* submission */
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 9c47a7b9e48e..c4319ac27bfb 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -213,6 +213,7 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 		init_waitqueue_head(&wq->err_queue);
 		init_completion(&wq->wq_dead);
 		init_completion(&wq->wq_resurrect);
+		INIT_LIST_HEAD(&wq->quarantine);
 		wq->max_xfer_bytes = WQ_DEFAULT_MAX_XFER;
 		idxd_wq_set_max_batch_size(idxd->data->type, wq, WQ_DEFAULT_MAX_BATCH);
 		idxd_wq_set_init_max_sgl_size(idxd, wq);
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index acb901e59a00..6f58d33b7297 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -427,7 +427,8 @@ static void idxd_wqs_flush_descs(struct idxd_device *idxd)
 	for (i = 0; i < idxd->max_wqs; i++) {
 		struct idxd_wq *wq = idxd->wqs[i];
 
-		idxd_wq_flush_descs(wq);
+		idxd_wq_flush_descs(wq, false);
+		idxd_wq_halt_release(wq);
 	}
 }
 
-- 
2.43.0

