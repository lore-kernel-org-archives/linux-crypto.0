Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0934AA566;
	Wed, 16 Sep 2026 09:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552205; cv=none; b=uFm0+VbBlLpIi/xPqtUN71o5OKbiwOUpYUBHqob/tq2gkMROY6kCSpbOPpTkrv/kWrxgTo4FGmTT4GLKL0YGafH9JD4UfrjVy8QoHGjnWzOg4m6pteRfQrWeovCF1FA7vkShNorCLuDs+KuJ6ThnqhcbtINpnkwBudGhgg6NO2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552205; c=relaxed/simple;
	bh=lcClBkjB32WNcDeTmu1ogtDrNFhEcfQ916rGE/SAyaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pPfKET7kkGQ4alARqmkgn3Hn5h8TmSiGlqxSftj6ttXHUTHxOEBMkG16k2VPiurcvYZiA4E+rYaqHtKcbYtesLhzabsxXmT0wYkq3VPwMY+7+mY9v5MLaWa879EPALjilXk5DiAixCYnvBtlWcecjmWrwxDwtjJUfc7zf0XEF64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NetxLrsx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NetxLrsx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=njikc4nORIsTPxlkCFcPQm3BO/kRWtHCUlB4reb5W0w=; 
	b=NetxLrsx/2fBWdXmzAZ44G444i0SA0dSDU6XvfWx6LY9NeKda8ptCKgQ0fTVgPwKcOJnIO0rxkJ
	wWmbTCu/15PZVHNApw6jkFEozSWa4KLcNS6OtPLgjOn69LBn5xv6LIRfNSwKv8GsoFrps7mnFwxTB
	dYm9vsv+TZqk2o6CVAK2cVSk4bJgBKDsGLMi3QPlpOHfrFULTuNrZdCJT7qreP5smQtnjKCXXYBVG
	xlrcbl1LJ/JqLTx4CEtlBg7YTFgPURsqjTIwg44CW2ObZA4ca+Gh2C3fne+PfBheL1iYer0tXmzBI
	xiSACKUIijQnwlojV/kbYlOB8Ru+HNgZti7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6mGx-0000000EYyY-0Ta6;
	Wed, 16 Sep 2026 17:49:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 19:49:47 +1000
Date: Wed, 16 Sep 2026 19:49:47 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: clabbe@baylibre.com, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, jkoolstra@xs4all.nl, lkp@intel.com
Subject: Re: [PATCH v2] crypto/amlogic: Use devm APIs for clock management
Message-ID: <aqpmOzURNFOm78ls@gondor.apana.org.au>
References: <20260901024302.5407-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901024302.5407-1-raizudeen.kerneldev@gmail.com>

On Tue, Sep 01, 2026 at 08:12:52AM +0530, Mohamad Raizudeen wrote:
> The driver currently gets the core clock and manually enables it using
> clk_prepare_enable(). This requires matching calls to
> clk_disable_unprepare() in the error paths and remove function.
> 
> Switch to devm_clk_get_enabled() instead. This lets the kernel handle
> enabling and disabling the clock automatically, which allow us to drop
> the manual cleanup code and keeps the probe function simple.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202608310329.QgxCCMs1-lkp@intel.com/
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
> Changes in v2:
> - Dropped the devm_crypto_engine_alloc_init() change due to build
>   failure reported by the kernel test robot.
> - Kept the devm_clk_get_enabled() clock cleanup as the sole focus of
>   this patch.
> - Link to v1: https://lore.kernel.org/linux-crypto/20260821151303.8150-1-raizudeen.kerneldev@gmail.com/T/#u
> 
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)

Please take a look at

https://sashiko.dev/#/patchset/20260901024302.5407-1-raizudeen.kerneldev%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
