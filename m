Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D01A2DAFA9;
	Fri, 17 Jul 2026 08:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276203; cv=none; b=D1h8Pw9JU70nRNH7gEsf5t7ilfAKBb1xStnVPGRnnJCk7LquFkyTf+L4tlUikEH/ARX6PEq9enB4Y7rVxcidppx1t1RGaFwfTQ+niRjGt1WjwZA2Bhc6T2wCZzELW1wgXymZ8kCUGAd0cGLPEwgIBhwdNlfQkdUkHAgrmOkFijs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276203; c=relaxed/simple;
	bh=YJqxkSIeYkycEZJZrrH6D7R4dbKCQ+uQOKsFs047iug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+VTSh2IWOsjUkrr+BnHK41x+ZJitWqaQN2SFdQr9SKc8ikCVZctOSEO/fYBLrJJKr46wYSJJHcFltl5N0McDgUVet8nP7OiXQb9gd+3Kvp+aBJfQw+yZZMPZkICaW8CA/kZHEnJVSsV7JlMR/6aiptRPMEFp7LyyMhyGd4Ejwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qwv1uubY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qwv1uubY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=06AYYIYfgRAXIqAMErr4O0bh0kIsqo27jJLndxJScq0=; 
	b=qwv1uubYnn5HVAX5NmCa3w77qfOE0pk8utDvVjgVwU/vYqhOZ24NNiwPuzvybUDBiLupar9Sxk0
	6kxZR4hE4cWl24N9QTmnBSkpwP+7SuP/e60jyOPM0Oh/zuHQNKUJGIEv2fyxcIM8R8rIogm3Yf6OM
	B2d+QKT9qEJKiszdMjH4Bo7ZhTPRwqQmwdHKCF799nX2OLtVSFbuGoxy0Uhnh9iEg1/k3zAZz4NmH
	LI9e7DJWE+bS9T1rGrso4+pOIJ+NsjQetSwlt8QiX+UFeSvNzUqAAQVV6Z4qXoEq+TB+ifx8hdsQS
	Ozk5UhO9t8mdzM0YN3Bv09P3xPDTluTEtPKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdkH-0000000EOAj-0Rzq;
	Fri, 17 Jul 2026 16:16:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:16:33 +1000
Date: Fri, 17 Jul 2026 18:16:33 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Corentin Labbe <clabbe@baylibre.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sl3516 - drop invalid sg_dma_len checks before
 DMA mapping
Message-ID: <alnk4X5dsPBoDfTH@gondor.apana.org.au>
References: <20260710074216.734849-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710074216.734849-2-thorsten.blum@linux.dev>

On Fri, Jul 10, 2026 at 09:42:17AM +0200, Thorsten Blum wrote:
> sg_dma_len() is only valid after mapping the scatterlist with
> dma_map_sg(). However, sl3516_ce_need_fallback() checks it before the
> source and destination scatterlists are mapped. Thus, a stale DMA length
> that is not a multiple of 16 could incorrectly force a software fallback
> when CONFIG_NEED_SG_DMA_LENGTH=y.
> 
> Remove the invalid checks; the existing scatterlist length checks are
> sufficient.
> 
> Fixes: 46c5338db7bd ("crypto: sl3516 - Add sl3516 crypto engine")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/gemini/sl3516-ce-cipher.c | 8 --------
>  1 file changed, 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
