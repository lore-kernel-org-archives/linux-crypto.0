Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8378F244691;
	Sat, 16 Aug 2025 09:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755336916; cv=none; b=rz1N3qYSbTvI+ABWbOUp7M68U8ATYDQZeXv3xZaIfYoMGq207C5dCQZ7HUkDGDEFdgjnQlyv0IQEEe67ow+/KcLaxDAFt5KZUkmSX7Uc/9jHOiTmEThGtnoPxbvcYQdR40V19kA5h0byaPpeIIMQuH917kxZUS0j9l2VKLRfHZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755336916; c=relaxed/simple;
	bh=vL1pWIIeA+gkr1dzD+beVbOku+chq7z2CHA2by6Mckk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JqW7qzBP+EDVYaScnQmajveHsG0zB5LrVJU6h1l5A9FQW2/1IJiwIXhTlAl2Ae8I918UdIlY/m/gdZnOoE+mFKK5fq8hJFXk/4BziDT0/kzCaHJ4f3g2XS+DsyXc2PNab114CS8Hf2etXRXeOEqu5nRQ3DwV/BIVAs+mvqGpUx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jL5FHEAi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jL5FHEAi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qc5HQDHwVHMxpEHETkNV6dvzLOvUTcQzrBqfc20nmD0=; b=jL5FHEAiLoxIsQI5XOOmkeZZC8
	56zzct30bq5Q4ITev9HM3sW9v+11sG51UmeRUqeaOU3Q05T1PYPfDvH2rVwxaVb7x/mo5C50o3Auz
	9/7F2q3pRrYJDqi8lVBCTNccC7wsKsOIs1961TPILuiK6AZOk3pk/ySfejEKRYmlswj61RKLcNvhL
	xHkKrOc9u5RgvI1JxkfNMYQUjcF1C4TWq1hQ6Qujy6XT2xypssXe0T1qW9tFsqcc9fKgJea+tvx1m
	+ZN+o123y5Veo5W13MMRmoDrZA6mhtxrGzowzrO8e7M51zU3SG2+cXE6CM5WDI14P6mtL9qCWrOPj
	Xs5XkKJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unD3Q-00EmOe-24;
	Sat, 16 Aug 2025 17:34:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:34:21 +0800
Date: Sat, 16 Aug 2025 17:34:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Cai Huoqing <cai.huoqing@linux.dev>, Arnd Bergmann <arnd@arndb.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Mayer <mmayer@broadcom.com>,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: nomadik: add ARM_AMBA dependency
Message-ID: <aKBQnVHyaSjr4uQ2@gondor.apana.org.au>
References: <20250729152804.2411621-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729152804.2411621-1-arnd@kernel.org>

On Tue, Jul 29, 2025 at 05:28:00PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Compile-testing this driver is only possible when the AMBA bus driver is
> available in the kernel:
> 
> x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_remove':
> nomadik-rng.c:(.text+0x67): undefined reference to `amba_release_regions'
> x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_probe':
> nomadik-rng.c:(.text+0xee): undefined reference to `amba_request_regions'
> x86_64-linux-ld: nomadik-rng.c:(.text+0x18d): undefined reference to `amba_release_regions'
> 
> The was previously implied by the 'depends on ARCH_NOMADIK', but needs to be
> specified for the COMPILE_TEST case.
> 
> Fixes: d5e93b3374e4 ("hwrng: Kconfig - Add helper dependency on COMPILE_TEST")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/char/hw_random/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
