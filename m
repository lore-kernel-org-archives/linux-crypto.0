Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54378F2B;
	Sun,  5 Jul 2026 08:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240454; cv=none; b=RN+PKeiPKVdTp7f1THmaz0HatNMotPFV6OWAGnPwZlq7QNiS5pTYQd2JsS3uXcf//NMwsAs9odPuNaC3eBZnF0IwnT0zusbaHJTnpKpDf8oikBXEm+lVn1C36RNlEqQn9po8fKYV1P+bO5DGzkOUtI1GEzlLuXwu6bU9Cem9bhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240454; c=relaxed/simple;
	bh=VNMqrPebhYo1TUmQOCvI+AIH8ierPt9EuUl0Itns1W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pS9PuM17hTSm8uzEBznrW5bkEuNz37lWN0u/rfpKfz3EW0/mnnkIg/HmLTCe8bjODwC3+Eif9zHIfFn8PIZUfDux8+iZr4UzVeIhyQRdB/PJp2EI57Wsm/NnTjpdty97wvl3/kUOd5wkLe9vaTEdHz0CJk1YxK6U5IiQcyDwJjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WJciYFPF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WJciYFPF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=hUKgVK5gaikwzZjAylQyUAO13KCC2gNFLqO89Rj1WhA=; 
	b=WJciYFPFvgjyAbFXwl/8rUYlCIZZzVG7fI3ShHOIQ7phyHNKfixvFIdte0sAEAdPVXgP4MD+yZW
	tyfnMBkVRdtcKU12KGlosavKe7ZtgaYVXcHJeyvrCq0ETeaq+USGXiSUcaJhKILl6LTCukZ62Bx6J
	gNJw+J40LAHQydtzsOgkJLLb9S/bzyNoN4M+1t/2Xeps7xBY1cG569RvqEBlQKa9v/3a8kWtl1+50
	tGhA0IO1OndAMP72U5hPtLVpA8P1uKF9eMOB2TjZ1bYQm5KxnCIkxwsyqvxFfsNheA2lhRakk8KhT
	8UBtT7k56iWkbjzF5zsAE43g/F+TXRZ/pqmg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIIi-0000000Al2L-0n0a;
	Sun, 05 Jul 2026 16:34:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:34:08 +0800
Date: Sun, 5 Jul 2026 16:34:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sa2ul: stop probe if context pool creation fails
Message-ID: <akoXAO15Z1af8Vqd@gondor.apana.org.au>
References: <20260616004627.947-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616004627.947-1-pengpeng@iscas.ac.cn>

On Tue, Jun 16, 2026 at 08:46:27AM +0800, Pengpeng Hou wrote:
> sa_ul_probe() calls sa_init_mem() to create the DMA pool used for
> security context buffers, but ignores its return value. If pool creation
> fails, probe still continues with DMA setup, algorithm registration and
> child population even though later request setup depends on that pool.
> 
> Stop probing when sa_init_mem() fails, and route that failure to the PM
> cleanup path without attempting to destroy an uncreated DMA pool.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/crypto/sa2ul.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
