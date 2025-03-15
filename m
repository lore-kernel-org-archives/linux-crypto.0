Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8083F192B8F;
	Sat, 15 Mar 2025 09:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742030268; cv=none; b=dmBrm5zwB4LVTUeoLDdgUgdVlANe+y/fT/jN+ScgEI3DCtcFQkQHi6Z1UA/oLyiLYrjJACp1zQ41TfNLnRZylotenaeb2sGTjljIiU+iEXCPwjHwxrGnmOTpwxf0g1aWTXlJ+iE4+sLFMxk/WPL+pmtp8vMvgRl2YrjSsI1CqHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742030268; c=relaxed/simple;
	bh=uSXcwOF4OX+6FyoJVGHlnICPZ0NEobxqqLmgMlnJEnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwihmhAACkvi2OWrymtE1FEU6WV2XbtGhKVoqbSCFSzAWBSftTMC6pR6+f5ZlOJJLDXu0lQ4OUqSivO4Rz05eBpO2Iinh5zk4jTMHVVeosAdqVFVNAgClCtZPm7dRdNr9qu+URiPxciuACC2H9+zzTXkARiye8ns7+bzgu0x/Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iyx2UdBY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iyx2UdBY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7ZKaV4wAzdHrL5lpJWveTwc7e0pa/4045fv/4FAgM+U=; b=iyx2UdBYaNjcrqKevY3u8kJAdw
	7QCKP5Ow5whvuCI/A2vPWw3LQ18w5XtuR2GrUuYaPowyEWez4ZGaS3TAFxSt952bOiPqkjdyPj0mi
	hgulOMYneeyV8L4Z4gSFj4ZTNzTlqZOGwuigseNoU3dERBe2ZRrblScz208t8bS2q/9sH3O7L937c
	CO8s9rQ4CSPSlGlyQ/caj5nf5aNwm4ISaVjSnrAXFe8geFNY+wWbsjxUyceFLSRDqArmkT8H6x4GT
	ZCh1H2IdEMMuKcDWb6OroB6yH4hvTsoP2LUZQmMPyGZXFAVF5l2OI7KUl4mYixSj1gPJch9vzaFmS
	NhtRHLwQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttNe5-006o9I-1j;
	Sat, 15 Mar 2025 17:17:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 17:17:29 +0800
Date: Sat, 15 Mar 2025 17:17:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>,
	"David S. Miller" <davem@davemloft.net>, linux-arm-kernel@axis.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: axis/artpec6: change from kzalloc to kcalloc in
 artpec6_crypto_probe()
Message-ID: <Z9VFqX75Uz1JOImq@gondor.apana.org.au>
References: <20250308-artpec6-devm_kcalloc-v1-1-37886eaebd16@ethancedwards.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308-artpec6-devm_kcalloc-v1-1-37886eaebd16@ethancedwards.com>

On Sat, Mar 08, 2025 at 07:30:52PM -0500, Ethan Carter Edwards wrote:
> We are trying to get rid of all multiplications from allocation
> functions to prevent potential integer overflows. Here the
> multiplication is probably safe, but using kcalloc() is more
> appropriate and improves readability. This patch has no effect
> on runtime behavior.
> 
> Link: https://github.com/KSPP/linux/issues/162 [1]
> Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
> ---
>  drivers/crypto/axis/artpec6_crypto.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
