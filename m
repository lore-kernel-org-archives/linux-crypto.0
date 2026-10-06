Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D592926B2AD;
	Tue,  6 Oct 2026 12:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791289522; cv=none; b=pSHzw18yXXpcSKGUToJ288wlnwBAJbSU0PAARt7vYipFMyuxW8n0q3xoGdBjUZHoKEQqwKXTGr/8lPVBQqcz6Tritvf+E5O6jB19qbRLrONqrM0dkhp4hg45az168HOfLRoM6KDmKz5LRfgECaZSC4UyJCYLUVoasheJ6oOulPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791289522; c=relaxed/simple;
	bh=/RhjXHBOD5BhXJCIHtpqPKJW3E9AWbOtML/PPhdsU/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eXLez5XUdWa356/7qG9AQGC6JPEm1Tb04a/VVO0dz36TQufQS/kiQKWUK25pggIFog0ZKYw5eTZQzOR2K3ejJ4key9qitWXAaKsKhRkfRB1ROUK9v7xr7ttgt9S5jpZJb1+Y3V6tOtLeDF9Sn7lIb0GkxIdx/GcB2b6AAdXbUOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHsfiyhE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHsfiyhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFDD1F00893;
	Tue,  6 Oct 2026 12:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791289520;
	bh=4SXPx9Ea3ATjgGrIP0vTAZkS+5sRu1BZcTDcbtL4Uag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kHsfiyhEcSs0YI2Yr/MYjfY5Paeznzyz/8UcFAte1SFQfdCAK0AFU7BxZmMCs3mST
	 8j7gX56+GJsU1qn5rzfMdkpp2mOLv72S4iApc8zcMa+J4TG+ojmqQIOdfXk6GwzpwN
	 mT0ZUd3kS/J2pYNdF7Pz6XLONgZ3caBK2hr7UvVWJ67dsin+0eN1Wu7B9w4++5efVH
	 tZPyYb7ldp78dZrBIrabgN1rVo8vyML4fpxUXb+RgylsAbcG3SEe1xRJR8JO5w1ona
	 K3VGxGIQSagqyjPh8o2T+LTo94vWECAHhH9UTlBvacGej638UDvuCoMp1I0q1eufS9
	 bjLg8f7C4pYZg==
Date: Tue, 6 Oct 2026 14:25:15 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] lib: Move SipHash into lib/crypto/
Message-ID: <20261006122515.GA3185@quark>
References: <20261003162827.155527-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003162827.155527-1-ebiggers@kernel.org>

On Sat, Oct 03, 2026 at 06:28:27PM +0200, Eric Biggers wrote:
> The addition of SipHash to lib/ predated the existence of the
> lib/crypto/ directory.  Since SipHash is a cryptographic algorithm, move
> it from the top-level lib/ directory to lib/crypto/.
> 
> (This does mean HalfSipHash comes with it too, as it's in the same
> files.  But lib/crypto/ still seems like the proper place for both.)
> 
> Specifically:
> 
> - Move both siphash.c and siphash_kunit.c.  Keep the header
>   <linux/siphash.h> as-is for now.
> 
> - Drop the dedicated MAINTAINERS entry for SipHash, as per the
>   suggestion from Jason
>   (https://lore.kernel.org/r/asB7QVFMlgKgbje2@zx2c4.com/).  The C files
>   now just fold up to the "CRYPTO LIBRARY" entry.  Add the header
>   explicitly, as it otherwise would be left unmaintained.
> 
> - Move the kconfig option that controls the KUnit test.  Put
>   "CRYPTO_LIB" in its name and update the prompt and help text to make
>   it consistent with the other crypto library test options.
> 
> - Enable the KUnit test in lib/crypto/.kunitconfig.
> 
> - Link to siphash.rst from the appropriate place in libcrypto-hash.rst.
> 
> - Use obj-y instead of lib-y, for consistency with the fact that
>   currently lib/crypto/ doesn't use kbuild's support for library file
>   goals.  We could keep it as lib-y, but virtually every kernel needs
>   SipHash support anyway (with vsprintf, printk, IPv4, IPv6, etc.
>   depending on it) so there is no practical difference in this case.
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
