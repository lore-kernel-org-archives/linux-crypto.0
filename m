Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BDF2DEA9D;
	Thu, 26 Mar 2026 02:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774492331; cv=none; b=Lt9pdGqKFX4Vx/6bTVBf5C2W+cRwOaMZYtX8YhrBhxj1HIRMVN9QO81CFYX60zpI26dKf2ekCUGcXVRtLojAuxpaMGg3QfZK7o3aiy297/FFkzpba5G5I0vKZ/mRyJsenN72TQBJLPkPRIe6NUkfwGbfIghH/CkUtIO1EsWe1FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774492331; c=relaxed/simple;
	bh=Dd5IcH9ycQW/L7TxAHF5Nss8yLzLcHgJKj/mxApUSiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dT3Kv8Uda6Y78PmMGHRqMkzVolNzMenT882ELVnO7VRmGL+P79kCbZOjiQ2Fqc6fKWSsgb9MFO4yX9zZnAkHi3UNZOfvaz9wFlJ7xd0GIDfByeLJapHgqySVG7Nyr3vxJxlxshFA7LPVNfF8md/VD3CgGTPTdjtXXC5CJ14O4vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEmOw/xS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEmOw/xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434A9C4CEF7;
	Thu, 26 Mar 2026 02:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774492331;
	bh=Dd5IcH9ycQW/L7TxAHF5Nss8yLzLcHgJKj/mxApUSiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YEmOw/xSZfWVEGi13DswiDtFZMhAQF8Tbi8SSntDpT27LOMVnzZXueP9jJNkS2ogj
	 jCyANDZ/l4SFNgs6Da+YBbr90yMF6ZThY7ymjmPYfd1uCS8U+VmZAEZVb0P/f/PCrl
	 o9brvI0vNrByEeb0VYv8OffEZeHStaIFSU5H0Ts7vRUjRRi4YMXwOLAf7VFRfUd+hf
	 DMUFlq4m2HMAC/THT8xAncFlhbOx6mpSJze+ngSlkjsHZTFMiIngOnocoQbWZT1BfZ
	 Aq7SRev5Fh/FYOAgw/IiS3d8qmuharaEhkAQGYSMJZw4LWNzaryGAu1ToZkbXWCsOB
	 biv7RZr/UHs/w==
Date: Wed, 25 Mar 2026 19:31:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] crypto: rng - Add crypto_stdrng_get_bytes()
Message-ID: <20260326023105.GA2304@sol>
References: <20260326001507.66500-1-ebiggers@kernel.org>
 <20260326001507.66500-2-ebiggers@kernel.org>
 <CAHmME9qWks00NyM8-kLKCcZNM6LAme5VZJkgrpg3ZVjbZFtH4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qWks00NyM8-kLKCcZNM6LAme5VZJkgrpg3ZVjbZFtH4Q@mail.gmail.com>

On Thu, Mar 26, 2026 at 02:38:47AM +0100, Jason A. Donenfeld wrote:
> I'm a little worried about this because I don't want to see a
> proliferation of crypto_stdrng_get_bytes() users. How can we be sure
> that this is mostly never used?
> 
> 
> Jason

Perhaps a slightly different comment?  By the end of the series it is:

/**
 * crypto_stdrng_get_bytes() - get cryptographically secure random bytes
 * @buf: output buffer holding the random numbers
 * @len: length of the output buffer
 *
 * This function fills the caller-allocated buffer with random numbers using the
 * normal Linux RNG if fips_enabled=0, or the highest-priority "stdrng"
 * algorithm in the crypto_rng subsystem if fips_enabled=1.
 *
 * Context: May sleep
 * Return: 0 function was successful; < 0 if an error occurred
 */

We could add something like:

    Don't call this unless you are sure you need it.  In most cases you
    should just call get_random_bytes_wait() directly.

- Eric
