Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6401327470;
	Sun, 12 Apr 2026 09:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775985399; cv=none; b=sZaBEFTYkG8bMoF5hR0D/Y1To9TBtA1ow3z3RPUnFrEPZRm0/PC+KVOIXYMmhk62eBq/ae8ff78HvK+E/KtlU8ou2rEPqJeTaUXMmHGv9EaoYM7AREV8bQIlwnTkHVNWP1vDwlRF2W++J5L1ZvxFKFJcXdnUumuQBT42OOjeGuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775985399; c=relaxed/simple;
	bh=GQiqePXHutCUc9RI5YvEMdtUOtsXIZCcx9Q+LVDcNj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hn3X4dZ1HieH0FfxJQuPYE1JcIpwUjQhHgf+nWvlgTmhxLiYj20/fuWja3DzCU+M8JZPpqFUw1uOyLNm2xvuPinaMrnFi3Ldp/D7AQk5Jzc1U+o0kVNQCwasRMADLQ/4rEkOgkyy6PR8Sh6H64Tjh71JwUt5Zsg2ZcdHI2xU8jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ghwLd1QB; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ghwLd1QB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CTovshi1GqmNEB4X/qx5YwzrJwn7Dy1PAzbfxM8YoYs=; 
	b=ghwLd1QBr4ky60ey0JBGQmk90Qlz+DfCT9t4ZSvB4ZG6BFCFAWPYaz8eHQKjX9tOMereGbQ30hh
	vxW6AH3VPGjCGYtRm07U4WPoc0PVQjpdljENjCiyNu2dqSO5OeXRsutyyxgT4PXa6S+JkOskGqzYy
	r78QLUpyPGQrcLkgiF4eS6vosuXf0eGY3VNErUl7JCEXFifRCvYVBdA68WZYPAr3cdU8AwFekSITP
	UfowQzKhPJguxFjd8SH4HXLlEaRUGES7N75S6Y2/+hn0WdwsKfq96koaL0aZhqrIEwEKqy/9zNw96
	hGgwj8fGtlqzMlTL952u/YD4af0c5CceUElg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBqW0-005UUi-0Z;
	Sun, 12 Apr 2026 17:16:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 17:16:19 +0800
Date: Sun, 12 Apr 2026 17:16:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: atmel-ecc - add Thorsten Blum as maintainer
Message-ID: <adti42hn8JLKdpFL@gondor.apana.org.au>
References: <20260403112135.903162-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403112135.903162-5-thorsten.blum@linux.dev>

On Fri, Apr 03, 2026 at 01:21:37PM +0200, Thorsten Blum wrote:
> Add Thorsten Blum as maintainer of the atmel-ecc driver.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  MAINTAINERS | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
