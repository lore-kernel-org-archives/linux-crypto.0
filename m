Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7D1397E84;
	Mon, 23 Mar 2026 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275288; cv=none; b=sWKZjSmeAu0UqMw07iT5BegqOtlirTxH35esJ+6yY9em4St2rpiqCRdGTJe6+zpEDgqWjds+wXsTNdIelLUA+7zdZdaF2DkDLE5E8gbjy8FnYHbi1HjYOR68Y4pynLjMluz+4OIHoiYLERLaz6VOTdPDLFsBjuJMeKKO+PqUhck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275288; c=relaxed/simple;
	bh=zGq00IgPWGqL77FNM/dQDXciY/ZegFndCC/oogZLb50=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=f3c4va+IIslf13UhjX9M+Ku+nhGcm0RcL511ROnJju62iwWV1DYZ+aPrQFGcELLNNdVeiU3nABcHkv1a1fHsNGqUWm+B3qVPdYlLiAhZBpgzF+rAwXSgtnE11j/uzn43iRNSAor61dhfUdryyeutKbxcuDvRkQqB8ZaAhmIcgpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VD+7uq5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VD+7uq5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2726FC4CEF7;
	Mon, 23 Mar 2026 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774275288;
	bh=zGq00IgPWGqL77FNM/dQDXciY/ZegFndCC/oogZLb50=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=VD+7uq5UXsEy8tNVFYT36WoWcxC5JMBFOnJ+L9HEkEnM0z6S/HfXSoZQVD//wu9Ie
	 f9sJ4gTawj6Ah/1+hUkmtsWF9R2zkXz3eJ71prGWrSzKGd1O/NT7QjgujxXCWPKCqh
	 zVKBmyBrtUvIU9Ln6txHl9rDaFI1p5ToCPN5eYpgXaRNiLW8n4bfYqXdKZbuHzE5O2
	 14dZcjAHUXQ+gJdclGr+UcXsTvOk42J5nCljFdQlPIvi44WozTrh8BUE1OZdWLPvSq
	 27WrtBpqSzgdOGnPbIoWyIdItrUaOZpje09PI14YTFKuHK09i7qPuueeqaDogRoeJb
	 A1hQ40hS6LSbQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3F978F40072;
	Mon, 23 Mar 2026 10:14:47 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 23 Mar 2026 10:14:47 -0400
X-ME-Sender: <xms:10rBaTv_Pd_A-6ULzONqAVkXr_4MPD196GJQz7buHXkZltg2elmcnA>
    <xme:10rBafSBpxD0TQpOy3v6fz6LszqG4ATc9EgRBSwWtvJFKnnfSZzivlf_y50klwR7H
    3oxwI_6gxh5kL4_IKY0-9ba_-MkCP2UlYjMfD_Qupk4et9tdTn7pIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefudekledvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    epudenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    uddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehhvghrsggvrhhtsehgohhnug
    horhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepvggsihhgghgvrhhssehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdr
    ohhrghdprhgtphhtthhopehlihhnuhigqdhrihhstghvsehlihhsthhsrdhinhhfrhgrug
    gvrggurdhorhhgpdhrtghpthhtoheplhhinhhugihpphgtqdguvghvsehlihhsthhsrdho
    iihlrggsshdrohhrghdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrd
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghr
    rdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhsfeeltdesvhhgvghrrd
    hkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:10rBaaGFLpYPkAFfUe8s0LClJL3yg-uQETj-BtW8AqxvXx6wa2LZzg>
    <xmx:10rBaTddSLdwcMNXVRXjM4NOTdJ0Yp4OCdaOBzuRMvdTf4x8LPKDhQ>
    <xmx:10rBaToo3Hfc96ZpYYeSgQ4Ytoz773zh1Qah3jH8yRPdejjOuCDUjw>
    <xmx:10rBaUC7w4iSDgVcJNhWvQ5nPUUZu2cGhbIyUbKyYqGgX6UzBq8tRg>
    <xmx:10rBacdbgrEXFbvY5AtS0DCzs3ou6S5NjToMUix-kf4qn8fY0dEhuwF7>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1A234700069; Mon, 23 Mar 2026 10:14:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Aux1nparIO0F
Date: Mon, 23 Mar 2026 15:14:25 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, x86@kernel.org
Message-Id: <2e95891e-442f-4360-a6b0-7715151a2658@app.fastmail.com>
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Subject: Re: [PATCH 00/19] GHASH library
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 19 Mar 2026, at 07:17, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
>
>     git fetch 
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git 
> ghash-lib-v1
>
> This series migrates the standalone GHASH code to lib/crypto/, then
> converts the "gcm" template and AES-GCM library code to use it.  (GHASH
> is the universal hash function used by GCM mode.)  As was the case with
> POLYVAL and Poly1305 as well, the library is a much better fit for it.
>
> Since GHASH and POLYVAL are closely related and it often makes sense to
> implement one in terms of the other, the existing "polyval" library
> module is renamed to "gf128hash" and the GHASH support is added to it.
>
> The generic implementation of GHASH is also replaced with a better one
> utilizing the existing polyval_mul_generic().
>
> Note that some GHASH implementations, often faster ones using more
> recent CPU features, still exist in arch/*/crypto/ as internal
> components of AES-GCM implementations.  Those are left as-is for now.
> The goal with this GHASH library is just to provide parity with the
> existing standalone GHASH support, which is used when a full
> implementation of AES-GCM (or ${someothercipher}-GCM, if another block
> cipher is being used) is unavailable.  Migrating the
> architecture-optimized AES-GCM code to lib/crypto/ will be a next step.
>
> Eric Biggers (19):
>   lib/crypto: gf128hash: Rename polyval module to gf128hash
>   lib/crypto: gf128hash: Support GF128HASH_ARCH without all POLYVAL
>     functions
>   lib/crypto: gf128hash: Add GHASH support
>   lib/crypto: tests: Add KUnit tests for GHASH
>   crypto: arm/ghash - Make the "ghash" crypto_shash NEON-only
>   crypto: arm/ghash - Move NEON GHASH assembly into its own file
>   lib/crypto: arm/ghash: Migrate optimized code into library
>   crypto: arm64/ghash - Move NEON GHASH assembly into its own file
>   lib/crypto: arm64/ghash: Migrate optimized code into library
>   crypto: arm64/aes-gcm - Rename struct ghash_key and make fixed-sized
>   lib/crypto: powerpc/ghash: Migrate optimized code into library
>   lib/crypto: riscv/ghash: Migrate optimized code into library
>   lib/crypto: s390/ghash: Migrate optimized code into library
>   lib/crypto: x86/ghash: Migrate optimized code into library
>   crypto: gcm - Use GHASH library instead of crypto_ahash
>   crypto: ghash - Remove ghash from crypto_shash API
>   lib/crypto: gf128mul: Remove unused 4k_lle functions
>   lib/crypto: gf128hash: Remove unused content from ghash.h
>   lib/crypto: aesgcm: Use GHASH library API
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
