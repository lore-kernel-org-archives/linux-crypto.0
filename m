Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC174306741;
	Thu, 11 Jun 2026 08:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168088; cv=none; b=OYKcajN7actGjodmZBSsIrsCmmucoRyep5/6+qFb+aQ2CtTj+G4cC0WxOKcdSlmWNb0jrDfN4sDBPbAKwIZI1sH5Ssifr1Q6/TkCtCyTtdfPq9DfR5LcS67+ZabVfkPRKsJuxDrmt5ZAdXEfjMz5OH+kFZMdIcoUdTJE85o9lqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168088; c=relaxed/simple;
	bh=YEJZfy9QY46g+ae8XBphy5TsxEnOqLWMXGmzZNdOuew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYAnbOqPaWLveV1sKafop40vuHnam+bmXFrVdlutZ+VeM5SmpOwLDqocdS41sOdTM2ql+IzZjw2+OQBAlMz3IU+TAyBw9MYRZuqnuZAixFpFSiWU/NWbuzBM0TGZZpQB87oknw6Yj64kXo1h3Tx6JAByOBwSP/zgjoPuEJUMNCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=i3Jq1p6a; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="i3Jq1p6a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=m2ko7DiHoP+qaaPuL/wZDTmbNapXMc/WLpQKqkcamEI=; 
	b=i3Jq1p6aYT3AfIEqwa0vTvN7a5lE9AN9o58lx/tSsT5YSns+wAhFT8UD/YZCjDDKCXccxmi/aD9
	eOes8oqnh1KAtRhf4ZsfV7P5BZDj3/oFp6wO0e/HRcyHkFhe3wv1rHdy+tb8eXXzIud9xAAEEsB7F
	6+5kS4wNVrm58BPZ5MljeSzvMItojQVtdUYSFYAMBDqqVyPm/VUItAc/APV+f3WVz0FrMcjd9v4om
	rgn+Hm9vH/xzaK/7HTQDWvkh+Qf2AMseBCqmODjFLohnl2AuDjD3ASWVoaGUxayeJtA0lKsKljocI
	IjEUIUM/NRX8icg3DVp9ioCa8INy0iJSdYgg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXbBS-00000004Xd5-2VMv;
	Thu, 11 Jun 2026 16:54:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:54:42 +0800
Date: Thu, 11 Jun 2026 16:54:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: jiajie.ho@starfivetech.com, olivia@selenic.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: jh7110: fix refcount leak in starfive_trng_read()
Message-ID: <aip30p1GyFsptpjQ@gondor.apana.org.au>
References: <20260603110327.3750514-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603110327.3750514-1-vulab@iscas.ac.cn>

On Wed, Jun 03, 2026 at 11:03:27AM +0000, Wentao Liang wrote:
> The starfive_trng_read() function acquires a runtime PM reference
> via pm_runtime_get_sync() but fails to release it on two error
> paths.  If starfive_trng_wait_idle() or starfive_trng_cmd() returns
> an error, the function exits without calling
> pm_runtime_put_sync_autosuspend(), leaving the runtime PM usage
> counter permanently elevated and preventing the device from entering
> runtime suspend.
> 
> Refactor the function to use a unified error path that calls
> pm_runtime_put_sync_autosuspend() before returning.
> 
> Cc: stable@vger.kernel.org
> Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/char/hw_random/jh7110-trng.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
