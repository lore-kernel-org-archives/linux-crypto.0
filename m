From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/7] random: replace non-blocking pool with a Chacha20-based CRNG
Date: Mon, 13 Jun 2016 11:48:37 -0400
Message-ID: <1465832919-11316-6-git-send-email-tytso@mit.edu>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com,
	Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45076 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424723AbcFMPt3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 11:49:29 -0400
In-Reply-To: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CRNG is faster, and we don't pretend to track entropy usage in the
CRNG any more.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 crypto/chacha20_generic.c |  61 --------
 drivers/char/random.c     | 374 +++++++++++++++++++++++++++++++++-------------
 include/crypto/chacha20.h |   1 +
 lib/Makefile              |   2 +-
 lib/chacha20.c            |  79 ++++++++++
 5 files changed, 353 insertions(+), 164 deletions(-)
 create mode 100644 lib/chacha20.c

diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
index da9c899..1cab831 100644
--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -15,72 +15,11 @@
 #include <linux/module.h>
 #include <crypto/chacha20.h>
 
-static inline u32 rotl32(u32 v, u8 n)
-{
-	return (v << n) | (v >> (sizeof(v) * 8 - n));
-}
-
 static inline u32 le32_to_cpuvp(const void *p)
 {
 	return le32_to_cpup(p);
 }
 
-static void chacha20_block(u32 *state, void *stream)
-{
-	u32 x[16], *out = stream;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(x); i++)
-		x[i] = state[i];
-
-	for (i = 0; i < 20; i += 2) {
-		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],  16);
-		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],  16);
-		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],  16);
-		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],  16);
-
-		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],  12);
-		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],  12);
-		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10], 12);
-		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11], 12);
-
-		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],   8);
-		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],   8);
-		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],   8);
-		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],   8);
-
-		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],   7);
-		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],   7);
-		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10],  7);
-		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11],  7);
-
-		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],  16);
-		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],  16);
-		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],  16);
-		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],  16);
-
-		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10], 12);
-		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11], 12);
-		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],  12);
-		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],  12);
-
-		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],   8);
-		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],   8);
-		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],   8);
-		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],   8);
-
-		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10],  7);
-		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11],  7);
-		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],   7);
-		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],   7);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(x); i++)
-		out[i] = cpu_to_le32(x[i] + state[i]);
-
-	state[12]++;
-}
-
 static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
 			     unsigned int bytes)
 {
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 83f5cd0..841f9a8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -261,6 +261,7 @@
 #include <linux/syscalls.h>
 #include <linux/completion.h>
 #include <linux/uuid.h>
+#include <crypto/chacha20.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -413,6 +414,29 @@ static struct fasync_struct *fasync;
 static DEFINE_SPINLOCK(random_ready_list_lock);
 static LIST_HEAD(random_ready_list);
 
+struct crng_state {
+	__u32		state[16];
+	unsigned long	init_time;
+	spinlock_t	lock;
+};
+
+struct crng_state primary_crng = {
+	.lock = __SPIN_LOCK_UNLOCKED(primary_crng.lock),
+};
+
+/*
+ * crng_init =  0 --> Uninitialized
+ *		1 --> Initialized
+ *		2 --> Initialized from input_pool
+ *
+ * crng_init is protected by primary_crng->lock, and only increases
+ * its value (from 0->1->2).
+ */
+static int crng_init = 0;
+#define crng_ready() (likely(crng_init > 0))
+static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE]);
+static void process_random_ready_list(void);
+
 /**********************************************************************
  *
  * OS independent entropy store.   Here are the functions which handle
@@ -442,10 +466,15 @@ struct entropy_store {
 	__u8 last_data[EXTRACT_SIZE];
 };
 
+static ssize_t extract_entropy(struct entropy_store *r, void *buf,
+			       size_t nbytes, int min, int rsvd);
+static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
+				size_t nbytes, int fips);
+
+static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
 static void push_to_pool(struct work_struct *work);
 static __u32 input_pool_data[INPUT_POOL_WORDS];
 static __u32 blocking_pool_data[OUTPUT_POOL_WORDS];
-static __u32 nonblocking_pool_data[OUTPUT_POOL_WORDS];
 
 static struct entropy_store input_pool = {
 	.poolinfo = &poolinfo_table[0],
@@ -466,16 +495,6 @@ static struct entropy_store blocking_pool = {
 					push_to_pool),
 };
 
-static struct entropy_store nonblocking_pool = {
-	.poolinfo = &poolinfo_table[1],
-	.name = "nonblocking",
-	.pull = &input_pool,
-	.lock = __SPIN_LOCK_UNLOCKED(nonblocking_pool.lock),
-	.pool = nonblocking_pool_data,
-	.push_work = __WORK_INITIALIZER(nonblocking_pool.push_work,
-					push_to_pool),
-};
-
 static __u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
@@ -678,12 +697,6 @@ retry:
 	if (!r->initialized && r->entropy_total > 128) {
 		r->initialized = 1;
 		r->entropy_total = 0;
-		if (r == &nonblocking_pool) {
-			prandom_reseed_late();
-			process_random_ready_list();
-			wake_up_all(&urandom_init_wait);
-			pr_notice("random: %s pool is initialized\n", r->name);
-		}
 	}
 
 	trace_credit_entropy_bits(r->name, nbits,
@@ -693,30 +706,27 @@ retry:
 	if (r == &input_pool) {
 		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
 
+		if (crng_init < 2 && entropy_bits >= 128) {
+			crng_reseed(&primary_crng, r);
+			entropy_bits = r->entropy_count >> ENTROPY_SHIFT;
+		}
+
 		/* should we wake readers? */
 		if (entropy_bits >= random_read_wakeup_bits) {
 			wake_up_interruptible(&random_read_wait);
 			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
 		/* If the input pool is getting full, send some
-		 * entropy to the two output pools, flipping back and
-		 * forth between them, until the output pools are 75%
-		 * full.
+		 * entropy to the blocking pool until it is 75% full.
 		 */
 		if (entropy_bits > random_write_wakeup_bits &&
 		    r->initialized &&
 		    r->entropy_total >= 2*random_read_wakeup_bits) {
-			static struct entropy_store *last = &blocking_pool;
 			struct entropy_store *other = &blocking_pool;
 
-			if (last == &blocking_pool)
-				other = &nonblocking_pool;
 			if (other->entropy_count <=
-			    3 * other->poolinfo->poolfracbits / 4)
-				last = other;
-			if (last->entropy_count <=
-			    3 * last->poolinfo->poolfracbits / 4) {
-				schedule_work(&last->push_work);
+			    3 * other->poolinfo->poolfracbits / 4) {
+				schedule_work(&other->push_work);
 				r->entropy_total = 0;
 			}
 		}
@@ -736,6 +746,154 @@ static void credit_entropy_bits_safe(struct entropy_store *r, int nbits)
 
 /*********************************************************************
  *
+ * CRNG using CHACHA20
+ *
+ *********************************************************************/
+
+#define CRNG_RESEED_INTERVAL (300*HZ)
+
+static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
+
+static void crng_initialize(struct crng_state *crng)
+{
+	int		i;
+	unsigned long	rv;
+
+	memcpy(&crng->state[0], "expand 32-byte k", 16);
+	if (crng == &primary_crng)
+		_extract_entropy(&input_pool, &crng->state[4],
+				 sizeof(__u32) * 12, 0);
+	else
+		get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
+	for (i = 4; i < 16; i++) {
+		if (!arch_get_random_seed_long(&rv) &&
+		    !arch_get_random_long(&rv))
+			rv = random_get_entropy();
+		crng->state[i] ^= rv;
+	}
+	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
+}
+
+static int crng_fast_load(const char *cp, size_t len)
+{
+	unsigned long flags;
+	static size_t c = 0;
+	char *p;
+
+	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
+		return 0;
+	if (crng_ready()) {
+		spin_unlock_irqrestore(&primary_crng.lock, flags);
+		return 0;
+	}
+	p = (unsigned char *) &primary_crng.state[4];
+	p += c;
+	while (len > 0 && c < CHACHA20_KEY_SIZE) {
+		*p ^= *cp;
+		p++; cp++; c++; len--;
+	}
+	if (c >= CHACHA20_KEY_SIZE) {
+		crng_init = 1;
+		wake_up_interruptible(&crng_init_wait);
+		pr_notice("random: fast init done\n");
+	}
+	spin_unlock_irqrestore(&primary_crng.lock, flags);
+	return 1;
+}
+
+static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
+{
+	unsigned long	flags;
+	int		i, num;
+	union {
+		__u8	block[CHACHA20_BLOCK_SIZE];
+		__u32	key[8];
+	} buf;
+
+	if (r) {
+		num = extract_entropy(r, &buf, 32, 16, 0);
+		if (num == 0)
+			return;
+	} else
+		extract_crng(buf.block);
+	spin_lock_irqsave(&primary_crng.lock, flags);
+	for (i = 0; i < 8; i++) {
+		unsigned long	rv;
+		if (!arch_get_random_seed_long(&rv) &&
+		    !arch_get_random_long(&rv))
+			rv = random_get_entropy();
+		crng->state[i+4] ^= buf.key[i] ^ rv;
+	}
+	memzero_explicit(&buf, sizeof(buf));
+	crng->init_time = jiffies;
+	if (crng == &primary_crng && crng_init < 2) {
+		crng_init = 2;
+		process_random_ready_list();
+		wake_up_interruptible(&crng_init_wait);
+		pr_notice("random: crng init done\n");
+	}
+	spin_unlock_irqrestore(&primary_crng.lock, flags);
+}
+
+static inline void crng_wait_ready(void)
+{
+	wait_event_interruptible(crng_init_wait, crng_ready());
+}
+
+static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
+{
+	unsigned long v, flags;
+	struct crng_state *crng = &primary_crng;
+
+	if (crng_init > 1 &&
+	    time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL))
+		crng_reseed(crng, &input_pool);
+	spin_lock_irqsave(&crng->lock, flags);
+	if (arch_get_random_long(&v))
+		crng->state[14] ^= v;
+	chacha20_block(&crng->state[0], out);
+	if (crng->state[12] == 0)
+		crng->state[13]++;
+	spin_unlock_irqrestore(&crng->lock, flags);
+}
+
+static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
+{
+	ssize_t ret = 0, i;
+	__u8 tmp[CHACHA20_BLOCK_SIZE];
+	int large_request = (nbytes > 256);
+
+	while (nbytes) {
+		if (large_request && need_resched()) {
+			if (signal_pending(current)) {
+				if (ret == 0)
+					ret = -ERESTARTSYS;
+				break;
+			}
+			schedule();
+		}
+
+		extract_crng(tmp);
+		i = min_t(int, nbytes, CHACHA20_BLOCK_SIZE);
+		if (copy_to_user(buf, tmp, i)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		nbytes -= i;
+		buf += i;
+		ret += i;
+	}
+
+	/* Wipe data just written to memory */
+	memzero_explicit(tmp, sizeof(tmp));
+
+	return ret;
+}
+
+
+/*********************************************************************
+ *
  * Entropy input management
  *
  *********************************************************************/
@@ -750,12 +908,12 @@ struct timer_rand_state {
 #define INIT_TIMER_RAND_STATE { INITIAL_JIFFIES, };
 
 /*
- * Add device- or boot-specific data to the input and nonblocking
- * pools to help initialize them to unique values.
+ * Add device- or boot-specific data to the input pool to help
+ * initialize it.
  *
- * None of this adds any entropy, it is meant to avoid the
- * problem of the nonblocking pool having similar initial state
- * across largely identical devices.
+ * None of this adds any entropy; it is meant to avoid the problem of
+ * the entropy pool having similar initial state across largely
+ * identical devices.
  */
 void add_device_randomness(const void *buf, unsigned int size)
 {
@@ -767,11 +925,6 @@ void add_device_randomness(const void *buf, unsigned int size)
 	_mix_pool_bytes(&input_pool, buf, size);
 	_mix_pool_bytes(&input_pool, &time, sizeof(time));
 	spin_unlock_irqrestore(&input_pool.lock, flags);
-
-	spin_lock_irqsave(&nonblocking_pool.lock, flags);
-	_mix_pool_bytes(&nonblocking_pool, buf, size);
-	_mix_pool_bytes(&nonblocking_pool, &time, sizeof(time));
-	spin_unlock_irqrestore(&nonblocking_pool.lock, flags);
 }
 EXPORT_SYMBOL(add_device_randomness);
 
@@ -802,7 +955,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	sample.jiffies = jiffies;
 	sample.cycles = random_get_entropy();
 	sample.num = num;
-	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
+	r = &input_pool;
 	mix_pool_bytes(r, &sample, sizeof(sample));
 
 	/*
@@ -918,11 +1071,21 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	fast_mix(fast_pool);
 	add_interrupt_bench(cycles);
 
+	if (!crng_ready()) {
+		if ((fast_pool->count >= 64) &&
+		    crng_fast_load((char *) fast_pool->pool,
+				   sizeof(fast_pool->pool))) {
+			fast_pool->count = 0;
+			fast_pool->last = now;
+		}
+		return;
+	}
+
 	if ((fast_pool->count < 64) &&
 	    !time_after(now, fast_pool->last + HZ))
 		return;
 
-	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
+	r = &input_pool;
 	if (!spin_trylock(&r->lock))
 		return;
 
@@ -966,9 +1129,6 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
  *
  *********************************************************************/
 
-static ssize_t extract_entropy(struct entropy_store *r, void *buf,
-			       size_t nbytes, int min, int rsvd);
-
 /*
  * This utility inline function is responsible for transferring entropy
  * from the primary pool to the secondary extraction pool. We make
@@ -1143,6 +1303,36 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 	memzero_explicit(&hash, sizeof(hash));
 }
 
+static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
+				size_t nbytes, int fips)
+{
+	ssize_t ret = 0, i;
+	__u8 tmp[EXTRACT_SIZE];
+	unsigned long flags;
+
+	while (nbytes) {
+		extract_buf(r, tmp);
+
+		if (fips) {
+			spin_lock_irqsave(&r->lock, flags);
+			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
+				panic("Hardware RNG duplicated output!\n");
+			memcpy(r->last_data, tmp, EXTRACT_SIZE);
+			spin_unlock_irqrestore(&r->lock, flags);
+		}
+		i = min_t(int, nbytes, EXTRACT_SIZE);
+		memcpy(buf, tmp, i);
+		nbytes -= i;
+		buf += i;
+		ret += i;
+	}
+
+	/* Wipe data just returned from memory */
+	memzero_explicit(tmp, sizeof(tmp));
+
+	return ret;
+}
+
 /*
  * This function extracts randomness from the "entropy pool", and
  * returns it in a buffer.
@@ -1155,7 +1345,6 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 				 size_t nbytes, int min, int reserved)
 {
-	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
 
@@ -1179,27 +1368,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
-	while (nbytes) {
-		extract_buf(r, tmp);
-
-		if (fips_enabled) {
-			spin_lock_irqsave(&r->lock, flags);
-			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
-				panic("Hardware RNG duplicated output!\n");
-			memcpy(r->last_data, tmp, EXTRACT_SIZE);
-			spin_unlock_irqrestore(&r->lock, flags);
-		}
-		i = min_t(int, nbytes, EXTRACT_SIZE);
-		memcpy(buf, tmp, i);
-		nbytes -= i;
-		buf += i;
-		ret += i;
-	}
-
-	/* Wipe data just returned from memory */
-	memzero_explicit(tmp, sizeof(tmp));
-
-	return ret;
+	return _extract_entropy(r, buf, nbytes, fips_enabled);
 }
 
 /*
@@ -1254,15 +1423,26 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
  */
 void get_random_bytes(void *buf, int nbytes)
 {
+	__u8 tmp[CHACHA20_BLOCK_SIZE];
+
 #if DEBUG_RANDOM_BOOT > 0
-	if (unlikely(nonblocking_pool.initialized == 0))
+	if (!crng_ready())
 		printk(KERN_NOTICE "random: %pF get_random_bytes called "
-		       "with %d bits of entropy available\n",
-		       (void *) _RET_IP_,
-		       nonblocking_pool.entropy_total);
+		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
 #endif
 	trace_get_random_bytes(nbytes, _RET_IP_);
-	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+
+	while (nbytes >= CHACHA20_BLOCK_SIZE) {
+		extract_crng(buf);
+		buf += CHACHA20_BLOCK_SIZE;
+		nbytes -= CHACHA20_BLOCK_SIZE;
+	}
+
+	if (nbytes > 0) {
+		extract_crng(tmp);
+		memcpy(buf, tmp, nbytes);
+		memzero_explicit(tmp, nbytes);
+	}
 }
 EXPORT_SYMBOL(get_random_bytes);
 
@@ -1280,7 +1460,7 @@ int add_random_ready_callback(struct random_ready_callback *rdy)
 	unsigned long flags;
 	int err = -EALREADY;
 
-	if (likely(nonblocking_pool.initialized))
+	if (crng_ready())
 		return err;
 
 	owner = rdy->owner;
@@ -1288,7 +1468,7 @@ int add_random_ready_callback(struct random_ready_callback *rdy)
 		return -ENOENT;
 
 	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (nonblocking_pool.initialized)
+	if (crng_ready())
 		goto out;
 
 	owner = NULL;
@@ -1352,7 +1532,7 @@ void get_random_bytes_arch(void *buf, int nbytes)
 	}
 
 	if (nbytes)
-		extract_entropy(&nonblocking_pool, p, nbytes, 0, 0);
+		get_random_bytes(p, nbytes);
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
@@ -1397,7 +1577,7 @@ static int rand_initialize(void)
 {
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
-	init_std_data(&nonblocking_pool);
+	crng_initialize(&primary_crng);
 	return 0;
 }
 early_initcall(rand_initialize);
@@ -1462,19 +1642,15 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	static int maxwarn = 10;
 	int ret;
 
-	if (unlikely(nonblocking_pool.initialized == 0) &&
-	    maxwarn > 0) {
+	if (!crng_ready() && maxwarn > 0) {
 		maxwarn--;
 		printk(KERN_NOTICE "random: %s: uninitialized urandom read "
-		       "(%d bytes read, %d bits of entropy available)\n",
-		       current->comm, nbytes, nonblocking_pool.entropy_total);
+		       "(%d bytes read)\n",
+		       current->comm, nbytes);
 	}
-
 	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
-	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
-
-	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),
-			   ENTROPY_BITS(&input_pool));
+	ret = extract_crng_user(buf, nbytes);
+	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS(&input_pool));
 	return ret;
 }
 
@@ -1520,10 +1696,7 @@ static ssize_t random_write(struct file *file, const char __user *buffer,
 {
 	size_t ret;
 
-	ret = write_pool(&blocking_pool, buffer, count);
-	if (ret)
-		return ret;
-	ret = write_pool(&nonblocking_pool, buffer, count);
+	ret = write_pool(&input_pool, buffer, count);
 	if (ret)
 		return ret;
 
@@ -1574,7 +1747,6 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		input_pool.entropy_count = 0;
-		nonblocking_pool.entropy_count = 0;
 		blocking_pool.entropy_count = 0;
 		return 0;
 	default:
@@ -1616,11 +1788,10 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 	if (flags & GRND_RANDOM)
 		return _random_read(flags & GRND_NONBLOCK, buf, count);
 
-	if (unlikely(nonblocking_pool.initialized == 0)) {
+	if (!crng_ready()) {
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
-		wait_event_interruptible(urandom_init_wait,
-					 nonblocking_pool.initialized);
+		crng_wait_ready();
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 	}
@@ -1856,18 +2027,17 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 {
 	struct entropy_store *poolp = &input_pool;
 
-	if (unlikely(nonblocking_pool.initialized == 0))
-		poolp = &nonblocking_pool;
-	else {
-		/* Suspend writing if we're above the trickle
-		 * threshold.  We'll be woken up again once below
-		 * random_write_wakeup_thresh, or when the calling
-		 * thread is about to terminate.
-		 */
-		wait_event_interruptible(random_write_wait,
-					 kthread_should_stop() ||
-			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
+	if (!crng_ready()) {
+		crng_fast_load(buffer, count);
+		return;
 	}
+
+	/* Suspend writing if we're above the trickle threshold.
+	 * We'll be woken up again once below random_write_wakeup_thresh,
+	 * or when the calling thread is about to terminate.
+	 */
+	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);
 }
diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
index 274bbae..20d20f68 100644
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -16,6 +16,7 @@ struct chacha20_ctx {
 	u32 key[8];
 };
 
+void chacha20_block(u32 *state, void *stream);
 void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
 int crypto_chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keysize);
diff --git a/lib/Makefile b/lib/Makefile
index 499fb35..34e205f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -22,7 +22,7 @@ KCOV_INSTRUMENT_hweight.o := n
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o \
-	 sha1.o md5.o irq_regs.o argv_split.o \
+	 sha1.o chacha20.o md5.o irq_regs.o argv_split.o \
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o nmi_backtrace.o nodemask.o
diff --git a/lib/chacha20.c b/lib/chacha20.c
new file mode 100644
index 0000000..250ceed
--- /dev/null
+++ b/lib/chacha20.c
@@ -0,0 +1,79 @@
+/*
+ * ChaCha20 256-bit cipher algorithm, RFC7539
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/bitops.h>
+#include <linux/cryptohash.h>
+#include <asm/unaligned.h>
+#include <crypto/chacha20.h>
+
+static inline u32 rotl32(u32 v, u8 n)
+{
+	return (v << n) | (v >> (sizeof(v) * 8 - n));
+}
+
+extern void chacha20_block(u32 *state, void *stream)
+{
+	u32 x[16], *out = stream;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(x); i++)
+		x[i] = state[i];
+
+	for (i = 0; i < 20; i += 2) {
+		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],  16);
+		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],  16);
+		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],  16);
+		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],  16);
+
+		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],  12);
+		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],  12);
+		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10], 12);
+		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11], 12);
+
+		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],   8);
+		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],   8);
+		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],   8);
+		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],   8);
+
+		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],   7);
+		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],   7);
+		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10],  7);
+		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11],  7);
+
+		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],  16);
+		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],  16);
+		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],  16);
+		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],  16);
+
+		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10], 12);
+		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11], 12);
+		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],  12);
+		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],  12);
+
+		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],   8);
+		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],   8);
+		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],   8);
+		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],   8);
+
+		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10],  7);
+		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11],  7);
+		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],   7);
+		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],   7);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(x); i++)
+		out[i] = cpu_to_le32(x[i] + state[i]);
+
+	state[12]++;
+}
+EXPORT_SYMBOL(chacha20_block);
-- 
2.5.0
