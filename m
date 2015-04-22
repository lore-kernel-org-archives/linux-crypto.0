From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 1/6] random: Addition of kernel_pool
Date: Wed, 22 Apr 2015 21:18:04 +0200
Message-ID: <9728527.rMI4vu0tMf@myon.chronox.de>
References: <5054521.el7mZro33c@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andreas Steffen <andreas.steffen@strongswan.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5054521.el7mZro33c@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The kernel pool is intended to serve kernel-internal callers only.
Its purpose and usage is identical to the blocking_pool.

As the kernel_pool is not available to user space, user space cannot
directly interfere with the blocking behavior when obtaining
data from the kernel_pool. Thus, if entropy is present in the
kernel_pool, user space can hog /dev/random and yet the kernel
internal requestor of random numbers that are generated equally
to the blocking_pool (i.e. with the blocking behavior) will not
be affected until data is needed from the input_pool.

The patch treats the kernel_pool fully equally to the blocking and
nonblocking pool with respect to the initialization and update. As now
there are three output pools, the patch adds a round-robin logic for
processing additional entropy when the input_pool is nearly full.

CC: Andreas Steffen <andreas.steffen@strongswan.org>
CC: Theodore Ts'o <tytso@mit.edu>
CC: Sandy Harris <sandyinchina@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 52 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9cd6968..2868754 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -407,6 +407,7 @@ static struct poolinfo {
 static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static DECLARE_WAIT_QUEUE_HEAD(urandom_init_wait);
+static DECLARE_WAIT_QUEUE_HEAD(random_kernel_wait);
 static struct fasync_struct *fasync;
 
 /**********************************************************************
@@ -442,6 +443,7 @@ static void push_to_pool(struct work_struct *work);
 static __u32 input_pool_data[INPUT_POOL_WORDS];
 static __u32 blocking_pool_data[OUTPUT_POOL_WORDS];
 static __u32 nonblocking_pool_data[OUTPUT_POOL_WORDS];
+static __u32 kernel_pool_data[OUTPUT_POOL_WORDS];
 
 static struct entropy_store input_pool = {
 	.poolinfo = &poolinfo_table[0],
@@ -472,6 +474,17 @@ static struct entropy_store nonblocking_pool = {
 					push_to_pool),
 };
 
+static struct entropy_store kernel_pool = {
+	.poolinfo = &poolinfo_table[1],
+	.name = "kernel",
+	.limit = 1,
+	.pull = &input_pool,
+	.lock = __SPIN_LOCK_UNLOCKED(kernel_pool.lock),
+	.pool = kernel_pool_data,
+	.push_work = __WORK_INITIALIZER(kernel_pool.push_work,
+					push_to_pool),
+};
+
 static __u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
@@ -674,29 +687,41 @@ retry:
 
 		/* should we wake readers? */
 		if (entropy_bits >= random_read_wakeup_bits) {
+			wake_up_interruptible(&random_kernel_wait);
 			wake_up_interruptible(&random_read_wait);
 			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
 		/* If the input pool is getting full, send some
-		 * entropy to the two output pools, flipping back and
+		 * entropy to the output pools, flipping back and
 		 * forth between them, until the output pools are 75%
 		 * full.
 		 */
 		if (entropy_bits > random_write_wakeup_bits &&
 		    r->initialized &&
 		    r->entropy_total >= 2*random_read_wakeup_bits) {
-			static struct entropy_store *last = &blocking_pool;
-			struct entropy_store *other = &blocking_pool;
-
-			if (last == &blocking_pool)
-				other = &nonblocking_pool;
-			if (other->entropy_count <=
-			    3 * other->poolinfo->poolfracbits / 4)
-				last = other;
-			if (last->entropy_count <=
-			    3 * last->poolinfo->poolfracbits / 4) {
-				schedule_work(&last->push_work);
-				r->entropy_total = 0;
+#define NUM_OUTPUT_POOLS 3
+			/* as we will recalculate this variable first thing in
+			 * the loop, it will point to the first output pool
+			 * after the first recalculation */
+			static int selected_pool = (NUM_OUTPUT_POOLS - 1);
+			int i = 0;
+			struct entropy_store *output_pools[NUM_OUTPUT_POOLS] = {
+				&blocking_pool,
+				&nonblocking_pool,
+				&kernel_pool};
+			/* select the next pool that has less than 75% fill
+			 * rate */
+			for (i = 0; NUM_OUTPUT_POOLS > i; i++) {
+				struct entropy_store *p = NULL;
+				selected_pool =
+					(selected_pool + 1) % NUM_OUTPUT_POOLS;
+				p = output_pools[selected_pool];
+				if (p->entropy_count <=
+					p->poolinfo->poolfracbits / 4) {
+					schedule_work(&p->push_work);
+					r->entropy_total = 0;
+					break;
+				}
 			}
 		}
 	}
@@ -1318,6 +1343,7 @@ static int rand_initialize(void)
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
 	init_std_data(&nonblocking_pool);
+	init_std_data(&kernel_pool);
 	return 0;
 }
 early_initcall(rand_initialize);
-- 
2.1.0
