Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423FF253932;
	Mon, 12 May 2025 05:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747028799; cv=none; b=MN+FsEPJT2+k+/Ja60MbhMiiP6LSKMnZTi207gu/mN8K+yGWIbru/wIElZ018bL7WSGuNGh/yrgp8tsj70gLGTXgZw4qyqjZP8j8pNt7xpa2BN084wURGWZHSJs3Y3v2Qaw0a6OfMx4sZfGmkPIEuE8nDbWwlZ9dj+vbpF3CIVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747028799; c=relaxed/simple;
	bh=/nxomLNQ0uR4756qgYMiNejXzmAfeJg1aKFobJ1To/4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=MCwDr4B+yFhT/KBs532PV4b2Y7mxD1VjDO7o0JGN19F3PBBCb04H6k9o1OAg6+Or5h2jvDHHEOlubzLh0VAW1oxKoGtbJTzsitwqAfTENegZldnbh/+7RzL4Kc1F0Yan8U5qTB6opqnIwIFiEaDlwTodKyykHWxM3h9g6dBcrP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=a7pSxBUY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="a7pSxBUY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IVoKLm0TRMU7MgXCmk2aD2suHFOk0S0fqlqkmCky9gk=; b=a7pSxBUYs71NsUkQRx2c561NfL
	a6XU4EIpqP6UfctAZ2VPJS70+MApcGN5KXCgPujjxmngM8RWPPPgfj7NfzM8Nc9/wN+NlW0D1m59h
	2Fj7Gy5zxrh5/4Iou5Gvjqdi8KRnJCuRFKpnPDKphWGuXXI4tKXjDdfcZo2H0rcppUI1enL9hZPQW
	jw0YaIMY1S49JLORLgGeaHs2Ge4iPr8XCPn2zjq0fSdT5KghQ8u/j5b0LEm20vBWoYHq/mGI5DPEp
	zxARVFK1xndm4MNVErYhSHVaykRjQl+JzXAzELRqQxtgxFknH9LShTaC7V36Bl1QW/0oSZz7o8DLb
	H4cufN+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uELzl-005Lo3-11;
	Mon, 12 May 2025 13:46:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 May 2025 13:46:33 +0800
Date: Mon, 12 May 2025 13:46:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Clean up the crypto testing options
Message-ID: <aCGLOd2B5MB0tpPQ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505203345.802740-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> This series reworks the crypto testing kconfig options to fix some
> longstanding issues:
> 
> - Replace the inverted option CONFIG_CRYPTO_MANAGER_DISABLE_TESTS with a
>  regular option CONFIG_CRYPTO_SELFTESTS.
> 
> - Make CONFIG_CRYPTO_SELFTESTS enable the full set of tests by default,
>  removing CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.
> 
> - Automatically enable CONFIG_CRYPTO_MANAGER when needed for the tests.
> 
> - Rename cryptomgr.noextratests to cryptomgr.noslowtests.
> 
> - Remove cryptomgr.panic_on_fail, as panic_on_warn can be used instead.
> 
> - Rename CONFIG_CRYPTO_TEST to CONFIG_CRYPTO_BENCHMARK.
> 
> Changed in v3:
>  - Keep options in defconfigs.
>  - Make CRYPTO_SELFTESTS depend on DEBUG_KERNEL.
> 
> Changed in v2:
>  - Moved selftest lines in lib/crypto/Makefile to appropriate places.
>  - Fixed a commit message.
> 
> Eric Biggers (7):
>  crypto: tcrypt - rename CRYPTO_TEST to CRYPTO_BENCHMARK
>  crypto: testmgr - remove panic_on_fail
>  crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with
>    CRYPTO_SELFTESTS
>  crypto: testmgr - make it easier to enable the full set of tests
>  crypto: testmgr - rename noextratests to noslowtests
>  crypto: Kconfig - make CRYPTO_MANAGER a hidden symbol
>  crypto: testmgr - enable CRYPTO_MANAGER when CRYPTO_SELFTESTS
> 
> arch/arm/configs/exynos_defconfig           |   2 +-
> arch/arm/configs/milbeaut_m10v_defconfig    |   3 +-
> arch/arm/configs/pxa_defconfig              |   3 +-
> arch/arm/configs/spitz_defconfig            |   2 +-
> arch/arm64/configs/defconfig                |   2 +-
> arch/loongarch/configs/loongson3_defconfig  |   2 +-
> arch/m68k/configs/amiga_defconfig           |   2 +-
> arch/m68k/configs/apollo_defconfig          |   2 +-
> arch/m68k/configs/atari_defconfig           |   2 +-
> arch/m68k/configs/bvme6000_defconfig        |   2 +-
> arch/m68k/configs/hp300_defconfig           |   2 +-
> arch/m68k/configs/mac_defconfig             |   2 +-
> arch/m68k/configs/multi_defconfig           |   2 +-
> arch/m68k/configs/mvme147_defconfig         |   2 +-
> arch/m68k/configs/mvme16x_defconfig         |   2 +-
> arch/m68k/configs/q40_defconfig             |   2 +-
> arch/m68k/configs/sun3_defconfig            |   2 +-
> arch/m68k/configs/sun3x_defconfig           |   2 +-
> arch/mips/configs/decstation_64_defconfig   |   1 -
> arch/mips/configs/decstation_defconfig      |   1 -
> arch/mips/configs/decstation_r4k_defconfig  |   1 -
> arch/mips/configs/gpr_defconfig             |   2 +-
> arch/mips/configs/ip28_defconfig            |   1 -
> arch/mips/configs/lemote2f_defconfig        |   2 +-
> arch/mips/configs/mtx1_defconfig            |   2 +-
> arch/mips/configs/rb532_defconfig           |   2 +-
> arch/parisc/configs/generic-32bit_defconfig |   2 +-
> arch/parisc/configs/generic-64bit_defconfig |   1 -
> arch/powerpc/configs/g5_defconfig           |   2 +-
> arch/powerpc/configs/powernv_defconfig      |   2 +-
> arch/powerpc/configs/ppc64_defconfig        |   2 +-
> arch/powerpc/configs/ppc64e_defconfig       |   2 +-
> arch/powerpc/configs/ppc6xx_defconfig       |   2 +-
> arch/s390/configs/debug_defconfig           |   4 +-
> arch/s390/configs/defconfig                 |   4 +-
> arch/sh/configs/migor_defconfig             |   1 -
> arch/sparc/configs/sparc64_defconfig        |   2 +-
> crypto/Kconfig                              |  45 ++++----
> crypto/Makefile                             |   2 +-
> crypto/algapi.c                             |   5 +-
> crypto/algboss.c                            |   2 +-
> crypto/api.c                                |   3 +-
> crypto/hkdf.c                               |   2 +-
> crypto/internal.h                           |   5 +-
> crypto/kdf_sp800108.c                       |   2 +-
> crypto/tcrypt.c                             |   8 +-
> crypto/tcrypt.h                             |   4 +-
> crypto/testmgr.c                            | 115 +++++---------------
> include/crypto/internal/simd.h              |   6 +-
> lib/crypto/Makefile                         |  11 +-
> lib/crypto/aescfb.c                         |   2 +-
> lib/crypto/aesgcm.c                         |   2 +-
> lib/crypto/blake2s.c                        |   2 +-
> lib/crypto/chacha20poly1305.c               |   2 +-
> lib/crypto/curve25519.c                     |   2 +-
> 55 files changed, 111 insertions(+), 183 deletions(-)
> 
> 
> base-commit: 64745a9ca890ed60d78162ec511e1983e1946d73

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
