Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5E8ECF;
	Thu, 27 Feb 2025 01:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620782; cv=none; b=RIgl+oaIJgCXZ6BJRTsYKNKsLmH955CjQbIqEI7L1DiUscvcUeZTqcLuF2tGTTQPC77LNfCxzJXDQHN0uIiEKs0bCYEclRBxqmljt8F64mCTcjPrIZ6tpNOIKQkSh/XVbQrZtWgdHTbuBKJT5qseUwav0j1PRXAdwTHaPWx5umA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620782; c=relaxed/simple;
	bh=e3kpkEEbsRYwEK4wxdO4LN/DJObHsOIrx1Sm9hCI0R4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdBCRonwfC7pBhPysD56JmqcE1LFHzlX5LuWhlLmw8rxzRwajcyM9mxZJUS49U7E8FdeCmwWG9ZEDQ33En+0a7wnOSjLRvW1l0WgHGVBnTFHc4Ewx0P0l62nLARibtabQGWgWx/0qJ95dzRcfxAVNX1KjpQafXA/Vp3eVMWZJzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=J5cHs0a/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="J5cHs0a/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tYqINuB4albZ0VTgLu3pfFxH0CuBGfvVR1aP+44OcvI=; b=J5cHs0a/ZZtg/jGwgQzwh9VJtg
	svzo/Gqrs0kFu8MaOAeCmd8JM5vDyu7nb2WfIegpm0GlXS/xe9HTQ3UAREEfvyFC/FJCNWEX/K/qD
	uEt+TGjABXpvboqMJL9sglHW2hgoSEosYmcjCRHgQTa7pdBdlP/2D+EVahRvR+STCH3AiOhVooC/K
	xjT0OprjHgbOhofRa01SdZozIDunv2/X1uVQpXekTo8kFVk+eV/KBt2JdocDJFNJWEQMbDkQ9RYBc
	kfUF6edA1CkMLLr+IVWS3J2X4HhmQCl+YNB82l/I2bdKN34I3nwbhmZslG+IT0ystv+PI7hm3JUtp
	hmLW69oA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnSyY-0028EY-02;
	Thu, 27 Feb 2025 09:46:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 09:46:10 +0800
Date: Thu, 27 Feb 2025 09:46:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Sterba <dsterba@suse.cz>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nitin Gupta <nitingupta910@gmail.com>,
	Richard Purdie <rpurdie@openedhand.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
	Dave Rodgman <dave.rodgman@arm.com>
Subject: Re: [PATCH] lib/lzo: Avoid output overruns when compressing
Message-ID: <Z7_D4i5yifwdXjwZ@gondor.apana.org.au>
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
 <20250226130037.GS5777@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226130037.GS5777@twin.jikos.cz>

On Wed, Feb 26, 2025 at 02:00:37PM +0100, David Sterba wrote:
>
> Does it have to check for the overruns? The worst case compression
> result size is known and can be calculated by the formula. Using big

If the caller is using different algorithms, then yes the checks
are essential.  Otherwise the caller would have to allocate enough
memory not just for LZO, but for the worst-case compression length
for *any* algorithm.  Adding a single algorithm would have the
potential of breaking all users.
 
> What strikes me as alarming that you insert about 20 branches into a
> realtime compression algorithm, where everything is basically a hot
> path.  Branches that almost never happen, and never if the output buffer
> is big enough.

OK, if that is a real concern then I will add a _safe version of
LZO compression alongside the existing code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
