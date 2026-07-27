Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3BF219A8A;
	Mon, 27 Jul 2026 00:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785112456; cv=none; b=sI9BAO6Fm5QU9LL7EU4thKIxUVIPihs7D6BPogquYYNMLsmMYm3lo6P2je/ww0NaH41ot1rrZ1gSWeKvDynv52fMiY7fPmiAFiv808RfeX0/Rit+YhsXhCU5zRplwJz74if+nVDhfuI+99V/OUWHtl4/vlPq95kED5ZKIW43jWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785112456; c=relaxed/simple;
	bh=/stAEnUsALIQe4aGWZl8xSB7pvQQQyzMNx5bhvr7QR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7Fe5RJkJ18+TbNqsIiPRgBaz5cZ4drDDJQCVayt2t7EtikJ0HNbHA2BL5JJunF8MUfQ4uB1rWC0XINsON1UvSvvcDWCozsV2E77jjoo5e285rwQbihnIVwHEJiwTsAJAVXZoP0LBw8Os7wJg4WqeDHTnoeAzBfI1z+QakwZeoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MxVuFBd4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MxVuFBd4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=3fyfllA+R03i6FnaVrgJld9P8d2aBVaN8jFttLwLF5g=; 
	b=MxVuFBd4qypLAAe+SaQeGV7lQjUicsxDa0ZvhYZmggN+2KDztjG+II1J5T/uUPS1eMn3rl+tphL
	4PAt7cWKcNP0P5wiR5sH836vI1PL33pB7ofSE7R+PCDQI/E53i5CxCNeqrS49RuA7z9GiWOxAfi8u
	h+YfSap2wsrPYxLwAxl4AryPtK0x6R+4fky8abQE9ThL5W4Fp8sVDEpNDFURt77KZSFNySVnSL8fA
	vTUVC9SuaXIfpEns7nwTJyGfUtHDfwQGsLR5mOHJqqt7DQ3TSFjRaisNS13Mgwh6lNvuvOVB1P1dV
	hS3rszImHi+90Pq5KEKfoRSGPM7ICJhLitJA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo9II-0000000GyyL-3tVX;
	Mon, 27 Jul 2026 08:34:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 10:34:10 +1000
Date: Mon, 27 Jul 2026 10:34:10 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: omap-aes: use
 devm_platform_get_and_ioremap_resource
Message-ID: <amangvQzsgdLq6Eo@gondor.apana.org.au>
References: <20260715215848.410011-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715215848.410011-1-rosenp@gmail.com>

On Wed, Jul 15, 2026 at 02:58:48PM -0700, Rosen Penev wrote:
> Replace the open-coded omap_aes_get_res_of()/omap_aes_get_res_pdev()
> helpers and the #ifdef CONFIG_OF machinery with the managed
> devm_platform_get_and_ioremap_resource(), platform_get_irq() and
> device_get_match_data() helpers. The omap_aes_pdata_omap2 fallback is
> kept for the non-DT (legacy platform_device) case, and the now-unused
> err_res label is removed.
> 
> Assisted-by: opencode:hy3-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/omap-aes.c | 84 ++++++---------------------------------
>  1 file changed, 12 insertions(+), 72 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
