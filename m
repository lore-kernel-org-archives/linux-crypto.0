Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503421C9EB1
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 03:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741059009; cv=none; b=er2oc7PDjAa52VV1iYW4Pe2zib+rY4yBirRUofjjpj6V/csTkdy/6sm+dMz5gUJLJPN/gIng1FtLCmooo0qls8HZTVXdOkGpPr9ws7fgEF1ss02olOaGAoToUkBTP7vrVhutmUUsivKdan1nitlJ4mR4tr8I41SKGVYTifRZosY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741059009; c=relaxed/simple;
	bh=3e6jqH7NXm0/hAsWkBGzbMzTHc/sjtQSGJVmRHs2HW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FhyLevz1+Z5/Bot/XdMGvCLL0vBscDjwRARCys/gaeKKRP0mXcyiBV5L0+Jx5BxAUUJRNgAd2s881HciOnAbqa+U2IcE+p+n3FqO4yESlaJz8QPMsdIeKBvP6UCaKqWddPCuSndD/O32QF8k4fuyVS8u+cN6RLfMkY/E6ny/Row=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=g+DS0Bp7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="g+DS0Bp7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rFsTboUj7sEp6BL834xzymGgVd/XeRc58hzpRPIhZ0w=; b=g+DS0Bp7LvVDaRN0qQhnkYFANZ
	twrjf7sKijWCRHuAlHW8q9y3kGIdflwU9/qUr7+NEXfFkdyY0lL2iEysanhOPJEar3Pepd0Nv1ouv
	er0nZAwA+9gSpf8ERjqgUfHryaoNsjDTqE4VoXhWc4RKcq+PUZTWFeOI+spKK7V96aYN9OdtOGY7Y
	RRaFFi5ULsVG5xnz+IkSITRJkiBt+pn0dCHMzV8ybNxi80KEqCS7TW6jiEyxvWJertxtxdw2Fuq7A
	C16j4nkz4ZdxmVEq4NVRT4fMyDoQ/c10r0x/eB2Dh0Li/E3AfHpmfWVxb21KSnb8R2Ak5161Uv++w
	wao38rSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpIyW-003USb-0o;
	Tue, 04 Mar 2025 11:29:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Mar 2025 11:29:44 +0800
Date: Tue, 4 Mar 2025 11:29:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
References: <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
 <Z8DcmK4eECXp3aws@google.com>
 <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8YOVyGugHwAsvmO@google.com>

On Mon, Mar 03, 2025 at 08:17:27PM +0000, Yosry Ahmed wrote:
>
> I have seen the other thread with Sergey, I believe the conclusion is
> that zsmalloc will be updated to use SG lists, at which point zswap can
> just pass this as-is to the crypto API, and we don't need any copies in
> either zsmalloc or zswap.
> 
> Is this correct?

That is my hope yes.

So there are two reasons why zswap should be using SG lists:

1) Non-linear memory because compressed object spans two pages;
2) Highmem.

> Will this patch series be dropped?

Not comletely, I rather liked the simplification of the scomp scratch
code.  And the chaining functionality is still needed for the batching
work.  The virtual address support will disappear for now but could
always come back if someone wants to do that.

However, I will reinstate the scomp scratch buffer in a more limited
form just to cater for the need to linearise things if the algorithm
does not support non-linear input (I hope to modify the algorithms
we care about to support non-linear input but that's going to be a
long-term project apart from LZO which I've already completed).

Right now there is a proliferation of per-cpu buffers throughout the
zswap/acomp call-stack.  I'm going to consolidate them so that there
is a single per-cpu buffer for everything (the stream memory, and
the linearisation buffer), and that it only comes into play when
needed (so hopefully LZO decompression will become completely
preemptible and not use any per-cpu buffers at all).

Once that is done I will repost this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
