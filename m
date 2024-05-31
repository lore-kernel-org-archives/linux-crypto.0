Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB8D134402;
	Fri, 31 May 2024 09:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717148528; cv=none; b=JwihfgWax4Hvak1LEd+2yG5QHGGZ6I5h7mjSejafthI6Ikk3M/q/sWWR/JdB/5gTkl6nhWy0yTaaZI5J3eZ4wVRYdEmGGmaRu78BakELJOf+APzw1sGveNwPeZ5uIz+4bUnmejWoW4pvwG8vY4htAIfC20MRgqP6jkPKWZdAoVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717148528; c=relaxed/simple;
	bh=N6JI27Liia9uHiEyt3naNHYOHlQI3xHVSeDe7eJdHG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRkKnH0YhIVFV2LrbGIvrqyyB7W+xuqwH2CJCHEhRFveOMFoBS7JMXbZfpzTLEYXPaecTeI4brVGXk6Hst9NbMQfuaH8xtWSlgHg9i7Y+c8C9JpsYP5U1gRbhtAaNZk20KSwunrglzKqtq37VH9MdZYLOUQBTle2OLhZqwStQZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCyln-0049yV-2N;
	Fri, 31 May 2024 17:41:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 17:41:57 +0800
Date: Fri, 31 May 2024 17:41:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: jesper.nilsson@axis.com, lars.persson@axis.com,
	linux-arm-kernel@axis.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: acix: Remove unused struct 'dbgfs_u32'
Message-ID: <ZlmbZW7MuIw-E5ua@gondor.apana.org.au>
References: <20240511145017.226166-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240511145017.226166-1-linux@treblig.org>

On Sat, May 11, 2024 at 03:50:17PM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'dbgfs_u32' appears unused.
> Remove it.
> (pdma_stat_descr is also unused, but I'm assuming it's
> some useful layout description of firmware/hardware
> so best left in)
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/crypto/axis/artpec6_crypto.c | 7 -------
>  1 file changed, 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
