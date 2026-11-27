Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756491;
	b=Yjqa97PTPa/hG/UkUKiv0yBjgVnCTtYm3SO261Kvz+9QTB3yPbf5Rp9HuM+aZXHAFae2
	 wJfsqB9qjPHqpX5wTgJduZYevAkxNB/W7bzR1BxJXa2QMuAsfhjOc5PhRxDTEudpL+B6G
	 DoNalu7JMBnNlhWWxRq/yYpW7/04kdpFakFXg8yM3tfEXzXb43wzIsWd7Av52kvkZPcDW
	 Cv+PeNzASfIBfsTYZ9LKKV18k/O3wz7aEgtTuHIdzax6dIysWg0REqEWISbTfs6hleZQY
	 ttTeP8u0tE5QLcRLV2QDg/iqS+oQ54HKHsLM+Zw+BJUwSv70NM4B0flXD1767RO6AcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756491;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=omQSExyjblpav3jdjGrCL54hGkIUAafVlLZHRvTCxIw=;
	b=pkD5yto9VxNWT4mGb+D303bUWtosBO5OXLgRVBD/bsDCY2iopj+j7gQUrdT1QDSeFwn+
	 HWyg7guVcSvKLUFJbh+0djASXQ5OMIVP8osj9Hcje+SNMa9Rf5hvCKqbEE8UGto18xV55
	 397avrhKCVshFb/alIfThuoXYjC3pDOacF+uAXkCObw/uyhetXo5Ti16kerLibUMyoryD
	 kZLd2RrMQILy6Vcrn5CBFquy4SMFvBhOPpA+pEZDpH5slFvgrrYPaKj/lZzEQ6RSu0Dy8
	 74o9zXY5wVnmTgbhwK6JSfK5G86Zw8CnIJh8RC24NJuJSkTgzbyOKg/19Gb9mLY2rEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=TC+TnxjH;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB18B606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 05:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB18B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=TC+TnxjH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=omQSExyjblpav3jdjGrCL54hGkIUAafVlLZHRvTCxIw=; 
	b=TC+TnxjHOk3bx+n88WLjfL9gx++EL0mE3TRstLmuiiT46ASdJXaM1RE/c1bfLGoiXJ3czmIyM0J
	AiwSgl9yYUlYPHC668FXh0rKrTOHrYiKumgwq9VZrv1kVl6da2C49VIqwt/zwkk2acg2ol2CueWaX
	KnrM8arPlvN+ABiMb0RylOwcLKAAt4ihC9tFGuqKDyOKvNaHs4z0gCDc3bDP5gHK2Ibm8eocL8Z1C
	AOAXUlS/GGt2DmiCNUYGU31uJtHnCM2VGNMwwP23V1aufqfBB1PBhGhU4v2J2CxuuBPOM3xPg/Z5f
	D5Ziignw6LuI62FF4I+XR+80l9HCE+CNVR+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoII-00000002VVF-2pSM;
	Fri, 27 Nov 2026 13:14:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:14:46 +0800
Date: Fri, 27 Nov 2026 13:14:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Haoxiang Li <haoxiang_li2024@163.com>
Subject: Re: [PATCH] crypto: hifn_795x - Remove the hifn_795x driver
Message-ID: <awkRxg6r38x0xSYg@gondor.apana.org.au>
References: <20261119033926.17527-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119033926.17527-1-ebiggers@kernel.org>

On Wed, Nov 18, 2026 at 07:39:26PM -0800, Eric Biggers wrote:
> Remove the hifn_795x driver, for many reasons:
> 
> - It supported only obsolete, early 2000s PCI chips; only legacy
>   algorithms (DES, 3DES, AES in ECB and CBC modes); and only
>   !ARCH_DMA_ADDR_T_64BIT kernels (e.g., no 64-bit or PAE/LPAE kernels).
> 
> - The last commit tested on hardware was in 2008.  Every commit since
>   then has been an API migration, cleanup, build fix, or static checker
>   fix.  It's clear that no one actually uses it.
> 
> - The only defconfig that enables it is ppc6xx_defconfig, which is a
>   big-endian platform where the driver is completely broken (as it has
>   an undeclared little-endian assumption).
> 
> - It has a large number of bugs, and there's no chance that it passes
>   the crypto self-tests.  For example:
> 
>     - Streaming DMA mappings are never unmapped.  Every crypto operation
>       leaks DMA mappings.  Pages can be leaked on error as well.
> 
>     - Scatterlists are walked using raw pointer arithmetic, breaking
>       chained scatterlists.  The scatterlist element coalescing logic is
>       also buggy and can generate corrupted destination DMA descriptors.
> 
>     - It BUG()s if passed more than PAGE_SIZE of misaligned data.
> 
>     - hifn_rng_data_present() has inverted logic: it reports data as
>       being ready before the required delay has elapsed.
> 
>     - ecb(aes) and cbc(aes) fail to validate the AES key length.
> 
>     - cbc(des3_ede) considers the IV to be 24 bytes rather than 8.
> 
>     - DES weak key checks are run on AES keys.
> 
>     - All algorithms fail to reject non-block-multiple lengths.
> 
>     - All CBC algorithms fail to return the next IV.
> 
> And of course, AI tools can easily find these issues in this unused and
> untested code, resulting in pointless fixes.  Just remove it instead.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  arch/powerpc/configs/ppc6xx_defconfig |    2 -
>  drivers/crypto/Kconfig                |   17 -
>  drivers/crypto/Makefile               |    1 -
>  drivers/crypto/hifn_795x.c            | 2560 -------------------------
>  4 files changed, 2580 deletions(-)
>  delete mode 100644 drivers/crypto/hifn_795x.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
