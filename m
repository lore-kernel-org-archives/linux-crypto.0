Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E35289811;
	Fri, 14 Nov 2025 10:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115652; cv=none; b=AsPcBawGaXqiuY4xLub2EKFGeX4+7uW/LvrxaRwU1cP2Afp/KWk7yVTOqAhJFOzp1IJSUPEcsOVaJ2cY+iOsiICvHDt3vG/oijIhT82+5CYJWuhRfeWmRUL6ECOiJPVJQxK/6II7RooJ/6TZA6GfaWlM60Q/t4TFX1gQi5/3JrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115652; c=relaxed/simple;
	bh=Eq90VWTnt2I1TVoiAkyeH5UlF46MjyLAovMmXoRg0a0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckRgBKvv+mG6kKTwO5P895tPnTLotvQfgc2Y0Wl0vg43nK8mFHt9yTl5vr8euM+Vz1ncax83VXU8yldLWGvpFNci2qpHQ9bbvgB1hjeiearz8IH0EkDhNqWSYWsTNy7p8eOq2Vy6ktp87BSPUJLyDCTt9o706HHvB9sbO5kf8EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YjwC4zgo; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YjwC4zgo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=uJV7z3H8pAHB1Y7A9KobxquZjedvC3wgafq5gopZbPQ=; 
	b=YjwC4zgo1nhN/4lFBr/MXRIQpBdSE/U70QbRoHsdHbKt5PcUKq3Cj/fzZLcmbdbcH6DND0pk7Wy
	qX/+lkefnckjJSl6RWt2x9WY84iR75OLC3+hrhOGmPChiOxw/NGATFYwUMG20VFDAuTsuaCWFAKH/
	TXdLWYLqcKY07Uc92Yad9O3i5cetu18TcBQFrtKlzxBy1SidOyQ/osETTB2dQopsmg/mM2r0CzLpJ
	NM66FGwKpvrzhO73HjVJbFz9oNlza8iP5Lqw5lqjJ94kma7Wm4TPepXkkJ2btZ4PcWAUzsaYO8NR4
	sOFwLpwYDxoYftJXCYqKRU95muioWi7REGew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJquz-002yO9-2n;
	Fri, 14 Nov 2025 18:20:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:20:37 +0800
Date: Fri, 14 Nov 2025 18:20:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karina Yankevich <k.yankevich@omp.ru>
Cc: Corentin Labbe <clabbe@baylibre.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH] crypto: rockchip - drop redundant
 crypto_skcipher_ivsize() calls
Message-ID: <aRcCdQu-d2byeFLY@gondor.apana.org.au>
References: <20251105145204.2888978-1-k.yankevich@omp.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105145204.2888978-1-k.yankevich@omp.ru>

On Wed, Nov 05, 2025 at 05:52:04PM +0300, Karina Yankevich wrote:
> The function already initialized the ivsize variable 
> at the point of declaration, let's use it instead of 
> calling crypto_skcipher_ivsize() extra couple times.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 57d67c6e8219 ("crypto: rockchip - rework by using crypto_engine")
> Signed-off-by: Karina Yankevich <k.yankevich@omp.ru>
> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> ---
>  drivers/crypto/rockchip/rk3288_crypto_skcipher.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
