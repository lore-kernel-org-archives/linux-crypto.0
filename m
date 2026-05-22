Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B4B3A1CF3;
	Fri, 22 May 2026 12:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453338; cv=none; b=sUyeDdrVXl4TLT/rjf6AxG9MQovr4D6Vb7YSk3Z7LPZmLQEa3SIDoJIl2S2V5o1rvPV63q98ZeeT0rcCaj3Jyf5ddGbqeCz16kKHCxLt53LKQanzAkt7uu7OM+1VQKWW3Ni93QQXYOTPCoVCLgxzrgREX5Y8XMC27yz5Uhb76nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453338; c=relaxed/simple;
	bh=uYxvE2ptz5IXPlG8EKwqJtc8tWo5q+9ESFVDkx02KTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWblhns48gm/Z39SKXhYPzRQ3odupiGdeUhlpFbMoFfCCzC+2UQNSTScAssLvQy8FCS554pizxmKsx87kc2oA6rL7CTZrJp0r/j78zf6rcslXN2EShfkUuY7LuH+cmRK1O9g+krYqHwyJscUQpDOCf9Y0f49gNzOVwAx91VrNAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iVfUsay3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iVfUsay3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=WGk/h12tge7yfjJA1XJzWb7BmHcbbS9U/K4OCPfXjgs=; 
	b=iVfUsay3TB6Xr37ZqEI/HjhE4zqcO5urE0tExDSAdhO00d341Y5Ui3Ty0qsiOC0UuEI1JhMAKHT
	FeBP9rukOUgK+DQoAfudxgbUetRfH9ViHy/bilAi5x9jiUjdLEX87H+bppba6RnPdtHx5aB+Rtfan
	IJGtfCg3B9j1AOhGDTqjoSRjFXmySMosj0bBPbNQR3hbCvclw+EDK/7DQNsPO+JGZ8HVS2jI1uhOa
	PrMYQbQaSfrV0pszm0T/UCh3l6sBZ79SvGcU5zfYZ3gCCellXyJbN2VHsVZe9Sh6GLw1EJAABI+J0
	OMEfc0jQOKaZBYA31ixRZHQvVf8i1slxz1LQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP6B-00GSVm-0H;
	Fri, 22 May 2026 20:35:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:35:31 +0800
Date: Fri, 22 May 2026 20:35:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: omap-des - add COMPILE_TEST and fix
 CONFIG_OF=n build
Message-ID: <ahBNk5bj4sVSMpDj@gondor.apana.org.au>
References: <20260517103414.1135537-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517103414.1135537-3-thorsten.blum@linux.dev>

On Sun, May 17, 2026 at 12:34:14PM +0200, Thorsten Blum wrote:
> CRYPTO_DEV_OMAP_DES only depends on ARCH_OMAP2PLUS, which is ARM-only
> and selects OF via ARM's USE_OF, making any non-OF code unreachable.
> 
> Add COMPILE_TEST so the driver can be built with CONFIG_OF=n, making the
> non-OF code reachable.
> 
> Fix the resulting non-OF build failures:
> 
> - omap_des_irq() was defined inside a CONFIG_OF block, but is referenced
>   unconditionally from omap_des_probe(). Move the CONFIG_OF guard so it
>   only covers omap_des_get_of().
> 
> - The non-OF omap_des_get_of() stub took a struct device *, while
>   omap_des_probe() passes a struct platform_device *. Make the stub
>   prototype match the OF implementation and the caller.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/Kconfig    | 4 ++--
>  drivers/crypto/omap-des.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
