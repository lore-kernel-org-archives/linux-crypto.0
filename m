Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0255371876;
	Wed, 16 Sep 2026 12:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789561939; cv=none; b=NmcYi1HtRCKBWYNQl5ax844SnsoHg3GZbofpPv3SzLG02dCy0O5XU1JZiR7Ucrnaqv9QEf5qKmOpGGYdT7DthAwgj8zl6rhlNjSpsBulSWddE6+MD1L/TSKPk8TkmgNISYjaFGe0k0wBx1GtIOWLGiNOmiLGw9u5xYrFmufcnwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789561939; c=relaxed/simple;
	bh=cITxidtSnPIIBQhlNy5nkHr7giFt/NXtpf76vgl295g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYUnGOxcsKc9to5sC7YDtDMP+w02cVQkG4xn/vCCKljazhDfAKEKOd5QHhWNW34idJW4Yll/2xkCc4Il7mz0NXh+Fck0o4TrM5UG1vcwav1akBtw1N4CWpH3vjdjxX1qrgeeH7ZU2YZtmmVMArwBVBcEnfRv4IJZv1HCuNZohOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=W3ubU2Gq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="W3ubU2Gq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vI4CRNUvTksW7MIwBavqA71EpNN/JVS4/CrW+d7hH7s=; 
	b=W3ubU2GqrhLQopKiKCHzbycRbpDoOb9M0mn5HeL+F9wm2ToUle5npIupmcnOxHu5Ce1BA5iEkuQ
	21VY1DHstqjMSuBy0bDn4IHV9FRq1zzbRf9UnrtmcOWGtkP4ytzd544q4TWnl2vlVWnLBkfW/cANJ
	gtRYEet8kmnrew2cdK4sI2NV2FbZtNYW4kDi5/9lbjrCwEkhUgcFAqlZ6yuv1VamjtfKVrcJurBQC
	M5ktfPHOB+uJyFgbl0gHOWPtSm6gxp9qQIt2sNt8F5+CKFK7ZetmgmkK+FlWC/k0HBNAUMmjua2XH
	klN3xjPrccHRmwUuXn3XBOgc4LTEvCa6LscQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6oo0-0000000Ec5l-2Vg9;
	Wed, 16 Sep 2026 20:32:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 22:32:04 +1000
Date: Wed, 16 Sep 2026 22:32:04 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiawen Liu <1298662399@qq.com>
Cc: Deepak Saxena <dsaxena@plexity.net>,
	Olivia Mackall <olivia@selenic.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] char: omap-rng: fix runtime PM cleanup
Message-ID: <aqqMRKATsLFj4jFG@gondor.apana.org.au>
References: <tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A@qq.com>
 <tencent_0D4EB3807DBF6095A7F5A9455D902DBA9708@qq.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0D4EB3807DBF6095A7F5A9455D902DBA9708@qq.com>

On Fri, Sep 04, 2026 at 02:26:54PM +0400, Jiawen Liu wrote:
> omap_rng_probe() enables runtime PM before requesting its optional clocks.
> If either devm_clk_get() returns -EPROBE_DEFER, the direct return leaves
> the runtime PM usage count elevated and runtime PM enabled. The second
> clock lookup can also leave the first clock enabled.
> 
> Route each deferred-probe path through resource-matched cleanup. Return
> directly after cleanup so normal probe deferrals remain quiet.
> 
> Fixes: 43ec540e6f9b ("hwrng: omap - move clock related code to omap_rng_probe()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiawen Liu <1298662399@qq.com>
> ---
> Changes in v2:
> - Use the full author name in From and Signed-off-by.
> - Return directly after deferred-probe cleanup to keep deferrals quiet.
> - Add Fixes and Cc stable tags.
> 
> v1: https://lore.kernel.org/all/tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A@qq.com/
> Sashiko review: https://sashiko.dev/#/patchset/tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A%40qq.com
> 
>  drivers/char/hw_random/omap-rng.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)

Sashiko couldn't apply your patch against linux-next:

https://sashiko.dev/#/patchset/tencent_0D4EB3807DBF6095A7F5A9455D902DBA9708%40qq.com

Please rebase and repost.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
