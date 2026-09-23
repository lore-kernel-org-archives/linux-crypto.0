Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F095A19005E;
	Wed, 23 Sep 2026 05:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790141682; cv=none; b=JA5nOrus4wWIfEzYqM/uFkQiGYq67Xr1hXq6hBj4Q4Mah30S4X6BKbsr5uAjwmVSXKlNj94iHDDRvJxkpKp+4dUJqQIGK5TbO+gE5kkUmw4am2W7m/4sdc+LWjKXZolaGQ927tU+eiolnPlU4ZctnJYWEyfHqqspXafSmfA7OY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790141682; c=relaxed/simple;
	bh=wD1a4x6mD9hhadF4dyvfpfIKtRaH+naN8bZd0dwjoz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mXuF9lLbtZjLpXWnwM6QK2CmD1zjn+KRvgJXf7WwPWIctv8qZGLtBCx6Awu81y6UeSqT1szNNXvNQe4RBN9kxnUOHhymWK9ORQWnoQaDFf6Rf7+u3wtKA+5LM0UWu7ttWFLRZyZwM4q9+ciWjrLzR2NbcNGYARs6LWE6Z8Ao1+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HiiBMhoj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HiiBMhoj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=t4crrsEFisREJ9CrGFW/zlKz2wTGxjmssg7rdlE5LvY=; 
	b=HiiBMhojD6Wxko1Hu1dUPrLa4SD2rQC8octaGtTL8DJocM+Jd0EJ+jkWS4vGpMZ3MY1Wv0JYF7r
	sWIMjH3DzrfKsaQxOYeJOgGDAP9Jn80eIHclUldE1VSa7TXk/b4nmYAjFp24yaebNxMhcMndykLMa
	x/yuekGdXYXIy/UFejWFlQ1T5CT0YXV1bIfdOKcdwRZs9P8D3XCwHfThyoYg2nqJT2GN9Y6q1mXJY
	xIV4+WBBIb+Kuzz8WM5tKHIdj24OpgB2hql2KT0AsI6+7Fh78bPtr9RJK0bnfne19jhhMfYBWuoyk
	xaiMofjIGXN8Wv8oG3tUuzTyjCApAvaCnJWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Fco-0000000Gucq-1rSt;
	Wed, 23 Sep 2026 13:34:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 15:34:34 +1000
Date: Wed, 23 Sep 2026 15:34:34 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: ayush.sawal@chelsio.com, davem@davemloft.net, harsh@chelsio.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chelsio - Fix wrcount leak in chcr_aes_decrypt()
Message-ID: <arNk6ujyrvTsFBfS@gondor.apana.org.au>
References: <20260916092359.2001753-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916092359.2001753-1-vulab@iscas.ac.cn>

On Wed, Sep 16, 2026 at 09:23:59AM +0000, Wentao Liang wrote:
> chcr_aes_decrypt() increments the device inflight count with
> chcr_inc_wrcount() before building the work request, but it returns
> early without dropping the count when the tx queue is full or when
> process_cipher() fails and returns no skb. The count is only dropped
> by the completion handlers, so every failed request permanently skews
> the count and eventually blocks the device from being detached, with
> the detach worker warning "CHCR:request Still Pending".
> 
> Add an error label that calls chcr_dec_wrcount(), mirroring
> chcr_aes_encrypt(), and jump to it on the failure paths.
> 
> Fixes: fef4912b66d6 ("crypto: chelsio - Handle PCI shutdown event")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Plesae combine this with the encrypt patch and repost.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
