From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/6] workqueue: don't use WQ_HIGHPRI for unbound workqueues
Date: Mon,  9 Jul 2012 11:41:50 -0700
Message-ID: <1341859315-17759-2-git-send-email-tj@kernel.org>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, joshhunt00-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bpm-sJ/iWh9BUns@public.gmane.org, elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, gustavo-THi1TnShQwVAfugRpC6u6w@public.gmane.org,
	johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341859315-17759-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Unbound wqs aren't concurrency-managed and try to execute work items
as soon as possible.  This is currently achieved by implicitly setting
%WQ_HIGHPRI on all unbound workqueues; however, WQ_HIGHPRI
implementation is about to be restructured and this usage won't be
valid anymore.

Add an explicit chain-wakeup path for unbound workqueues in
process_one_work() instead of piggy backing on %WQ_HIGHPRI.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/workqueue.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9a3128d..27637c2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -580,6 +580,10 @@ static bool __need_more_worker(struct global_cwq *gcwq)
 /*
  * Need to wake up a worker?  Called from anything but currently
  * running workers.
+ *
+ * Note that, because unbound workers never contribute to nr_running, this
+ * function will always return %true for unbound gcwq as long as the
+ * worklist isn't empty.
  */
 static bool need_more_worker(struct global_cwq *gcwq)
 {
@@ -1867,6 +1871,13 @@ __acquires(&gcwq->lock)
 	if (unlikely(cpu_intensive))
 		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
 
+	/*
+	 * Unbound gcwq isn't concurrency managed and work items should be
+	 * executed ASAP.  Wake up another worker if necessary.
+	 */
+	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(gcwq))
+		wake_up_worker(gcwq);
+
 	spin_unlock_irq(&gcwq->lock);
 
 	work_clear_pending(work);
@@ -2984,13 +2995,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	if (flags & WQ_MEM_RECLAIM)
 		flags |= WQ_RESCUER;
 
-	/*
-	 * Unbound workqueues aren't concurrency managed and should be
-	 * dispatched to workers immediately.
-	 */
-	if (flags & WQ_UNBOUND)
-		flags |= WQ_HIGHPRI;
-
 	max_active = max_active ?: WQ_DFL_ACTIVE;
 	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 
-- 
1.7.7.3
