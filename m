From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] random: set up the NUMA crng instances after the CRNG is fully initialized
Date: Thu, 12 Apr 2018 21:30:44 -0400
Message-ID: <20180413013046.404-3-tytso@mit.edu>
References: <20180413013046.404-1-tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413013046.404-1-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Until the primary_crng is fully initialized, don't initialize the NUMA
crng nodes.  Otherwise users of /dev/urandom on NUMA systems before
the CRNG is fully initialized can get very bad quality randomness.  Of
course everyone should move to getrandom(2) where this won't be an
issue, but there's a lot of legacy code out there.

Reported-by: Jann Horn <jannh@google.com>
Fixes: 1e7f583af67b ("random: make /dev/urandom scalable for silly...")
Cc: stable@kernel.org # 4.8+
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 2154a5fe4c81..681ee0c0de24 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -787,6 +787,32 @@ static void crng_initialize(struct crng_state *crng)
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
+#ifdef CONFIG_NUMA
+static void numa_crng_init(void)
+{
+	int i;
+	struct crng_state *crng;
+	struct crng_state **pool;
+
+	pool = kcalloc(nr_node_ids, sizeof(*pool), GFP_KERNEL|__GFP_NOFAIL);
+	for_each_online_node(i) {
+		crng = kmalloc_node(sizeof(struct crng_state),
+				    GFP_KERNEL | __GFP_NOFAIL, i);
+		spin_lock_init(&crng->lock);
+		crng_initialize(crng);
+		pool[i] = crng;
+	}
+	mb();
+	if (cmpxchg(&crng_node_pool, NULL, pool)) {
+		for_each_node(i)
+			kfree(pool[i]);
+		kfree(pool);
+	}
+}
+#else
+static int numa_crng_init(void) {}
+#endif
+
 /*
  * crng_fast_load() can be called by code in the interrupt service
  * path.  So we can't afford to dilly-dally.
@@ -893,6 +919,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	spin_unlock_irqrestore(&primary_crng.lock, flags);
 	if (crng == &primary_crng && crng_init < 2) {
 		invalidate_batched_entropy();
+		numa_crng_init();
 		crng_init = 2;
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
@@ -1727,28 +1754,9 @@ static void init_std_data(struct entropy_store *r)
  */
 static int rand_initialize(void)
 {
-#ifdef CONFIG_NUMA
-	int i;
-	struct crng_state *crng;
-	struct crng_state **pool;
-#endif
-
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
 	crng_initialize(&primary_crng);
-
-#ifdef CONFIG_NUMA
-	pool = kcalloc(nr_node_ids, sizeof(*pool), GFP_KERNEL|__GFP_NOFAIL);
-	for_each_online_node(i) {
-		crng = kmalloc_node(sizeof(struct crng_state),
-				    GFP_KERNEL | __GFP_NOFAIL, i);
-		spin_lock_init(&crng->lock);
-		crng_initialize(crng);
-		pool[i] = crng;
-	}
-	mb();
-	crng_node_pool = pool;
-#endif
 	return 0;
 }
 early_initcall(rand_initialize);
-- 
2.16.1.72.g5be1f00a9a
