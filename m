Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DF77173C;
	Fri, 30 Aug 2024 10:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725013916; cv=none; b=cv+DbI8ZGdMOFhTRXHo89nCzZ9tdCAlcZiT2GJKfu7o4dATyfQwSETPrUunWGY3QcLBlTXKKZlIbHAvZlmY9/6MHdfUzqsKDeI5khEfySuzfqfXc5ogNUQISBg94yOgHV0x0K3BAj1F3KjzZB7Q3Om2CJLA7WSO42iICRvp/AYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725013916; c=relaxed/simple;
	bh=V331VKn18d/1qv7waeAlGnxPu8LthkeCfhTt7Ao7Hfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7bakX4gq7BSahwEUV/uQ3kWJqi2+IPvI0ruWV13LxKe5t5HV6MyH6Q2PZ6DCIAuATP/whfJirHeYQBYg/sebtU5xkFIhWqx3HZXZLVAP4z4rufOBVerGf+Ziws/L6tCv5arrP/zaJFT/HYW6UiDsryoROVdWBRWSBGT6zU82bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjymS-008UhT-0F;
	Fri, 30 Aug 2024 18:31:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:31:45 +0800
Date: Fri, 30 Aug 2024 18:31:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: jitter - Use min() to simplify
 jent_read_entropy()
Message-ID: <ZtGfkaNFfYZMenc3@gondor.apana.org.au>
References: <20240819141843.875665-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819141843.875665-2-thorsten.blum@toblux.com>

On Mon, Aug 19, 2024 at 04:18:44PM +0200, Thorsten Blum wrote:
> Use the min() macro to simplify the jent_read_entropy() function and
> improve its readability.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  crypto/jitterentropy.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
