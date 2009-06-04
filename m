From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] crypto: add optional continuous repetition test to
 entropy store based rngs
Date: Thu, 04 Jun 2009 15:14:10 -0500
Message-ID: <1244146450.22069.216.camel@calx>
References: <20090604195030.GA11300@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([66.93.16.53]:36105 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbZFDUOd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2009 16:14:33 -0400
In-Reply-To: <20090604195030.GA11300@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2009-06-04 at 15:50 -0400, Neil Horman wrote:
> FIPS-140 requires that all random number generators implement continuous self
> tests in which each extracted block of data is compared against the last block
> for repetition.  The ansi_cprng implements such a test, but it would be nice if
> the hw rng's did the same thing.  Obviously its not something thats always
> needed, but it seems like it would be a nice feature to have on occasion.  I've
> written the below patch which allows individual entropy stores to be flagged as
> desiring a continuous test to be run on them as is extracted.  By default this
> option is off, but is enabled in the event that fips mode is selected during
> bootup.
> 
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> diff --git a/crypto/internal.h b/crypto/internal.h
> index fc76e1f..150d389 100644
> --- a/crypto/internal.h
> +++ b/crypto/internal.h
> @@ -26,12 +26,6 @@
>  #include <linux/rwsem.h>
>  #include <linux/slab.h>
>  
> -#ifdef CONFIG_CRYPTO_FIPS
> -extern int fips_enabled;
> -#else
> -#define fips_enabled 0
> -#endif
> -
>  /* Crypto notification events. */
>  enum {
>  	CRYPTO_MSG_ALG_REQUEST,
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 8c74448..fbdfc70 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -250,6 +250,8 @@
>  #include <asm/irq.h>
>  #include <asm/io.h>
>  
> +#include <crypto/algapi.h>
> +

I think we'd rather not make random.c incestuous with crypto/.

>  /*
>   * Configuration information
>   */
> @@ -400,6 +402,7 @@ module_param(debug, bool, 0644);
>   **********************************************************************/
>  
>  struct entropy_store;
> +#define ENT_F_CONT_TEST 1
>  struct entropy_store {
>  	/* read-only data: */
>  	struct poolinfo *poolinfo;
> @@ -413,6 +416,8 @@ struct entropy_store {
>  	unsigned add_ptr;
>  	int entropy_count;
>  	int input_rotate;
> +	int flags;
> +	__u8 *last_data;
>  };
>  
>  static __u32 input_pool_data[INPUT_POOL_WORDS];
> @@ -424,7 +429,9 @@ static struct entropy_store input_pool = {
>  	.name = "input",
>  	.limit = 1,
>  	.lock = __SPIN_LOCK_UNLOCKED(&input_pool.lock),
> -	.pool = input_pool_data
> +	.pool = input_pool_data,
> +	.flags = 0,
> +	.last_data = NULL
>  };

No need to null-initialize these things.

>  static struct entropy_store blocking_pool = {
> @@ -433,7 +440,9 @@ static struct entropy_store blocking_pool = {
>  	.limit = 1,
>  	.pull = &input_pool,
>  	.lock = __SPIN_LOCK_UNLOCKED(&blocking_pool.lock),
> -	.pool = blocking_pool_data
> +	.pool = blocking_pool_data,
> +	.flags = 0,
> +	.last_data = NULL
>  };
>  
>  static struct entropy_store nonblocking_pool = {
> @@ -441,7 +450,9 @@ static struct entropy_store nonblocking_pool = {
>  	.name = "nonblocking",
>  	.pull = &input_pool,
>  	.lock = __SPIN_LOCK_UNLOCKED(&nonblocking_pool.lock),
> -	.pool = nonblocking_pool_data
> +	.pool = nonblocking_pool_data,
> +	.flags = 0,
> +	.last_data = NULL
>  };
>  
>  /*
> @@ -852,12 +863,21 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
>  {
>  	ssize_t ret = 0, i;
>  	__u8 tmp[EXTRACT_SIZE];
> +	unsigned long flags;
>  
>  	xfer_secondary_pool(r, nbytes);
>  	nbytes = account(r, nbytes, min, reserved);
>  
>  	while (nbytes) {
>  		extract_buf(r, tmp);
> +
> +		if (r->flags & ENT_F_CONT_TEST) {
> +			spin_lock_irqsave(&r->lock, flags);
> +			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
> +				panic("Hardware RNG duplicated output!\n");
> +			memcpy(r->last_data, tmp, EXTRACT_SIZE);
> +			spin_unlock_irqrestore(&r->lock, flags);
> +		}

This should go in extract_buf. I think we can avoid adding flags to the
pool struct by simply checking that last_data is not null.

>  		i = min_t(int, nbytes, EXTRACT_SIZE);
>  		memcpy(buf, tmp, i);
>  		nbytes -= i;
> @@ -940,6 +960,14 @@ static void init_std_data(struct entropy_store *r)
>  	now = ktime_get_real();
>  	mix_pool_bytes(r, &now, sizeof(now));
>  	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
> +	/* Enable continuous test in fips mode */
> +	if (fips_enabled) {
> +		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
> +		if (r->last_data)
> +			r->flags |= ENT_F_CONT_TEST;
> +		else
> +			panic("Could not alloc data for rng test\n");
> +	} 
>  }
>  
>  static int rand_initialize(void)
> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
> index 0105454..88e9535 100644
> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -20,6 +20,12 @@ struct module;
>  struct rtattr;
>  struct seq_file;
>  
> +#ifdef CONFIG_CRYPTO_FIPS
> +extern int fips_enabled;
> +#else
> +#define fips_enabled 0
> +#endif
> +
>  struct crypto_type {
>  	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
>  	unsigned int (*extsize)(struct crypto_alg *alg,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
http://selenic.com : development and support for Mercurial and Linux


