From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] padata: get_next is never NULL
Date: Wed, 12 Apr 2017 10:40:19 +0200
Message-ID: <20170412084019.16190-1-Jason@zx2c4.com>
References: <20170411091601.GA24844@mwanda>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: steffen.klassert@secunet.com, linux-crypto@vger.kernel.org,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:42779 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753394AbdDLIke (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 04:40:34 -0400
In-Reply-To: <20170411091601.GA24844@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Per Dan's static checker warning, the code that returns NULL was removed
in 2010, so this patch updates the comments and fixes the code
assumptions.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 kernel/padata.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index f1aef1639204..ac8f1e524836 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -154,8 +154,6 @@ EXPORT_SYMBOL(padata_do_parallel);
  * A pointer to the control struct of the next object that needs
  * serialization, if present in one of the percpu reorder queues.
  *
- * NULL, if all percpu reorder queues are empty.
- *
  * -EINPROGRESS, if the next object that needs serialization will
  *  be parallel processed by another cpu and is not yet present in
  *  the cpu's reorder queue.
@@ -182,8 +180,6 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 	cpu = padata_index_to_cpu(pd, next_index);
 	next_queue = per_cpu_ptr(pd->pqueue, cpu);
 
-	padata = NULL;
-
 	reorder = &next_queue->reorder;
 
 	spin_lock(&reorder->lock);
@@ -235,12 +231,11 @@ static void padata_reorder(struct parallel_data *pd)
 		padata = padata_get_next(pd);
 
 		/*
-		 * All reorder queues are empty, or the next object that needs
-		 * serialization is parallel processed by another cpu and is
-		 * still on it's way to the cpu's reorder queue, nothing to
-		 * do for now.
+		 * If the next object that needs serialization is parallel
+		 * processed by another cpu and is still on it's way to the
+		 * cpu's reorder queue, nothing to do for now.
 		 */
-		if (!padata || PTR_ERR(padata) == -EINPROGRESS)
+		if (PTR_ERR(padata) == -EINPROGRESS)
 			break;
 
 		/*
-- 
2.12.2
