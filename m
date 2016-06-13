From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/7] random: make /dev/urandom scalable for silly userspace programs
Date: Mon, 13 Jun 2016 11:48:38 -0400
Message-ID: <1465832919-11316-7-git-send-email-tytso@mit.edu>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com,
	Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On a system with a 4 socket (NUMA) system where a large number of
application threads were all trying to read from /dev/urandom, this
can result in the system spending 80% of its time contending on the
global urandom spinlock.  The application should have used its own
PRNG, but let's try to help it from running, lemming-like, straight
over the locking cliff.

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 841f9a8..d640865 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -434,6 +434,8 @@ struct crng_state primary_crng = {
  */
 static int crng_init = 0;
 #define crng_ready() (likely(crng_init > 0))
+static void _extract_crng(struct crng_state *crng,
+			  __u8 out[CHACHA20_BLOCK_SIZE]);
 static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE]);
 static void process_random_ready_list(void);
 
@@ -754,6 +756,16 @@ static void credit_entropy_bits_safe(struct entropy_store *r, int nbits)
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
+#ifdef CONFIG_NUMA
+/*
+ * Hack to deal with crazy userspace progams when they are all trying
+ * to access /dev/urandom in parallel.  The programs are almost
+ * certainly doing something terribly wrong, but we'll work around
+ * their brain damage.
+ */
+static struct crng_state **crng_node_pool __read_mostly;
+#endif
+
 static void crng_initialize(struct crng_state *crng)
 {
 	int		i;
@@ -815,7 +827,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 		if (num == 0)
 			return;
 	} else
-		extract_crng(buf.block);
+		_extract_crng(&primary_crng, buf.block);
 	spin_lock_irqsave(&primary_crng.lock, flags);
 	for (i = 0; i < 8; i++) {
 		unsigned long	rv;
@@ -835,19 +847,26 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	spin_unlock_irqrestore(&primary_crng.lock, flags);
 }
 
+static inline void maybe_reseed_primary_crng(void)
+{
+	if (crng_init > 2 &&
+	    time_after(jiffies, primary_crng.init_time + CRNG_RESEED_INTERVAL))
+		crng_reseed(&primary_crng, &input_pool);
+}
+
 static inline void crng_wait_ready(void)
 {
 	wait_event_interruptible(crng_init_wait, crng_ready());
 }
 
-static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
+static void _extract_crng(struct crng_state *crng,
+			  __u8 out[CHACHA20_BLOCK_SIZE])
 {
 	unsigned long v, flags;
-	struct crng_state *crng = &primary_crng;
 
 	if (crng_init > 1 &&
 	    time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL))
-		crng_reseed(crng, &input_pool);
+		crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
 	spin_lock_irqsave(&crng->lock, flags);
 	if (arch_get_random_long(&v))
 		crng->state[14] ^= v;
@@ -857,6 +876,19 @@ static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
+static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
+{
+	struct crng_state *crng = NULL;
+
+#ifdef CONFIG_NUMA
+	if (crng_node_pool)
+		crng = crng_node_pool[numa_node_id()];
+	if (crng == NULL)
+#endif
+		crng = &primary_crng;
+	_extract_crng(crng, out);
+}
+
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i;
@@ -1575,9 +1607,31 @@ static void init_std_data(struct entropy_store *r)
  */
 static int rand_initialize(void)
 {
+#ifdef CONFIG_NUMA
+	int i;
+	int num_nodes = num_possible_nodes();
+	struct crng_state *crng;
+	struct crng_state **pool;
+#endif
+
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
 	crng_initialize(&primary_crng);
+
+#ifdef CONFIG_NUMA
+	pool = kmalloc(num_nodes * sizeof(void *),
+		       GFP_KERNEL|__GFP_NOFAIL|__GFP_ZERO);
+	for (i=0; i < num_nodes; i++) {
+		crng = kmalloc_node(sizeof(struct crng_state),
+				    GFP_KERNEL | __GFP_NOFAIL, i);
+		spin_lock_init(&crng->lock);
+		crng_initialize(crng);
+		pool[i] = crng;
+
+	}
+	mb();
+	crng_node_pool = pool;
+#endif
 	return 0;
 }
 early_initcall(rand_initialize);
-- 
2.5.0
