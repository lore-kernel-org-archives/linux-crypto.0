Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC7D23E35D;
	Wed, 23 Apr 2025 03:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745379727; cv=none; b=FTN4X2FRiUWPzlAI/H8a5Jxp/TvndZLjtYvCwmHyb5ryi8HBaPlOl2/yacbO3YSIvPCvnkr+QAYzzVbmvXkB11007h2HTPsWxJyRSq6FpFB5SyF4UBYU7dAFQEPNnA8VlKY6wtQTS/D/5q4WuTZ3Y3hR1xPPGHMaJL0+3tJQsXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745379727; c=relaxed/simple;
	bh=IWyVJ7aEC0M9P/TD88qqDmwjbikyz7A4xCKX2Spz3Rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msEUudSD4ZJwH2q6LnvS0tGuivWqhqyeOz+HP/d9SW0cGUfSPxe8KDtwpfReoe1/Y0y4snNFBmoJyh/+/eAwk5L/R1wltDSLiP/+NgVHe+epjwfTbowSkRvxOHwptgFX19oUZs1mwuiC3QxfGs0Rgek4Q4PzXUabtZCvggwMJjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=R8vgEWJd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="R8vgEWJd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CvPjl01CQoNJfYkNbSOrcz1LqiZzSxsyrCfhIJ29m9k=; b=R8vgEWJdqlme13UJVkaPIZHDE4
	amrQcxE8lxDjdKupqdnGcahR2iVayU6Ag7+ewrmI7fraqxmVk96AjfEfwGyQYLdSuFBEexcTbMA7A
	L79WeTcHIlKiAiCdFnol93lrAyDKQSIA2uBem9coPynZuro+xpaB7LkjZcVukeXjAVR1gaRiOFRW1
	6CJdYh+CSZRnZSJxYHLtEDuRcH5Dv+ZkuJFupJH51dG7Ha6Sx5oU6U3T1o0RUrAaz3OfIDD43mk0W
	iBegjOWKsYTtaGhJzw+PSPGbF5VvbToidzopdYO97FpWgZUm9Gk7LJ5GndirWEUdevq7rI0jhp5w0
	xlJ7hYKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7QzX-000Gji-1a;
	Wed, 23 Apr 2025 11:41:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Apr 2025 11:41:43 +0800
Date: Wed, 23 Apr 2025 11:41:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - Set hwrng quality to lowest
 possible
Message-ID: <aAhhd91a94ZypyWN@gondor.apana.org.au>
References: <20250422095718.17360-1-kabel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250422095718.17360-1-kabel@kernel.org>

On Tue, Apr 22, 2025 at 11:57:18AM +0200, Marek Behún wrote:
> According to the review by Bill Cox [1], the Atmel SHA204A random number
> generator produces random numbers with very low entropy.
> 
> Set the lowest possible entropy for this chip just to be safe.
> 
> [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
> 
> Fixes: da001fb651b00e1d ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/crypto/atmel-sha204a.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Patch appiled.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
