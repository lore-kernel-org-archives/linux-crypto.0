Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBB020DD48;
	Sat, 22 Nov 2025 03:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763781533; cv=none; b=Ha4HEaMjsTZkGg3MEALsD8aXPHDesyHYunQS5sO7SLEs/Bz+TX9eO2GIGZTImPUs5CSJFP89IW5vKe+7rust3d9DKnjA+RH3UKcsbHaeebZi5ZY8e7p/6ji2B2PRNeoEEUHfNDR8KRekXs1qFIrBmZoJNyCuRoRaSbssUNTUUZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763781533; c=relaxed/simple;
	bh=Eltmj+PR1bRacTsoEOPDt13F4OBA/mpcGidlIygi8/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hICGU965/zxtumC77TySnglS87i5NLUkRUbq4ZwDO1ijo1OdnwYHsFSVIIhRA/134DouZU4SlimPaq+ujsysyfxeDk8QRDt5hUnOSNLXUn/7pqSlRVDPNvNa6g61SkIQY+b7OWUyQzED5h4JhpX+sKdCnMXTRUsl/pG9RolxCoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nQr7JhjP; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nQr7JhjP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PeQLKK5S2Oj5dTrYUFC+GoA3XWgmm2GKW6GzzzrfZBk=; 
	b=nQr7JhjPDySSfjkM72ePOSFP+A4eiYt0BK0Ekw/xLWPifzAQcGRDnMg2qJK39boWJBLSRMbULCV
	RakXeXfts6wiEWXzHTpUqUNZg7bP4e5SL9FLi86DidiNQbLdgPAB56+oU8xPhRu190HqaTurGCj/w
	s1uhDWuMWlLX+LJ7Ir/s9cA0yCrbsp7k1f2QHX+bVVsWalqbL3bPGny3p2YXhJYMF5QJWUujTJHyI
	OPgKcwyEiLXaZvaA1JyN/PaP2FX5jjTNZGpr6HQIoem8R8iTgXFyAikousVmk+wubCRKC5GVEBD/U
	aNyIUd4MUaEhZbDUsme87/O7LfCY/0pzFMYA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMe93-0056Wr-2j;
	Sat, 22 Nov 2025 11:18:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 11:18:41 +0800
Date: Sat, 22 Nov 2025 11:18:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org, Haotian Zhang <vulab@iscas.ac.cn>,
	Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: ansi_cprng - Remove unused ansi_cprng algorithm
Message-ID: <aSErkZDtpzg6OcHw@gondor.apana.org.au>
References: <20251114025708.230616-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114025708.230616-1-ebiggers@kernel.org>

On Thu, Nov 13, 2025 at 06:57:08PM -0800, Eric Biggers wrote:
> Remove ansi_cprng, since it's obsolete and unused, as confirmed at
> https://lore.kernel.org/r/aQxpnckYMgAAOLpZ@gondor.apana.org.au/
> 
> This was originally added in 2008, apparently as a FIPS approved random
> number generator.  Whether this has ever belonged upstream is
> questionable.  Either way, ansi_cprng is no longer usable for this
> purpose, since it's been superseded by the more modern algorithms in
> crypto/drbg.c, and FIPS itself no longer allows it.  (NIST SP 800-131A
> Rev 1 (2015) says that RNGs based on ANSI X9.31 will be disallowed after
> 2015.  NIST SP 800-131A Rev 2 (2019) confirms they are now disallowed.)
> 
> Therefore, there is no reason to keep it around.
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Haotian Zhang <vulab@iscas.ac.cn>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting cryptodev/master
> 
>  Documentation/crypto/userspace-if.rst       |   7 +-
>  MAINTAINERS                                 |   1 -
>  arch/arm/configs/axm55xx_defconfig          |   1 -
>  arch/arm/configs/clps711x_defconfig         |   1 -
>  arch/arm/configs/dove_defconfig             |   1 -
>  arch/arm/configs/ep93xx_defconfig           |   1 -
>  arch/arm/configs/jornada720_defconfig       |   1 -
>  arch/arm/configs/keystone_defconfig         |   1 -
>  arch/arm/configs/lpc32xx_defconfig          |   1 -
>  arch/arm/configs/mmp2_defconfig             |   1 -
>  arch/arm/configs/mv78xx0_defconfig          |   1 -
>  arch/arm/configs/omap1_defconfig            |   1 -
>  arch/arm/configs/orion5x_defconfig          |   1 -
>  arch/arm/configs/pxa168_defconfig           |   1 -
>  arch/arm/configs/pxa3xx_defconfig           |   1 -
>  arch/arm/configs/pxa910_defconfig           |   1 -
>  arch/arm/configs/spitz_defconfig            |   1 -
>  arch/arm64/configs/defconfig                |   1 -
>  arch/hexagon/configs/comet_defconfig        |   1 -
>  arch/m68k/configs/amcore_defconfig          |   1 -
>  arch/m68k/configs/amiga_defconfig           |   1 -
>  arch/m68k/configs/apollo_defconfig          |   1 -
>  arch/m68k/configs/atari_defconfig           |   1 -
>  arch/m68k/configs/bvme6000_defconfig        |   1 -
>  arch/m68k/configs/hp300_defconfig           |   1 -
>  arch/m68k/configs/mac_defconfig             |   1 -
>  arch/m68k/configs/multi_defconfig           |   1 -
>  arch/m68k/configs/mvme147_defconfig         |   1 -
>  arch/m68k/configs/mvme16x_defconfig         |   1 -
>  arch/m68k/configs/q40_defconfig             |   1 -
>  arch/m68k/configs/stmark2_defconfig         |   1 -
>  arch/m68k/configs/sun3_defconfig            |   1 -
>  arch/m68k/configs/sun3x_defconfig           |   1 -
>  arch/mips/configs/decstation_64_defconfig   |   1 -
>  arch/mips/configs/decstation_defconfig      |   1 -
>  arch/mips/configs/decstation_r4k_defconfig  |   1 -
>  arch/s390/configs/debug_defconfig           |   1 -
>  arch/s390/configs/defconfig                 |   1 -
>  arch/sh/configs/ap325rxa_defconfig          |   1 -
>  arch/sh/configs/apsh4a3a_defconfig          |   1 -
>  arch/sh/configs/apsh4ad0a_defconfig         |   1 -
>  arch/sh/configs/dreamcast_defconfig         |   1 -
>  arch/sh/configs/ecovec24_defconfig          |   1 -
>  arch/sh/configs/edosk7760_defconfig         |   1 -
>  arch/sh/configs/espt_defconfig              |   1 -
>  arch/sh/configs/hp6xx_defconfig             |   1 -
>  arch/sh/configs/landisk_defconfig           |   1 -
>  arch/sh/configs/lboxre2_defconfig           |   1 -
>  arch/sh/configs/migor_defconfig             |   1 -
>  arch/sh/configs/r7780mp_defconfig           |   1 -
>  arch/sh/configs/r7785rp_defconfig           |   1 -
>  arch/sh/configs/rts7751r2d1_defconfig       |   1 -
>  arch/sh/configs/rts7751r2dplus_defconfig    |   1 -
>  arch/sh/configs/sdk7780_defconfig           |   1 -
>  arch/sh/configs/sdk7786_defconfig           |   1 -
>  arch/sh/configs/se7206_defconfig            |   1 -
>  arch/sh/configs/se7343_defconfig            |   1 -
>  arch/sh/configs/se7705_defconfig            |   1 -
>  arch/sh/configs/se7712_defconfig            |   1 -
>  arch/sh/configs/se7721_defconfig            |   1 -
>  arch/sh/configs/se7722_defconfig            |   1 -
>  arch/sh/configs/se7724_defconfig            |   1 -
>  arch/sh/configs/se7750_defconfig            |   1 -
>  arch/sh/configs/se7751_defconfig            |   1 -
>  arch/sh/configs/se7780_defconfig            |   1 -
>  arch/sh/configs/sh03_defconfig              |   1 -
>  arch/sh/configs/sh2007_defconfig            |   1 -
>  arch/sh/configs/sh7710voipgw_defconfig      |   1 -
>  arch/sh/configs/sh7757lcr_defconfig         |   1 -
>  arch/sh/configs/sh7763rdp_defconfig         |   1 -
>  arch/sh/configs/sh7785lcr_32bit_defconfig   |   1 -
>  arch/sh/configs/sh7785lcr_defconfig         |   1 -
>  arch/sh/configs/shmin_defconfig             |   1 -
>  arch/sh/configs/shx3_defconfig              |   1 -
>  arch/sh/configs/titan_defconfig             |   1 -
>  arch/sh/configs/ul2_defconfig               |   1 -
>  arch/sh/configs/urquell_defconfig           |   1 -
>  arch/sparc/configs/sparc32_defconfig        |   1 -
>  arch/sparc/configs/sparc64_defconfig        |   1 -
>  arch/xtensa/configs/audio_kc705_defconfig   |   1 -
>  arch/xtensa/configs/generic_kc705_defconfig |   1 -
>  arch/xtensa/configs/iss_defconfig           |   1 -
>  arch/xtensa/configs/nommu_kc705_defconfig   |   1 -
>  arch/xtensa/configs/smp_lx200_defconfig     |   1 -
>  arch/xtensa/configs/virt_defconfig          |   1 -
>  arch/xtensa/configs/xip_kc705_defconfig     |   1 -
>  crypto/Kconfig                              |  13 +-
>  crypto/Makefile                             |   1 -
>  crypto/ansi_cprng.c                         | 474 --------------------
>  crypto/tcrypt.c                             |   4 -
>  crypto/testmgr.c                            |  97 ----
>  crypto/testmgr.h                            | 106 -----
>  include/crypto/rng.h                        |  11 +-
>  93 files changed, 9 insertions(+), 789 deletions(-)
>  delete mode 100644 crypto/ansi_cprng.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
