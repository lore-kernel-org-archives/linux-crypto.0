Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE403A9629;
	Tue, 20 Jan 2026 21:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768946259; cv=none; b=S5CKklXFJw+JuOk8u6W6hIp8AErzDfKIgbsg/jhZCDQeI5J6MQIJ+VW72pioQekJAObZXF5WUSsQQZNc7v/ha1Jvvcj5hlRKCMcmmM+59zzrS7bM9V4DHztbSmMiJnqTAWFjgZO/zbi3A+MjPfNp/e3Oyn5Xvs8gSgcH0Tsp0eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768946259; c=relaxed/simple;
	bh=ooZdkUNotiQb6WGMCqaJRarcg0Mr49OiVT7aI8qmSTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXhxhH1NRnyxbx6wB7GTg543733/sg1gOjyPb9dBMHU4a50EY8CL15dfxT0Sbt8/Fy1bmL+1g6/1NTKwKUkqqNGDkgfWq+b5FxXYH+fOSDlmaGmUcqa7P0kefD/e/78YFfpYCvI2jefqtFukGbIlCBms9l1hsSZIpnLfvQphIok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id BD6E172C8CC;
	Wed, 21 Jan 2026 00:51:57 +0300 (MSK)
Received: from altlinux.org (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id A08DA36D00D2;
	Wed, 21 Jan 2026 00:51:57 +0300 (MSK)
Date: Wed, 21 Jan 2026 00:51:57 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@cloudflare.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Eric Biggers <ebiggers@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Stephan Mueller <smueller@chronox.de>, 
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 11/12] x509, pkcs7: Limit crypto combinations that
 may be used for module signing
Message-ID: <aW_4T-o1eqgKtYVo@altlinux.org>
References: <20260120145103.1176337-1-dhowells@redhat.com>
 <20260120145103.1176337-12-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20260120145103.1176337-12-dhowells@redhat.com>

David,

On Tue, Jan 20, 2026 at 02:50:57PM +0000, David Howells wrote:
> Limit the set of crypto combinations that may be used for module signing as
> no indication of hash algorithm used for signing is added to the hash of
> the data, so in theory a data blob hashed with a different algorithm can be
> substituted provided it has the same hash output.
> 
> This also rejects the use of less secure algorithms.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Lukas Wunner <lukas@wunner.de>
> cc: Ignat Korchagin <ignat@cloudflare.com>
> cc: Stephan Mueller <smueller@chronox.de>
> cc: Eric Biggers <ebiggers@kernel.org>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: keyrings@vger.kernel.org
> cc: linux-crypto@vger.kernel.org
> ---
>  crypto/asymmetric_keys/public_key.c | 55 +++++++++++++++++++++++++++--
>  1 file changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 13a5616becaa..90b98e1a952d 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -24,6 +24,52 @@ MODULE_DESCRIPTION("In-software asymmetric public-key subtype");
>  MODULE_AUTHOR("Red Hat, Inc.");
>  MODULE_LICENSE("GPL");
>  
> +struct public_key_restriction {
> +	const char	*pkey_algo;	/* Signing algorithm (e.g. "rsa") */
> +	const char	*pkey_enc;	/* Signature encoding (e.g. "pkcs1") */
> +	const char	*hash_algo;	/* Content hash algorithm (e.g. "sha256") */
> +};
> +
> +static const struct public_key_restriction public_key_restrictions[] = {
> +	/* algo			encoding	hash */
> +	{ "rsa",		"pkcs1",	"sha256" },
> +	{ "rsa",		"pkcs1",	"sha384" },
> +	{ "rsa",		"pkcs1",	"sha512" },
> +	{ "rsa",		"emsa-pss",	"sha512" },
> +	{ "ecdsa",		"x962",		"sha256" },
> +	{ "ecdsa",		"x962",		"sha384" },
> +	{ "ecdsa",		"x962",		"sha512" },
> +	{ "ecrdsa",		"raw",		"sha256" },
> +	{ "ecrdsa",		"raw",		"sha384" },
> +	{ "ecrdsa",		"raw",		"sha512" },

Why such hash choice? Aren't it should be streebog256 and streebog512?

Thanks,

> +	{ "mldsa44",		"raw",		"sha512" },
> +	{ "mldsa65",		"raw",		"sha512" },
> +	{ "mldsa87",		"raw",		"sha512" },
> +	/* ML-DSA may also do its own hashing over the entire message. */
> +	{ "mldsa44",		"raw",		"-" },
> +	{ "mldsa65",		"raw",		"-" },
> +	{ "mldsa87",		"raw",		"-" },
> +};
> +
> +/*
> + * Determine if a particular key/hash combination is allowed.
> + */
> +static int is_public_key_sig_allowed(const struct public_key_signature *sig)
> +{
> +	for (int i = 0; i < ARRAY_SIZE(public_key_restrictions); i++) {
> +		if (strcmp(public_key_restrictions[i].pkey_algo, sig->pkey_algo) != 0)
> +			continue;
> +		if (strcmp(public_key_restrictions[i].pkey_enc, sig->encoding) != 0)
> +			continue;
> +		if (strcmp(public_key_restrictions[i].hash_algo, sig->hash_algo) != 0)
> +			continue;
> +		return 0;
> +	}
> +	pr_warn_once("Public key signature combo (%s,%s,%s) rejected\n",
> +		     sig->pkey_algo, sig->encoding, sig->hash_algo);
> +	return -EKEYREJECTED;
> +}
> +
>  /*
>   * Provide a part of a description of the key for /proc/keys.
>   */
> @@ -391,12 +437,17 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	bool issig;
>  	int ret;
>  
> -	pr_devel("==>%s()\n", __func__);
> -
>  	BUG_ON(!pkey);
>  	BUG_ON(!sig);
>  	BUG_ON(!sig->s);
>  
> +	ret = is_public_key_sig_allowed(sig);
> +	if (ret < 0)
> +		return ret;
> +
> +	pr_devel("==>%s(%s,%s,%s)\n",
> +		 __func__, sig->pkey_algo, sig->encoding, sig->hash_algo);
> +
>  	/*
>  	 * If the signature specifies a public key algorithm, it *must* match
>  	 * the key's actual public key algorithm.
> 
