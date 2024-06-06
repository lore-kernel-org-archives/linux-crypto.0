Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B4F13AA48;
	Thu,  6 Jun 2024 08:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717661306; cv=none; b=Pwi2Dg8DVNvaG2o+vXcjVk308eSxFxMvr4ObBUBVK/bbHvurFuehoqMCoNGCus2KHBswYJFhXVDwfi0nADC6LTepZn1fL2WoaydD1+iolWLQqndWscAZ1TqnKkukQs3joRQ68Xht4tpglsAL0UkzaSGcvYMWQcXwR1WMP49fiUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717661306; c=relaxed/simple;
	bh=6xuV2MJEvNFB5sqdVQt/0qFPZktWFm9ZqnfUlVgZgwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtNomDFXSEhK6gSvV1PeEWW/S8mu8hF/XBbVJi777DGrAkYTtT6jKLQTF/sJkKqBOXioHsclkUFRGu8i9WvykxAWr8yMaKKY9pa6m45s8gbWHs4CAo6vlJYaP/53LCdI0tpvlK3XNpwXGjPyYhrE7ay9grGOaKerljo2TJmAZ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sF8AR-006J1u-0r;
	Thu, 06 Jun 2024 16:08:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Jun 2024 16:08:17 +0800
Date: Thu, 6 Jun 2024 16:08:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZmFucW37DI6P6iYL@gondor.apana.org.au>
References: <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
 <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
 <ZmAz8-glRX2wl13D@gondor.apana.org.au>
 <20240605191410.GB1222@sol.localdomain>
 <ZmEYJQFHQRFKC5JM@gondor.apana.org.au>
 <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
 <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au>
 <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>

On Thu, Jun 06, 2024 at 09:55:56AM +0200, Ard Biesheuvel wrote:
>
> So again, how would that work for ahash falling back to shash. Are you
> saying every existing shash implementation should be duplicated into
> an ahash so that the multibuffer optimization can be added? shash is a
> public interface so we cannot just remove the existing ones and we'll
> end up carrying both forever.

It should do the same thing for ahash algorithms that do not support
multiple requests.  IOW it should process the requests one by one.

> Sure, but the block I/O world is very different. Forcing it to use an
> API modeled after how IPsec might use it seems, again, unreasonable.

It's not different at all.  You can see that by the proliferation
of kmap calls in fs/verity.  It's a fundamental issue.  You can't
consistently get a large contiguous allocation beyond one page due
to fragmentation.  So large data is always going to be scattered.

BTW, I'm all for elminating the overhead when you already have a
linear address for scattered memory, e.g., through vmalloc.  We
should definitely improve our interface for ahash/skcipher/aead so
that vmalloc addresses (as well as kmalloc virtual addresses by
extension) are supported as first class citizens, and we don't turn
them into SG lists unless it's necessary for DMA.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
