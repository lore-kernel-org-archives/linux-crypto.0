Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D8A27602C;
	Sun, 28 Sep 2025 03:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759031972; cv=none; b=Ii0FTGG0XCHawOxtUs+r2ljsB6sjngAf94vqLqDpWSyu5hGCbq5vd2aoLQC3tcDWVyYUS099F8ZIp6wNrnKzLZu9PhXKWf1vqgTcCBWR23sFO0RLRAayShQ2edaxfpC6nsK3B+jn30gIRp1t7lL1DusYDt8G0rhcK3RH8NSzWLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759031972; c=relaxed/simple;
	bh=7XFEMioG5ClehkbqbHkXS1QqdDe1+Oqjb8NFmVdgzNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O+HMwKUXGgJWYLv+3LKDpnVbhDoZ5njTyARkFAPOu5v/3AjuSYep9YI2K1TygjVT/cRlDI0uMnmp4IQJeGL/Ei8HYzJEjlJZRiLlU+eSB9BoJGhD55vgOzga+IgxlquFizfK8aBPXhTifmUwVHpdKzLqs+mZyQtizLyMP/EmcNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VWYaqpx7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VWYaqpx7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=Xlt0Bidng/p/ihVyyOOmlOnS/3IpMJU9FC0UPLnOohc=; b=VWYaqpx7L3p4i1SGWj4LKtJ+0J
	EFGNpomQUaMBnULNJxHojMJn4QvbXikxqYiQVKHtgUHsHrAjWM04v66LSn3cdlLb1F3V8m8UbPEol
	KLZzLE6T0ku2xX+d2Q6rwINMbTtTM67ax2I/XNA3wa27K5I8JweFz3FmUuHB2C3i6rNd3iGIRCbMb
	whf8sMIM63ZwX/aIm3c8X3vYlwYbuPkWk0bkSTwXbB34znSmt2IO/LpELjIrZLaTlr6ackBLtL7Tr
	HP69MKxoymTLc6TvccURpC7YH6H446YoaP/ZHDYO2WJQLH7WGpNT9q7cf1voRJ3ywYI1ob+ZJ7CBP
	puz6igiQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v2iZK-008qWK-16;
	Sun, 28 Sep 2025 11:59:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 28 Sep 2025 11:59:26 +0800
Date: Sun, 28 Sep 2025 11:59:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Crypto <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] crypto: Add explicit title heading to API docs
Message-ID: <aNiynvf85p9v97Vq@gondor.apana.org.au>
References: <20250920001650.10474-2-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920001650.10474-2-bagasdotme@gmail.com>

On Sat, Sep 20, 2025 at 07:16:51AM +0700, Bagas Sanjaya wrote:
> Documentation for crypto programming interfaces lack explicit title.
> As such, all its sections become entries in the toctree index.
> 
> Add the title heading to tidy up toctree.
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/crypto/api-aead.rst     | 3 +++
>  Documentation/crypto/api-akcipher.rst | 3 +++
>  Documentation/crypto/api-digest.rst   | 3 +++
>  Documentation/crypto/api-kpp.rst      | 3 +++
>  Documentation/crypto/api-rng.rst      | 3 +++
>  Documentation/crypto/api-sig.rst      | 3 +++
>  Documentation/crypto/api-skcipher.rst | 3 +++
>  7 files changed, 21 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
