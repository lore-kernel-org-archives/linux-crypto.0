Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422880;
	b=N9x3lp9tPHHXul/VtV0/YwESsmk9YvbHjnVEEw1fJLuSGre+/Guw1aDFPvndKVacsLxQ
	 OtUGNvF6aVfvK5HYq3jzikwQc5YCVchbGc8GLeKB7uVVl2egOVGBaupgHG9kKWz0HaUQk
	 g0qd27L7AKxwIbp/IOT+ZQaETM7B4zockUIBgF/U1bpb2FE/NgC3mNh4JCU0YgLu6MmLm
	 GzfXog02/44L887QtRzcInFQJwrq74I+xTQKKo09f44JZCe5lJIcsNevFlVxyn8Y8AnsK
	 8bOvNeYmhje6YyQNb6cl4wVbs9rdQ4ydmoQbay9YWSVnFaRyBGYdMtKBam23eP0tpyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422880;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/sR/qr3wNghQPSbmzJH0FRDpYdJ4IAbfFL35MswEGf4=;
	b=SeeTENQ0S7hcEDnkVc2+wgvHJT8S1vxFS41tetsw65lUTeysH6uIunG1Sv1zA5KxNpHh
	 Bw1WlfiM8457lPODF6ijo/obD4hhIQq+EOPAIFke7TohAlJXRIR2VM5OkvMwiJTOZpJR+
	 2GT4wA1LgiC+cEVsicntsEX48fCufeZJpWKXbTGqZ6eftNL9sefanrwkNeTiLqC/oU5H5
	 2u4uc9xigeUQjXvaMA2yP1ApVvwXnUDuR0cjZhk0OSozD4qiERz7K6CBiPWQvgRJCuM1v
	 SDRPx5i3lpEODa+A0WlCz3FeTaJRYszai4O0ltKUpeu5lMhHKZT0O6u+QrWvR2sgMtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Nr5smz6G;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0997609CEE3;
	Mon, 19 Oct 2026 15:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0997609CEE3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Nr5smz6G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422880; x=1823958880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kjIEKWxyEWzOKHNbrUmC0TVqwNqMYsVDZrB3bHb4Gwo=;
  b=Nr5smz6G9/YWzXdfbsiLYK/ouitQdMsaxXA4MiavpAVR3vNwlESjg0MH
   BhJIXM1ZtWYuTf90/vetBDIJZCzJOzdkw+5AIyZLHpunc3jeaEEKP25Kf
   gdW9oU5QucRUjtLkYMEJxNOk2rAtEjY8ufw080V1RA83ouc2V+H0VD9yl
   K7Ta7n1C9ytXyCKNbgqY3utYp3whcYHGU4PwY8vy9RRm5zolezDLgkkg6
   mS2SGvUf5O6qkKtZ7aYwPtsWF3IDsU+eu5cs4I5mAkR2Y3mN99MlUsDe2
   zFfRrZz4JTTIWWLxIy5YKZY8/l783baFL7IU0DySPescxhThFBWNwK8jF
   A==;
X-CSE-ConnectionGUID: Rgn+1VJvS7KwB0uUfe0HGA==
X-CSE-MsgGUID: gezt2/4lSZiF00uOZ6jmdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986933"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986933"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:35 -0700
X-CSE-ConnectionGUID: kDVV5SLWQ1iTz/Yx4vPcwA==
X-CSE-MsgGUID: EpqCT2+qQ52AFPfq1+MEag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536995"
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
Subject: [PATCH 14/17] dmaengine: idxd: complete an iaa_crypto descriptor through its own driver on abort and flush
Date: Mon, 19 Oct 2026 08:06:27 -0700
Message-ID: <20261019150630.4026341-15-daniel1.byrne@intel.com>
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

The teardown flush and the submit abort complete every descriptor as a
dmaengine transaction, whichever driver owns the queue. An iaa_crypto
queue is a kernel queue as well, and its interrupt-armed descriptors
carry the crypto request where a dmaengine descriptor has its txd, so
completing one of them as a transaction takes the request pointer for
a cookie and a DMA address for the channel, and either hits the cookie
BUG_ON() or stores through that address. A single iaa_crypto client
reaches this without a halt or a shared channel: in the teardown flush
after a drain that failed or after free_irq() lost a completion
interrupt, and in a guest on every failed interrupt-armed submission to
a shared queue that other guests keep full.

Complete such a descriptor through the completion of the driver that
owns the queue, as the interrupt thread does, and mark one the device
never finished as aborted first so that the driver fails its request.
The txd handling, the callback strip and the quarantine stay with
dmaengine queues. A failed submission of another driver's descriptor is
left entirely to its submitter, which learns of it from the return
value.

The teardown flush frees each descriptor it completes only when that
completion returns, and iaa_crypto's verify allocates from inside one.
A blocking allocation therefore fails at once on a queue whose
wq_active is dead with no revive to come, rather than wait for a slot
only the flush could free. Every submission there fails anyway.

Fixes: 09646c98d0bf ("crypto: iaa - Add irq support for the crypto async interface")
Cc: stable@vger.kernel.org # 6.8+
Assisted-by: Claude:claude-opus-5
Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/device.c | 23 +++++++++++++++++++----
 drivers/dma/idxd/idxd.h   | 10 ++++++++++
 drivers/dma/idxd/submit.c | 22 +++++++++++++++++++++-
 3 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 222c201669bd..a33c4309f5d4 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1534,10 +1534,25 @@ static void idxd_flush_pending_descs(struct idxd_irq_entry *ie,
 		list_del(&desc->list);
 		ctype = desc->completion->status ? IDXD_COMPLETE_NORMAL : IDXD_COMPLETE_ABORT;
 		/*
-		 * wq is being disabled. Any remaining descriptors are
-		 * likely to be stuck and can be dropped. callback could
-		 * point to code that is no longer accessible, for example
-		 * if dmatest module has been unloaded.
+		 * Another driver's descriptor carries that driver's request
+		 * in place of a txd, and a client may still wait for it, so it
+		 * goes back through that driver's completion. The completion
+		 * reads the outcome from the record, which the device never
+		 * wrote for an unfinished descriptor. Only a dmaengine channel
+		 * terminates, so nothing of such a queue is quarantined.
+		 */
+		if (!idxd_wq_has_txd(wq)) {
+			if (ctype == IDXD_COMPLETE_ABORT)
+				desc->completion->status = IDXD_COMP_DESC_ABORT;
+			idxd_desc_complete(desc, ctype, true);
+			continue;
+		}
+		/*
+		 * wq is being disabled or terminated. Any remaining
+		 * descriptors are likely to be stuck and can be dropped.
+		 * With no client left the callback could point to code that
+		 * is no longer accessible (dmatest unloaded), and a client's
+		 * own terminate must not get it, so it is stripped.
 		 */
 		tx = &desc->txd;
 		tx->callback = NULL;
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 9d88b0d82fee..3caf9fc00f83 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -755,6 +755,16 @@ void idxd_dma_complete_txd(struct idxd_desc *desc,
 			   enum idxd_complete_type comp_type,
 			   bool free_desc, void *ctx, u32 *status);
 
+/*
+ * Whether the queue's descriptors are dmaengine transactions. Another
+ * driver, such as iaa_crypto, keeps its own context where they keep
+ * their txd.
+ */
+static inline bool idxd_wq_has_txd(struct idxd_wq *wq)
+{
+	return wq_to_idxd_drv(wq)->desc_complete == idxd_dma_complete_txd;
+}
+
 static inline void idxd_desc_complete(struct idxd_desc *desc,
 				      enum idxd_complete_type comp_type,
 				      bool free_desc)
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 5806b1b74a2f..fab3e0176cba 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -52,6 +52,21 @@ struct idxd_desc *idxd_alloc_desc(struct idxd_wq *wq, enum idxd_op_type optype)
 		return __get_desc(wq, idx, cpu);
 	}
 
+	/*
+	 * A dying reference whose resurrect has completed belongs to a
+	 * queue quiesced for good: no kill in progress will revive it, and
+	 * every submission fails. Waiting for a slot there gains nothing
+	 * and may never end. The teardown flush and the interrupt thread
+	 * free the slot of each descriptor they complete only when its
+	 * completion returns, and iaa_crypto's verify of a compression
+	 * allocates from inside one. The two reads are not atomic, so an
+	 * allocation that races a revive can fail like a request the kill
+	 * caught.
+	 */
+	if (data_race(percpu_ref_is_dying(&wq->wq_active)) &&
+	    completion_done(&wq->wq_resurrect))
+		return ERR_PTR(-ENXIO);
+
 	ws = &sbq->ws[0];
 	for (;;) {
 		sbitmap_prepare_to_wait(sbq, ws, &wait, TASK_INTERRUPTIBLE);
@@ -149,7 +164,12 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 	 * complete and free it, and the caller frees it as well.
 	 */
 	WARN_ON_ONCE(!found);
-	if (found)
+	/*
+	 * Another driver's submitter cleans up all of its own: it learns
+	 * of the failure from the return value and its descriptor carries
+	 * its request where a dmaengine descriptor has its txd.
+	 */
+	if (found && idxd_wq_has_txd(wq))
 		idxd_dma_complete_txd(desc, IDXD_COMPLETE_ABORT, false,
 				      NULL, NULL);
 }
-- 
2.43.0

