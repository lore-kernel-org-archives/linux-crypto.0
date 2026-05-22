Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75D138F251;
	Fri, 22 May 2026 12:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453185; cv=none; b=lI7deRKp053uU58h0YTeXtdTPG0YVo857REqxr2Ey2vosGPB5HQpfnnalEqpIJPYaTtjpHAomtHhUbo+T6Syxoiy4dZT58pBylFZ5DJ0j3TI6H8BPp1g66FGqsYu66jS8nF7TQU5fZupuH3QMBnNI6+JJuZrFI0Y6TIPVYnhxEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453185; c=relaxed/simple;
	bh=3l58wQ4GgI2lwXc/VqgtiFFwbwBsk1Lt69DUPDrfu8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRbTTsm7sf728Y7LwCcxyLroRjK21cZlfeh4m84TEelwoukt5+Tv3OCmCr5uDchmUaeMzWOiyN5wkVI3XdZxGHeuL4delUYgKAEOcjxbjHlkPewcAtMD/lAh+L6pFMYCOj6sBDB5FgQoiVNmjzQc998k5luwpqAPYK62/YTgVwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=G0d18tSL; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="G0d18tSL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=J5RJHoSNuWSt7X/qWWuD0nqDl1wz0DoB1HUcmFQ98RU=; 
	b=G0d18tSLxzUXkkkaCTT0DfGxsFZ+679GWPXm33atbcr3aD9gaW/gs8pbk69t68LhTxh4QU5rq6H
	ZD1C8TBYgRXnbyC5wDFNqFHvZxsh2Rf/s/fuJVnm+Z01YQ3IaNcoDALEdZIF0s7O4jIDb3jTBEqag
	1ZVm1cJH09VYysIOqkYW+n7aQkBqIjbPwmuJQw7126sxnRpVugMa8TxNnAkyfnnOAu+rQoZImTIBs
	sn2oq6IfemVcjhKakZkq8XRihhCJVAdQN9Z1JlfqU0YgewznXP0KFxIyKG4nulufcAdOuDz/1OXs7
	R0vGVQWaco5ul0P3X5zdRFUQPJDL+TKXT/HQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP3e-00GSRL-0z;
	Fri, 22 May 2026 20:32:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:32:54 +0800
Date: Fri, 22 May 2026 20:32:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Aaron Kling <webgeek1234@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: tegra - Don't touch bo refcount in host1x bo
 pin/unpin
Message-ID: <ahBM9lBhn1VoXOn6@gondor.apana.org.au>
References: <20260515-host1x-bocache-leak-v1-0-a0375f68aeab@nvidia.com>
 <20260515-host1x-bocache-leak-v1-2-a0375f68aeab@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515-host1x-bocache-leak-v1-2-a0375f68aeab@nvidia.com>

On Fri, May 15, 2026 at 11:34:52AM +0900, Mikko Perttunen wrote:
> Since commit "gpu: host1x: Allow entries in BO caches to be freed",
> host1x_bo_pin() and host1x_bo_unpin() handle the bo's refcount
> themselves. .pin/.unpin callbacks should not adjust it.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>  drivers/crypto/tegra/tegra-se-main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
