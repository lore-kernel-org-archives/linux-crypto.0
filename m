Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2001BC5C
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 04:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741062611; cv=none; b=jvWJDWBoDK38npBWnDLCJp3//sHKxvyqTTqRFB24j/twqmTCYPobU1iqcfAM2bdueXMPwvwNBpg1VjoL9WEljC+Eta9188q6VIBN3uCvj4ZOTsakcGH/9v2OSj83KNmWgyvAynIpwOjnngJrn5dtKJCK06JholSoh2CAa1/RRQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741062611; c=relaxed/simple;
	bh=jbsudPnrb/LIAdpQV96uxIGN5hVCYjLjpFHBruLCP90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUVll2qbuG2cvpcmbiegidv1lwqGckrh18VS2sItSxL2uvbOO0FI9cSRu47zdK5lXHGB1qYZzltAxQkFhPg8Nr4p5KUhuuPCNOhGBs+lIiEUXQ5HFMNH51HFz67V8Eo7LwtTOGRmLgaS2cUnbDIPyOCuhy46+esDOPt1RgfEmNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gUsKSdWm; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gUsKSdWm"
Date: Tue, 4 Mar 2025 04:30:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741062606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNv/Glifk73jt7z0FPmxZX8Vcu3aK9Hgz6Mjj5M3NBc=;
	b=gUsKSdWm+gRoNk+ML0cx0WgrTmOCCig5oBv/YDjmxXneM6lDr7+zizLoe9qMrd3A9C1uUa
	encG6Q9K+p4cFyx2xmm2WqpMAkuT+xoRb5hRuNmHwVB9CUH0d2fAkVCtWYHgUPWzY6sLhn
	JGhqJepQBHYeo+sT0JM8SzsX+YIYmes=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8aByQ5kJZf47wzW@google.com>
References: <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
 <Z8DcmK4eECXp3aws@google.com>
 <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 04, 2025 at 11:29:44AM +0800, Herbert Xu wrote:
> On Mon, Mar 03, 2025 at 08:17:27PM +0000, Yosry Ahmed wrote:
> >
> > I have seen the other thread with Sergey, I believe the conclusion is
> > that zsmalloc will be updated to use SG lists, at which point zswap can
> > just pass this as-is to the crypto API, and we don't need any copies in
> > either zsmalloc or zswap.
> > 
> > Is this correct?
> 
> That is my hope yes.
> 
> So there are two reasons why zswap should be using SG lists:
> 
> 1) Non-linear memory because compressed object spans two pages;
> 2) Highmem.
> 
> > Will this patch series be dropped?
> 
> Not comletely, I rather liked the simplification of the scomp scratch
> code.  And the chaining functionality is still needed for the batching
> work.  The virtual address support will disappear for now but could
> always come back if someone wants to do that.
> 
> However, I will reinstate the scomp scratch buffer in a more limited
> form just to cater for the need to linearise things if the algorithm
> does not support non-linear input (I hope to modify the algorithms
> we care about to support non-linear input but that's going to be a
> long-term project apart from LZO which I've already completed).
> 
> Right now there is a proliferation of per-cpu buffers throughout the
> zswap/acomp call-stack.  I'm going to consolidate them so that there
> is a single per-cpu buffer for everything (the stream memory, and
> the linearisation buffer), and that it only comes into play when
> needed (so hopefully LZO decompression will become completely
> preemptible and not use any per-cpu buffers at all).

Looking forward to this :)

> 
> Once that is done I will repost this.
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
