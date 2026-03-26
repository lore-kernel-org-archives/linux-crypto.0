Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2120235F612
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 08:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774514650; cv=none; b=H3UtcDs43vF8ttV2x4EBmseCRDwX5/uuMntmZZFS+UQpnYuUD4hdNjY54AIascPXqCgqOvkCElieA8odeZ1JgAWjaFbyJzmh8QMbbsg2DmByitTAOaTBlrxBP5uNgA4cSTFFaEpm/WtRc546PNjKTVDyWQEJd+Cavx0G70+3I0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774514650; c=relaxed/simple;
	bh=88sQCgKTRlKiKBHna8cGbW0kdS1ure7TvUoaXmdZ5A0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IeXIrLWGBZqpXgymutGlJkEURvB9tlk8k8DZQt44byrtx6ToigyXLBnQEidi9Kdt6mSEpM/Wg2QYjYzkHTFCvhwMi9VZb9A+ho018NZfU+6awnv5qT6hs/5ADKMB3PR8ja0eB5zhcuXvURTKFYw9nO5J+9QEDJhJApcd0MQ8UUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Br6l2bSi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Br6l2bSi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=C0LDul5N3CuDJJoqVLY27CdIZPw8bM8qyBfdQyjcvHo=; 
	b=Br6l2bSirvglDpwIQ2KDSCkG1Gw2JDILyZXHhvWydps0Qmwdaz8g9uxqTl+JqYLJCrd2EflJd1p
	/TPq+9A7J1minfJ//XKVQj1K/JBVHLFpST3atnRedrLWhMCfOy6qNIZoJ7DqfX0+UWC3QJhB0puk+
	WX5iCtdDOhKnzG6cZfcNl6HnN7wP1KYDz7BXQL1KRMzoWm3Qpip8kXNK7Zyo1CeVEB+2DoioU0JOV
	4xe+hJewaq8RXffxEok3CSa01kD3wdrOe7yfxyBvGp3vMcrKsgF7DlbRfYhZ6eon6WXvLy+Iey8ix
	/CojpobtkYeqmpxntR/EkIHJekACwivZRCXQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5fuT-001FIa-0R;
	Thu, 26 Mar 2026 16:44:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 17:44:03 +0900
Date: Thu, 26 Mar 2026 17:44:03 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: Re: [PATCH] crypto: deflate - fix decompression window size
Message-ID: <acTx0-uYRgjaTLU9@gondor.apana.org.au>
References: <20260324180905.120703-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324180905.120703-1-giovanni.cabiddu@intel.com>

On Tue, Mar 24, 2026 at 06:08:58PM +0000, Giovanni Cabiddu wrote:
> deflate_decompress() initializes the inflate stream with windowBits set
> to -DEFLATE_DEF_WINBITS (11 bits, 2KB window). Valid raw DEFLATE streams
> allow window sizes up to MAX_WBITS (15 bits, 32KB).  Using a smaller
> window than the one used during compression causes decompression to fail
> for externally generated data. This might occur if data is compressed
> with a compressor that is not deflate-generic (i.e. this
> implementation).
> 
> Use -MAX_WBITS when calling zlib_inflateInit2() to accept all valid raw
> DEFLATE streams. The inflate workspace allocated in deflate_alloc_stream()
> is already sized using zlib_inflate_workspacesize(), which accounts for
> the maximum window size, so no allocation change is needed.
> 
> Fixes: 08cabc7d3c86 ("crypto: deflate - Convert to acomp")

That commit doesn't touch this at all.  I think you meant

commit 62a465c25e99b9a98259a6b7f5bb759f5296d501
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Aug 30 17:56:25 2023 +0800

    crypto: deflate - Remove zlib-deflate

But this simply restored the status quo prior to

commit a368f43d6e3a001e684e9191a27df384fbff12f5
Author: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Date:   Fri Apr 21 21:54:30 2017 +0100

    crypto: scomp - add support for deflate rfc1950 (zlib)

So the commit message needs to be rewritten to clearly state
why this is needed for the "deflate" algorithm.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
