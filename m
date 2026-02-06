Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1055935FF6E;
	Fri,  6 Feb 2026 10:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770374907; cv=none; b=IwUUCBRRtrXKfGlNBXwwD5Po6F48M4bnB8iZ5NUiTJKJPQMFmdcGZjXCiK7BOypYNpEO7zIyW2vxv40bFT7gyvdL4L03k1elgi8kUX5f4bmCBN6H/S2/7BOmNLUwOKvNs3AtWtMl378qIhG3qkRJoVK5xtR2OuUEV4pmeQRb2/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770374907; c=relaxed/simple;
	bh=xZahdDcIiXNmiWiQpPqsuGaQ2D81aGB8Ufd1t8I0GWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAF3W5kvl1gPBJ/3PyGtZuckXbjnijKmcIkJ26oWUPeil9H24UIaauJXPF5svC1dIzany/Zxynu4c1qvjHxEYv6cbcpWfLpDzNBAr6mSymTtp4z624+1Yq3lkOxIXGwIujiZo/AVuYVQ9+0nr3vzxucp4x8gNYtBojfKH+7iMH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HWLXCPne; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HWLXCPne"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FnLp+WfYpx0MNvkgCWm/fXSiKjmhsszDBOKmLwjwMCM=; 
	b=HWLXCPneoPqOp2feilbLaD8sWXv+kMGDHjz5oVF5J6FrhZMF9zOfUEenLetiTDLcubVGHb3CP6w
	R/kYrwQPJdPGD2DX7HGMmM9dkwpo8J4oRiKfPR6laFL2qe9emMStjQtG08/cDXsgvDa4J15xOYH/1
	/7vGAwLRfRu1FgiWAk0noV7ZCwq/E4pRL39BVpZkdbIU2SX7bXqgPL/AlrNisk+q048ckcorGoso2
	JWw4WTteqABY03wXPgqiJ6UXHd4jaoG7t01QPHor2NuDeCHztvJL6icR93opPsV5pSCIF19Szh+/a
	OY1G7qcUe8Z3Y6eqaLvJhmN4WXoNGMFJEkRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJNV-004zIe-0o;
	Fri, 06 Feb 2026 18:47:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 18:47:57 +0800
Date: Fri, 6 Feb 2026 18:47:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com,
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 02/26] crypto: iaa - Replace sprintf with sysfs_emit
 in sysfs show functions
Message-ID: <aYXG3RF4PltO9wtA@gondor.apana.org.au>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-3-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-3-kanchana.p.sridhar@intel.com>

On Sat, Jan 24, 2026 at 07:35:13PM -0800, Kanchana P Sridhar wrote:
> Replace sprintf() with sysfs_emit() in verify_compress_show() and
> sync_mode_show(). sysfs_emit() is preferred to format sysfs output as it
> provides better bounds checking.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> Acked-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

This patch has already been applied to cryptodev.  Please rebase
your patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
