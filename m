Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278D11C84CC
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 06:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741155514; cv=none; b=HtkeXe04TFWHbisYoPtpYSPNXEJ03zlkSZtpgMD9t44X0C0wtbE63O29wIC8Ru9NDoM/3EM0VIAnHF6xy63GJIlZptEIQ+jZ8aSg/QnF6tpjm7qhjDFeKJf1o2HM6KB5aK5Si9MdanI8me4qjUu8HgkqXJCv8MGaJiro7bX2UjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741155514; c=relaxed/simple;
	bh=SDCkTIYj7zwgJOutnIm4iywaE3FgNvLFbHCBmoGcnbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tn28Be4oImRVuHvO1egxi+NAOTWdm43/RaL/YCk7Fm5WSvc1ZRsmclH/9MWy7CcPef8ye9JEbIMvmo0zP1ntA2nNXtm7/mVTxNrblkqJs2TGo9pH9VKPjtcyo2s3M6CWFMsVdvm/OWwCyid/qTs9YUEOClEotefrgLS+tC0ZfV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X6As7Ko0; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X6As7Ko0"
Date: Wed, 5 Mar 2025 06:18:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741155510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1yGWecFDqKQYeR8vSmi+tRoNoJ4mz0WXCjz98jznmLE=;
	b=X6As7Ko0iJNHHi6y6LEyJSHLPRVXvjHrGLC/nO9pzhRFCdrReeMzrkIlDI/E5CLKGV/usm
	oOJ0iKQ3/3htlz1pav/n9qBPoqOkDlh+EyZUJxgfGrD+5fIbE29MTey1XIUSCyybPV++e9
	rapIF3cUykiBsbTLMsrPDYec6iFqOoc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8fssWOSw0kfggsM@google.com>
References: <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8dm9HF9tm0sDfpt@google.com>
 <Z8fI1zdqBNGmqW2d@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8fI1zdqBNGmqW2d@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 05, 2025 at 11:45:27AM +0800, Herbert Xu wrote:
> On Tue, Mar 04, 2025 at 08:47:48PM +0000, Yosry Ahmed wrote:
> >
> > Yeah I have the same feeling that the handling is all over the place.
> > Also, we don't want to introduce new map APIs, so anything we do for
> > zswap should ideally work for zram.
> 
> I will be getting to zram next.  AFAIK all that's missing from
> acomp is parameter support.  Once that is added we can convert
> zram over to acomp and get rid of zcomp altogether.

I think there are other motivations for zcomp. Nhat was actually talking
about switch zswap to use zcomp for other reasons. Please see this
thread:
https://lore.kernel.org/lkml/CAKEwX=O8zQj3Vj=2G6aCjK7e2DDs+VBUhRd25AefTdcvFOT-=A@mail.gmail.com/.
