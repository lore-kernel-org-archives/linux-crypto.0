Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E116205E06;
	Thu, 13 Feb 2025 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739419757; cv=none; b=djiKJl5NRa7sf5VmgKwDVPsC50xo2fpSCXugRrZl3BKb1x7HdEW59cTEew3iIfG0VoqS+8g8ebLwCDLZtM2ovLgdg0pXvglWl62vgfnFuGStudg+WTJ7OUM6AV1p3uerouBaaAcdyaebcXzrttuisqq9Y4Auem80984j9LkCGFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739419757; c=relaxed/simple;
	bh=Wcl938ZKvkUh4XqOPIJ+fJuG7yca7zh5/sesrLOC8Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shZ3e5pf1A8vjZTk12sJm23yWUHFdMdnh06gN7hrwqlXwMM3kwK0MTXnH/YlGH+tbFG7qE3AFJ6CIU5oSELz/28NR3+BEwXnOZ9czed1Vckp2hvdNMCwLtK6gnwfCXZu2xCSWCiRIVxNzgJjDoNDgUb8jruFdVtpECCw3a4ajXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=njljT/FO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="njljT/FO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lCsvZsTofR4Py2O1aHZXrInHbqtjddVUbWlHMZBzL2E=; b=njljT/FO3VhAs4Z7hgp84SYXrC
	NHO8Rr9WAKnUOA5kx8JrAKiv1KI9adSWNUy6UCXgDw2WTgTJON95Ef1FX/3w/LJkTJDa46XmriQG7
	jJvfboAtFTuNXQ+GcSF3oYMafeZyydsV9Dx9bpmvf1fPYsS5/LZU3/TAKXROUTjAB62yCW+zRr77m
	b1u5qiECdajoOi/ImW+huUQzlkiFNb1g9w7qd0k7h6EinT2NWdC/nis4GPt2CniY79FIizsmYbHIz
	zd/8uCBuCRyoioveY7bMHNnoeW0FSDS5k8c0gef2rvZFmfvZpoIq4N1+eZTMX1AIFvCJxymy0Fzk4
	LMDwy5Lg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tiQK4-00HUsx-0x;
	Thu, 13 Feb 2025 12:08:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Feb 2025 12:08:53 +0800
Date: Thu, 13 Feb 2025 12:08:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>, davem@davemloft.net,
	dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <Z61wVdSjgnRr7uaX@gondor.apana.org.au>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <Z6hrvQzb5G_wqlni@gondor.apana.org.au>
 <20250209163430.GB1230@sol.localdomain>
 <9971160da17b1d18d4bdc87fc1297fda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9971160da17b1d18d4bdc87fc1297fda@linux.ibm.com>

On Wed, Feb 12, 2025 at 12:17:46PM +0100, Harald Freudenberger wrote:
>
> There are other downsides with the asynch implementations:
> They are much more complex and thus expensive and - how the hell can a
> test cover all the code branches?

I think rather than writing an ahash algorithm from scratch,
this could be done in a way similar to the simd wrapper.

In fact, forget about phmac for the moment, and please fix
the one that's already in the kernel: paes.

Under the simd model, you turn paes into an internal algorithm
that is always synchronous.  In the exceptional case, you return
an error so that the wrapper can then enter the async path.

The wrapper handles all the complexities of the async path and
hides it from the actual paes code.

> Next is the thing with the CRYPTO_ALG_ALLOCATES_MEMORY flag. If I
> want to have a hash implementation usable for dm-integrity the alg
> implementation must NOT set this flag and must not allocate any memory
> during crypto operations (includung setkey()). As of now I am still not
> through with the phmac code for this. And I only have a faint idea on
> how to implement this on the pkey and maybe zcrypt code...

Why do you need to allocate memory? If anything ahash makes this
slightly easier since you can allocate your own memory beforehand
through the request object.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
