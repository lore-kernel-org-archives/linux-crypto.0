Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFCB3AE70F;
	Fri, 15 May 2026 10:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840485; cv=none; b=gdclsfdFb5PCVOeFo7YJMNtgxohfuAaeX1Wtb2wClBcdjvg67tktRLnEY7qVgZPkdVkm4cDKHBwPk0MFYbL+sTx7Fle3UfGsL7cniwGAiRlnSCUy1Ze6o//xaFuAlOc9YaZU6AhIggbXjQBCxXvEPsZDAm3CDQcq8N4QGFnHbJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840485; c=relaxed/simple;
	bh=ycXyt8twHDnFa9tp2gKxMICoJsrQD1x4X1/Xw2O1OFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwwzwl91bEY8wdrR39vLQy8fVAx6OGBnPfRTezqpGWQVCJlpz88QqF2wKAJ3GzIzBqqNAKLf60lWgWJwpmo/BEvnxzv+d1ZgXzNrV0HPO9Yhqcdc9+TLpfvx2tr5ZGV9RMmAuSEYONnZOx7l65lbNGOwXLvgs9ILoUoY15zSU2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=CXovIy0u; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="CXovIy0u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=U6R8vxWvKXe7XLKA7MrV/ARv2DnNhCxbpeyjCG0HIeg=; 
	b=CXovIy0u3LXK3XeP1XMTeQBvsSPaJC6MZHNdqqwE5LANl4hhV7tC5ZDPHXPXfwO598AXXgfz0Jv
	alxyC8CkAvZWCXkGHe6J5/87lynsaRpciKctwpAzSVz7bPTWrIjsUg9+x8lRda0tG7AqJVHRc+Sgo
	Hvt2YnymDbqCFiQbSdNBaCrHDQo8n5LONGvIFMiLI5Xw6BBboSCRyhqVRq+sYJ5uIuQ0WS28mhI3i
	9UNXVr6C/uqHolnO2HqjoWsrHtL/X+S6Enp7EGGgG6sqRVie7ViGuBn/rrRSQtxDq0gJSE/1RY1Nf
	FpDS7qT3rnk3jRbCej3nxUAYXkfj5CkDyDEw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpfO-00EOVK-2R;
	Fri, 15 May 2026 18:21:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:21:14 +0800
Date: Fri, 15 May 2026 18:21:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree - replace snprintf("%s") with strscpy
Message-ID: <agbzmoVAZChI5xrL@gondor.apana.org.au>
References: <20260506092150.177660-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506092150.177660-2-thorsten.blum@linux.dev>

On Wed, May 06, 2026 at 11:21:51AM +0200, Thorsten Blum wrote:
> Replace snprintf("%s") with the faster and more direct strscpy().
> 
> In cc_aead.c, group the includes while at it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/ccree/cc_aead.c   |  9 ++++-----
>  drivers/crypto/ccree/cc_cipher.c |  7 +++----
>  drivers/crypto/ccree/cc_hash.c   | 13 +++++--------
>  3 files changed, 12 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
