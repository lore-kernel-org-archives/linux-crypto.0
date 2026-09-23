Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C805443A97;
	Wed, 23 Sep 2026 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153439; cv=none; b=aLm1l2Fm0LnexUoK6XNXkhtTkIRi5bn8shZvBJYRTX4YbgfYbvtCrtn85FV3Lu/tYOlSwJday4J46McXg0Ox4BVP+7h4V29aXjCGMPgETLqiR+NfivpS/hEOH1y9AC89irtlpxEN3Trtok+4CUSkcb20KMhDyEFXAgVZIkYsHt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153439; c=relaxed/simple;
	bh=JRPPgXFAau79Y0JqwITpnK4uPIN8AVrpHArRYe6LJYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRajjDchQVvpT4CeEjh1DwU5WFJnT8ucdSQd16i3dWV1CJZf9RlzzBgWsTfAehOdkeB4LIZg3X7d+KjBoSGo45dgfJgdHP5bn/6AINjy8PJXCNroqW41PmK5v36hez9+ZNPgKPSp6fKOTniMKhnRcXXXzN4NB42WHr+xTFJN6qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YBMp5weZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YBMp5weZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=mLJwPVslVmxbfOK/h/qXZ4Q2+9Q1t7IyYizljFrDCCM=; 
	b=YBMp5weZE87ZVfePbHM5EY5IJozWbIw/V8aY0fxIAnNbin+ESql1b3qIcORFUgzxy+D0jBBpWP0
	gDGj7pneeqJ5RHlrg1B9dNONzQKRtnQGwBi7/nMBtG4FPBJTZenjyogOli/4tVyjW+6tHdw4FlK3Z
	vkvjAI3nTt5NkwonVQ+y+PcdvsfW2FAppTNQe9oVA5sgzWc/ST+iLlj3t97q0tBF6aLXZzkM2Lj07
	7ODy7lt+wzsKKFu9bN4snYSV+Zdix5T5hpqTb+g6YGvr9TqUedXccxGLLUZu5S02zzgvhRk7qcS9k
	uZ8+K+aLPHBtpB3W5NTCdS6xUTBisyR6YFRA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9IgO-0000000GyDQ-38EF;
	Wed, 23 Sep 2026 16:50:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:50:28 +1000
Date: Wed, 23 Sep 2026 18:50:28 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: clabbe@baylibre.com, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, jkoolstra@xs4all.nl, lkp@intel.com
Subject: Re: [PATCH v4] crypto/amlogic: Use devm APIs for clock management
Message-ID: <arOS1D2qj8kZd6dK@gondor.apana.org.au>
References: <20260916174227.5581-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916174227.5581-1-raizudeen.kerneldev@gmail.com>

On Wed, Sep 16, 2026 at 11:12:27PM +0530, Mohamad Raizudeen wrote:
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
> Changes in v4:
> - Fix typo in meson_allocate_chanlist() function name.
> - Add error_chanlist label to properly free chanlist if IRQ requests
>   fail, preventing a memory leak.
> 
> Link to v3: https://lore.kernel.org/all/20260916154941.7254-1-raizudeen.kerneldev@gmail.com/T/
> Link to v2: https://lore.kernel.org/all/20260901024302.5407-1-raizudeen.kerneldev@gmail.com/T/
> Link to separate IRQ fix patch [1]: https://lore.kernel.org/all/20260908160120.4805-1-raizudeen.kerneldev@gmail.com/T/
> 
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 31 +++++++++--------------
>  1 file changed, 12 insertions(+), 19 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
