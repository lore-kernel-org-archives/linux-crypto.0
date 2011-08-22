From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 02/15] crypto: Add userspace configuration API
Date: Mon, 22 Aug 2011 14:59:01 +0800
Message-ID: <20110822065901.GA29599@gondor.apana.org.au>
References: <20110817120859.GX16877@secunet.com> <20110817121013.GZ16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48909 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1HVG7G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Aug 2011 02:59:06 -0400
Content-Disposition: inline
In-Reply-To: <20110817121013.GZ16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 17, 2011 at 02:10:13PM +0200, Steffen Klassert wrote:
>
> +struct crypto_user_alg {
> +	char cru_name[CRYPTO_MAX_ALG_NAME];
> +	char cru_driver_name[CRYPTO_MAX_ALG_NAME];
> +	__u32 type;
> +	__u32 mask;
> +};
> +
> +#define CRYPTO_MAX_NAME CRYPTO_MAX_ALG_NAME
> +
> +struct crypto_report_base {
> +	char name[CRYPTO_MAX_ALG_NAME];
> +	char driver_name[CRYPTO_MAX_ALG_NAME];
> +	char module_name[CRYPTO_MAX_NAME];
> +	char selftest[CRYPTO_MAX_NAME];
> +	int priority;
> +	int refcnt;
> +};

We should use one structure for both creating algorithms and
querying them.  User-space can leave the query fields blank
when creating them.

On another note, all fields specified when creating an algorithm
should be returned when querying/reporting.  This is so that
we can recreate the exact configuration after dumping.

Also, instead of returning selftest as a string, a single bit
would suffice.  So I'd suggest turning it into flags of type
__u32.

In fact, let's turn the other two int fields into __u32 too.

Sorry for not pointing this out earlier.  But we need to get this
right the first time as we'll be stuck with the interface for
ever.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
