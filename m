Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A840F463B6F
	for <linux-crypto@vger.kernel.org>; Wed,  7 Oct 2026 10:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791368714; cv=none; b=gpFbET8BSS7krwlXP4frs+M8Vyfi5MauweFYR9Jpmr73DSv6URxz0sudRldNmb1mmbGdJZ58d0dCz2BDc5VvsqN2YTsNe4pJ8oBDDb18TvzAUHxUerx2pYZoXJyU4rdqk6eft793VKUwzoIr53/usU9o7kiaK2W0gKRDQlk2fb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791368714; c=relaxed/simple;
	bh=Cy+Qno8n/kSaFu5vKqD37JuygDPFTf3ixu06zcKzppM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMR+u3vCZDvtyiWn69l/RvZihqPBjKoXikFS4NssqzCFP1HBdYGBGd9eCt1YheD8W6rv5rOFAxpMnGBSHCEyfYpSfWG8O8sjQH+19dyphnHXA5l/I9UrRiJVvsUPVM7mLWtrlqZhpvVMlESgJW6V8zD8iHlL3Uv7yZu8hgN2M8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkj5lrWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkj5lrWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D561F0089B;
	Wed,  7 Oct 2026 10:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791368704;
	bh=C5LwdiYiLi4Ev1c4a4Uqka34LGKg7dbU17HBPUmW8KU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dkj5lrWcbI9q3ag3x+ScCrRmtKwSZS6G7sx9JteBleuqNLV/HfpxKC7EDNaNWg738
	 Cvex5bgdYsw1HdHHjk9AkwrnQQXKzivRkedbI3reERMczIV7jwAjvGG78nQsV5PR9r
	 bjoVffB6WNFf5omBACdCZ6AulapfOi4Wff8Y5pN6ggQuIL5ux6gaSUB5qK9+WvjpNb
	 YV0ATF1s2dzFDhm9K3KA6NdzAsdJKoTxfLDIvEYZpPjsNUjcPSqjPdgo7x+4tXbqm0
	 dAKMqDGUUnP091jmq9UbU9+cfKniTf2Vk9FDft18yKYwPlYj2c31ewKIv1RnXEnRRh
	 VykQ2fX8A7yWw==
Date: Wed, 7 Oct 2026 12:24:57 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	"Derwig, Ruud" <ruud.derwig@gf.com>,
	Ross Bannerman <Ross.Bannerman@synopsys.com>,
	Nazim Khan <nazim.khan@vayavyalabs.com>,
	Navami R Telsang <navami.telsang@vayavyalabs.com>
Subject: Re: CMAC fallback failures from SPAcc driver
Message-ID: <20261007102457.GA1695@quark>
References: <CALxtO0nT-a44-HkocT5C69=sqPurEg4G-S=1BbFPWRVVjuV1eQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0nT-a44-HkocT5C69=sqPurEg4G-S=1BbFPWRVVjuV1eQ@mail.gmail.com>

On Wed, Oct 07, 2026 at 02:51:00PM +0530, Pavitrakumar Managutte wrote:
> Hi Eric,
>    While bringing up the SPAcc async ahash hardware driver against
> 7.3-rc1, cmac(aes) and xcbc(aes) fail their self-tests during TFM
> allocation.
> 
> I did some digging and it looks like this is due to the missing
> export_core/import_core functions in the cmac software
> implementations. I see that all other hash algos have
> export_core/import_core functions except cmacs. Is it intentional?
> 
> For cmac(aes)/xcbc(aes) it fails. In crypto/ahash.c,
> crypto_ahash_init_tfm() allocates the fallback with:
> 
>     fb = crypto_alloc_ahash(name, CRYPTO_ALG_REQ_VIRT,
>                        CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT |
>                        CRYPTO_AHASH_ALG_NO_EXPORT_CORE);
> 
> i.e. it requires a fallback that is synchronous, virtual-address
> capable, and has NO_EXPORT_CORE clear.
> 
> On our tree no cmac(aes)/xcbc(aes) provider satisfies that: with both
> CONFIG_CRYPTO_CMAC/XCBC=y and CONFIG_CRYPTO_LIB_AES_CBC_MACS=y,
> neither the classic crypto/cmac.c template nor the new AES-CMAC
> library shash implements export_core/import_core, so both report
> NO_EXPORT_CORE. The allocation finds no fallback candidate and returns
> -EINVAL:
> 
>   alg: hash: failed to allocate transform for spacc-cmac(aes): -22
> 
> BTW for SPAcc incremental(init/update/final) path, we always use the
> software fallbacks since SPAcc hardware cannot export or import the
> intermediate MAC state. Herbert suggested this.

In hash algorithms like "cmac-aes-lib" that XOR pending data into the
state, there's no meaningful concept of the "core" state.  So I do not
think cmac-aes-lib needs to be, or should, be changed.

crypto/cmac.c does buffer data separately from the state for some
reason.  So sure, you could update it to support exporting and importing
the "core" state.

But the whole concept of drivers calling into crypto_ahash recursively
is broken anyway, as is the "core" state thing.  A better way to
implement the fallback would be to just use the library functions.

Or just do not support this algorithm in the driver, as the CPU-based
implementation is almost always better than drivers like these anyway.

- Eric
