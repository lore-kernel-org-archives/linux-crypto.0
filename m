From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v1] compiler: prevent dead store elimination
Date: Sun, 28 Feb 2010 10:55:20 +0100
Message-ID: <20100228095520.GA29531@one.firstfloor.org>
References: <4B8984EE.8090605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Mikael Pettersson <mikpe@it.uu.se>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>, andi@firstfloor.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Herbert@gondor.apana.org.au
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B8984EE.8090605@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> Every byte in the [p,p+n[ range must be used. If you only use the
> first byte, via e.g. asm("" :: "m"(*(char*)p)), then the compiler
> _will_ skip scrubbing bytes beyond the first. This works with
> gcc-3.2.3 up to gcc-4.4.3.

You forgot to credit Mikael who did all the hard work figuring
this out?

>  /*
> + * Dead store elimination (DSE) is an optimization that may remove a write to
> + * a buffer that is not used anymore. Use ARRAY_PREVENT_DSE after a write when
> + * the scrub is required for security reasons.
> + */
> +#define ARRAY_PREVENT_DSE(p, n)				\

Maybe it's just me, but the name is ugly.

> +	do {						\
> +		struct __scrub { char c[n]; };		\


Better typeof(*p)[n]

> +++ b/include/linux/compiler-intel.h
> @@ -14,9 +14,11 @@
>   * It uses intrinsics to do the equivalent things.
>   */
>  #undef barrier
> +#undef ARRAY_PREVENT_DSE
>  #undef RELOC_HIDE
>  
>  #define barrier() __memory_barrier()
> +#define ARRAY_PREVENT_DSE(p, n)

Who says the Intel compiler doesn't need this?

I'm sure it does dead store elimination too and it understands
gcc asm syntax.

> +/**
> + * secure_bzero - Call memset to fill a region of memory with zeroes and
> + * ensure this memset is not removed due to dead store elimination.
> + * @p: Pointer to the start of the area.
> + * @n: The size of the area.
> + */
> +void secure_bzero(void *p, size_t n)
> +{
> +	memset(p, 0, n);
> +	ARRAY_PREVENT_DSE(p, n);

I think that's a candidate for a inline

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
