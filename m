From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Wed, 14 Jan 2009 14:16:13 +1100
Message-ID: <20090114031613.GA7429@gondor.apana.org.au>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46906 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752603AbZANDQR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2009 22:16:17 -0500
Content-Disposition: inline
In-Reply-To: <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Geert:

On Tue, Jan 13, 2009 at 04:59:40PM +0100, Geert Uytterhoeven wrote:
> The current "comp" crypto interface supports one-shot (de)compression only,
> i.e. the whole data buffer to be (de)compressed must be passed at once, and
> the whole (de)compressed data buffer will be received at once.
> In several use-cases (e.g. compressed file systems that store files in big
> compressed blocks), this workflow is not suitable.
> Furthermore, the "comp" type doesn't provide for the configuration of
> (de)compression parameters, and always allocates workspace memory for both
> compression and decompression, which may waste memory.

Thanks for the patch-set!

> diff --git a/crypto/pcompress.c b/crypto/pcompress.c
> new file mode 100644
> index 0000000..b9e3724
> --- /dev/null
> +++ b/crypto/pcompress.c
> @@ -0,0 +1,94 @@
> +/*
> + * Cryptographic API.
> + *
> + * Partial compression operations.
> + *
> + * Copyright 2008 Sony Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundation,
> + * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
> + */
> +
> +#define pr_fmt(fmt)	"%s: " fmt, __func__

This appears to be unused?

> +static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm,
> +				 const struct crypto_type *frontend)
> +{
> +	if (frontend->type != CRYPTO_ALG_TYPE_PCOMPRESS)
> +		return -EINVAL;

This is my fault.  The check is redundant so you can remove it.
I'll kill it in shash too.

> +struct pcomp_alg {
> +	int (*setup)(struct crypto_tfm *tfm, const void *params);

Actually I was thinking of separate alloc functions for compress
and decompress so that

1) We know what the user wants to do without every algorithm
reinventing their own signalling for it;

2) The parameters can be separated.

Also, this is something that we'll potentially export to user-space,
so we need to ensure that it is invariant to word length.

So something like this would be good

	int (*setup_comp)(struct crypto_pcomp *tfm, const void *params,
			  unsigned int length);
	int (*setup_decomp)(struct crypto_pcomp *tfm, const void *params,
			    unsigned int length);

The actual parameters should be formatted using the netlink helpers
(nla_*).  So each parameter that you want to set should show up as
a netlink attribute.  If a paramter is absent then you'd just use
the default, etc.

> +	int (*compress_init)(struct crypto_tfm *tfm);

That should be struct crypto_pcomp.

> +static inline struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_name,
> +						      u32 type, u32 mask)
> +{
> +	type &= ~CRYPTO_ALG_TYPE_MASK;
> +	type |= CRYPTO_ALG_TYPE_PCOMPRESS;
> +	mask |= CRYPTO_ALG_TYPE_MASK;
> +
> +	return __crypto_pcomp_cast(crypto_alloc_base(alg_name, type, mask));
> +}

That's the old way to allocate tfm's which won't work since pcomp
is using the new type API.  You should do it the way that shash
does it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
