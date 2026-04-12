Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF752DEA64;
	Sun, 12 Apr 2026 08:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775983957; cv=none; b=Z+WyvMFPyyiZnE02mRD9MMG4SplWAnvAbmwAt+qJiY6CEIZl8WCvNBQp4A2s7nIi5LnxQK4BeKJYBTtDtRoLWTZuqrJOM6TXzH89hXgx3zFQM4HHFreJAo25j8qrOcxKLk0xiiHCpBf9TIkXg2HHJ5j/L2q++Wvo2+w2S04Tx6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775983957; c=relaxed/simple;
	bh=qC8azDV0vffk9hHMlDY/PxsnnxgTSWST1PfaNo7yrJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0O4JkY432FP600S7tVj+L1VexZcFxObxrm5dNTQRSvLqY62VQqvxSV5GodDHmkQbXqNsN7hlFwPRF9FBcv5D/FbKP5gK4QTwrwviNKy8NtlLUqVo7qDC9s9KrH8NEmBLGpp3NuzCZrlipVQysw1zsbwBxqvyyHik91LBWbU6Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VAC3Qapf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VAC3Qapf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=YXlCirSCQoS/yjXkuLU4P2eBAK34ytGDfIwQK/GVfuc=; 
	b=VAC3QapfkTWkn+UhlQ99gqwPhxwu8SxoQlX8d3kXM51gcCZ1TTT7cT5DO4H6San+Nbejbc6PRtt
	1Eae9o9DdAmvyGsvxqPC5KMxG37TnIF40ETRj4WRLUgQa7z4yj+ySm9MYP1SimAjhclibPwacwH3/
	rku7Vqk6r6ardjQsGIrRVwip71dsYVgAsdZjIT7hyzjTTwxP2i5wGk+mvhtONzC5F51rW2kht3JiI
	7KhKahjt07m0/Nt8bu5qhFIvqP1IUBxlsBQZO71CZHIVlGRH1lAKzA+ai48zLgIO0WjYMqLg+9FUf
	ZmHzkdJnpXf+mK2do49wzjI7xrQvutlknK3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBq8w-005UJe-08;
	Sun, 12 Apr 2026 16:52:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 16:52:28 +0800
Date: Sun, 12 Apr 2026 16:52:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qce - simplify qce_xts_swapiv()
Message-ID: <adtdTF0wommm_LW6@gondor.apana.org.au>
References: <20260330173923.479407-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330173923.479407-3-thorsten.blum@linux.dev>

On Mon, Mar 30, 2026 at 07:39:25PM +0200, Thorsten Blum wrote:
> Declare 'swap' as zero-initialized and use a single index variable to
> simplify the byte-swapping loop in qce_xts_swapiv(). Add a comment for
> clarity.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/qce/common.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
