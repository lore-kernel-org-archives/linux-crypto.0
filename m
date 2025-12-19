Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9F922F74D;
	Fri, 19 Dec 2025 07:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766128132; cv=none; b=vAu09kVs9Z+jFxqjojDRQ8dt0ZZ7++NuVZqO2EXWXWnr1qFTAlH0wotxord/BYaUjBmaCqBqzKWBQJY+GHcnrxZS3+ikNZK3KKk+EevlOuAxh+00pTH928faqTJMlPgx7q+weMoyXaRkguXnn24zcrIS3PzFeoaR6yJT2lnlo8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766128132; c=relaxed/simple;
	bh=fjJDb2dBww76Vm5Zwp7/jC4523Ghhr1k34vjHeToGpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WICHVUIiHYWk2clEEmFDY7lEXvuHmTNllO6G7O8Kh+9942apJwx7W1oG+M9mC9N5zRY2wpemQ5m8b0aLtzog/tip514nmU7cpNb3LyAdGy9mV/CAXHwm/KYld9vFFsPrZl3cPn9I43CIE8ffbpzjYavQY5tXPa5+vWJpokwDg1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qZpqC2Qu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qZpqC2Qu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0AteCfFF6o3spVT4mCbQf3N8O1eUhZCly6EM37ZeqiQ=; 
	b=qZpqC2QueBiRXcaPNZ/YLpbVzzdEt3VAMfklgWCIFT2+5NqNX7uYEHwzoiNEUr6oA76MRHggxZv
	IMRJ9LtpDkikz1VJRPqMf24S0Bz4x7gtc8GFc0qHPa3wIWnBrYq0it1c38z/BbXNS7GwSxUIxCcCt
	7j/2ewSWMQzba+y3bjB0Ye9wU6TSQbwgd3YSHADufi35zjVOG1OrthQT+cvKBfno7vSzP4TdK1X4H
	aK3Da3gpNVbyIqjSZTfATC7vJ2X8Oim3TCzHqS+0sqT47zpNblHC5/GWUvMixpXiahDcH1lcTHAtc
	NW8WMP7KHQPiprfFbXEssllUq3UgLTWBYJuw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUbU-00BEjF-0i;
	Fri, 19 Dec 2025 15:08:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 15:08:44 +0800
Date: Fri, 19 Dec 2025 15:08:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: scompress - Remove forward declaration of
 crypto_scomp_show
Message-ID: <aUT5_PL2AeBB1m8H@gondor.apana.org.au>
References: <20251209153044.432883-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209153044.432883-1-thorsten.blum@linux.dev>

On Tue, Dec 09, 2025 at 04:30:43PM +0100, Thorsten Blum wrote:
> Add the __maybe_unused attribute to the crypto_scomp_show() definition
> and remove the now-unnecessary forward declaration.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/scompress.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
