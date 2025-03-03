Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246A52B9AA
	for <linux-crypto@vger.kernel.org>; Mon,  3 Mar 2025 20:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741033056; cv=none; b=ffS7dWsi1HehM4EPMaeQSpyzEfhqkcM2FCe1nUlhK4zGw1umdRiYx4O63cTH6M7MkrPamkMYMZE5nxsrzd47tepIatv32FXyXwcF14ePfFNu+y3I9EPb0cymQTTdKKppf6haJsrhX0S1DG2KUC1prFUElHdkNdfty2wEQzhx9XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741033056; c=relaxed/simple;
	bh=joR9r3/L3DIq5W5SywDWUZLI3xXOOlpfc6pwS+Vpf+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWpVBRluOgedP6Lc1bmWfStrOf8fEPgn6f526ZNvaoOBKYAZNZ6EaWB1gtTVT+IPYcmDJrTl9mRsjzemro9lXkNFRFncyPUBpToqSjLgCQC0X0mcBTvYc/+OrwjbviohRatcjwSKTDm7yr5vmwchJCEPWZgenGHdA1ruwdFS2XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xIGkQl6y; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xIGkQl6y"
Date: Mon, 3 Mar 2025 20:17:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741033052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tBrtmBoSs2rTsZ8Uol/MTGHwyc4e+wo/BgpFbOP6EXI=;
	b=xIGkQl6ynHXDrCowub/aY1FH5hJSjlHZzahywTBaF8ZAkVJOcQqNZxdcmyEbOspNh1cBtn
	BgalJI8tnkuWX9BQ5zyHqXnVv/Ux6RK1II3181QH3q/UhMqJRU6t3wd5QydlLCDQt3Z2Z1
	cgv+D+Y13riS0qeLfUm42dC1Z1NC9Ks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8YOVyGugHwAsvmO@google.com>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
 <Z8DcmK4eECXp3aws@google.com>
 <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 01, 2025 at 03:03:48PM +0800, Herbert Xu wrote:
> On Sat, Mar 01, 2025 at 02:36:50PM +0800, Herbert Xu wrote:
> >
> > I thought this was a lot more complicated and you had some weird
> > arbtirary pointer from an unknown source.  But if it's just highmem
> > I can get rid of the memcpy for you right now.
> 
> So it appears that your highmem usage is coming from zsmalloc.  In
> that case you don't want virtual addresses at all, you want an SG
> list.
> 
> In fact you've already gone through a totally unnecessary copy
> in _zs_map_object.  Had it simply given us a 2-entry SG list,
> the Crypto API can process the data directly with no copies at
> all.
> 
> The whole point of SG lists is to deal with memory fragmentation.
> When your object is too big to fit in a single page, you need an
> SG list to describe it.  Forcing virtual addresses just leads to
> an unnecessary copy.

I have seen the other thread with Sergey, I believe the conclusion is
that zsmalloc will be updated to use SG lists, at which point zswap can
just pass this as-is to the crypto API, and we don't need any copies in
either zsmalloc or zswap.

Is this correct?

Will this patch series be dropped?

> 
> Chers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
