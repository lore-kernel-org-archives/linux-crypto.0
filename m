From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/5] random: make /dev/urandom scalable for silly userspace programs
Date: Mon, 30 May 2016 08:03:59 +0200
Message-ID: <5245285.5ppKq7E4P6@tauon.atsec.com>
References: <1464586765-14436-1-git-send-email-tytso@mit.edu> <1464586765-14436-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, cryptography@lakedaemon.net, jsd@av8n.com,
	hpa@zytor.com, linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464586765-14436-3-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 30. Mai 2016, 01:39:22 schrieb Theodore Ts'o:

Hi Theodore,

> On a system with a 4 socket (NUMA) system where a large number of
> application threads were all trying to read from /dev/urandom, this
> can result in the system spending 80% of its time contending on the
> global urandom spinlock.  The application should have used its own
> PRNG, but let's try to help it from running, lemming-like, straight
> over the locking cliff.
> 
> Reported-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  drivers/char/random.c | 57
> +++++++++++++++++++++++++++++++++++++++++++++++---- 1 file changed, 53
> insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 3a4d865..1778c84 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -434,6 +434,8 @@ struct crng_state primary_crng = {
>   */
>  static int crng_init = 0;
>  #define crng_ready() (likely(crng_init >= 2))
> +static void _extract_crng(struct crng_state *crng,
> +			  __u8 out[CHACHA20_BLOCK_SIZE]);
>  static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE]);
>  static void process_random_ready_list(void);
> 
> @@ -754,6 +756,17 @@ static void credit_entropy_bits_safe(struct
> entropy_store *r, int nbits)
> 
>  static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
> 
> +#ifdef CONFIG_NUMA
> +/*
> + * Hack to deal with crazy userspace progams when they are all trying
> + * to access /dev/urandom in parallel.  The programs are almost
> + * certainly doing something terribly wrong, but we'll work around
> + * their brain damage.
> + */
> +static struct crng_state **crng_node_pool __read_mostly;
> +#endif
> +
> +
>  static void _initialize_crng(struct crng_state *crng)
>  {
>  	int		i;
> @@ -774,11 +787,13 @@ static void _initialize_crng(struct crng_state *crng)
>  	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
>  }
> 
> +#ifdef CONFIG_NUMA
>  static void initialize_crng(struct crng_state *crng)
>  {
>  	_initialize_crng(crng);
>  	spin_lock_init(&crng->lock);
>  }
> +#endif
> 
>  static int crng_fast_load(__u32 pool[4])
>  {
> @@ -818,7 +833,7 @@ static void crng_reseed(struct crng_state *crng, struct
> entropy_store *r) if (num == 0)
>  			return;
>  	} else
> -		extract_crng(buf.block);
> +		_extract_crng(&primary_crng, buf.block);
>  	spin_lock_irqsave(&primary_crng.lock, flags);
>  	for (i = 0; i < 8; i++) {
>  		unsigned long	rv;
> @@ -838,19 +853,26 @@ static void crng_reseed(struct crng_state *crng,
> struct entropy_store *r) spin_unlock_irqrestore(&primary_crng.lock, flags);
>  }
> 
> +static inline void maybe_reseed_primary_crng(void)
> +{
> +	if (crng_init > 2 &&
> +	    time_after(jiffies, primary_crng.init_time + 
CRNG_RESEED_INTERVAL))
> +		crng_reseed(&primary_crng, &input_pool);
> +}
> +
>  static inline void crng_wait_ready(void)
>  {
>  	wait_event_interruptible(crng_init_wait, crng_ready());
>  }
> 
> -static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
> +static void _extract_crng(struct crng_state *crng,
> +			  __u8 out[CHACHA20_BLOCK_SIZE])
>  {
>  	unsigned long v, flags;
> -	struct crng_state *crng = &primary_crng;
> 
>  	if (crng_init > 2 &&
>  	    time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL))
> -		crng_reseed(crng, &input_pool);
> +		crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
>  	spin_lock_irqsave(&crng->lock, flags);
>  	if (arch_get_random_long(&v))
>  		crng->state[14] ^= v;
> @@ -860,6 +882,17 @@ static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
> spin_unlock_irqrestore(&crng->lock, flags);
>  }
> 
> +static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
> +{
> +#ifndef CONFIG_NUMA
> +	struct crng_state *crng = &primary_crng;
> +#else
> +	struct crng_state *crng = crng_node_pool[numa_node_id()];
> +#endif
> +
> +	_extract_crng(crng, out);
> +}
> +
>  static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
>  {
>  	ssize_t ret = 0, i;
> @@ -1573,6 +1606,22 @@ static void init_std_data(struct entropy_store *r)
>   */
>  static int rand_initialize(void)
>  {
> +#ifdef CONFIG_NUMA
> +	int i;
> +	int num_nodes = num_possible_nodes();
> +	struct crng_state *crng;
> +
> +	crng_node_pool = kmalloc(num_nodes * sizeof(void *),
> +				 GFP_KERNEL|__GFP_NOFAIL);
> +
> +	for (i=0; i < num_nodes; i++) {
> +		crng = kmalloc(sizeof(struct crng_state),
> +			       GFP_KERNEL | __GFP_NOFAIL);
> +		initialize_crng(crng);

Could you please help me understand the logic flow here: The NUMA secondary 
DRNGs are initialized before the input/blocking pools and the primary DRNG.

The initialization call uses get_random_bytes() for the secondary DRNGs. But 
since the primary DRNG is not yet initialized, where does the get_random_bytes 
gets its randomness from?

> +		crng_node_pool[i] = crng;
> +
> +	}
> +#endif
>  	init_std_data(&input_pool);
>  	init_std_data(&blocking_pool);
>  	_initialize_crng(&primary_crng);


Ciao
Stephan
