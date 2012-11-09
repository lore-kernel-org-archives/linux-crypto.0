From: Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v3 5/9] kernel: padata : use __this_cpu_read per-cpu helper
Date: Fri, 09 Nov 2012 10:21:20 +0800
Message-ID: <509C68A0.1070004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: steffen.klassert@secunet.com,
	Kernel-Maillist <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, cl@linux-foundation.org,
	Shan Wei <shanwei88@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

For bottom halves off, __this_cpu_read is better.

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
v3: use __this_cpu_read instead of this_cpu_read.
---
 kernel/padata.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 89fe3d1..072f4ee 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -171,7 +171,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
 	int cpu, num_cpus;
 	unsigned int next_nr, next_index;
-	struct padata_parallel_queue *queue, *next_queue;
+	struct padata_parallel_queue *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
 
@@ -204,8 +204,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		goto out;
 	}
 
-	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
-	if (queue->cpu_index == next_queue->cpu_index) {
+	if (__this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {
 		padata = ERR_PTR(-ENODATA);
 		goto out;
 	}
-- 
1.7.1
