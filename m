From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH RFC v5 3/4] crypto: rsa: add a new rsa generic implementation
Date: Tue, 16 Jun 2015 01:23:14 +0200
Message-ID: <3921303.7tkMvJ6vYE@tachyon.chronox.de>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201847.15697.55852.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47737 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbbFOXYM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 19:24:12 -0400
In-Reply-To: <20150615201847.15697.55852.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Juni 2015, 13:18:47 schrieb Tadeusz Struk:

Hi Tadeusz,

> Add a new rsa generic SW implementation.
> This implements only cryptographic primitives.

Thank you, that seems to address the issues around the FIPS side including the 
self test code.

Though, I have one question:

> +
> +int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
> +	      const void *value, size_t vlen)
> +{
> +	struct crypto_akcipher *tfm = context;
> +	struct rsa_key *key = tfm->key;
> +
> +	key->n = mpi_read_raw_data(value, vlen);
> +
> +	if (!key->n)
> +		return -ENOMEM;
> +
> +	/* In FIPS mode only allow key size minimum 2K */
> +	if (fips_enabled && (mpi_get_size(key->n) < 256)) {

Considering my previous email, shouldn't that check rather be

if (fips_enabled &&
    ((mpi_get_size(key->n) != 256) || (mpi_get_size(key->n) != 384))

?

> +		pr_err("RSA: key size not allowed in FIPS mode\n");
> +		mpi_free(key->n);
> +		key->n = NULL;
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +int rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
> +	      const void *value, size_t vlen)
> +{
> +	struct crypto_akcipher *tfm = context;
> +	struct rsa_key *key = tfm->key;
> +
> +	key->e = mpi_read_raw_data(value, vlen);
> +
> +	if (!key->e)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +int rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
> +	      const void *value, size_t vlen)
> +{
> +	struct crypto_akcipher *tfm = context;
> +	struct rsa_key *key = tfm->key;
> +
> +	key->d = mpi_read_raw_data(value, vlen);
> +
> +	if (!key->d)
> +		return -ENOMEM;
> +
> +	/* In FIPS mode only allow key size minimum 2K */
> +	if (fips_enabled && (mpi_get_size(key->d) < 256)) {

dto.

> +		pr_err("RSA: key size not allowed in FIPS mode\n");
> +		mpi_free(key->d);
> +		key->d = NULL;
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +

Thanks
-- 
Ciao
Stephan
