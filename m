From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] crypto: gf128mul - define gf128mul_x_ble in gf128mul.h
Date: Thu, 30 Mar 2017 12:55:46 -0700
Message-ID: <20170330195546.GA60896@gmail.com>
References: <20170330192535.23123-1-omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34584 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934152AbdC3Tzu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Mar 2017 15:55:50 -0400
Received: by mail-pg0-f66.google.com with SMTP id o123so12117168pga.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Mar 2017 12:55:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170330192535.23123-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ondrej,

On Thu, Mar 30, 2017 at 09:25:35PM +0200, Ondrej Mosnacek wrote:
> The gf128mul_x_ble function is currently defined in gf128mul.c, because
> it depends on the gf128mul_table_be multiplication table.
> 
> However, since the function is very small and only uses two values from
> the table, it is better for it to be defined as inline function in
> gf128mul.h. That way, the function can be inlined by the compiler for
> better performance.
> 
> After this change, the speed of the generic 'xts(aes)' implementation
> increased from ~225 MiB/s to ~235 MiB/s (measured using 'cryptsetup
> benchmark' on an Intel system with CRYPTO_AES_X86_64 and
> CRYPTO_AES_NI_INTEL disabled).
> 
> Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
...
>  
> -/* multiply by x in ble format, needed by XTS */
> -void gf128mul_x_ble(be128 *a, const be128 *b);
> +/* Multiply by x in ble format, needed by XTS.
> + * Defined here for performance. */
> +static inline void gf128mul_x_ble(be128 *r, const be128 *x)
> +{
> +	u64 a = le64_to_cpu(x->a);
> +	u64 b = le64_to_cpu(x->b);
> +	/* equivalent to gf128mul_table_be[b >> 63] (see crypto/gf128mul.c): */
> +	u64 _tt = (b & ((u64)1 << 63)) ? 0x87 : 0x00;
> +
> +	r->a = cpu_to_le64((a << 1) ^ _tt);
> +	r->b = cpu_to_le64((b << 1) | (a >> 63));
> +}
>  
>  /* 4k table optimization */
>  
> -- 
> 2.9.3
> 

This is an improvement; I'm just thinking that maybe this should be done for all
the gf128mul_x_*() functions, if only so that they use a consistent style and
are all defined next to each other.

Also note that '(b & ((u64)1 << 63)) ? 0x87 : 0x00;' is actually getting
compiled as '((s64)b >> 63) & 0x87', which is branchless and therefore makes the
new version more efficient than one might expect:

	sar    $0x3f,%rax
	and    $0x87,%eax

It could even be written the branchless way explicitly, but it shouldn't matter.

- Eric
