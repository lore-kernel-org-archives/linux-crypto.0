Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E74C13F42B;
	Fri, 26 Apr 2024 09:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714123782; cv=none; b=jK/TQJyAk4zFSBMWCN0AhDy3HZNHckdMJAAH456UrzV88jOEWI8nFuAfRnNCpivQ7ikUqURBli989xngg6/+iT5qbBQr/e0ordNwXWNVykg+TvivFXFdRbf5ijmFTJiB53yaYgXuLgXeAIpmALVaS2yHAl4sdeLhXk9xIkr679g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714123782; c=relaxed/simple;
	bh=owwDRQE7yKWZ1zr51Il7f3MkTI2pN2XkpCFgTUiqE4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhgpzJeVlN4C7/4tm3SiDDQL9tKCnyu1n8W0lK11ZzRbdFhO35o8KoNvyvw1oUWrS03SFuhgc3vR+IuJ5bLNhJ1G/g1z1JLtXFIDq3eiXbHycUMGsvcdjr2e8Mbxs9NDm5wOxf6LoURfgoDHjDVmg7Rtb2M/71qwiUGbtQVBAcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0HtY-006eHu-V4; Fri, 26 Apr 2024 17:29:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:29:46 +0800
Date: Fri, 26 Apr 2024 17:29:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Akhil R <akhilrajeev@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] crypto: tegra-se - Convert to platform remove callback
 returning void
Message-ID: <Zit0Cg8nFs2HDBsN@gondor.apana.org.au>
References: <20240415073422.8274-2-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240415073422.8274-2-u.kleine-koenig@pengutronix.de>

On Mon, Apr 15, 2024 at 09:34:21AM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> this driver appeared in today's next. Given that I want to change struct
> platform_driver::remove soon (probably in next after the upcoming merge
> window), it would be great if the driver could be adapted immediately.
> 
> Best regards
> Uwe
> 
>  drivers/crypto/tegra/tegra-se-main.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
