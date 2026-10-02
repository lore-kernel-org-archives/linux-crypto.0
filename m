Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FD82110E;
	Fri,  2 Oct 2026 10:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790936019; cv=none; b=fCpwDkXfO7Qu66NlhxnGtgdjxSv4X3YPMpvx22GMYG0A+SsloLe97D1hqTyPAs/jibW+oHxvmiq9mp/NpBbeP/GCfj4He7h7W53WH7HJzO7kasJykV5CBHzRkibEVyh7mzlbjGNrAB8ISdK251vOqXrfW5BOZdL/WTE7IUFLedo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790936019; c=relaxed/simple;
	bh=rssTxfG1WyM5eZZdER+mLqWF82PS3ItlgrkXt0YMRtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WR0Z9F+IxBVcBF0n3spNx+piha3zohlB2hm29WC64IAB3SsnTzAxyDK/JSxkXIlpLCy4AdksLBgHJRyyt5L6T9x4bixNCxZCWng7GbYEaVpH3GN15nlwP+mCkwtZXCVVuw3hF7NIkid2PhIgJ/SOZH3x0CRZS0/OLVHauQgPiJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Pjt1TKjq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Pjt1TKjq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=p+nimgUzuus0627n4B6PQmMno8yPLU04Y7h4i/7Mg4Y=; 
	b=Pjt1TKjqG45NWEXPsXDKzgG/mljk8jP/5rGwcG9ZedFDpMQIO+Grsqs2vO5v0mZ7paM2zaruHL8
	+m+VIYkfNqZ4E3Y9Cng5aFZxCy1eQghxZYvL0zEVvoeJMH1aHK2I1hvskkXd66TwucgpoV+TmX+RU
	v3uYJxEJhdzCNiY6jCVqYw0UfLYW2xDOYIpKkAV/uqpNLkMncvvVwY0RrHUi4AHJjM+aHEZ32JKso
	6Ig8o5RWzGk9UdiNl4jNOu4lDTxFxh0ST9io8Wt81Rqi1j9bm3/S5HrEPTMf5azuX+aR/q5NWQdpm
	JIsjhCnfl68hsS6yC8lXixxn6DxtQ15+0l5Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaGb-000000001i1-2pVF;
	Fri, 02 Oct 2026 18:13:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:13:25 +1000
Date: Fri, 2 Oct 2026 20:13:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Manos Pitsidianakis <manos@pitsidianak.is>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	Lianjie Wang <karin0.zst@gmail.com>,
	"Thomas Richard (TI)" <thomas.richard@bootlin.com>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: core - reject unknown RNG names
Message-ID: <ar-DxYN0dBs3FXNZ@gondor.apana.org.au>
References: <20260924212114.120633-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924212114.120633-2-blum@kernel.org>

On Thu, Sep 24, 2026 at 11:21:13PM +0200, Thorsten Blum wrote:
> In rng_current_store(), err is 0 after successfully locking rng_mutex,
> and if the requested RNG name cannot be found, the function reports
> success even though the current RNG was not changed.
> 
> Set err = -ENODEV before searching the RNG list to reject unknown names.
> 
> Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/core.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
