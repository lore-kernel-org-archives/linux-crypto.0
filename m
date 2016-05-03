From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a Chacha20-based CRNG
Date: Tue, 03 May 2016 11:36:12 +0200
Message-ID: <2341945.hVvssvnSpF@tauon.atsec.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu> <1462170413-7164-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54572 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbcECJgR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 05:36:17 -0400
In-Reply-To: <1462170413-7164-2-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 2. Mai 2016, 02:26:51 schrieb Theodore Ts'o:

Hi Theodore,

One more item.

> The CRNG is faster, and we don't pretend to track entropy usage in the
> CRNG any more.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  crypto/chacha20_generic.c |  61 ----------
>  drivers/char/random.c     | 282
> ++++++++++++++++++++++++++++++++++------------ include/crypto/chacha20.h | 
>  1 +
>  lib/Makefile              |   2 +-
>  lib/chacha20.c            |  79 +++++++++++++
>  5 files changed, 294 insertions(+), 131 deletions(-)
>  create mode 100644 lib/chacha20.c
> 
> diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
> index da9c899..1cab831 100644
> --- a/crypto/chacha20_generic.c
> +++ b/crypto/chacha20_generic.c
> @@ -15,72 +15,11 @@
>  #include <linux/module.h>
>  #include <crypto/chacha20.h>
> 
> -static inline u32 rotl32(u32 v, u8 n)
> -{
> -	return (v << n) | (v >> (sizeof(v) * 8 - n));
> -}
> -
>  static inline u32 le32_to_cpuvp(const void *p)
>  {
>  	return le32_to_cpup(p);
>  }
> 
> -static void chacha20_block(u32 *state, void *stream)
> -{
> -	u32 x[16], *out = stream;
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(x); i++)
> -		x[i] = state[i];
> -
> -	for (i = 0; i < 20; i += 2) {
> -		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],  16);
> -		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],  16);
> -		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],  16);
> -		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],  16);
> -
> -		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],  12);
> -		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],  12);
> -		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10], 12);
> -		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11], 12);
> -
> -		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],   8);
> -		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],   8);
> -		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],   8);
> -		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],   8);
> -
> -		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],   7);
> -		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],   7);
> -		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10],  7);
> -		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11],  7);
> -
> -		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],  16);
> -		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],  16);
> -		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],  16);
> -		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],  16);
> -
> -		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10], 12);
> -		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11], 12);
> -		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],  12);
> -		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],  12);
> -
> -		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],   8);
> -		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],   8);
> -		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],   8);
> -		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],   8);
> -
> -		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10],  7);
> -		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11],  7);
> -		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],   7);
> -		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],   7);
> -	}
> -
> -	for (i = 0; i < ARRAY_SIZE(x); i++)
> -		out[i] = cpu_to_le32(x[i] + state[i]);
> -
> -	state[12]++;
> -}
> -
>  static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
>  			     unsigned int bytes)
>  {
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index b583e53..95f4451 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -260,6 +260,7 @@
>  #include <linux/irq.h>
>  #include <linux/syscalls.h>
>  #include <linux/completion.h>
> +#include <crypto/chacha20.h>
> 
>  #include <asm/processor.h>
>  #include <asm/uaccess.h>
> @@ -412,6 +413,15 @@ static struct fasync_struct *fasync;
>  static DEFINE_SPINLOCK(random_ready_list_lock);
>  static LIST_HEAD(random_ready_list);
> 
> +/*
> + * crng_init =  0 --> Uninitialized
> + *		2 --> Initialized
> + *		3 --> Initialized from input_pool
> + */
> +static int crng_init = 0;
> +#define crng_ready() (likely(crng_init >= 2))
> +static void process_random_ready_list(void);
> +
>  /**********************************************************************
>   *
>   * OS independent entropy store.   Here are the functions which handle
> @@ -441,10 +451,13 @@ struct entropy_store {
>  	__u8 last_data[EXTRACT_SIZE];
>  };
> 
> +static ssize_t extract_entropy(struct entropy_store *r, void *buf,
> +			       size_t nbytes, int min, int rsvd);
> +
> +static int crng_reseed(struct entropy_store *r);
>  static void push_to_pool(struct work_struct *work);
>  static __u32 input_pool_data[INPUT_POOL_WORDS];
>  static __u32 blocking_pool_data[OUTPUT_POOL_WORDS];
> -static __u32 nonblocking_pool_data[OUTPUT_POOL_WORDS];
> 
>  static struct entropy_store input_pool = {
>  	.poolinfo = &poolinfo_table[0],
> @@ -465,16 +478,6 @@ static struct entropy_store blocking_pool = {
>  					push_to_pool),
>  };
> 
> -static struct entropy_store nonblocking_pool = {
> -	.poolinfo = &poolinfo_table[1],
> -	.name = "nonblocking",
> -	.pull = &input_pool,
> -	.lock = __SPIN_LOCK_UNLOCKED(nonblocking_pool.lock),
> -	.pool = nonblocking_pool_data,
> -	.push_work = __WORK_INITIALIZER(nonblocking_pool.push_work,
> -					push_to_pool),
> -};
> -
>  static __u32 const twist_table[8] = {
>  	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
>  	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
> @@ -677,12 +680,6 @@ retry:
>  	if (!r->initialized && r->entropy_total > 128) {
>  		r->initialized = 1;
>  		r->entropy_total = 0;
> -		if (r == &nonblocking_pool) {
> -			prandom_reseed_late();
> -			process_random_ready_list();
> -			wake_up_all(&urandom_init_wait);
> -			pr_notice("random: %s pool is initialized\n", r-
>name);
> -		}
>  	}
> 
>  	trace_credit_entropy_bits(r->name, nbits,
> @@ -692,30 +689,27 @@ retry:
>  	if (r == &input_pool) {
>  		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
> 
> +		if (crng_init < 3 && entropy_bits >= 128) {
> +			(void) crng_reseed(r);
> +			entropy_bits = r->entropy_count >> ENTROPY_SHIFT;
> +		}
> +
>  		/* should we wake readers? */
>  		if (entropy_bits >= random_read_wakeup_bits) {
>  			wake_up_interruptible(&random_read_wait);
>  			kill_fasync(&fasync, SIGIO, POLL_IN);
>  		}
>  		/* If the input pool is getting full, send some
> -		 * entropy to the two output pools, flipping back and
> -		 * forth between them, until the output pools are 75%
> -		 * full.
> +		 * entropy to the blocking pool until it is 75% full.
>  		 */
>  		if (entropy_bits > random_write_wakeup_bits &&
>  		    r->initialized &&
>  		    r->entropy_total >= 2*random_read_wakeup_bits) {
> -			static struct entropy_store *last = &blocking_pool;
>  			struct entropy_store *other = &blocking_pool;
> 
> -			if (last == &blocking_pool)
> -				other = &nonblocking_pool;
>  			if (other->entropy_count <=
> -			    3 * other->poolinfo->poolfracbits / 4)
> -				last = other;
> -			if (last->entropy_count <=
> -			    3 * last->poolinfo->poolfracbits / 4) {
> -				schedule_work(&last->push_work);
> +			    3 * other->poolinfo->poolfracbits / 4) {
> +				schedule_work(&other->push_work);
>  				r->entropy_total = 0;
>  			}
>  		}
> @@ -735,6 +729,158 @@ static void credit_entropy_bits_safe(struct
> entropy_store *r, int nbits)
> 
>  /*********************************************************************
>   *
> + * CRNG using CHACHA20
> + *
> + *********************************************************************/
> +
> +#define CRNG_RESEED_INTERVAL (300*HZ)
> +
> +struct crng_state {
> +	__u32		state[16];
> +	unsigned long	init_time;
> +	spinlock_t	lock;
> +};
> +
> +struct crng_state primary_crng = {
> +	.lock = __SPIN_LOCK_UNLOCKED(primary_crng.lock),
> +};
> +static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
> +
> +static void _initialize_crng(struct crng_state *crng)
> +{
> +	int		i;
> +	unsigned long	rv;
> +
> +	memcpy(&crng->state[0], "expand 32-byte k", 16);
> +	for (i = 4; i < 16; i++) {
> +		if (!arch_get_random_seed_long(&rv) &&
> +		    !arch_get_random_long(&rv))
> +			rv = random_get_entropy();
> +		crng->state[i] ^= rv;
> +	}
> +	crng->init_time = jiffies - CRNG_RESEED_INTERVAL;
> +}
> +
> +static void initialize_crng(struct crng_state *crng)
> +{
> +	_initialize_crng(crng);
> +	spin_lock_init(&crng->lock);
> +}
> +
> +static int crng_fast_load(__u32 pool[4])
> +{
> +	int	i;
> +	__u32	*p;
> +
> +	if (!spin_trylock(&primary_crng.lock))
> +		return 0;
> +	if (crng_ready()) {
> +		spin_unlock(&primary_crng.lock);
> +		return 0;
> +	}
> +	p = &primary_crng.state[4];
> +	if (crng_init == 1)
> +		p += 4;
> +	for (i=0; i < 4; i++)
> +		*p ^= pool[i];
> +	if (crng_init++ >= 2)
> +		wake_up_interruptible(&crng_init_wait);
> +	pr_notice("random: crng_init %d\n", crng_init);
> +	spin_unlock(&primary_crng.lock);
> +	return 1;
> +}
> +
> +/* Returns 1 on success */
> +static int crng_reseed(struct entropy_store *r)
> +{
> +	unsigned long	flags;
> +	int		ret = 0;
> +	int		i, num, num_words;
> +	__u32		tmp[16];
> +
> +	spin_lock_irqsave(&primary_crng.lock, flags);
> +	num = extract_entropy(r, tmp, 32, 16, 0);
> +	if (num == 0)
> +		goto out;
> +	if (num < 16 || num > 32) {
> +		WARN_ON(1);
> +		pr_err("crng_reseed: num is %d?!?\n", num);
> +	}
> +	num_words = (num + 3) / 4;
> +	for (i = 0; i < num_words; i++)
> +		primary_crng.state[i+4] ^= tmp[i];
> +	primary_crng.init_time = jiffies;
> +	if (crng_init < 3) {
> +		crng_init = 3;
> +		process_random_ready_list();
> +		wake_up_interruptible(&crng_init_wait);
> +		pr_notice("random: crng_init 3\n");
> +	}
> +	ret = 1;
> +out:
> +	spin_unlock_irqrestore(&primary_crng.lock, flags);
> +	return ret;
> +}
> +
> +static inline void crng_wait_ready(void)
> +{
> +	wait_event_interruptible(crng_init_wait, crng_ready());
> +}
> +
> +static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
> +{
> +	unsigned long v, flags;
> +	struct crng_state *crng = &primary_crng;
> +
> +	if (crng_init > 2 &&
> +	    time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL))
> +		crng_reseed(&input_pool);
> +	spin_lock_irqsave(&crng->lock, flags);
> +	if (arch_get_random_long(&v))
> +		crng->state[14] ^= v;
> +	chacha20_block(&crng->state[0], out);
> +	if (crng->state[12] == 0)
> +		crng->state[13]++;
> +	spin_unlock_irqrestore(&crng->lock, flags);
> +}
> +
> +static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
> +{
> +	ssize_t ret = 0, i;
> +	__u8 tmp[CHACHA20_BLOCK_SIZE];
> +	int large_request = (nbytes > 256);
> +
> +	while (nbytes) {
> +		if (large_request && need_resched()) {
> +			if (signal_pending(current)) {
> +				if (ret == 0)
> +					ret = -ERESTARTSYS;
> +				break;
> +			}
> +			schedule();
> +		}
> +
> +		extract_crng(tmp);
> +		i = min_t(int, nbytes, CHACHA20_BLOCK_SIZE);
> +		if (copy_to_user(buf, tmp, i)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		nbytes -= i;
> +		buf += i;
> +		ret += i;
> +	}
> +
> +	/* Wipe data just written to memory */
> +	memzero_explicit(tmp, sizeof(tmp));


Would it make sense to add another chacha20_block() call here at the end? 
Note, the one thing about the SP800-90A DRBG I really like is the enhanced 
backward secrecy support which is implemented by "updating" the internal state 
(the key / state) used for one or more random number generation rounds after 
one request for random numbers is satisfied.

This means that even if the state becomes known or the subsequent caller 
manages to deduce the state of the RNG to some degree of confidence, he cannot 
backtrack the already generated random numbers.

I see that the ChaCha20 RNG implicitly updates its state while it operates. 
But for the last round of the RNG, there is no more shuffling of the internal 
state. As one round is 64 bytes in size and many callers just want 16 or 32 
bytes (as seen during testing), a lot of callers trigger only one round of the 
RNG.


> +
> +	return ret;
> +}
> +
> +
> +/*********************************************************************
> + *
>   * Entropy input management
>   *
>   *********************************************************************/
> @@ -749,12 +895,12 @@ struct timer_rand_state {
>  #define INIT_TIMER_RAND_STATE { INITIAL_JIFFIES, };
> 
>  /*
> - * Add device- or boot-specific data to the input and nonblocking
> - * pools to help initialize them to unique values.
> + * Add device- or boot-specific data to the input pool to help
> + * initialize it.
>   *
> - * None of this adds any entropy, it is meant to avoid the
> - * problem of the nonblocking pool having similar initial state
> - * across largely identical devices.
> + * None of this adds any entropy; it is meant to avoid the problem of
> + * the entropy pool having similar initial state across largely
> + * identical devices.
>   */
>  void add_device_randomness(const void *buf, unsigned int size)
>  {
> @@ -766,11 +912,6 @@ void add_device_randomness(const void *buf, unsigned
> int size) _mix_pool_bytes(&input_pool, buf, size);
>  	_mix_pool_bytes(&input_pool, &time, sizeof(time));
>  	spin_unlock_irqrestore(&input_pool.lock, flags);
> -
> -	spin_lock_irqsave(&nonblocking_pool.lock, flags);
> -	_mix_pool_bytes(&nonblocking_pool, buf, size);
> -	_mix_pool_bytes(&nonblocking_pool, &time, sizeof(time));
> -	spin_unlock_irqrestore(&nonblocking_pool.lock, flags);
>  }
>  EXPORT_SYMBOL(add_device_randomness);
> 
> @@ -801,7 +942,7 @@ static void add_timer_randomness(struct timer_rand_state
> *state, unsigned num) sample.jiffies = jiffies;
>  	sample.cycles = random_get_entropy();
>  	sample.num = num;
> -	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
> +	r = &input_pool;
>  	mix_pool_bytes(r, &sample, sizeof(sample));
> 
>  	/*
> @@ -921,7 +1062,13 @@ void add_interrupt_randomness(int irq, int irq_flags)
>  	    !time_after(now, fast_pool->last + HZ))
>  		return;
> 
> -	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
> +	if (!crng_ready() && crng_fast_load(fast_pool->pool)) {
> +		fast_pool->count = 0;
> +		fast_pool->last = now;
> +		return;
> +	}
> +
> +	r = &input_pool;
>  	if (!spin_trylock(&r->lock))
>  		return;
> 
> @@ -964,9 +1111,6 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
>   *
>   *********************************************************************/
> 
> -static ssize_t extract_entropy(struct entropy_store *r, void *buf,
> -			       size_t nbytes, int min, int rsvd);
> -
>  /*
>   * This utility inline function is responsible for transferring entropy
>   * from the primary pool to the secondary extraction pool. We make
> @@ -1252,15 +1396,26 @@ static ssize_t extract_entropy_user(struct
> entropy_store *r, void __user *buf, */
>  void get_random_bytes(void *buf, int nbytes)
>  {
> +	__u8 tmp[CHACHA20_BLOCK_SIZE];
> +
>  #if DEBUG_RANDOM_BOOT > 0
> -	if (unlikely(nonblocking_pool.initialized == 0))
> +	if (!crng_ready())
>  		printk(KERN_NOTICE "random: %pF get_random_bytes called "
> -		       "with %d bits of entropy available\n",
> -		       (void *) _RET_IP_,
> -		       nonblocking_pool.entropy_total);
> +		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
>  #endif
>  	trace_get_random_bytes(nbytes, _RET_IP_);
> -	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
> +
> +	while (nbytes >= CHACHA20_BLOCK_SIZE) {
> +		extract_crng(buf);
> +		buf += CHACHA20_BLOCK_SIZE;
> +		nbytes -= CHACHA20_BLOCK_SIZE;
> +	}
> +
> +	if (nbytes > 0) {
> +		extract_crng(tmp);
> +		memcpy(buf, tmp, nbytes);
> +		memzero_explicit(tmp, nbytes);
> +	}

dto here.

>  }
>  EXPORT_SYMBOL(get_random_bytes);
> 
> @@ -1278,7 +1433,7 @@ int add_random_ready_callback(struct
> random_ready_callback *rdy) unsigned long flags;
>  	int err = -EALREADY;
> 
> -	if (likely(nonblocking_pool.initialized))
> +	if (crng_ready())
>  		return err;
> 
>  	owner = rdy->owner;
> @@ -1286,7 +1441,7 @@ int add_random_ready_callback(struct
> random_ready_callback *rdy) return -ENOENT;
> 
>  	spin_lock_irqsave(&random_ready_list_lock, flags);
> -	if (nonblocking_pool.initialized)
> +	if (crng_ready())
>  		goto out;
> 
>  	owner = NULL;
> @@ -1350,7 +1505,7 @@ void get_random_bytes_arch(void *buf, int nbytes)
>  	}
> 
>  	if (nbytes)
> -		extract_entropy(&nonblocking_pool, p, nbytes, 0, 0);
> +		get_random_bytes(p, nbytes);
>  }
>  EXPORT_SYMBOL(get_random_bytes_arch);
> 
> @@ -1395,7 +1550,7 @@ static int rand_initialize(void)
>  {
>  	init_std_data(&input_pool);
>  	init_std_data(&blocking_pool);
> -	init_std_data(&nonblocking_pool);
> +	_initialize_crng(&primary_crng);
>  	return 0;
>  }
>  early_initcall(rand_initialize);
> @@ -1459,16 +1614,10 @@ urandom_read(struct file *file, char __user *buf,
> size_t nbytes, loff_t *ppos) {
>  	int ret;
> 
> -	if (unlikely(nonblocking_pool.initialized == 0))
> -		printk_once(KERN_NOTICE "random: %s urandom read "
> -			    "with %d bits of entropy available\n",
> -			    current->comm, nonblocking_pool.entropy_total);
> -
> +	crng_wait_ready();
>  	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
> -	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
> -
> -	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),
> -			   ENTROPY_BITS(&input_pool));
> +	ret = extract_crng_user(buf, nbytes);
> +	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS(&input_pool));
>  	return ret;
>  }
> 
> @@ -1514,10 +1663,7 @@ static ssize_t random_write(struct file *file, const
> char __user *buffer, {
>  	size_t ret;
> 
> -	ret = write_pool(&blocking_pool, buffer, count);
> -	if (ret)
> -		return ret;
> -	ret = write_pool(&nonblocking_pool, buffer, count);
> +	ret = write_pool(&input_pool, buffer, count);
>  	if (ret)
>  		return ret;
> 
> @@ -1568,7 +1714,6 @@ static long random_ioctl(struct file *f, unsigned int
> cmd, unsigned long arg) if (!capable(CAP_SYS_ADMIN))
>  			return -EPERM;
>  		input_pool.entropy_count = 0;
> -		nonblocking_pool.entropy_count = 0;
>  		blocking_pool.entropy_count = 0;
>  		return 0;
>  	default:
> @@ -1610,11 +1755,10 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf,
> size_t, count, if (flags & GRND_RANDOM)
>  		return _random_read(flags & GRND_NONBLOCK, buf, count);
> 
> -	if (unlikely(nonblocking_pool.initialized == 0)) {
> +	if (!crng_ready()) {
>  		if (flags & GRND_NONBLOCK)
>  			return -EAGAIN;
> -		wait_event_interruptible(urandom_init_wait,
> -					 nonblocking_pool.initialized);
> +		crng_wait_ready();
>  		if (signal_pending(current))
>  			return -ERESTARTSYS;
>  	}
> diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
> index 274bbae..20d20f68 100644
> --- a/include/crypto/chacha20.h
> +++ b/include/crypto/chacha20.h
> @@ -16,6 +16,7 @@ struct chacha20_ctx {
>  	u32 key[8];
>  };
> 
> +void chacha20_block(u32 *state, void *stream);
>  void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
>  int crypto_chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
>  			   unsigned int keysize);
> diff --git a/lib/Makefile b/lib/Makefile
> index 7bd6fd4..9ba27cd 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -22,7 +22,7 @@ KCOV_INSTRUMENT_hweight.o := n
>  lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
>  	 idr.o int_sqrt.o extable.o \
> -	 sha1.o md5.o irq_regs.o argv_split.o \
> +	 sha1.o chacha20.o md5.o irq_regs.o argv_split.o \
>  	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
>  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
>  	 earlycpio.o seq_buf.o nmi_backtrace.o
> diff --git a/lib/chacha20.c b/lib/chacha20.c
> new file mode 100644
> index 0000000..250ceed
> --- /dev/null
> +++ b/lib/chacha20.c
> @@ -0,0 +1,79 @@
> +/*
> + * ChaCha20 256-bit cipher algorithm, RFC7539
> + *
> + * Copyright (C) 2015 Martin Willi
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/export.h>
> +#include <linux/bitops.h>
> +#include <linux/cryptohash.h>
> +#include <asm/unaligned.h>
> +#include <crypto/chacha20.h>
> +
> +static inline u32 rotl32(u32 v, u8 n)
> +{
> +	return (v << n) | (v >> (sizeof(v) * 8 - n));
> +}
> +
> +extern void chacha20_block(u32 *state, void *stream)
> +{
> +	u32 x[16], *out = stream;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(x); i++)
> +		x[i] = state[i];
> +
> +	for (i = 0; i < 20; i += 2) {
> +		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],  16);
> +		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],  16);
> +		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],  16);
> +		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],  16);
> +
> +		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],  12);
> +		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],  12);
> +		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10], 12);
> +		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11], 12);
> +
> +		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],   8);
> +		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],   8);
> +		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],   8);
> +		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],   8);
> +
> +		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],   7);
> +		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],   7);
> +		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10],  7);
> +		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11],  7);
> +
> +		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],  16);
> +		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],  16);
> +		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],  16);
> +		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],  16);
> +
> +		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10], 12);
> +		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11], 12);
> +		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],  12);
> +		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],  12);
> +
> +		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],   8);
> +		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],   8);
> +		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],   8);
> +		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],   8);
> +
> +		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10],  7);
> +		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11],  7);
> +		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],   7);
> +		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],   7);
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(x); i++)
> +		out[i] = cpu_to_le32(x[i] + state[i]);
> +
> +	state[12]++;
> +}
> +EXPORT_SYMBOL(chacha20_block);


Ciao
Stephan
