Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2448644AB6A;
	Fri,  2 Oct 2026 08:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929572; cv=none; b=WnCr+GXf3aAgNfbxLE8MwzrOGwhi/Taq4VMoOwyYRrKO+jKXFo5mpEN3dqQgfLqcndoXk5UA58PEuZAa2z1DsBHQnK+C3g9l/oiF2DvpXGMNt9iYdeuuDr1xI9yx0OS/XEBVnrijTSEDd4c8ESQkQbHfRGWdlgzwiMhSDOVpP0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929572; c=relaxed/simple;
	bh=rEJFtJF0xQTEFm2TPz8e/ruPrgiSyVR1vkAqotVstVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMwr85wG84q09YouvYkP/v1mqM2bmQFitB1FTorcbOJ85mdmUu/T/fTt07Z3h5nOPEUX3HCPz/vTSGiuir0nt7SAgrNh2DrT71ymKt623AKg5UZ1C1k7lzTGnxpHh6ABqtvvPv1OQLwonPUeHvfb8j1hsPKidHnPQoHKzfGbGm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=liYZfYgW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="liYZfYgW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+ga4PUxJ7DyZl/TIAxs1kY2f082Q38jxhP/17oj7jWM=; 
	b=liYZfYgWM30itCMfxlPH8awNR2tV2hKht+9P1D2ghJjjxzjsgupgSHE3eBhP99lthcIx1rfG4t5
	aXPdFQnLoMb2/NN03Nb7vTk4BcNe7K7oCq1tFBx8IQUqwMSjedO1DNs8CMuhvo/T8LD13OLKkIWke
	Sql1v/mIC66wRwcPYnmxh01OlsaocLOVsnArOjyCz8SL8yqeCe1nWxKRct380bhRge1K/3+zZ4xym
	snDmAueyFnH/nMnuIG+fP/IPQOk4Ih18MzLRbRePGPJ8+hDjxIiihJI6qonIimyvz7rxk3vytCi9r
	kuJtwwS79i+JbvaG/6clQ4ow79sCDYmlRmHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYaf-00000002mk9-3eZu;
	Fri, 02 Oct 2026 16:26:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:26:01 +1000
Date: Fri, 2 Oct 2026 18:26:01 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tero Kristo <t-kristo@ti.com>, Keerthy <j-keerthy@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: sa2ul - Fix HMAC key preparation
Message-ID: <ar9qma1xm5q-eb6X@gondor.apana.org.au>
References: <20260923051116.92741-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923051116.92741-1-ebiggers@kernel.org>

On Tue, Sep 22, 2026 at 10:11:16PM -0700, Eric Biggers wrote:
> sa_prepare_iopads() has multiple bugs, as discussed at
> https://lore.kernel.org/linux-crypto/20260831055141.1632832-1-s-vadapalli@ti.com/T/#u
> 
> - Commit 3bf533787910 ("crypto: sha256 - Use the partial block API")
>   introduced a 1-byte buffer overflow in the SHA-256 case by making the
>   crypto_shash_export() write 1 more than sizeof(struct sha256_state).
> 
> - It never worked for HMAC keys longer than 64 bytes in the first place.
> 
> Fix both of these bugs by just using the crypto library to prepare the
> key, like what the chelsio and qat drivers do.  Also remove the
> pointless use of an indirect call.
> 
> Fixes: 3bf533787910 ("crypto: sha256 - Use the partial block API")
> Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/crypto/sa2ul.c | 121 +++++++++--------------------------------
>  1 file changed, 27 insertions(+), 94 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
