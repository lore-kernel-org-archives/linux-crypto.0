From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] padata: Remove unused but set variables
Date: Mon, 17 Oct 2016 12:16:08 +0200
Message-ID: <20161017101608.18007-1-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove the unused but set variable pinst in padata_parallel_worker to
fix the following warning when building with 'W=1':

  kernel/padata.c: In function ‘padata_parallel_worker’:
  kernel/padata.c:68:26: warning: variable ‘pinst’ set but not used [-Wunused-but-set-variable]

Also remove the now unused variable pd which is only used to set pinst.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 kernel/padata.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 7848f0566403..05316c9f32da 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -64,15 +64,11 @@ static int padata_cpu_hash(struct parallel_data *pd)
 static void padata_parallel_worker(struct work_struct *parallel_work)
 {
 	struct padata_parallel_queue *pqueue;
-	struct parallel_data *pd;
-	struct padata_instance *pinst;
 	LIST_HEAD(local_list);
 
 	local_bh_disable();
 	pqueue = container_of(parallel_work,
 			      struct padata_parallel_queue, work);
-	pd = pqueue->pd;
-	pinst = pd->pinst;
 
 	spin_lock(&pqueue->parallel.lock);
 	list_replace_init(&pqueue->parallel.list, &local_list);
-- 
2.9.0
