From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] workqueue: move hot fields of workqueue_struct to the end
Date: Tue, 19 Mar 2013 17:00:25 -0700
Message-ID: <1363737629-16745-7-git-send-email-tj@kernel.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com,
	jmoyer@redhat.com, zab@redhat.com, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1363737629-16745-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move wq->flags and ->cpu_pwqs to the end of workqueue_struct and align
them to the cacheline.  These two fields are used in the work item
issue path and thus hot.  The scheduled NUMA affinity support will add
dispatch table at the end of workqueue_struct and relocating these two
fields will allow us hitting only single cacheline on hot paths.

Note that wq->pwqs isn't moved although it currently is being used in
the work item issue path for unbound workqueues.  The dispatch table
mentioned above will replace its use in the issue path, so it will
become cold once NUMA support is implemented.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 151ce49..25dab9d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -230,8 +230,6 @@ struct wq_device;
  * the appropriate worker_pool through its pool_workqueues.
  */
 struct workqueue_struct {
-	unsigned int		flags;		/* WQ: WQ_* flags */
-	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
 	struct list_head	pwqs;		/* FR: all pwqs of this wq */
 	struct list_head	list;		/* WQ: list of all workqueues */
 
@@ -258,6 +256,10 @@ struct workqueue_struct {
 	struct lockdep_map	lockdep_map;
 #endif
 	char			name[WQ_NAME_LEN]; /* I: workqueue name */
+
+	/* hot fields used during command issue, aligned to cacheline */
+	unsigned int		flags ____cacheline_aligned; /* WQ: WQ_* flags */
+	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwqs */
 };
 
 static struct kmem_cache *pwq_cache;
-- 
1.8.1.4
