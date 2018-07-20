From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: make sure swap arguments are the same type? (was: Re: [PATCH]
 crypto: rmd320 - use swap macro in rmd320_transform)
Date: Fri, 20 Jul 2018 10:43:27 -0500
Message-ID: <ac6bf6b3-b739-a6b8-c9b0-8d496fb7a470@embeddedor.com>
References: <20180718171908.GA22962@embeddedor.com>
 <4dbef38e6020d6cb78e860a9f01fcd1de9f0fb52.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Joe Perches <joe@perches.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4dbef38e6020d6cb78e860a9f01fcd1de9f0fb52.camel@perches.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Joe,

I like the idea. I'll take a look at the cases you mention and see
if I can make them work with your version of swap.

BTW, I wonder if it would be more convenient to trigger a build warning
instead of an error.

What do you think?

Thanks
--
Gustavo

On 07/18/2018 01:31 PM, Joe Perches wrote:
> On Wed, 2018-07-18 at 12:19 -0500, Gustavo A. R. Silva wrote:
>> swap
> 
> Perhaps the swap macro should verify that the
> swap(a, b) arguments are the same type.
> 
> Something like the patch below, but this patch
> causes a compilation failure on at least a couple
> cases that aren't obviously correct in
> 
> net/netfilter/ipset/ip_set_bitmap_port.c
> 	where a u16 is swapped with a u32.
> 
> and
> 
> net/netfilter/ipset/ip_set_hash_netport.c
> 	where a single bit bitfield is swapped with a u8
> ---
>  include/linux/kernel.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d6aac75b51ba..506b59e0da24 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -969,14 +969,19 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>   */
>  #define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
>  
> -
>  /**
>   * swap - swap values of @a and @b
>   * @a: first value
>   * @b: second value
> + * @a and @b must be the same type
>   */
> -#define swap(a, b) \
> -	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
> +#define swap(a, b)							\
> +do {									\
> +	typeof(a) __tmp = (a);						\
> +	BUILD_BUG_ON(!__same_type(typeof(a), typeof(b)));		\
> +	(a) = (b);							\
> +	(b) = __tmp;							\
> +} while (0)
>  
>  /* This counts to 12. Any more, it will return 13th argument. */
>  #define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n
> 
