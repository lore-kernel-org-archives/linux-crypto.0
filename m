From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v6 2/3] crypto: rsa: add a new rsa generic
 implementation
Date: Tue, 16 Jun 2015 16:41:02 +0800
Message-ID: <20150616084101.GB23347@gondor.apana.org.au>
References: <20150616080153.447.83834.stgit@tstruk-mobl1>
 <20150616080205.447.58498.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150616080205.447.58498.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 16, 2015 at 01:02:05AM -0700, Tadeusz Struk wrote:
>
> +	if (!pkey->n || !pkey->e || !req->dst_len)
> +		return -EINVAL;

You leaked m.

> +	if (*req->dst_len < mpi_get_size(pkey->n)) {
> +		*req->dst_len = mpi_get_size(pkey->n);
> +		return -EINVAL;
> +	}

This needs to be an error that's distinct from real errors.  So
perhaps pick EOVERFLOW.

> +static int rsa_init_tfm(struct crypto_tfm *_tfm)
> +{
> +	return 0;
> +}

The init function is optional.  So just drop it if there is nothing
to be done.

> +	.encrypt = rsa_enc,
> +	.decrypt = rsa_dec,
> +	.sign = rsa_sign,
> +	.verify = rsa_verify,
> +	.setkey = rsa_setkey,
> +	.base = {
> +		.cra_name = "rsa",
> +		.cra_driver_name = "rsa-generic",
> +		.cra_priority = 100,
> +		.cra_ctxsize = 0,
> +		.cra_alignmask = 0,
> +		.cra_module = THIS_MODULE,
> +		.cra_ctxsize = sizeof(struct rsa_key),

You're initialising cra_ctxsize twice.  Also please drop the
alignmask since the default is zero.

> +		.cra_init = rsa_init_tfm,
> +		.cra_exit = rsa_exit_tfm,
> +	},
> +};

Please drop cra_init/cra_exit and add type-safe init/exit functions
like I did in 5eb8ec6dc857d5027bc8cf7268a199107a583ae5

> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
> new file mode 100644
> index 0000000..103dd2e
> --- /dev/null
> +++ b/crypto/rsa_helper.c
> @@ -0,0 +1,124 @@
> +/*
> + * RSA key extract helper
> + *
> + * Copyright (c) 2015, Intel Corporation
> + * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +#include <linux/fips.h>
> +#include <crypto/internal/rsa.h>
> +#include "rsakey-asn1.h"

Need export.h.

> +static void free_mpis(struct rsa_key *key)
> +{
> +	if (key->n)
> +		mpi_free(key->n);

mpi_free already checks for NULL, so you can remove the check
here.

> diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
> new file mode 100644
> index 0000000..018f373
> --- /dev/null
> +++ b/include/crypto/internal/rsa.h
> @@ -0,0 +1,28 @@
> +/*
> + * RSA internal helpers
> + *
> + * Copyright (c) 2015, Intel Corporation
> + * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +#ifndef _RSA_HELPER_
> +#define _RSA_HELPER_
> +#include <linux/mpi.h>
> +#include <crypto/akcipher.h>

You should drop akcipher.h since nothing in this file uses it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
