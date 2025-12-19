Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F3C192590;
	Fri, 19 Dec 2025 06:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127520; cv=none; b=bUE9hy7sF6+K98te2c1Jd/6ZYiVQa3okt9Cfwo4lshp38nV3xi8WqhmY8YrgTD0T3/uu+UcljfswDok7bW5RNikCg+CtAhS2qEskMfcLCvkZdWM+nj/BMOnTNdAsmaX0fw7aCzOGRsaW1ua8Qs5v603XbumaWKpj6X3/9ojRWKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127520; c=relaxed/simple;
	bh=7cgqwMc4zZXwMWR12y+CgkWAOVV76UK8/EKppZTlUjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VX/E7LLWqLGrhoagxCB0gwcdglRkgWFhEbq9JosXUw7/RKTKIVVGtMlB87sPRpthIDoRNmbUQRBPW3d6Oe8TzDOu+wsCUm3+a4/3bQ3IirAruUs61mvHgkvpHf0zLf6orHVl7BKscMT9OQqZJ7o/S8rzTOZWm6GQN90nEgB5xG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rl23U4sb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rl23U4sb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=TJ8zMu9MePUhbsmPHVewV9sJA/Fh9rLxzkUQzu+BsnE=; 
	b=rl23U4sbj2/NRxoytdaKGCwDstEKEMjuL1UdjQhR/+eb4jvI2wDhz+FO3RsmjaHINJRDA0a5phj
	MnDWAOD16b9TURwIkORrx5hZbHDfzdf/fHx8s/eCbiwFq4XRxV87rnJzhdjZMhvNscINTKd+UC/qR
	6nSxV6pkh2McNlHnDnq7z4X22PwiNrnINuo/k9vwx+1S4MnAb3pBPpZsNzTYzNc004GwioF7NfvHN
	krguSL5XGq7ku7hnYQ4/W4w92lXHb9fQxIFGYmMFEnrugsG34WHBDFZfOygiEn3c7iBc1mSGMVe1q
	Twqp83K/8HwDPVfYkuSB1rOuG9CFVZtcsBTg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWURV-00BEZp-29;
	Fri, 19 Dec 2025 14:58:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 14:58:25 +0800
Date: Fri, 19 Dec 2025 14:58:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] crypto: sun8i-ss - Avoid
 -Wflex-array-member-not-at-end warning
Message-ID: <aUT3keNXVOUw2lOg@gondor.apana.org.au>
References: <aSQhQh1xyp-zauPM@kspp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSQhQh1xyp-zauPM@kspp>

On Mon, Nov 24, 2025 at 06:11:30PM +0900, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Move the conflicting declaration to the end of the corresponding
> structure. Notice that `struct ahash_request` is a flexible structure,
> this is a structure that contains a flexible-array member.
> 
> With these changes fix the following warning:
> 
> drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h:251:30: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
