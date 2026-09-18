Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF89284690;
	Fri, 18 Sep 2026 09:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789722548; cv=none; b=fPajz1cHpJib91b6zuX1XhuyXBZY1BtCqiV6PVqWpMKka81qaEIotjrWICIGN+k2vVQA//BNfrNUxcY8kzJrrpYzxkEjfS9rPmw9utb9VqfJ1WKyLW310Xq+pz9EneGla72KXuqib1FZsMkZjzya4QzGOlxWaaOaOF23c7cIbVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789722548; c=relaxed/simple;
	bh=9+lWLER+rUa7/ceW7aj7nn67eT8arJzBiCs82po8baI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uo1yrBde8PaRYt98uBjM3R95UUakTYUPpA/mwMPQwKBSOIhnniV3iUKZIZeto4ecYB5qojZfQ5scowt28wP8AhX2wZuYDIoh3FtEUvhbRg+/aJyrgXzbNQfW1CNHli6doFdLrCiQ8MtSW/wV0UF7hrrCgmvFuNuwOBKooBkVnv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hHXCYHng; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hHXCYHng"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cKQJ+IzzRx5F3on6fiLdD2Ma2xWSVDZn0K98Cnb+3+E=; 
	b=hHXCYHngOy9rd5o77kurEKwJ2YUgzji3s60w8vVHtQbC9KosrNBKZA4uz20dPBLooIVgeX9mrGo
	uTEHY2b+u0RjJJ9FfI8ChCaAZ0xEjY7Gig3I8xMLyzEWRR1F/Kz4gmJjDVEk7pl3mEnM0//5IHh9c
	Y0ijqF9qR7O4hgHheOvbGHIe+5BuD7gPPaPnoMYswTm5rEP3tLZEpY3ByHs/g0L7h4W5i7CGI9Ik3
	O+pGxwi9h/c38/DG96Z/f1FQLmL+ODv3zssTL0JuvXGxedP2n64TexhRZq4x8Qrm8taT04k9es4sa
	lGsxHaqlyeOP/tfpNraALh4HL5IQypoU8pSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7Uaa-0000000FKz1-0bRA;
	Fri, 18 Sep 2026 17:09:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:09:00 +1000
Date: Fri, 18 Sep 2026 19:09:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Sebin Francis <sebin.francis@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/15] crypto: ti - Fix spinlock inconsistency in
 DTHEv2
Message-ID: <aqz_rKnEDvtobXXB@gondor.apana.org.au>
References: <20260910175619.2122149-1-t-pratham@ti.com>
 <20260910175619.2122149-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910175619.2122149-3-t-pratham@ti.com>

On Thu, Sep 10, 2026 at 11:26:06PM +0530, T Pratham wrote:
> Probe and remove functions use spin_(un)lock for acquiring the
> dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
> spin_(un)lock_bh to spin_(un)lock to avoid potential deadlock when a
> softIRQ process tries to acquire the already held lock.
> 
> Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  drivers/crypto/ti/dthev2-common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
> index cc02449382673..4c6b72ba104ec 100644
> --- a/drivers/crypto/ti/dthev2-common.c
> +++ b/drivers/crypto/ti/dthev2-common.c
> @@ -39,11 +39,11 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
>  	if (ctx->dev_data)
>  		return ctx->dev_data;
>  
> -	spin_lock_bh(&dthe_dev_list.lock);
> +	spin_lock(&dthe_dev_list.lock);

This makes no sense.  The only time you can use a plain spin lock
is if all callers are from the same context, e.g., all with BH off
or all with BH on.

Because this function is called from the Crypto API, which allows
mixed BH context, you cannot safely use spin_lock.

In fact Sashiko reported this issue too:

https://sashiko.dev/#/patchset/20260910175619.2122149-1-t-pratham%40ti.com

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
