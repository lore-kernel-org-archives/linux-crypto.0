Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0522236FA;
	Sat, 19 Sep 2026 04:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789792228; cv=none; b=TGpPcDjf5VMO2iRhSbGguWqnufbdDN5fRHdyTPo1WRYW4lDUZrO+bq6BpwVwKd8qY9HVVDJ6+yEY3Hwkstyd6lXZh/uuDmaCpoPEhOaauKrQhprhp1GK3B3JTkBvLhczdDykTTUlhu/y+8YRY58S9W5uKa6CwW8CJu+0FQwNe4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789792228; c=relaxed/simple;
	bh=9nQfvskgJr6vcesVtX2tFudCYtZ/j45gIDAQHtUfW9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2x26AuNm8v6Jr+v9+lKOe1Ex7PLtme2qDfAEAi3vi67NCb1UhhhyfLhVpHEuEHBThuKPNr0uaM8LsO+O2SPJdMIPWM4ElfPRCrcTIwLeJ/91RuRD0drrT0f83LpOJ3ojwAtMvtMqHYOQGhE83VwN9+7s8TqwBQKwJD/CFwg0FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fyQ5cxLw; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fyQ5cxLw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=w+UeNwv3t+cYqiKhSTr5CY5tQ+ov5hsLoeiCWF/Iu9k=; 
	b=fyQ5cxLwKL03RWgQHl0Zo2+8zxNLZBDbQrw97S5j5stDtE45dKunhhLpDnm7/N9LLJkv5w4s5UX
	tTey9O/hQydcF6LXY2HrTrN0MFjZQytq1z2HraG0s59hBGK1FL2HAbfgnWBuoSjjJDkoPZyROts8Q
	eARst4RyB6lQ5OcG97Fna++vS8u849OYQADx+82UDibGoZtOfwdOUSGxyFsPvKXjrj3dX5s3VShns
	3wLSNVbiBN2ZQVLPjx0GmpKTJN0S8r4toTBRkL6j1t5iJEZRhvjKiCbut0SBmXhChlQV33K3P6uce
	IGLwLakUxmsAV2bPICXUS5oz3BZNOZl3EH0w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7miR-0000000Fdga-0xps;
	Sat, 19 Sep 2026 12:30:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Sep 2026 14:30:19 +1000
Date: Sat, 19 Sep 2026 14:30:19 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Leonid Ravich <lravich@amazon.com>
Cc: linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, ebiggers@kernel.org, snitzer@kernel.org,
	mpatocka@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH v5 2/5] crypto: dun - data-unit-number dispatch template
Message-ID: <aq4P2xxmcYLjqKEu@gondor.apana.org.au>
References: <20260630083431.2772-3-lravich@amazon.com>
 <alRMn--pY1ELYmBJ@gondor.apana.org.au>
 <20260715120102.6687-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715120102.6687-1-lravich@amazon.com>

On Wed, Jul 15, 2026 at 12:01:02PM +0000, Leonid Ravich wrote:
> 
> I benchmarked the mid-API split vs the legacy per-sector loop on
> r7i.metal (VAES-AVX512): dm-crypt shows no measurable throughput or
> latency regression, but a microbench isolates a fixed ~50 ns per 512B
> unit.  It's a fixed per-call cost: the split
> copies the counter IV to a per-unit scratch and re-walks the sglist per
> unit and is paid only by callers setting unit_size != 0.
> That gives two directions:
> 
>   1. SW batching layer (current v6): mid-API transparently splits when
>      the alg lacks CRYPTO_ALG_REQ_SEG and unit_size != 0.  
>      Works today on every existing skcipher at the ~50 ns/unit cost, 
>      and goes quiet as algs gain native support.

I think we should be able to eliminate this overhead.  Could you
send me the patch so I can take a look?

But going back to the dun template, I think we should still go with
no templates for plain64.  But the other ones should use a template
instead of using the cc->iv_gen_ops->generator.

IOW if unit-splitting is in use, dm-crypt should always pass the
sector number in little-endian format in as the IV.  Then depending
on which IV generator is configured (which should be done through
templates, just like essiv), they can generate the final IV.

With this scheme, there should be no overall increase in indirect
calls in any case (and with one less for plain64).

This still preserves the ability for optimised implementations to
eliminate indirect calls for the IV generator by handling it directly
rather than through the generic template.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
