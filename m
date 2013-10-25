From: Mathias Krause <mathias.krause@secunet.com>
Subject: [PATCH RESEND] padata: make the sequence counter an atomic_t
Date: Fri, 25 Oct 2013 12:14:15 +0200
Message-ID: <1382696055-24264-1-git-send-email-mathias.krause@secunet.com>
References: <20131025092644.GA20145@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <mathias.krause@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:45746 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab3JYKOk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Oct 2013 06:14:40 -0400
In-Reply-To: <20131025092644.GA20145@gondor.apana.org.au>
References: <1380721245-5215-1-git-send-email-mathias.krause@secunet.com> <20131008120824.GN7660@secunet.com> <526A29E0.8070204@secunet.com> <20131025092644.GA20145@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using a spinlock to atomically increase a counter sounds wrong -- we've
atomic_t for this!

Also move 'seq_nr' to a different cache line than 'lock' to reduce cache
line trashing. This has the nice side effect of decreasing the size of
struct parallel_data from 192 to 128 bytes for a x86-64 build, e.g.
occupying only two instead of three cache lines.

Those changes results in a 5% performance increase on an IPsec test run
using pcrypt.

Btw. the seq_lock spinlock was never explicitly initialized -- one more
reason to get rid of it.

Signed-off-by: Mathias Krause <mathias.krause@secunet.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/padata.h |    3 +--
 kernel/padata.c        |    9 ++++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 86292be..4386946 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -129,10 +129,9 @@ struct parallel_data {
 	struct padata_serial_queue	__percpu *squeue;
 	atomic_t			reorder_objects;
 	atomic_t			refcnt;
+	atomic_t			seq_nr;
 	struct padata_cpumask		cpumask;
 	spinlock_t                      lock ____cacheline_aligned;
-	spinlock_t                      seq_lock;
-	unsigned int			seq_nr;
 	unsigned int			processed;
 	struct timer_list		timer;
 };
diff --git a/kernel/padata.c b/kernel/padata.c
index 07af2c9..2abd25d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -46,6 +46,7 @@ static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 
 static int padata_cpu_hash(struct parallel_data *pd)
 {
+	unsigned int seq_nr;
 	int cpu_index;
 
 	/*
@@ -53,10 +54,8 @@ static int padata_cpu_hash(struct parallel_data *pd)
 	 * seq_nr mod. number of cpus in use.
 	 */
 
-	spin_lock(&pd->seq_lock);
-	cpu_index =  pd->seq_nr % cpumask_weight(pd->cpumask.pcpu);
-	pd->seq_nr++;
-	spin_unlock(&pd->seq_lock);
+	seq_nr = atomic_inc_return(&pd->seq_nr);
+	cpu_index = seq_nr % cpumask_weight(pd->cpumask.pcpu);
 
 	return padata_index_to_cpu(pd, cpu_index);
 }
@@ -429,7 +428,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
-	pd->seq_nr = 0;
+	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 0);
 	pd->pinst = pinst;
-- 
1.7.2.5
