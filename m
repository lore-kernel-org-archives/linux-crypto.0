From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] random: make /dev/urandom scalable for silly userspace programs
Date: Wed,  4 May 2016 15:25:49 -0400
Message-ID: <1462389951-29439-3-git-send-email-tytso@mit.edu>
References: <1462389951-29439-1-git-send-email-tytso@mit.edu>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462389951-29439-1-git-send-email-tytso@mit.edu>
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
 drivers/char/random.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 62 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 91d5c2a..b970db6 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -749,6 +749,17 @@ struct crng_state primary_crng = {
 };
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
+
 static void _initialize_crng(struct crng_state *crng)
 {
 	int		i;
@@ -764,11 +775,13 @@ static void _initialize_crng(struct crng_state *crng)
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL;
 }
 
+#ifdef CONFIG_NUMA
 static void initialize_crng(struct crng_state *crng)
 {
 	_initialize_crng(crng);
 	spin_lock_init(&crng->lock);
 }
+#endif
 
 static int crng_fast_load(__u32 pool[4])
 {
@@ -823,19 +836,23 @@ out:
 	return ret;
 }
 
+static inline void maybe_reseed_primary_crng(void)
+{
+	if (crng_init > 2 &&
+	    time_after(jiffies, primary_crng.init_time + CRNG_RESEED_INTERVAL))
+		crng_reseed(&input_pool);
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
 
-	if (crng_init > 2 &&
-	    time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL))
-		crng_reseed(&input_pool);
 	spin_lock_irqsave(&crng->lock, flags);
 	if (arch_get_random_long(&v))
 		crng->state[14] ^= v;
@@ -845,6 +862,30 @@ static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
+static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
+{
+#ifndef CONFIG_NUMA
+	maybe_reseed_primary_crng();
+	_extract_crng(&primary_crng, out);
+#else
+	int node_id = numa_node_id();
+	struct crng_state *crng = crng_node_pool[node_id];
+
+	if (time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL)) {
+		unsigned long flags;
+
+		maybe_reseed_primary_crng();
+		_extract_crng(&primary_crng, out);
+		spin_lock_irqsave(&crng->lock, flags);
+		memcpy(&crng->state[4], out, CHACHA20_KEY_SIZE);
+		crng->state[15] = node_id;
+		crng->init_time = jiffies;
+		spin_unlock_irqrestore(&crng->lock, flags);
+	}
+	_extract_crng(crng, out);
+#endif
+}
+
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i;
@@ -1549,6 +1590,22 @@ static void init_std_data(struct entropy_store *r)
  */
 static int rand_initialize(void)
 {
+#ifdef CONFIG_NUMA
+	int i;
+	int num_nodes = num_possible_nodes();
+	struct crng_state *crng;
+
+	crng_node_pool = kmalloc(num_nodes * sizeof(void *),
+				 GFP_KERNEL|__GFP_NOFAIL);
+
+	for (i=0; i < num_nodes; i++) {
+		crng = kmalloc(sizeof(struct crng_state),
+			       GFP_KERNEL | __GFP_NOFAIL);
+		initialize_crng(crng);
+		crng_node_pool[i] = crng;
+
+	}
+#endif
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
 	_initialize_crng(&primary_crng);
-- 
2.5.0
