Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC7F16EBE6;
	Sat, 26 Oct 2024 07:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729926240; cv=none; b=qI1cMMXTn8zAJsp8j39Gs1ZVuFdmm9ACcmLnZvadvQ1+GjL0jRl4HpelPaKUxKleAGVY21R/6q+8eG7o4XISA3f+Aaq6id43NIQoa+GVzH7CtaK/dnkFxptAdkMcZd+pa+9CUNa5CwdcSA5gDM79OixCfRYR7cd2b4HCjCGa7NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729926240; c=relaxed/simple;
	bh=w2dUvvDKoqesv1ytQ0yyH5VZ3gt8DoiWgSqXrq2XPsI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=TUSpixkegVLkcJd1MLU6if2J629EyFX8M0E6vlbv9IZdeWLX3ohUIFpWhKYxEJxRv9Sn2qEXTn3k+/pz4lroJtg4wfL4dC6Pp77Rsc23RHvJLVFE03moGZivjjk/mjqvl7CvsAQm7jnEOnuJCWvZK8yBS0uBm9eSuj3vw2o3yRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YboSmBu1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YboSmBu1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=iqjgwPoSadyGxLdrVj7DYmqocPwRm0P5OMZARcUhpIg=; b=YboSmBu1TFEJbpaBgR8TCTVnhS
	P6jGo1LcARnvh6ckzHNzThGd4Ao6Vt8XgtgpNGcEW75wvyMhKH9tYDpADEbaZ2kkJ52zgMSFWCzvc
	l/6b9/ZAUUcBwdfYl3ozz/y0EUH80b9OJBIoSp2UW37mRT7aazrtC2PSweYQqRhDYA7YhqKhXkOyk
	zmsFwCj2ttGQtU8gkUB1o4iAAo42TPPylBSKvJKw605wg1gEV2XdyYcFTEeZbO4kZoS6Cn3MPZ7Ae
	OBZl/SFOkWcEcCiqHZZTzw2gGjz1cLpbEBf8is7imHWdk8ybTiEAOLunbCLBxb0u8/Osp7R6h07KA
	aF/VtEFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4apz-00CG1O-1S;
	Sat, 26 Oct 2024 15:03:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 15:03:51 +0800
Date: Sat, 26 Oct 2024 15:03:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, ardb@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto - move crypto_simd_disabled_for_test to lib
Message-ID: <ZxyUV2cMZoKJ317I@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018235343.425758-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Move crypto_simd_disabled_for_test to lib/ so that crypto_simd_usable()
> can be used by library code.
> 
> This was discussed previously
> (https://lore.kernel.org/linux-crypto/20220716062920.210381-4-ebiggers@kernel.org/)
> but was not done because there was no use case yet.  However, this is
> now needed for the arm64 CRC32 library code.
> 
> Tested with:
>    export ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
>    echo CONFIG_CRC32=y > .config
>    echo CONFIG_MODULES=y >> .config
>    echo CONFIG_CRYPTO=m >> .config
>    echo CONFIG_DEBUG_KERNEL=y >> .config
>    echo CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n >> .config
>    echo CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y >> .config
>    make olddefconfig
>    make -j$(nproc)
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/algapi.c     |  6 ------
> lib/crypto/Makefile |  2 ++
> lib/crypto/simd.c   | 11 +++++++++++
> 3 files changed, 13 insertions(+), 6 deletions(-)
> create mode 100644 lib/crypto/simd.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
