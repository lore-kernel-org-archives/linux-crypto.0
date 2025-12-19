Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DAE1F17E8;
	Fri, 19 Dec 2025 03:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766115344; cv=none; b=jqx6aohk2vfJx84drBU4rwug3PrxwYwNM8C6+weidUIaE+p6orMEUMRbi3R9nffDLSP7TISeuVPZmJIvyDBgp7f6fTU28oD2huJkKj1qKn3C9hiqTVNTCDCrM4C1fIRAbC9RhZ6wx3BpjyxoTge8amoBVWEZzrVLcgsJONJai0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766115344; c=relaxed/simple;
	bh=74vJrN3KnthL4brOBqNVSN2MUKWj7lS9SCILQELXKZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TevwRjErY7CkG48iWkVM1UA1yTEgW4H9mevx9cCqznyVemkU+k6VBYA4RyfMWGxRQK7B1snoLBT57GvOKRVUDn0xM/np5TscCEwDzpXQ9/n1DMB2EFNW+e8+lcXkgcjtHLZYbB+ZE2CyPYmgoluj33s2f+cCaH7G46N5r5Nyp7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BpdeKBz1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BpdeKBz1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1vpLG2xCKwKkUhQAxR9QJDnM8LdIuHlyBTs/ApoYfJg=; 
	b=BpdeKBz1cp7osWVKXwJgNSp1AGdJkYFp71VRqYS16kfQgnxNKJBJIAbR54B0AJTxgz7TfYexWEp
	lv5mlnmb+WTaC+UI7v/53XOGxr1SdFOsFovEPe8yQhaSQrOV0Hxgyut9jfz94a4HKH+9yORdgvdR9
	RrqWIKzuo7P64iNYGWqVEasyFu+GkABI3JFki53SakEST1ffwDbLqxDamB5Wlv5tKWzvsWS76eJ2v
	pRpLJF9sQV1/PxKp7bFN3WAwSunAOCpNx0OoDeTufJ9L68ay0AiUHI5jvdrG2CzcuKoJI/UeVuEz/
	8FxAcVv54IVioanN3PT1y++JB3fb2YdZUXKA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWRH8-00BD02-0M;
	Fri, 19 Dec 2025 11:35:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 11:35:30 +0800
Date: Fri, 19 Dec 2025 11:35:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jeanmichel.hautbois@yoseli.org
Cc: Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Olivia Mackall <olivia@selenic.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH v4 2/2] m68k: coldfire: Add RNG support for MCF54418
Message-ID: <aUTIAicJiTxKHJb7@gondor.apana.org.au>
References: <20251126-b4-m5441x-add-rng-support-v4-0-5309548c9555@yoseli.org>
 <20251126-b4-m5441x-add-rng-support-v4-2-5309548c9555@yoseli.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126-b4-m5441x-add-rng-support-v4-2-5309548c9555@yoseli.org>

On Wed, Nov 26, 2025 at 08:08:10AM +0100, Jean-Michel Hautbois via B4 Relay wrote:
> From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> 
> Add support for the hardware Random Number Generator (RNGB) found on
> MCF54418 ColdFire processors with clock enabled at platform
> initialization.
> 
> The RNGB block is compatible with the imx-rngc driver.
> 
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> ---
>  arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
>  arch/m68k/coldfire/m5441x.c       |  2 +-
>  arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
>  drivers/char/hw_random/Kconfig    |  3 ++-
>  drivers/char/hw_random/imx-rngc.c |  7 +++++++
>  5 files changed, 47 insertions(+), 2 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
