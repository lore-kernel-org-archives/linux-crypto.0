Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772F41AE877;
	Sat, 21 Mar 2026 08:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774082944; cv=none; b=X006l90XZhXKWoQ/o1e3fWL+9dyEb9ch0QGAQKb0Yz0ZuSHC15JRiTdtDL9qxHVc9goRAfPlOteIIOW/3/IdZDbuP9m8JX0I0vhHBK7rbF6nARTN5z5/ha2p7LJLQVYnyXjkNbZOatCD9VaJJ/Evp6W4v0tD8lytZfBr2oXNHho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774082944; c=relaxed/simple;
	bh=BJCJz8Oe/ddU/fzufoMNlb/JdrTYHpgc3dtC8y8OpS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBFqZ9rw+4ngQ7A5vku4jEDKs+wQEhfj1q2SC4MTPihyRO3C7MO+KsbBFP0InFlMEdWEPkTgpmst8efOdQA3R31iwwT/79a5HkBDQtLV6IVBMxAPV+diHd5trvjKzz7AG5/OQTSL9xYfJQGDn3pEbzsEfu5POt2YrvljC/xV5ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GC99Jqve; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GC99Jqve"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ew4b6Du8jBihJbSUcGCASA7OYqEMzJLSf09+YdWVI+4=; 
	b=GC99Jqvew+yJLRJmskcV3lWozHTbHv773XQ+SSaciYMxP947kvzh3cyI8IswooJIKWZzdxd97U1
	MaQpcMJUZ+zqTlrrx2rpgvpjSzFxPybWp3yBHbenAfzFiPNhOeavWKVfxKE9DssWtZSm0kaPFTx7W
	AJSHHEF+xqxjOZME6wwwqIkPR8GlShpPe1W+8xcRGwSRh2krAkQg0p7Qc93D9Zn75I3PiaWF9y52p
	8HJf7jcUaN/Q4BBJ+E9FER+QC96arhT4P8+E2B36ZemO6q6pt71RAlUy75TIdo0hYUumFIC2IEMbn
	PXXSN+LFBLINlCGujps7lNUkSuXdWO4J/zzQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3s0k-00GJAG-22;
	Sat, 21 Mar 2026 16:48:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:48:46 +0900
Date: Sat, 21 Mar 2026 17:48:46 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-aes - guard unregister on error in
 atmel_aes_register_algs
Message-ID: <ab5bbqzl-EeKqf7t@gondor.apana.org.au>
References: <20260311113927.305633-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311113927.305633-3-thorsten.blum@linux.dev>

On Wed, Mar 11, 2026 at 12:39:28PM +0100, Thorsten Blum wrote:
> Ensure the device supports XTS and GCM with 'has_xts' and 'has_gcm'
> before unregistering algorithms when XTS or authenc registration fails,
> which would trigger a WARN in crypto_unregister_alg().
> 
> Currently, with the capabilities defined in atmel_aes_get_cap(), this
> bug cannot happen because all devices that support XTS and authenc also
> support GCM, but the error handling should still be correct regardless
> of hardware capabilities.
> 
> Fixes: d52db5188a87 ("crypto: atmel-aes - add support to the XTS mode")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-aes.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
