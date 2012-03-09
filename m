From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 1/2] padata: Fix race in the serialization path
Date: Fri, 9 Mar 2012 07:20:12 +0100
Message-ID: <20120309062012.GJ15404@secunet.com>
References: <20120309061828.GI15404@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120309061828.GI15404@secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When a padata object is queued to the serialization queue, another
cpu might process and free the padata object. So don't dereference
it after queueing to the serialization queue.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index b452599..aa99295 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -230,6 +230,7 @@ out:
 
 static void padata_reorder(struct parallel_data *pd)
 {
+	int cb_cpu;
 	struct padata_priv *padata;
 	struct padata_serial_queue *squeue;
 	struct padata_instance *pinst = pd->pinst;
@@ -270,13 +271,14 @@ static void padata_reorder(struct parallel_data *pd)
 			return;
 		}
 
-		squeue = per_cpu_ptr(pd->squeue, padata->cb_cpu);
+		cb_cpu = padata->cb_cpu;
+		squeue = per_cpu_ptr(pd->squeue, cb_cpu);
 
 		spin_lock(&squeue->serial.lock);
 		list_add_tail(&padata->list, &squeue->serial.list);
 		spin_unlock(&squeue->serial.lock);
 
-		queue_work_on(padata->cb_cpu, pinst->wq, &squeue->work);
+		queue_work_on(cb_cpu, pinst->wq, &squeue->work);
 	}
 
 	spin_unlock_bh(&pd->lock);
-- 
1.7.0.4
