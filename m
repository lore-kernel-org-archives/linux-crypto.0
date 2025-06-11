Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45B6146A68;
	Wed, 11 Jun 2025 02:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607823; cv=none; b=CFGAF57NxVf1W8e6dZpEwIugcd+U5NRRFxtEdBYpTf5AuqFdwfFN45KKR0p0KxqRj3dI2umTMdkdoR6kbSGJgKVmy5qwTxTExYnkogrRa3DiQthiP8ztUnvL2Y0Q9OTXyCYTxXJZSAgfwE+/jQmm7jS6EWPKan9rtXLAUhTUW/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607823; c=relaxed/simple;
	bh=bdajXBWMLVtUnv6iNJh0P+J15tqpBrKvq6lkhpeiVEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jC7Bt9gWJoUbmkCZpRk3xl5cl+YjL5Z9w39mW4iqRd5OVKYQt05d7dXZOSzY+uBYUBaE7MSQ7uqZGFR/fW57Bw3xkxjklQGFDCk+QWk+zg2ybWYyF+5AgVX1r01Jhuof6w+wZm1UQ/VkmJ5oh4GBhXUlbjllzu+YiS6M963FrQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=skPpYOvy; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="skPpYOvy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SDQToI/TzBm/Nj78Pcmlye3TohvWIQtZzAcJDnoDzYg=; b=skPpYOvy2eBBN6tLwg0dNDQEJn
	NQ2JFQT/4VsvMt/gV5snM86pd0Xqez6LDKgw/l7NDxFSBN825xr5M9eQ4i6Gte9aU7rf+W8aapUUI
	CL5EdqyGjqW6t45pRLlgXaoBc1Y7gl0Z81bpV2xEBnSgKoLtFN5baj3P11E4gP3NJHhyWVOMBy1M6
	+TT4AQIxEmp1Gka9XwYrJOwdWoZGGVIO/UiAm9koC6M1FocW8eLnOuSbK9EZSRjo9McRpLDM8WapV
	HwdyASXU2ZM/IMiG+//FvjO+gNIFLlPcGWbEU1rcT+ejmaikyw0ezyMC4K6lGh0lGXGXUtVd/8nk5
	q9WOQZWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPAug-00CEXL-1E;
	Wed, 11 Jun 2025 10:10:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Jun 2025 10:10:02 +0800
Date: Wed, 11 Jun 2025 10:10:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: meenakshi.aggarwal@nxp.com
Cc: gaurav.jain@nxp.com, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - Set DMA alignment explicitly
Message-ID: <aEjlevVOgCMgBmq0@gondor.apana.org.au>
References: <20250604101446.3993932-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604101446.3993932-1-meenakshi.aggarwal@nxp.com>

On Wed, Jun 04, 2025 at 12:14:46PM +0200, meenakshi.aggarwal@nxp.com wrote:
> From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> 
> Few DMA alignment were missed in the original patch.
> 
> Fixes: 4cb4f7c11dee ("crypto: caam - Set DMA alignment explicitly")
> 
> Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> ---
>  drivers/crypto/caam/caamalg.c    | 22 +++++++++++-----------
>  drivers/crypto/caam/caamalg_qi.c |  4 ++--
>  2 files changed, 13 insertions(+), 13 deletions(-)

Why does the request contexts need DMA alignment? There is no DMA memory
in them:

struct caam_skcipher_req_ctx {
	struct skcipher_edesc *edesc;
	struct skcipher_request fallback_req;
};

struct caam_aead_req_ctx {
	struct aead_edesc *edesc;
};

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
