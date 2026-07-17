Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BD73DD50D;
	Fri, 17 Jul 2026 08:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276111; cv=none; b=AQOKJWN+gUN3IH656W41lGoRLB4j14UOO5gRtvCFBxFiTmSj35FRndVjxQUuSjdKrcMjrGRwG93wxSYkXZw9XL8X5rwbdelDLMY+IuKlsMDdlNrcVM1u9N9lio+VDm5raP7P0LFPvm0m8omTdsn2AcJUiSA63IKgVNqXF5NKe+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276111; c=relaxed/simple;
	bh=Y/kSFx6A2GwAAJbN28P/COCcIRqWj2MU/CXKw4W6gtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ll0hkNTJGBqm9s7eoMRtvwQCZHkJczxF7bywQRoLoQvCcj3nUjM7OBh+6ICkYxd9iLVWT69QElLVUxMekWyMHt3cLCgeiRq2gK71L4XsuKa0B/3qcURiBfo0fu5ljBWNV/Azg8V7jAh6cmtDIqzdzgz1Ger2Pl0ajWXKqXJt7M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PUelPz5O; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PUelPz5O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5exeP60+Paw9Puba3bnlZkuXgjOPwLwVNGkFQKE2G7A=; 
	b=PUelPz5OBzYDGCi3Y9PtBBjImtb+wZ0qH7dCic2vnIfeI0MSn04MRFmd9kBiVvQvIrHZJXhlB2/
	r86lqXtKDQNdNQbpAgEvY+mfZXSjYFTWW8S5clKHbGLL49eE//srgSxSgznDEXnwe8CVECFiSGIJ2
	Z0hFTeEXXyTkj5X6rPUtB8aZh9kje2viINGqTUmAbuoNmJvPROkRh5uZyt+rgS6V0AeqxfzVSraBb
	f4pOf7W3qRr3SSFNo2XtMXEFCi5xHYQG97sSNF/z98FDPnIUeDVFqiJ2nKrzsqzC4dBPeAvzwDKzy
	BtoSl2HU8zfIuOzt/1IlEHVxvt01Sa5XdCeQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdim-0000000EO83-3u2O;
	Fri, 17 Jul 2026 16:15:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:15:00 +1000
Date: Fri, 17 Jul 2026 18:15:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - clear RNG data from memory
Message-ID: <alnkhHBvJe88caUS@gondor.apana.org.au>
References: <20260708150359.545852-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708150359.545852-2-thorsten.blum@linux.dev>

On Wed, Jul 08, 2026 at 05:04:00PM +0200, Thorsten Blum wrote:
> In atmel_sha204a_rng_read(), use memzero_explicit() to clear the local
> stack variable cmd before it goes out of scope, since cmd.data may still
> hold the last 32 random bytes.
> 
> Since atmel_sha204a_rng_done() caches work_data in hwrng::priv, and its
> response data is later used as RNG entropy, use kfree_sensitive() to
> clear the cached data on transaction failure and device removal.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-sha204a.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
