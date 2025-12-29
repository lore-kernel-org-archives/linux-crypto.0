Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C5A2D7BF;
	Mon, 29 Dec 2025 00:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766969474; cv=none; b=qPk1oHIsE2FA20GHbBm5XbPdu1p/bRopGlcYNFhCFzQ1SRgK/I6n+B39Kz6GfA0uNqgDxQ1QfVAWT/zs2wtdGiB9ZPp2jK9dYAyBBW03to+QFAKcTrR2jXfuYj6JBLX0ma8id5jMbTSAi6R7sHfSSkKyskzDblVe3CSUCr3AllM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766969474; c=relaxed/simple;
	bh=w/exPul4glVIoVpy5gQygksF3C89vafNuI7+mXCotbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rr1KgJH5iZt5hXShWUaojuTC26eG2896VexSVc7HrUO6XPvihbE2ms6eZWAc6McxObmtGcpGddCHqE2nW/Y+OxQuN7uXB0lkLcdKEFQVIHwi6lC0Y/DcinSG9BsEGbE/p4CAxJnbZe2HVtivW8ZExrMkDINbDNB2RwnPiK9v3vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SfePWMsJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SfePWMsJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=n0G05CBcludsDcS5c+gNE2zdaEpSorjyYo6DuuodMl4=; 
	b=SfePWMsJv57apzxQ1qUnIU252bV1763rcOsuFote7FRo82Z2WC1dmvjQzQzwtwNgkSnlTb6r53f
	ElOhWBYfDaadVrnVFwCmjxwYyD/25QraUcF93NFk0lHXWBeLXw1B5BZRG0pzJIoVUdBtUCIieCf/Y
	2HbYj+7DR3rlA96QLsTN367EZW9NPkjP9W0USYdnuirUe46eoTjiOPV+w4GJFI/cwMs8STg2kVEFi
	4w+5giaQ75/E8rjVoHJF0YMZWwaHWbY9eoQveuX8//Rstmvj+Q03qM4H1cTZsX12hN6/ifOrhP5sO
	v0S8coexlmsGJ9AYgqV8fZ04B0lYdlLI8FJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1va1TU-00D0Fj-2Q;
	Mon, 29 Dec 2025 08:51:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Dec 2025 08:51:04 +0800
Date: Mon, 29 Dec 2025 08:51:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: khazad - simplify return statement in
 khazad_mod_init
Message-ID: <aVHQeAF9So391tbP@gondor.apana.org.au>
References: <20251216145536.44670-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216145536.44670-1-thorsten.blum@linux.dev>

On Tue, Dec 16, 2025 at 03:55:35PM +0100, Thorsten Blum wrote:
> Return the result of calling crypto_register_alg() directly and remove
> the local return variable.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/khazad.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
