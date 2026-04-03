Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FCB248F62;
	Fri,  3 Apr 2026 01:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178507; cv=none; b=WXFQgMg4uOmIg/XD+MQzTdYqphLRDEQhO3gesIlr3yTdXXAjqDwf9HqK8AfdUsDAVXmSTLVjVz9DauR1tTP2oWonWx0i1JzgD+eFZOt/GGEy7PDZZJmEugAYlyw1YqXQRtFgFkLKPT7UNguFY4RZsU3B3kZjt6tRhKeZseI0//s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178507; c=relaxed/simple;
	bh=Q9C7SGmedoYXbH0WOQKLHcH9U2xGYdzCgSllpkNeeE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnzPSqpGeL6NV7PRXdRJAcRDOf80TL5bOrBToOfVukM6yHDYanVtN4SrYqMRhhhzx13ergyBliOJiVz80Bs55inJOJ94p4915uja5ce8rONFiKNYN0Srb42FyVo5Ig4bZXh3eesBNSTxi75Wx9zDuBCniSrvK0Ewi/w934BP8TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AA08h6YE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AA08h6YE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+USeSNrd+VSsWq4NWpR8STtSmRmf5rBfxlBSk+ilRjc=; 
	b=AA08h6YEptjPw1421+YEP9vDDsn+1EuiCqm+5zGTK1lJnsyCbFH6dRC6U9wVkitvpmXzxA+8t2w
	DQtagT41wHKDNp7O2/+JWthWqPJTAxTThvmZFRhY321eAcjuflFwbl6NxXb4WElIJuUGbZPuKfuCM
	Ndi77UxTBrmTKU6KlCayvnb9z15qE/x+jptTlwE+/LGurxByoU7YY6efkhzcHwj0h260Ktt41Fibo
	Y846aq+hjxXFM1lbV/A2IqFBjccVdJLRrZQj8f3gf1mylLTSItiAOTmJJZRLcGRbM8O3zxkDgE38C
	ghrlFACL/aK1Hd5ly5W8x2TOa7BfiSW5xNBA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SbY-003R2l-08;
	Fri, 03 Apr 2026 09:08:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:08:02 +0800
Date: Fri, 3 Apr 2026 09:08:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: Neal Liu <neal_liu@aspeedtech.com>,
	"David S. Miller" <davem@davemloft.net>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-aspeed@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aspeed/hash: Use memcpy_from_sglist() in
 aspeed_ahash_dma_prepare()
Message-ID: <ac8S8jLrZrXg8M-K@gondor.apana.org.au>
References: <20260327092418.10476-1-paul.louvel@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327092418.10476-1-paul.louvel@bootlin.com>

On Fri, Mar 27, 2026 at 10:24:18AM +0100, Paul Louvel wrote:
> Replace scatterwalk_map_and_copy() with memcpy_from_sglist() in
> aspeed_ahash_dma_prepare(). The latter provides a simpler interface
> without requiring a direction parameter, making the code easier to
> read and less error-prone.
> 
> No functional change intended.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>  drivers/crypto/aspeed/aspeed-hace-hash.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
