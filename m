Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C321D31B114;
	Thu, 15 Oct 2026 09:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058261; cv=none; b=lJZJaPWAaUjUtgPFQAfpcNN9znsa5DONfezc+2z1zZNZVbaHpQR6jXqt0TtJhcr1yjf9g8jd++Y+zDbGGMKfKLRq5r5+ZvoMvUQvbnbcoiSHqh5J67yJoIiOcLLQrjrcB5ElJNUXzRWwbzac7uVypYTLigaYm4XzZHQEPbulLQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058261; c=relaxed/simple;
	bh=10jvn3WUrrvHTbDuZ3lnKlTd8AYqKst5CwKLL2j6W8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4HTULrL20sZ/8vfmfEPMqy8vzRRGhngfnCSk1pYNK7NgaLECbu8mvikXJf0nEVuP3KH4kdKOEu//NWqb5q/8yFZMafntKdAbWBVnxyNNOKkBvFeWJLWBZtJRoTAQWY/21UGXJfjKvgypfprSX3dS7MdRXu+0a9lD+W8ltMOdCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=W7jNGiHi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="W7jNGiHi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0Wh3qrY14Sslubc19aOLgxGEyM8a7Dn6x9v9B96vx04=; 
	b=W7jNGiHiXZIQCIMd89BxMPrvtu+fujMwUeLqQG/dML2DEx0u4JC74gXIBu0Uk36PGMZcOIEyTBv
	QJ6hozOwUOGnQA1/j/uNLmGg9bPZbGG/DJBuoxPp1TJjHZsZKd0FuNTg+2IgnpnS1sAcdKwL9FWE9
	5qYNiPDpoVeZkBroSLqJB4JxctHY+ilN8rAU5dh6HqWDRLkaBmkQ7CLpKf3B2XAWU/teEcCt4tTwI
	r9Qi3QvKHHat21KF+LFIoe8/Scxfo3INpBA64gkkffqgvIAF2Nd0+1E3lNe+gOX151k39xTvGqHlI
	gallbpWZUZ/PZ81Q9wYIJRjjesGqWuaZuHZg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHIDO-000000047wG-3YxO;
	Thu, 15 Oct 2026 17:57:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 20:57:34 +1100
Date: Thu, 15 Oct 2026 20:57:34 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: amd - use PMBASE_OFFSET consistently
Message-ID: <atCjjn53RV11Zz8-@gondor.apana.org.au>
References: <20261008093737.180712-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008093737.180712-2-blum@kernel.org>

On Thu, Oct 08, 2026 at 11:37:37AM +0200, Thorsten Blum wrote:
> Use PMBASE_OFFSET instead of the hard-coded 0xF0 and add the missing
> space to the ioport_map() error message.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/amd-rng.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
