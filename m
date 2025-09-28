Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A31277008;
	Sun, 28 Sep 2025 03:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759031911; cv=none; b=Q3LbzFif2FUI0lN3k7wV7yVUErBiCbqSWDthPFHwXnf2hC8KoNeJY6cMtRw2TAvknt9LRtkxh0Dzlk9r25rsAtN184CuoVUoRf+ZcnrWjeCUu0ebVXru2ceW4AG7aKXmaeoB4eDkOe24/2ahhstTi4HR4OwaPZiLzJxA3dcPp+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759031911; c=relaxed/simple;
	bh=1pCNHyM5kMts+zlbtg8ygMKLp1Ukh6NB2xSxBABZeEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bZEq1Vpzci68hhEFiLg9o+ST4P+eL9Ouxqrp7tWA71CQKrR33khlWVaPLmZaC5wzHiac3ck3afqz+RnPOGw1Le0gpJnY2TdCSG0ilofunGA+Uq8U813pPLiaOnNdo2KQxUUNoppYZOnwLzuQAhH4uM4ejkv2SPk6N70mZNaTai0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=V7sFqOtQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="V7sFqOtQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=ifRi3a19UAwBZ/2XDD+9SGBAyv9/QfQxtDzcdHTpBvU=; b=V7sFqOtQqWruUBXaIwg4dDBPab
	ioL7nCNBDLoCgqenBOLDF+IQNNGAPy3T48cr8ouFh50eQ0Bv2i3shhVn9Knu85wRe/rZpjFS8Gcw5
	9sXq5dI+cYII6yOxYk+jRD+2nOnd1Eh/XvzUElilUzeY+92tRL87crVTSk/fiFq//OSsk0ZCFMRFJ
	JEKs3M0uy303HaNssXKl9P/eraseJ2H9lmSPv5tXVNwIW0m7a2Ff23dRVuCGjev2U/zKmarNkoinv
	5TZ2iEkyIbdM98+MCT0KfhuSEnW+tFzjFyDDDQ0VygxBO5mRZ6p+dv7NSu43uIOsFmMezieIHMKhf
	TUSfdmOw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v2iYA-008qSr-11;
	Sun, 28 Sep 2025 11:58:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 28 Sep 2025 11:58:14 +0800
Date: Sun, 28 Sep 2025 11:58:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nishanth Menon <nm@ti.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	Olivia Mackall <olivia@selenic.com>,
	Alexander Sverdlin <alexander.sverdlin@nokia.com>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hwrng: fix division by zero in ks_sa_rng_init
Message-ID: <aNiyVogNAXQ3AtuT@gondor.apana.org.au>
References: <20250919132002.180874-1-nm@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919132002.180874-1-nm@ti.com>

On Fri, Sep 19, 2025 at 08:20:02AM -0500, Nishanth Menon wrote:
> Fix division by zero in ks_sa_rng_init caused by missing clock
> pointer initialization. The clk_get_rate() call is performed on
> an uninitialized clk pointer, resulting in division by zero when
> calculating delay values.
> 
> Add clock initialization code before using the clock.
> 
> Fixes: 6d01d8511dce ("hwrng: ks-sa - Add minimum sleep time before ready-polling")
> Signed-off-by: Nishanth Menon <nm@ti.com>
> 
>  drivers/char/hw_random/ks-sa-rng.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> ---
> 
> Noticed this when looking at kci logs:
> https://dashboard.kernelci.org/log-viewer?itemId=ti%3A0af42187f4b24261b0c102f0&org=ti&type=test&url=http%3A%2F%2Ffiles.kernelci.org%2F%2Fti%2Fmainline%2Fmaster%2Fv6.17-rc6-43-g8b789f2b7602%2Farm%2Fmulti_v7_defconfig%2BCONFIG_EFI%3Dy%2BCONFIG_ARM_LPAE%3Dy%2Bdebug%2Bkselftest%2Btinyconfig%2Fgcc-12%2Fbaseline-nfs-boot.nfs-k2hk-evm.txt.gz
> 
> Fixed version boot:
> https://gist.github.com/nmenon/0996e5f7bdbcd3b014cee9921a60d88c
> 
>  drivers/char/hw_random/ks-sa-rng.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
