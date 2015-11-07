From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 3/7] Initialise pools randomly if CONFIG_RANDOM_INIT=y
Date: Sat, 7 Nov 2015 16:54:52 +0000
Message-ID: <20151107165452.GA29227@io.lakedaemon.net>
References: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
 <1446906642-19372-3-git-send-email-sandyinchina@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts\\'o" <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:45334 "EHLO
	outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711AbbKGQyz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Nov 2015 11:54:55 -0500
Content-Disposition: inline
In-Reply-To: <1446906642-19372-3-git-send-email-sandyinchina@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 07, 2015 at 09:30:38AM -0500, Sandy Harris wrote:
> Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
> ---
>  drivers/char/random.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 46 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index d0da5d8..e222e0f 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -231,7 +231,7 @@
>   * not be attributed to the Phil, Colin, or any of authors of PGP.
>   *
>   * Further background information on this topic may be obtained from
> - * RFC 1750, "Randomness Recommendations for Security", by Donald
> + * RFC 4086, "Randomness Requirements for Security", by Donald

I'm pretty sure you already sent this hunk separately.  Please remove it
from the next version.

thx,

Jason.

>   * Eastlake, Steve Crocker, and Jeff Schiller.
>   */
>  
> @@ -275,13 +275,19 @@
>  /*
>   * Configuration information
>   */
> +#ifdef CONFIG_RANDOM_INIT
> +
> +#include <generated/random_init.h>
> +
> +#else
>  #define INPUT_POOL_SHIFT	12
>  #define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
>  #define OUTPUT_POOL_SHIFT	10
>  #define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
> -#define SEC_XFER_SIZE		512
> -#define EXTRACT_SIZE		10
> +#endif
>  
> +#define EXTRACT_SIZE		10
> +#define SEC_XFER_SIZE		512
>  #define DEBUG_RANDOM_BOOT 0
>  
>  #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
> @@ -296,6 +302,27 @@
>  #define ENTROPY_SHIFT 3
>  #define ENTROPY_BITS(r) ((r)->entropy_count >> ENTROPY_SHIFT)
>  
> +/* sanity checks */
> +
> +#if ((ENTROPY_SHIFT+INPUT_POOL_SHIFT) >= 16)
> +#ifndef CONFIG_64BIT
> +#error *_SHIFT values problematic for credit_entropy_bits()
> +#endif
> +#endif
> +
> +#if ((INPUT_POOL_WORDS%16) || (OUTPUT_POOL_WORDS%16))
> +#error Pool size not divisible by 16, which code assumes
> +#endif
> +
> +#if (INPUT_POOL_WORDS < 32)
> +#error Input pool less than a quarter of default size
> +#endif
> +
> +#if (INPUT_POOL_WORDS < OUTPUT_POOL_WORDS)
> +#error Strange configuration, input pool smalller than output
> +#endif
> +
> +
>  /*
>   * The minimum number of bits of entropy before we wake up a read on
>   * /dev/random.  Should be enough to do a significant reseed.
> @@ -442,16 +469,23 @@ struct entropy_store {
>  };
>  
>  static void push_to_pool(struct work_struct *work);
> +
> +#ifndef CONFIG_RANDOM_INIT
>  static __u32 input_pool_data[INPUT_POOL_WORDS];
>  static __u32 blocking_pool_data[OUTPUT_POOL_WORDS];
>  static __u32 nonblocking_pool_data[OUTPUT_POOL_WORDS];
> +#endif
>  
>  static struct entropy_store input_pool = {
>  	.poolinfo = &poolinfo_table[0],
>  	.name = "input",
>  	.limit = 1,
>  	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
> -	.pool = input_pool_data
> +#ifdef CONFIG_RANDOM_INIT
> +	.pool = pools,
> +#else
> +	.pool = input_pool_data,
> +#endif
>  };
>  
>  static struct entropy_store blocking_pool = {
> @@ -460,7 +494,11 @@ static struct entropy_store blocking_pool = {
>  	.limit = 1,
>  	.pull = &input_pool,
>  	.lock = __SPIN_LOCK_UNLOCKED(blocking_pool.lock),
> +#ifdef CONFIG_RANDOM_INIT
> +	.pool = pools + INPUT_POOL_WORDS,
> +#else
>  	.pool = blocking_pool_data,
> +#endif
>  	.push_work = __WORK_INITIALIZER(blocking_pool.push_work,
>  					push_to_pool),
>  };
> @@ -470,7 +508,11 @@ static struct entropy_store nonblocking_pool = {
>  	.name = "nonblocking",
>  	.pull = &input_pool,
>  	.lock = __SPIN_LOCK_UNLOCKED(nonblocking_pool.lock),
> +#ifdef CONFIG_RANDOM_INIT
> +	.pool = pools + INPUT_POOL_WORDS + OUTPUT_POOL_WORDS,
> +#else
>  	.pool = nonblocking_pool_data,
> +#endif
>  	.push_work = __WORK_INITIALIZER(nonblocking_pool.push_work,
>  					push_to_pool),
>  };
> -- 
> 2.5.0
> 
