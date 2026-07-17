Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5AD3002DC;
	Fri, 17 Jul 2026 08:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276262; cv=none; b=XYDPAvW6YBaLvfagm5B1Cyc5MNCN1POPrzsWXIgQ+sGnloVRVH2J5/2Y0JL9HPL+xwvjPTii34CP++lGID6jFlNXcGHE9q7T0M8fu5eM5kMm87FzrvP0ymgkhdvdnlUVP3qE0YtqlGNWq8tYdrBhafY5rLfqno4aff0zcl3hu/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276262; c=relaxed/simple;
	bh=EHCR4Vjh/5hNgj+ybmJO4HrIjjmhPKaHJSaejYjNNpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNzUja9mC3g0LlpX4oT48rADsCVxONrPAuAIah6xTo+uc8bZdejo6Dd5AoFXuseJ1p7uKAsWEYgpXY08XH1yR9TdL5zrKRU45vsJahbDJxNlF1tZRVLUtLEwcv70LPEKxW8DjzkFeFrHy7ZgaLppYrtwyWDFS19Hdi0lBLkHqs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FS1pC/ud; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FS1pC/ud"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=L/KnMbt1TI7vrSfrLslsKhPGmVSPaIlaFk810tQ/Tfs=; 
	b=FS1pC/udPDs1EyGx+3iEhq6qLS4zmF+ggdj+l0a8VS4HpqgCyaDCzfvBjjBLdnds9Nm0U9Bi29Q
	t2UYjM2XN5vvhWvbieDyFX+y3MJVVEsIhtxC68ZhecCoDhrJIz2yrjQEdIZMHgHg543sRxhxcHUvm
	6aMO3xldbRZqpfg2cXTLA8lZj2+ItiDrrULFAOyjc7TceE39tEkie4k6hl2eXvfLtDu+HwV0KvglY
	CK21LmX7Vx7inShS1OL/mF0VTnu4yvIZ2hWdnItHpG5N1yfaYYdDkdgyF1Qbyd7PR4azvDErRerEq
	UDnzQ8gMa0u1vyKdbBOl4pFrJKYkRizimAPw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdlD-0000000EOCT-2Mij;
	Fri, 17 Jul 2026 16:17:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:17:31 +1000
Date: Fri, 17 Jul 2026 18:17:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Pascal EBERHARD <pascal.eberhard@se.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] hwrng: Enable EIP-76 on RZ/N1
Message-ID: <alnlGyNOa9fcgGJB@gondor.apana.org.au>
References: <20260710-schneider-v7-2-rc1-eip76-upstream-v2-0-4eab557b0e70@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-schneider-v7-2-rc1-eip76-upstream-v2-0-4eab557b0e70@bootlin.com>

On Fri, Jul 10, 2026 at 08:20:31PM +0200, Miquel Raynal (Schneider Electric) wrote:
> The EIP-76 is an block from Inside-Secure which is not at all OMAP
> specific. Make it available on Renesas RZ/N1 where it is present inside
> a container named EIP-150.
> 
> These patches come from a bigger series which I split into meaningful
> patchsets, one per subsystem:
> 
> Link: https://lore.kernel.org/all/20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com/
> 
> Changes in v2:
> - Patches have been extracted from the bigger series.
> - Rebased on top of v7.2-rc1.
> - Tag from Rob collected.
> 
> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
> ---
> Miquel Raynal (Schneider Electric) (2):
>       dt-bindings: rng: Rename the title of the EIP-76 file
>       hwrng: omap: Enable on Renesas RZ/N1D
> 
>  Documentation/devicetree/bindings/rng/inside-secure,safexcel-eip76.yaml | 2 +-
>  drivers/char/hw_random/Kconfig                                          | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> ---
> base-commit: 7f26e010764df304602f33912a0550dcf46e72c2
> change-id: 20260710-schneider-v7-2-rc1-eip76-upstream-4d6a83015f7e

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
