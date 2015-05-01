From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RFC 2/2] crypto: RSA: KEYS: convert rsa and public key to new PKE API
Date: Fri, 01 May 2015 17:21:43 +0100
Message-ID: <4394.1430497303@warthog.procyon.org.uk>
References: <20150430223658.10157.32631.stgit@tstruk-mobl1> <20150430223647.10157.82156.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, corbet@lwn.net,
	keescook@chromium.org, qat-linux@intel.com, jwboyer@redhat.com,
	richard@nod.at, d.kasatkin@samsung.com,
	linux-kernel@vger.kernel.org, steved@redhat.com, vgoyal@redhat.com,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, jdelvare@suse.de,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbbEAQWL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 12:22:11 -0400
In-Reply-To: <20150430223658.10157.32631.stgit@tstruk-mobl1>
Content-ID: <4393.1430497303.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> +Additionally public key algorithm names are defined:
> +#define PKEY_ALGO_DSA "dsa"
> +#define PKEY_ALGO_RSA "rsa"
> +These will be used to allocate public key tfm instances.

These should be a blank line either side of the two #defines and the #defines
should be indented a tab.

> -	BUG_ON(ctx->sinfo->sig.pkey_algo != PKEY_ALGO_RSA);
> +	BUG_ON(strcmp(ctx->sinfo->sig.pkey_algo, PKEY_ALGO_RSA));

If you make PKEY_ALGO_RSA a const char [] can you use != here?

Oh, and can you do either != 0 or == 0 on the end of your strcmp()?  It's a
bit more obvious since strcmp()'s return is sort of inverse.

> +			.verify = RSA_verify_signature,
> +			.capabilities = PKEY_CAN_VERIFY,

Can we keep .verify_signature as the name of the first.  The second is
redundant given the function pointers.

> +		if (cert->pub && !IS_ERR(cert->pub->tfm))
> +			crypto_free_pke(cert->pub->tfm);
> ...
> +
> +	cert->pub->tfm = crypto_alloc_pke(ctx->cert->sig.pkey_algo, 0, 0);
> +	if (IS_ERR(cert->pub->tfm)) {
> +		pr_err("Failed to alloc pkey algo %s\n",
> +		       ctx->cert->sig.pkey_algo);
> +		goto error_decode;
> +	}
> +

Given that X.509 certs can hang around for a very long time, having a tfm in
the cert is probably a bad idea as it may pin resources such as crypto h/w.

> -	ctx->cert->pub->pkey_algo = PKEY_ALGO_RSA;
> -

I think you need this rather than the above.  You should only get the tfm when
you actually need it.

> -	pr_devel("Cert Key Algo: %s\n", pkey_algo_name[cert->pub->pkey_algo]);
> +	pr_devel("Cert Key Algo: %s\n", pke_alg_name(cert->pub->tfm));

pkey_algo_name() perhaps?

> +	pr_devel("Cert Signature: %s + %s\n", cert->sig.pkey_algo,

Split line at that comma please.  That way all the arguments line up.

> -	cert->pub->algo = pkey_algo[cert->pub->pkey_algo];

Might still need this.

> -enum pkey_algo {
> -	PKEY_ALGO_DSA,
> -	PKEY_ALGO_RSA,
> -	PKEY_ALGO__LAST
> -};

This represents a value seen external to the kernel - at least for the
moment.  Switching to PKCS#7 module sigs would cure that.

> +#define PKEY_ALGO_DSA "dsa"
> +#define PKEY_ALGO_RSA "rsa"

const char []

> +int public_key_verify_signature(const struct public_key *pk,
> +				const struct public_key_signature *sig);

Retain the extern please and the following blank line.

> +static const char *const pkey_algo_name[] = {
> +	PKEY_ALGO_DSA, PKEY_ALGO_RSA
> +};
> +

Split the list over multiple lines, please.  Better still, move to PKCS#7.

David
