Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095CA35C190;
	Thu, 11 Jun 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168076; cv=none; b=IRQNu+QypSyE9JpWfMRbQRIHR293qDL6evyacZLHyDbjKw+rWf+xKO6Dlh1zdEA/jmxCwoESjRpgxijrU05S2PHPTwa2sA6TebxxT9pgoeSyQGxZ+3w1K/60NDis8wYhLj0ghovCm9LRjp7oogM/EqUtb8r0SiV1+k9q9lRC8n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168076; c=relaxed/simple;
	bh=rd4UvFbg+f6+NZ48qWtwQaHBdmEzw79AyMuSZc8GOSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QD8CfKk9c7gRyjQcBF8WyC6DfySt1+ibDATg+lNHKikY1qmxWFMyV4izDOxbBys22GXrT5/U2MDj5+bmxkDKcp7hpOg8mzl0AinS0aulCrOPrW6HGJmXTYAKzzMDUHR24fBoEDzIvTxCrfiVaS8tEddJuN8ZjvJf8UjiFsljqN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Lwg9Yg+t; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Lwg9Yg+t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=S95Pps6sDL0cr55qXcXyoNsqagjVpdEK9MkSxzWkhp4=; 
	b=Lwg9Yg+tZO9VgMzfyzz/RjqzFKf6OutFexKpthGW9YuqUlMC8+IdtTGnpIRyC8YGok3HKE2TnjF
	8Sn35SbwnziruUI7Ky9u+haoI6hdh0vek003zvTgvfCj3tCX37gOM8br5Jz0zwrvrmo9ne/O5U4uU
	eEUtpdQp3VCqdn7JDucNlVNDh3GIhYXqdmdVAghCk6agbUvAW5BfgshrxmS74SBLay60PTQZl/c5C
	Sf1DfCvFySXJjyi2cs6gzE0ZfSXxqBNlQEn+SlzKdRt18iOVE7sV0ytwWHv3+PltuwuHdpKjczI1U
	oZjAXqahqEbW8cqvmD4UFnURkG1sxTebwuyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXbBC-00000004XcU-0F3J;
	Thu, 11 Jun 2026 16:54:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:54:26 +0800
Date: Thu, 11 Jun 2026 16:54:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - drop dead code in atmel_ecdh_max_size
Message-ID: <aip3wkCx0UIOXGrn@gondor.apana.org.au>
References: <20260602222517.1071850-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602222517.1071850-3-thorsten.blum@linux.dev>

On Wed, Jun 03, 2026 at 12:25:19AM +0200, Thorsten Blum wrote:
> atmel_ecdh_init_tfm() always allocates ctx->fallback, so it is never
> NULL in atmel_ecdh_max_size(). Remove the dead code and return
> crypto_kpp_maxsize() directly.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
