Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FD7192590
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 06:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127431; cv=none; b=rgZSUNuNvx1lnDrMFwCCSjD3TfmwV//8lSTPckbe7lycPOHhuDFEnHWtI3+i2GfjkAYHUNQdoST4NAlCwIk8iloudaYTYGTAwkySkEmJKDyu+1eV9XhHeomgZPktBxm4XuibJiW+YRNfYyHlHBPLffGSmc/ZoIbJmul+7Z6YrtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127431; c=relaxed/simple;
	bh=+gaI+Y8wfgKcX4k7L7VYipg/OffDxu5cNCfNZdZLNwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IxApTPGnKHFWTV6cUz2k2W+wLE8OQiN64szEieZRfLqi6QzsdlAw8VPj2P4IqQ0O20P8wAyMFhomdsTlvjLQGkadHnILYxaSCYqnrciuxen8EnTW2QsG/UBMjtKCf0WxDzvGvOd4Nw68W1bnyuNeMzMdKueE8o9QKS0BwksBdi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hp+6ZRXs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hp+6ZRXs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=yElVsZI8GpLJlJOdp2xxZ9JTx7M2+JVhFiWdCiVsxHo=; 
	b=hp+6ZRXsxPrn2UGC+ZJoSnfJy401rKkniZQKAUEHqBNS7sThMxnGWJYnj12x2jn8x+grxYTpNRh
	+LzDeVnb8kYUVQMRX4mth8Ck6dGjFDjh1gsCeUUMp05At6zYhWoa9KcdnFrqvpEQV5iDkGdfS2kBw
	gGt4/uFUQVH87ZUDBUmX3yjVajzmwy13Vy/hcAJfIxmQ5fCBN66SFM5mQ0EcbhEpA0EuH7wlJ/XiD
	o95WbTHbxTNENIYbyXy+cd3+Aq5m9+Bfz44iIV2kXM6diUvwsNGtgqx/HUWSsOUcBLSiMlNHuCLzP
	rLRc6aLFFshERMC42pniZSFpzWCvGgz5x+6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUQD-00BEXD-0S;
	Fri, 19 Dec 2025 14:57:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 14:57:05 +0800
Date: Fri, 19 Dec 2025 14:57:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Qihua Dai <qihua.dai@intel.com>, Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - fix parameter order used in
 ICP_QAT_FW_COMN_FLAGS_BUILD
Message-ID: <aUT3Qe73GQwmuss8@gondor.apana.org.au>
References: <20251120162932.29051-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120162932.29051-1-giovanni.cabiddu@intel.com>

On Thu, Nov 20, 2025 at 04:29:23PM +0000, Giovanni Cabiddu wrote:
> The macro ICP_QAT_FW_COMN_FLAGS_BUILD sets flags in the firmware
> descriptor to indicate:
> 
>   * Whether the content descriptor is a pointer or contains embedded
>     data.
>   * Whether the source and destination buffers are scatter-gather lists
>     or flat buffers.
> 
> The correct parameter order is:
> 
>   * First: content descriptor type
>   * Second: source/destination pointer type
> 
> In the asymmetric crypto code, the macro was used with the parameters
> swapped. Although this does not cause functional issues, since both
> macros currently evaluate to 0, it is incorrect.
> 
> Fix the parameter order in the Diffie-Hellman and RSA code paths.
> 
> Fixes: a990532023b9 ("crypto: qat - Add support for RSA algorithm")
> Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> Reported-by: Qihua Dai <qihua.dai@intel.com> # off-list
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
