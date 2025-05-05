Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3DE207DF3;
	Mon,  5 May 2025 12:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746448102; cv=none; b=XThY8v5uV5ZhUrpTQb764o0ktfMKWZKoVDF1JsUDGBVYl95D3o6AGOitqAQmDVG0S0/gUROXitJ2+2LP1j/vX4RVDQ8mY5oET/0EqzNF3K/MhNU+STT5SnLYGqRuvKwkipc7BDx/3F8pPYX3vMLjbPfLyBO6OHGSNgd3ZhsNhiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746448102; c=relaxed/simple;
	bh=V6ae1nujc2OoomkiwPjMp3duTY+xm3ECq6nf0m00iH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NiZ0BSiRpswQRaSCMbUx9L19lOz9cC2CzFMPVrF5Yv8hOrKuKHIg5OHCqjbE2sLc9RrTx5f/KtAej9KReO7f/XfUioM5NEk7AkFvp7IalewpegiQDv2CC1XLbF7WuDag6BeGIuErp6NYZTL3mH6sXM34t+yZHTaAiukWhAIRqD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MOVlBDjm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MOVlBDjm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2F4wsw1NZfHzd76CCShnKalzM/B3bViD+s8nNqyL9k0=; b=MOVlBDjmqKH4z8SI35gB1h9NBo
	MEq1Ih6dcpid5VW+fASCsOExnu1vbOL93VQK6Ga418/U/2MgxIT7wkGPqMk/uLygfH+OLvr0/TSo5
	+wz8FIHovJov39bReQhU6DPnTLOhP7hOC3gmYSxuYmJBpXBg/0CExEJ+8pnagkr7+1F9iEXrbuKpI
	/mSXnaRO9IS6lA4NzINeHE+bpf32OAMIOcyjzdqcrab1IWbOkzOzBMCY0hAFdwniK/vJbYSl55+va
	CeS4FoMtNKqTzmBUH8jrNw2nQ/k6hO9ec+wjqJUu0664F6gEEXg6pUzveV/se1n2jN2neYZnSRBhd
	evAioJIg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBuvW-003YIA-0M;
	Mon, 05 May 2025 20:28:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:28:06 +0800
Date: Mon, 5 May 2025 20:28:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: sun8i-ce: undo runtime PM changes during
 driver removal
Message-ID: <aBiu1idwaftlynji@gondor.apana.org.au>
References: <20250501190651.3863582-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501190651.3863582-1-ovidiu.panait.oss@gmail.com>

On Thu, May 01, 2025 at 10:06:50PM +0300, Ovidiu Panait wrote:
> The pm_runtime_use_autosuspend() call must be undone with
> pm_runtime_dont_use_autosuspend() at driver exit, but this is not
> currently handled in the driver.
> 
> To fix this issue and at the same time simplify error handling, switch
> to devm_pm_runtime_enable(). It will call both pm_runtime_disable() and
> pm_runtime_dont_use_autosuspend() during driver removal.
> 
> Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
