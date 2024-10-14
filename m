Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B3D1C302E
	for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2024 19:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728934696; cv=none; b=qiAc7mWgS59RMngtOv267EHQ9VI2/7UXxgL/hhtc+hl6dTivVYzmrzNztGguvN1Q+PrdTiqdZFpMzu12ThRs4qrN+hViK6WT3xRrHauKZvQhegTdkv8ZboJYUZb85vVGmmTKB2KcG5d324sH8uqongYJxVRb1b2XhEjSWifAS+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728934696; c=relaxed/simple;
	bh=CEX//ZqgBf243Jq5Ik7iugVFhpGbU6XT4kUmSQIGSa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/u/vO76JlA7ErNh48apqHagSJR5xCjCrbex/2zuSaxLSE+SvA71BJL/JOGtTCmzfLg73G4xvQr+XB0lnIxHwXp99rQY0sV0FUB7ShWufkTXF1PynZNqoGpUjnbchN4HYfHG4BBaCpN5qJ2hXvACmYrbbTNfQOuo254pA7l5nws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfyAMs3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfyAMs3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D15C4CEC3;
	Mon, 14 Oct 2024 19:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728934696;
	bh=CEX//ZqgBf243Jq5Ik7iugVFhpGbU6XT4kUmSQIGSa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MfyAMs3zUrsCZGU/j6FEKgwmFi35ULiPVN73cPNaRfuinzOxGvl0+TRMwZ7oN3r9b
	 eRUJJ1pUoeZhP1ZVyCKIbgFWtpYELq1e5ik4Mfjqo23oFFZI/G+JFh19rxOJcKCSzY
	 prj+LH1RUHQ/I/PwW0eCdtJbT2cNmyn4kdmhNBI0rw+wEnTJfxJ0Bto7tSh6D1FH49
	 LbEBne0HJjegAvyGdhjScc9cCiRblkhXH/98UYRjxw+AABbUWRQ0d5KRvVgV+reMLQ
	 kUn+oLNh5gZlvcGHKYMXtMhMIRnl4iTbFl4eCMY/ubSG/UnMEJ8g+Rh009Kb0jxSjD
	 3Nr6X4hHAfD8A==
Date: Mon, 14 Oct 2024 12:38:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/9] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
Message-ID: <20241014193814.GB1137@sol.localdomain>
References: <20241011155430.43450-1-hare@kernel.org>
 <20241011155430.43450-2-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011155430.43450-2-hare@kernel.org>

On Fri, Oct 11, 2024 at 05:54:22PM +0200, Hannes Reinecke wrote:
> Separate out the HKDF functions into a separate module to
> to make them available to other callers.
> And add a testsuite to the module with test vectors
> from RFC 5869 to ensure the integrity of the algorithm.

integrity => correctness

> +config CRYPTO_HKDF
> +	tristate
> +	select CRYPTO_SHA1 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> +	select CRYPTO_SHA256 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> +	select CRYPTO_HASH2

Any thoughts on including SHA512 tests instead of SHA1, given that SHA1 is
obsolete and should not be used?

> +int hkdf_expand(struct crypto_shash *hmac_tfm,
> +		const u8 *info, unsigned int infolen,
> +		u8 *okm, unsigned int okmlen)
> +{
> +	SHASH_DESC_ON_STACK(desc, hmac_tfm);
> +	unsigned int i, hashlen = crypto_shash_digestsize(hmac_tfm);
> +	int err;
> +	const u8 *prev = NULL;
> +	u8 counter = 1;
> +	u8 tmp[HASH_MAX_DIGESTSIZE];
> +
> +	if (WARN_ON(okmlen > 255 * hashlen ||
> +		    hashlen > HASH_MAX_DIGESTSIZE))
> +		return -EINVAL;

The crypto API guarantees HASH_MAX_DIGESTSIZE, so checking that again is not
very useful.

> +
> +	memzero_explicit(tmp, HASH_MAX_DIGESTSIZE);

The zeroization above is unnecessary.  If it's done anyway, it is just an
initialization, so it should use an initializer '= {}' instead of
memzero_explicit() which is intended for "destruction".

> +MODULE_ALIAS_CRYPTO("hkdf");

This alias does not make sense and is unnecessary.  These are library functions
that are not exposed by name through the crypto API, so there is no need to wire
them up to the module autoloading accordingly.

> diff --git a/include/crypto/hkdf.h b/include/crypto/hkdf.h
> new file mode 100644
> index 000000000000..c1f23a32a6b6
> --- /dev/null
> +++ b/include/crypto/hkdf.h
> @@ -0,0 +1,18 @@
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
> +int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
> +		 unsigned int ikmlen, const u8 *salt, unsigned int saltlen,
> +		 u8 *prk);
> +int hkdf_expand(struct crypto_shash *hmac_tfm,
> +		const u8 *info, unsigned int infolen,
> +		u8 *okm, unsigned int okmlen);
> +#endif

This needs to include <crypto/hash.h>.

Otherwise there will be errors if someone includes this as their first header.

- Eric
