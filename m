Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23C164A
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 17:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781148; cv=none; b=pdq22RcBUu4Epi6YqrulldLjOa79jFJFZaonvdJx/2JpWJmy1u2luTLkECIoHJvI44e49rT82Pz26IrtbgwvUMuu0fhjyhBI1FkkQvmOg1S09Uzw2SU5B1wrfD7XDhIlatsLuBx7byXbonTt2NTv8obimwQ5jHbWhVLMO24BZ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781148; c=relaxed/simple;
	bh=Rj0Vj6+WrjswkpwTWsrIf2NYmNdnC0dOj0MUaatbcVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jAQRx+Sc5ogoUpEZ2Rl7IemXyqZ/rDrH0RW7+RwiQZ4M0hW8fVyZf3R2rufjL2KwAK8RA77iUdZhxUNoBXOvwgVdQ+h+icAsk8kBOFfl8Iu7+QAcpqySjWl/7Rt9BfHDU1dzkJxUkTTcFcHtqPa+nCO6ybutD7DVLP4eeCWsz34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ujmZjYXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ujmZjYXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD33C4FF6C;
	Tue, 27 Aug 2024 17:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724781147;
	bh=Rj0Vj6+WrjswkpwTWsrIf2NYmNdnC0dOj0MUaatbcVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ujmZjYXKvs9y9f+J5pweaqudl4ROmOMBNwy9/Dzfc4GbNU/wB7iAJP1OComRfoacJ
	 vIAdTPtQ7o38oXWAfULp9p/fBve0OlB2E2cTSMC1Gn2nHzN4NW0npldepHm1qM0SGP
	 V5tiGgs5Yk3fFkMzRXk12uA1YMLTY9HK2JYBunHe/q/T7XrYvFPxURhgnH/bIEB9y4
	 5G1lqKS1ED3ve/jpIqbBSfVvJyW6cqdD/mVvFh5PoXidz9LjOkkE5PvilqqnaFnap9
	 IZl8X4/ZQ+W94YWPDKlYfXWqBB80iCIo7RM2pLvFDjoBUmGSRUXhzkwKJQoKiI4jyO
	 GyF/v0cZcemLA==
Date: Tue, 27 Aug 2024 10:52:25 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/9] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
Message-ID: <20240827175225.GA2049@sol.localdomain>
References: <20240813111512.135634-1-hare@kernel.org>
 <20240813111512.135634-2-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813111512.135634-2-hare@kernel.org>

On Tue, Aug 13, 2024 at 01:15:04PM +0200, Hannes Reinecke wrote:
> Separate out the HKDF functions into a separate module to
> to make them available to other callers.
> And add a testsuite to the module with test vectors
> from RFC 5869 to ensure the integrity of the algorithm.

integrity => correctness

> diff --git a/crypto/hkdf.c b/crypto/hkdf.c
> new file mode 100644
> index 000000000000..67d55fc3e180
> --- /dev/null
> +++ b/crypto/hkdf.c
[...]
> +/**
> + * hkdf_extract - HKDF-Extract (RFC 5869 section 2.2)
> + * @hmac_tfm: hash context

Should document hmac_tfm properly.  Maybe something like:

@hmac_tfm: an HMAC transform using the hash function desired for HKDF.  The
           caller is responsible for setting the @prk afterwards.

> + * @ikm: input keying material
> + * @ikmlen: length of @ikm
> + * @salt: input salt value
> + * @saltlen: length of @salt
> + * @prk: resulting pseudorandom key
> + *
> + * Extracts a pseudorandom key @prk from the input keying material
> + * @ikm with length @ikmlen and salt @salt with length @saltlen.
> + * The length of @prk is given by the digest size of @hmac_tfm.
> + * For an 'unsalted' version of HKDF-Extract @salt should be set
> + * to all zeroes and @saltlen should be set to the length of @prk.

should => must (both times above)

> + * otherwise a negative error.

negative errno value (not just any negative error)

> +/*
> + * hkdf_expand - HKDF-Expand (RFC 5869 section 2.3)

Needs to be /** to make it a kerneldoc comment

> + * @hmac_tfm: hash context keyed with pseudorandom key
> + * @info: application-specific information
> + * @infolen: length of @info
> + * @okm: output keying material

Missing documentation for @okmlen parameter

> + *
> + * This expands the pseudorandom key, which was already keyed into @hmac_tfm,
> + * into @okmlen bytes of output keying material parameterized by the
> + * application-specific @info of length @infolen bytes.
> + * This is thread-safe and may be called by multiple threads in parallel.
> + *
> + * Returns 0 on success with output keying material stored in @okm,
> + * negative error number otherwise.
> + */
> +int hkdf_expand(struct crypto_shash *hmac_tfm,
> +		const u8 *info, unsigned int infolen,
> +		u8 *okm, unsigned int okmlen)
> +{
> +	SHASH_DESC_ON_STACK(desc, hmac_tfm);
> +	unsigned int i, hashlen = crypto_shash_digestsize(hmac_tfm);
> +	int err;
> +	const u8 *prev = NULL;
> +	u8 counter = 1;
> +	u8 *tmp;
> +
> +	if (WARN_ON(okmlen > 255 * hashlen))
> +		return -EINVAL;
> +
> +	tmp = kzalloc(hashlen, GFP_KERNEL);
> +	if (!tmp)
> +		return -ENOMEM;

tmp can be allocated on the stack since it has maximum length
HASH_MAX_DIGESTSIZE.

Also, either way, it needs to be zeroized at the end of the function.

> +	desc->tfm = hmac_tfm;
> +
> +	for (i = 0; i < okmlen; i += hashlen) {
> +
> +		err = crypto_shash_init(desc);
> +		if (err)
> +			goto out;
> +
> +		if (prev) {
> +			err = crypto_shash_update(desc, prev, hashlen);
> +			if (err)
> +				goto out;
> +		}
> +
> +		if (info && infolen) {

'if (infolen)' instead of 'if (info && infolen)'.  The latter is a bad practice
because it can hide bugs.

> +struct hkdf_testvec {
> +	const char *test;
> +	const unsigned char *ikm;
> +	const unsigned char *salt;
> +	const unsigned char *info;
> +	const unsigned char *prk;
> +	const unsigned char *okm;
> +	unsigned short ikm_size;
> +	unsigned short salt_size;
> +	unsigned short info_size;
> +	unsigned short prk_size;
> +	unsigned short okm_size;
> +};

u8 and u16 instead of unsigned char and unsigned short, please.

> +static int hkdf_test(const char *shash, const struct hkdf_testvec *tv)
> +{	struct crypto_shash *tfm = NULL;
> +	u8 *prk = NULL, *okm = NULL;
> +	unsigned int prk_size;
> +	const char *driver;
> +	int err;
> +
> +	tfm = crypto_alloc_shash(shash, 0, 0);
> +	if (IS_ERR(tfm)) {
> +		pr_err("%s(%s): failed to allocate transform: %ld\n",
> +		       tv->test, shash, PTR_ERR(tfm));
> +		return PTR_ERR(tfm);
> +	}
> +	driver = crypto_shash_driver_name(tfm);
> +
> +	prk_size = crypto_shash_digestsize(tfm);
> +	prk = kzalloc(prk_size, GFP_KERNEL);
> +	if (!prk) {
> +		err = -ENOMEM;
> +		goto out_free_shash;
> +	}
> +
> +	if (tv->prk_size != prk_size) {
> +		pr_err("%s(%s): prk size mismatch (vec %u, digest %u\n",
> +		       tv->test, driver, tv->prk_size, prk_size);
> +		err = -EINVAL;
> +		goto out_free_prk;
> +	}

Since freeing NULL is a no-op, this function only really needs one label.

> +	err = crypto_shash_setkey(tfm, tv->prk, tv->prk_size);
> +	if (err) {
> +		pr_err("%s(%s): failed to hash key to PRK, error %d\n",
> +		       tv->test, driver, err);

Not sure what "failed to hash key to PRK" means here.  It failed to set the PRK,
so a better error message might be "failed to set PRK".

> +static int __init crypto_hkdf_module_init(void)
> +{
> +	int ret = 0, i;
> +
> +	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
> +		return 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(hkdf_sha256_tv); i++) {
> +		ret = hkdf_test("hmac(sha256)", &hkdf_sha256_tv[i]);
> +		if (ret)
> +			return ret;
> +	}
> +	for (i = 0; i < ARRAY_SIZE(hkdf_sha1_tv); i++) {
> +		ret = hkdf_test("hmac(sha1)", &hkdf_sha1_tv[i]);
> +		if (ret)
> +			return ret;
> +	}

It's surprising that there are tests for sha1 which is obsolete, but none for
sha512 which is what is actually being used.

In any case, nothing guarantees that sha256 and sha1 are available here, as they
aren't selected by CRYPTO_HKDF.  They would need to be selected, at least if
CRYPTO_MANAGER_DISABLE_TESTS=n, or else the tests would need to be skipped if
the underlying hash algorithm is not available in the crypto API.

> +MODULE_DESCRIPTION("Hashed-Key derivation functions");

This may be a misunderstanding about what HKDF stands for.

How about: MODULE_DESCRIPTION("HMAC-based Key Derivation Function (HKDF)");


> diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
> index 5a384dad2c72..4f1d331bee9f 100644
> --- a/fs/crypto/hkdf.c
> +++ b/fs/crypto/hkdf.c
[...]
> @@ -79,12 +63,8 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
>  		return PTR_ERR(hmac_tfm);
>  	}
>  
> -	if (WARN_ON_ONCE(crypto_shash_digestsize(hmac_tfm) != sizeof(prk))) {
> -		err = -EINVAL;
> -		goto err_free_tfm;
> -	}

Why is this WARN_ON_ONCE being removed?  It doesn't seem to be replaced by
anything.

> -
> -	err = hkdf_extract(hmac_tfm, master_key, master_key_size, prk);
> +	err = hkdf_extract(hmac_tfm, master_key, master_key_size,
> +			   default_salt, HKDF_HASHLEN, prk);
>  	if (err)
>  		goto err_free_tfm;
>  
> @@ -118,61 +98,24 @@ int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
>  			u8 *okm, unsigned int okmlen)
>  {
>  	SHASH_DESC_ON_STACK(desc, hkdf->hmac_tfm);
> -	u8 prefix[9];
> -	unsigned int i;
> +	u8 *full_info;
>  	int err;
> -	const u8 *prev = NULL;
> -	u8 counter = 1;
> -	u8 tmp[HKDF_HASHLEN];
>  
>  	if (WARN_ON_ONCE(okmlen > 255 * HKDF_HASHLEN))
>  		return -EINVAL;

... but this WARN_ON_ONCE is no longer needed since hkdf_expand() does it.

>  
> +	full_info = kzalloc(infolen + 9, GFP_KERNEL);
> +	if (!full_info)
> +		return -ENOMEM;
>  	desc->tfm = hkdf->hmac_tfm;
>  
> -	memcpy(prefix, "fscrypt\0", 8);
> -	prefix[8] = context;
> -
> -	for (i = 0; i < okmlen; i += HKDF_HASHLEN) {
> -
> -		err = crypto_shash_init(desc);
> -		if (err)
> -			goto out;
> -
> -		if (prev) {
> -			err = crypto_shash_update(desc, prev, HKDF_HASHLEN);
> -			if (err)
> -				goto out;
> -		}
> -
> -		err = crypto_shash_update(desc, prefix, sizeof(prefix));
> -		if (err)
> -			goto out;
> -
> -		err = crypto_shash_update(desc, info, infolen);
> -		if (err)
> -			goto out;
> -
> -		BUILD_BUG_ON(sizeof(counter) != 1);
> -		if (okmlen - i < HKDF_HASHLEN) {
> -			err = crypto_shash_finup(desc, &counter, 1, tmp);
> -			if (err)
> -				goto out;
> -			memcpy(&okm[i], tmp, okmlen - i);
> -			memzero_explicit(tmp, sizeof(tmp));
> -		} else {
> -			err = crypto_shash_finup(desc, &counter, 1, &okm[i]);
> -			if (err)
> -				goto out;
> -		}
> -		counter++;
> -		prev = &okm[i];
> -	}
> -	err = 0;
> -out:
> -	if (unlikely(err))
> -		memzero_explicit(okm, okmlen); /* so caller doesn't need to */
> -	shash_desc_zero(desc);
> +	memcpy(full_info, "fscrypt\0", 8);
> +	full_info[8] = context;
> +	memcpy(full_info + 9, info, infolen);
> +
> +	err = hkdf_expand(hkdf->hmac_tfm, full_info, infolen + 8,
> +			  okm, okmlen);
> +	kfree_sensitive(full_info);
>  	return err;

infolen + 9, not infolen + 8.  Otherwise this patch breaks fscrypt.

> diff --git a/include/crypto/hkdf.h b/include/crypto/hkdf.h
> new file mode 100644
> index 000000000000..ee3e7d21a5fe
> --- /dev/null
> +++ b/include/crypto/hkdf.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * HKDF: HMAC-based Key Derivation Function (HKDF), RFC 5869
> + *
> + * Extracted from fs/crypto/hkdf.c, which has
> + * Copyright 2019 Google LLC
> + */
> +
> +#ifndef _CRYPTO_HKDF_H
> +#define _CRYPTO_HKDF_H
> +
> +#ifdef CONFIG_CRYPTO_HKDF
> +int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
> +		 unsigned int ikmlen, const u8 *salt, unsigned int saltlen,
> +		 u8 *prk);
> +int hkdf_expand(struct crypto_shash *hmac_tfm,
> +		const u8 *info, unsigned int infolen,
> +		u8 *okm, unsigned int okmlen);
> +#else
> +static inline int hkdf_extract(struct crypto_shash *hmac_tfm,
> +			       const u8 *ikm, unsigned int ikmlen,
> +			       const u8 *salt, unsigned int saltlen,
> +			       u8 *prk)
> +{
> +	return -ENOTSUP;
> +}
> +static inline int hkdf_expand(struct crypto_shash *hmac_tfm,
> +			      const u8 *info, unsigned int infolen,
> +			      u8 *okm, unsigned int okmlen)
> +{
> +	return -ENOTSUP;
> +}
> +#endif
> +#endif

This header is missing <crypto/hash.h> which it depends on.

Also the !CONFIG_CRYPTO_HKDF stubs are unnecessary and should not be included.

- Eric
