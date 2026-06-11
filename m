Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9954C35C190;
	Thu, 11 Jun 2026 08:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168011; cv=none; b=oRyAErEB6z6WA/G9p7qWjXUQv9bBvnp8T5yVmiWhjx+eijun24CTBWYi9yH1Zso84Hmc7sha2rPRVQYDhXO8B6uu7chL+VDp6CCazqDizlSpPOJ4BzwJzInFPVrO5I6meNHEDU/ApjIYpkPPgjJbqLdDHMoes2b8pPQymxiFyeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168011; c=relaxed/simple;
	bh=AeyGtm7JsZ53+PQXEN6bE0OjgYNmvNxowPevAl9jHyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYmGEZYeQ5434Zhv2at7cEb0OhosT/WI9qz5sNpu9I2u5NC/CzaKFnVDI3J8VBNtvJ00iXuEBz+cPnjAWgMPFSET2P7ffVEI40bc5R4dgd75XACpEabYrRlk8f8qP7+WU3spLhQaHldkUffTg8sEX+uwJ/CITrIDtHqCU9X49Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NSd/vj5a; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NSd/vj5a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=WitVYfJkDkCXd51OYQTSGhKAShEFeP8PItDxRgN1Pzs=; 
	b=NSd/vj5ahlVJsAoSWjX6p3hrRCJk4xFYCN3OX9+BY9yQ3EJXH4FutfUvZ/mcuTUhzhhvmqgXaf8
	VTVESSEoTevfBa61kTGfqHSf/OstcGnzsJoB/pf5KgvIGzkAfaw++qehgpjWELvDDK+zwmLkYKKNH
	22nUoefn/t99X27mkWdlEcGxmZn0o6VOYeCEvVzaVums0CYHWtbAJnuzOhpgLqckZ7LKuxG3TEZbF
	Ye69qEB0i/W4tNzJlRZ8ZyXJh91ii3Q6QTXdchXMpE/ehO1y0SDqGmIIBxD+Vy8n5TFZqWlhAmyoA
	agWB0WtdEXFVJsYbocI174xfc9yQFCM+FR0w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXbAD-00000004XbE-2PgB;
	Thu, 11 Jun 2026 16:53:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:53:25 +0800
Date: Thu, 11 Jun 2026 16:53:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: amcc - convert irq_of_parse_and_map to
 platform_get_irq
Message-ID: <aip3hd_sjLs1Uoou@gondor.apana.org.au>
References: <20260602014645.522137-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602014645.522137-1-rosenp@gmail.com>

On Mon, Jun 01, 2026 at 06:46:45PM -0700, Rosen Penev wrote:
> Replace the deprecated irq_of_parse_and_map() call with the modern
> platform_get_irq() in the probe function. This also improves error
> handling: platform_get_irq() returns a negative errno on failure,
> whereas irq_of_parse_and_map() returned 0.
> 
> Change the irq field in struct crypto4xx_core_device from u32 to int
> to match the return type of platform_get_irq().
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 6 +++++-
>  drivers/crypto/amcc/crypto4xx_core.h | 2 +-
>  2 files changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
