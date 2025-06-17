Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA3A28399;
	Tue, 17 Jun 2025 05:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750138605; cv=none; b=EkccutisdwLrtxQxiv50h+HgZeAy8yEGtsPu41feARw7cthL7lTvBYZ+8e4RrPQ0SNv3VPloqtYzH/OjtWJz61bKg/uq5jlMHkvcU4r5NOr5o0hvjaxL9FWeKaBCGmZkVcGh8MMtfWoEFZdA5C/rb3DB///hQiy3WhmqeaP9ejs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750138605; c=relaxed/simple;
	bh=jbP9uGjsDMznmBpJruQX9jR+BpwYKtH06lHDqNl37Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDnxqCR9vltQBVPBW4SdhNxT47G/wMC8AENYMWQFpHR4ciniMpa8D82wYyJMyD/qYSv/S7EB5WEeH1B5ntaTyvhJS+U5eoMYgWXPL4Qis+1XJsN5uOfR+vp2YV92KRvSJ3T4LlGlh+HtnhybdLPi/YcgUktrMOhruztIjEPtn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=X1d4KBud; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="X1d4KBud"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fYuxPv6o911HB4LCZgDj4D5PgU252TUBup/qW5CJp1o=; b=X1d4KBud3m/P/cmFBCichdGAsS
	Z4agd+LbHf/jktjYPjr0UZ12PlmvJTHMmqvYk7u51VmGLMinXgXwBJ+kUi0d0Bd/hl/bQJxa9CMak
	obu5dv9cx9b0qHzYYQj50NZgyM70T8oGAKpvIztivAE3V5xQIJ54OZwlbQhhlub/2UBWAARvdN5bo
	bEZcZhcxUDLmYaiUnbDRqDY0UJOcuI0IuHWEbwPXg7aaI6CGkzK+FULoAh7vNqvMnoLnQojtWaaj3
	eOYJHFZXLPO40htgO86vJIfHcwSoO3MLf4SJZFE3TRxgcaEG+THAzuqze1HlKOkKDMuauNA1EmoNo
	FJLXeUxg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uROkl-000aIV-0S;
	Tue, 17 Jun 2025 13:36:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 17 Jun 2025 13:36:38 +0800
Date: Tue, 17 Jun 2025 13:36:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aFD-5i8RrA4tHJ6Y@gondor.apana.org.au>
References: <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
 <aCMOyWVte4tw85_F@gondor.apana.org.au>
 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
 <aCa7J3I8DyRs7pP_@gondor.apana.org.au>
 <c01e9b258e024e745ef8711bb94e0d5f6d7d4f96.camel@gmail.com>
 <043472e83b086681ff3a6d0130bfa01ceeff5fa8.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <043472e83b086681ff3a6d0130bfa01ceeff5fa8.camel@gmail.com>

On Tue, Jun 17, 2025 at 07:32:28AM +0200, Klaus Kudielka wrote:
> Hello,
> 
> Plain v6.16-rc1 with marvell-cesa as module and CRYPTO_SELFTESTS enabled.
> Identical behaviour as reported previously with the cryptodev tree (see below).
> 
> According to /proc/crypto, all marvell-cesa selftests (including ahash) appear to pass reliably again.
> 
> If we can trust the information in /proc/crypto, I would suggest to revert commit
> e845d2399a00f866f287e0cefbd4fc7d8ef0d2f7 ("crypto: marvell/cesa - Disable hash algorithms")

Corentin is still able to reproduce failures reliably.  While
I have a patch that seems to reduce the failure rate for him it
is not yet a complete fix.  There is also no full explanation of
why my patch even works to the extent that it does (the DMA memory
is supposed to be cache-coherent but perhaps it isn't).

So I think it is still premature at this point.  There is also a
known problem with the hmac code where it fails to deal with zero-length
updates correctly.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
