Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CFD204090;
	Sun, 18 May 2025 07:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747555153; cv=none; b=nnEUEaSL0O0E+GZqC6vN6ix5kWG2GmbQyDtHh7stcAs/IQJIL/w2nlpFBT18ZMRJ3mKzvzALscE+yl9SoHIDOhJXKarP6HCk0zE+hiiCVSoR/a+KAwuTgoEYM4AfnHRIgAaEL2SWwp4SpKA3QsEiR+kanl5CSSEdBEipxAOQBCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747555153; c=relaxed/simple;
	bh=4J4KfFdyJy0mvKpxNX93AgMdd1xp0yDGzypCIuL8D/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8myLOmeWoSb2Yo4cijR3/xgjwHnuxIMBxTTDydSI6fasmJiYsljG+mn597YGObgk3csQHy1XOPV4jrvGtLaLQ4jfTnKfuxQxkaQPvtuUVe2lBdPplqtJ38XKqZRdJ69sEvqk1XGEJm7Az4gbPixQOezYbbTvUfcgs5JQbpwxxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=N0F5ruP0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="N0F5ruP0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1l+Vpf23qIz8+p+rgGR8X/y0yOK0TfII8bnSXZ4uOAw=; b=N0F5ruP0YwhjUStQHZnMh2TbyV
	qvjG2Mb49hYpwpufK8xgfz0DnN+SC3v9rKJjpBNHi6vsCr6saeSkPRivnUmgdr9lojbf3ZLqP/U+Q
	M+XdcL0DarGFNvNjW+MLyLo6V70pQqBxrqCH6EaGpWH2g07hU26rCJ3gBIk5namH89pASxf7tdvMM
	rjzQnFtTGhDwDmJib/V31IX02Qg97v9g1PdQcGzxAT1Fw4W+e3HNIUFlFO/sQl/cszVpMwef2QSKa
	SZaGs/PfOvvgewyF/MeTea1fYPem5uSS7/3zBZnMxgf6CCmcN2E2pQltBwmwUkgrtPnXd5wr6xzHr
	vp1zZanA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGYvC-006wH7-1Y;
	Sun, 18 May 2025 15:58:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 18 May 2025 15:58:58 +0800
Date: Sun, 18 May 2025 15:58:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
References: <aCMOyWVte4tw85_F@gondor.apana.org.au>
 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
 <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aChx_ODF_hYKL8XO@Red>

On Sat, May 17, 2025 at 01:24:44PM +0200, Corentin Labbe wrote:
>
> Your patch didnt apply cleanly on cryptodev/master in tdma.c
> I have fixed at hand and the result is:
> http://kernel.montjoie.ovh/478852.log

Hah my debug patch was broken.  It didn't take into account the
partial block when recalculating the hash with the fallback.

However, this seems to suggest that my hunch was incorrect.  The
partial hash wasn't being corrupted and it's actually the final
calculation that was wrong.

This could be good news.  Because if it is a hardware bug causing
this, then the final calculation can be easily worked around by
turning the final hash into a partial update.

Let me crank out a debugging patch for that.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
