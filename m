Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB36114A0AD;
	Fri, 10 May 2024 07:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715326847; cv=none; b=qLyAARZmdiLk8mOhyRxZpZ9q4GnTqlLzID9fgDmhEGv1L6SJv4QlfN8rsMiybXRZ+Inl2FE5ouea27OHQ1D3pM8D4K6gL2j9bC8/NAWQ4KhbxVV2rYKxuXKlBa78KCr4eLzUjU70MxhT9GG8iA94O5aX+veRyHbmOATHNlFm0os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715326847; c=relaxed/simple;
	bh=4P5ZgoP/b2LxVlyXCnK4MCQuRxhGO9eRPBLoDnFhz0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5D8J4wgB7IsO5cHHsB+ls4mJndJYkgREDAd9Euie2EQnRqRniaOJesx6iFILylGXCVNgCti9VAg60X22BhLjwiv6aJsykZD6gJRjCOqCgL/Mpqj+Sg2Ksex95sfIg/UXxZZGF21c48ol3g8IUZZDUKhLGgZohKmrXGkFeHmGsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5KrU-00DHCj-0g;
	Fri, 10 May 2024 15:40:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 15:40:12 +0800
Date: Fri, 10 May 2024 15:40:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCHv3 00/19] zram: convert to custom compression API and
 allow algorithms tuning
Message-ID: <Zj3PXKcpqUPuFJRu@gondor.apana.org.au>
References: <20240508074223.652784-1-senozhatsky@chromium.org>
 <ZjzFB2CzCh1NKlfw@infradead.org>
 <20240510051509.GI8623@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510051509.GI8623@google.com>

On Fri, May 10, 2024 at 02:15:09PM +0900, Sergey Senozhatsky wrote:
>
> Well, I asked crypto folks if that's doable and the only reply was
> "did you try using compression libs directly".  And that's not a
> bad response, I take it.

Sorry, I've been busy but I was going to get back to you on this.
 
> But in general case, a typical crypto API usage
> 
> 	tfm = crypto_alloc_comp(comp->name, 0, 0);
> 
> should become much more complex.  I'd say that, probably, developing
> an entirely new sub-set of API would be simpler.

We could easily add a setparams interface for acomp to support
this.  The form of parameters would be specific to each individual
algorithm (but obviously all drivers for the same algorithm must
use the same format).

Let me hack something up for you.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
