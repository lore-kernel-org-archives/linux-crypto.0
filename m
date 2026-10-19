Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422881;
	b=lzgaGlk4RI82LYIrlofhD+0PUybyky0V3jibzWJLB5849AkRdYTmE57qhlT4A4WyV5xb
	 kuOlSuewmIw3QcI2Kf0qWNdTa+NgwjWQ8ez6z8BkacXOACjL3MIQ3zxrnVlOUr8lgrWNP
	 RfQR1lR3RpCaJVJqjmlHl+URCIDI9Ev6c9+RTc8SyEHvhM8Az02c+tPEASbxVCouai/+S
	 a/viH9k9/CLI68Io4FGwt6Qto/k6x05VIbYjJ4LA0ECA6vkcGlJ79J49QDTmHQ9wN4/W4
	 8k+KGwdYoBxJ1NgoDf8S7CiE0+lOGs4EU/3XsY+1PuzhMjr4Djki1L+fe9YJ4YDOJ2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422881;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4KPYc3E+o50lGpfkZzyN+iidtBIGIosti2i/oeYJMK4=;
	b=fTynAKvjvlLbD5a6I8rcyPf2QWRa7cV0OMn8XjJ+S2V46kY+/2PX80xTi0ercuxL7Nhn
	 jfSaPPBPmyXXrh+n1URA7c6DWR9C0Jp6vGqTNPwn8v6eeFzplhvnxf51t6CsVjecWfW7e
	 NAkuwYTGITUAJOGOhXT6VjyJlnxedSwJL3qGO5S1jvf2FyLKlaWVQo6zEeceVXehoJarW
	 QuvjkiRpQmK/fkTLdk+gTpNtSF/7A8JHz+y5b2hsh+Mxvq5F8G4/1HwdN23D+xqMWPOyD
	 ted4/UY1GdTPnVNlgdHANNW4lAKFnBIZuh2t8wRvD237LhguQi6JXQmsXeEs5tl6cEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T1el7Yp9;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8259609CEE0;
	Mon, 19 Oct 2026 15:14:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8259609CEE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T1el7Yp9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422879; x=1823958879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dC5QT0uihgVJxiEcFO1l7zrA7kQg0kL1a85c3o260k0=;
  b=T1el7Yp96xy2zHu/WGfKjLbN/zKZwFNfnmrYOgQyD6CJ63FtdSlUSjCv
   mZ2d/iQjBXHt8gd9MiGLikV2QMi1+b5AoCULyiw5rUEPojkooN1KdXgYn
   NNDbzkzhjiAv+rXvauLZo1gjjIvy+Yu5UPBqPdHAunbb+tIVMl/aZTcmL
   evH5hIsT4VDgLx5X7B68UMa0huHWDAHAUsrMEGKviK9YnE5rnO+18h/xu
   dOTCp0c3S3PzhipIazBhxsmDaQVN49VYT0LQKWxvZn23b/bdnP3n72LFB
   CXoBdLdgwf4Bb8a1WJ6wAOQUTbyHGzXnoV9TllCh0BwzkOrjOJNhHbSWQ
   A==;
X-CSE-ConnectionGUID: 5d0MSqvDT1K3NPPPQxTQ9A==
X-CSE-MsgGUID: taK4wTd3TPCeJao8Jfi27Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986930"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986930"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:35 -0700
X-CSE-ConnectionGUID: Wt6oS79eS4SSxZvP5G77OA==
X-CSE-MsgGUID: B203IircSgSMji9YVuFFnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536991"
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
Subject: [PATCH 13/17] dmaengine: idxd: fix the double free of a descriptor whose submission failed
Date: Mon, 19 Oct 2026 08:06:26 -0700
Message-ID: <20261019150630.4026341-14-daniel1.byrne@intel.com>
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

llist_abort_desc() marks the failed descriptor aborted before it
searches the lists for it. When the interrupt thread has just taken the
pending list into a private batch, the search misses it, the thread
completes and frees the descriptor on seeing the mark, and the caller
frees it again: sbitmap_queue_clear() then stores through the per-cpu
hint of cpu -1, or clears the bit of the slot's next owner, and a thread
that read the record before the mark puts the freed descriptor on the
work list. This needs only interrupt-armed descriptors in flight on a
shared queue whose ENQCMDS fails, as in a guest whose shared queue other
guests keep full.

Sort the pending list under the list lock in the thread, as the abort
does, so a descriptor still waiting on the hardware is always on one of
the lists the abort searches. The device never took a failed
descriptor, so its record stays clear and nothing completes it before
the abort has taken it off the lists; from then on it is the
submitter's alone and needs no mark. The finished descriptors the abort
takes off the pending list go to the work list for the interrupt thread,
which the abort wakes, instead of being completed in the submitter's
context.

Fixes: 6b4b87f2c31a ("dmaengine: idxd: fix submission race window")
Cc: stable@vger.kernel.org # 5.14+
Assisted-by: Claude:claude-opus-5
Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/irq.c    | 63 ++++++++++++++++++++++-----------------
 drivers/dma/idxd/submit.c | 48 +++++++++++++++--------------
 2 files changed, 62 insertions(+), 49 deletions(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index e48f7c307ceb..1ec3d360eea8 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -651,31 +651,39 @@ static void irq_process_pending_llist(struct idxd_irq_entry *irq_entry)
 {
 	struct idxd_desc *desc, *t;
 	struct llist_node *head;
+	LIST_HEAD(flist);
 
-	head = llist_del_all(&irq_entry->pending_llist);
-	if (!head)
+	if (llist_empty(&irq_entry->pending_llist))
 		return;
 
+	/*
+	 * Sort under the list lock, as the submit abort does. A descriptor
+	 * still waiting on the hardware reaches the work list within the
+	 * same hold, so the abort of a failed submission, which searches
+	 * both lists under the lock, always finds its own descriptor.
+	 */
+	spin_lock(&irq_entry->list_lock);
+	head = llist_del_all(&irq_entry->pending_llist);
 	llist_for_each_entry_safe(desc, t, head, llnode) {
 		u8 status = desc->completion->status & DSA_COMP_STATUS_MASK;
 
-		if (status) {
-			/*
-			 * Check against the original status as ABORT is software defined
-			 * and 0xff, which DSA_COMP_STATUS_MASK can mask out.
-			 */
-			if (unlikely(desc->completion->status == IDXD_COMP_DESC_ABORT)) {
-				idxd_desc_complete(desc, IDXD_COMPLETE_ABORT, true);
-				continue;
-			}
+		if (status)
+			list_add_tail(&desc->list, &flist);
+		else
+			list_add_tail(&desc->list, &irq_entry->work_list);
+	}
+	spin_unlock(&irq_entry->list_lock);
 
+	list_for_each_entry_safe(desc, t, &flist, list) {
+		list_del(&desc->list);
+		/*
+		 * Check against the original status as ABORT is software
+		 * defined and 0xff, which DSA_COMP_STATUS_MASK can mask out.
+		 */
+		if (unlikely(desc->completion->status == IDXD_COMP_DESC_ABORT))
+			idxd_desc_complete(desc, IDXD_COMPLETE_ABORT, true);
+		else
 			idxd_desc_complete(desc, IDXD_COMPLETE_NORMAL, true);
-		} else {
-			spin_lock(&irq_entry->list_lock);
-			list_add_tail(&desc->list,
-				      &irq_entry->work_list);
-			spin_unlock(&irq_entry->list_lock);
-		}
 	}
 }
 
@@ -727,18 +735,19 @@ irqreturn_t idxd_wq_thread(int irq, void *data)
 	 * submmiter adds all the submitted descriptor after sending it to
 	 * the workqueue. It's a lockless singly linked list. The work_list
 	 * is the common linux double linked list. We are in a scenario of
-	 * multiple producers and a single consumer. The producers are all
-	 * the kernel submitters of descriptors, and the consumer is the
-	 * kernel irq handler thread for the msix vector when using threaded
-	 * irq. To work with the restrictions of llist to remain lockless,
-	 * we are doing the following steps:
+	 * multiple producers and several consumers. The producers are all
+	 * the kernel submitters of descriptors, and they add to the llist
+	 * without a lock. The consumers are the kernel irq handler thread
+	 * for the msix vector when using threaded irq, the abort of a
+	 * failed submission, the interrupt handle abort and the flushes,
+	 * and each empties the llist under the list lock. The thread does
+	 * so in these steps:
 	 * 1. Iterate through the work_list and process any completed
 	 *    descriptor. Delete the completed entries during iteration.
-	 * 2. llist_del_all() from the pending list.
-	 * 3. Iterate through the llist that was deleted from the pending list
-	 *    and process the completed entries.
-	 * 4. If the entry is still waiting on hardware, list_add_tail() to
-	 *    the work_list.
+	 * 2. Under the list lock, llist_del_all() from the pending list and
+	 *    move each entry still waiting on hardware to the work_list and
+	 *    each completed one to a private list.
+	 * 3. Process the entries of the private list outside the lock.
 	 */
 	irq_process_work_list(irq_entry);
 	irq_process_pending_llist(irq_entry);
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 26dce0179d30..5806b1b74a2f 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2019 Intel Corporation. All rights rsvd. */
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -92,12 +93,6 @@ static struct idxd_desc *list_abort_desc(struct idxd_wq *wq, struct idxd_irq_ent
 		}
 	}
 
-	/*
-	 * At this point, the desc needs to be aborted is held by the completion
-	 * handler where it has taken it off the pending list but has not added to the
-	 * work list. It will be cleaned up by the interrupt handler when it sees the
-	 * IDXD_COMP_DESC_ABORT for completion status.
-	 */
 	return NULL;
 }
 
@@ -106,9 +101,8 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 {
 	struct idxd_desc *d, *t, *found = NULL;
 	struct llist_node *head;
-	LIST_HEAD(flist);
+	bool wake = false;
 
-	desc->completion->status = IDXD_COMP_DESC_ABORT;
 	/*
 	 * Grab the list lock so it will block the irq thread handler. This allows the
 	 * abort code to locate the descriptor need to be aborted.
@@ -122,10 +116,15 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 				continue;
 			}
 
+			/*
+			 * A finished descriptor goes on the work list for
+			 * the interrupt thread, as one still in flight does,
+			 * rather than being completed in the submitter's
+			 * context.
+			 */
 			if (d->completion->status)
-				list_add_tail(&d->list, &flist);
-			else
-				list_add_tail(&d->list, &ie->work_list);
+				wake = true;
+			list_add_tail(&d->list, &ie->work_list);
 		}
 	}
 
@@ -133,21 +132,26 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
 		found = list_abort_desc(wq, ie, desc);
 	spin_unlock(&ie->list_lock);
 
-	if (found)
-		idxd_dma_complete_txd(found, IDXD_COMPLETE_ABORT, false,
-				      NULL, NULL);
+	/*
+	 * Their interrupts may have run the thread before they reached the
+	 * work list, so it is woken again.
+	 */
+	if (wake)
+		irq_wake_thread(ie->vector, ie);
 
 	/*
-	 * completing the descriptor will return desc to allocator and
-	 * the desc can be acquired by a different process and the
-	 * desc->list can be modified.  Delete desc from list so the
-	 * list traversing does not get corrupted by the other process.
+	 * The device never took the descriptor, so its record is still
+	 * clear. The interrupt thread and another submitter's abort sort
+	 * the lists under the list lock and leave one with a clear record
+	 * on a list, so the search finds the descriptor, and once off the
+	 * lists it is the submitter's alone. Marking it aborted before
+	 * that would let another context that saw the mark on a list
+	 * complete and free it, and the caller frees it as well.
 	 */
-	list_for_each_entry_safe(d, t, &flist, list) {
-		list_del_init(&d->list);
-		idxd_dma_complete_txd(d, IDXD_COMPLETE_ABORT, true,
+	WARN_ON_ONCE(!found);
+	if (found)
+		idxd_dma_complete_txd(desc, IDXD_COMPLETE_ABORT, false,
 				      NULL, NULL);
-	}
 }
 
 /*
-- 
2.43.0

