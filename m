From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 1/3] padata: set cpu_index of unused CPUs to -1
Date: Fri,  8 Sep 2017 20:57:09 +0200
Message-ID: <1504897031-27523-2-git-send-email-minipli@googlemail.com>
References: <1504897031-27523-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33045 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756760AbdIHS5W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 14:57:22 -0400
Received: by mail-wm0-f65.google.com with SMTP id 187so2315715wmn.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Sep 2017 11:57:22 -0700 (PDT)
In-Reply-To: <1504897031-27523-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The parallel queue per-cpu data structure gets initialized only for CPUs
in the 'pcpu' CPU mask set. This is not sufficient as the reorder timer
may run on a different CPU and might wrongly decide it's the target CPU
for the next reorder item as per-cpu memory gets memset(0) and we might
be waiting for the first CPU in cpumask.pcpu, i.e. cpu_index 0.

Make the '__this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index'
compare in padata_get_next() fail in this case by initializing the
cpu_index member of all per-cpu parallel queues. Use -1 for unused ones.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 kernel/padata.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 868f947166d7..1b9b4bac4a9b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -384,8 +384,14 @@ static void padata_init_pqueues(struct parallel_data *pd)
 	struct padata_parallel_queue *pqueue;
 
 	cpu_index = 0;
-	for_each_cpu(cpu, pd->cpumask.pcpu) {
+	for_each_possible_cpu(cpu) {
 		pqueue = per_cpu_ptr(pd->pqueue, cpu);
+
+		if (!cpumask_test_cpu(cpu, pd->cpumask.pcpu)) {
+			pqueue->cpu_index = -1;
+			continue;
+		}
+
 		pqueue->pd = pd;
 		pqueue->cpu_index = cpu_index;
 		cpu_index++;
-- 
1.7.10.4
