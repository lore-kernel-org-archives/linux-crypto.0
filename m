Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCB036A34F;
	Fri,  4 Sep 2026 10:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516075; cv=none; b=j748u7cwnHecAdRlOwliZalJpQnyY+/Y8mSR7oHk87gM55WGgqNS/sCovscM4WT2fp4vry6k02YaEyOJ8CxIEur3EDA5/LuUpIcpMYFkJCOjfxCobWX6i6JiFNAofW19I3dN5lMhj+2fZ3/+xG6xf8UwGPgZThEEm61/7ntD6lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516075; c=relaxed/simple;
	bh=zp3acMSxFHC0udAbClnsSrJvQhSfyujBHdInass4AD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cxUVoU+eJ52m14YsYHyanSANNQlkaFnHGNH5XBYkeazCByewQM1ekksu1T6vloR46fz928BKT3qYGWgEjUdEW8TJEs6qiS47Chl79MWEA7vA1m2xGaQYvUMj8GAXNFqEY2/erX7Zcd1Y4O+eoObOdDsT2+haHDTKrh82nJ2yfjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mMfJOAJM; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mMfJOAJM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=yanAzUyDM1RFTxT28yqLnHViLWSNc9I4o3LkDlLAfL8=; 
	b=mMfJOAJM6KPuDL/vChH2udtHKvlts30THaxGiH4qzx3J5gRQlY1Kl4IGTVRppW1AG+sQrvLWMQ8
	882btYVDeq79s+U+RXein+QXlA9zX7Tt5OXX0mpohxXHk6hbvhH2StDSaE/p3c9QzY8SWVcAAOKd+
	7SoKm/Q4SAvPfVVLGPwI5dodym6TxElCTbOGVu41EH3DhRDGG+F8S27dzngzhNmy0zaoJMnlLFm3D
	M1PXtB/s6cRQgRrQBLdZnZsFiFC17Lo8bIaIxNzND33RIkJOIZywuPmpp4yDfUYG90NHRFwrxQZMf
	7mf+Zvhtn2X+A63VsZEoxJJd3qAR61QuWkCg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2QjI-0000000AnJk-3pUZ;
	Fri, 04 Sep 2026 18:01:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 20:01:04 +1000
Date: Fri, 4 Sep 2026 20:01:04 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: cctrng - Fix runtime PM usage counter leak
Message-ID: <apqW4H4QqPCZXoG1@gondor.apana.org.au>
References: <20260814133933.1385764-1-ruoyuw560@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814133933.1385764-1-ruoyuw560@gmail.com>

On Fri, Aug 14, 2026 at 09:39:33PM +0800, Ruoyu Wang wrote:
> pm_runtime_get_sync() increments the device usage counter even when
> runtime resume fails. cctrng_read() propagates errors from
> cc_trng_pm_get() without scheduling the work that later drops the
> counter, so a clock or reset-completion failure in cctrng_resume()
> leaves the counter elevated.
> 
> Use pm_runtime_resume_and_get(), which drops the usage counter when
> resume fails and returns zero on success. This preserves the existing
> success path while balancing the error path.
> 
> This issue was found by a static analysis checker and confirmed by
> manual source review.
> 
> Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
> Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
> ---
>  drivers/char/hw_random/cctrng.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
