Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B232E338F
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 06:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741154749; cv=none; b=L7DZMbyNr23HWibSY3JLfP1YIGgybYKC1IGhvZ7sQnw4zC+AAnIg1hc11mWBoVI3by640N6cCU0Ddt39bnSKLyhDtEY/TWm+RThSxBZiNssZYAmpmT/kMpXz6d3Vmfp3IRcVHDcGQzERxDfoPsEONwTuPqjBMZFkvg1ndvxCtUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741154749; c=relaxed/simple;
	bh=/sU08e1t+4gWrww79l+PAmT62VJ4h2Z/PhubO3ddsF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvXYCrX/LaPUiPBBTnG3wXzfy0DF7e8jw3YIf92FajanNSIa1kIJGz0U4dTGA7t/f2lE3ft01Uf6lemfp0iFDPymR5RvuaNhgRBsGM2kwapIp0JmW7jUluB09oD9VaZv7t/7g5sNax7/Fd3Cz6FFKsfo1qNjN5/LTtS0/+syeyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JZE5OAqA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JZE5OAqA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OwWJrEWYKmeVS7IzW/VHvKh8rDdccegxs+uFdljTB6A=; b=JZE5OAqA5PtPGfpwDDr0unr6vZ
	aSOKxvVG6mHY7xOthK4x+2OueYno34YHHXE0Irx+UGBj627lLR+Ftf/cMBpsAB5sL1tZkoHEiggVy
	fHtBdDsTFQABWOWFoGouSo/i/zDLBK/G+9VzwFH7Cr/yxGXYOoFgpK7EaIoAribqW3JSNoxIMqMyA
	9DO2X8/m0WiL9xRfGMq2RpAcafklFXuO5SgCyy6+cXXEhhSbVSoYuN6NBlFuYsUfLor5CaNVxGd4h
	vJRWkYxyk3eXZJ4f86TSr4NtjVaBwGd0faNabVuIGSUYBv+p0uFTEAHeXXxW8Um7Gqb/So+hqcVsc
	+0G0+gSw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tphsr-003spX-1F;
	Wed, 05 Mar 2025 14:05:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Mar 2025 14:05:33 +0800
Date: Wed, 5 Mar 2025 14:05:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8fprQeKNvU5QCrP@gondor.apana.org.au>
References: <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8dm9HF9tm0sDfpt@google.com>
 <Z8fI1zdqBNGmqW2d@gondor.apana.org.au>
 <fcjhjs3yp7odqskzvfzvovhdabov6hnilqnjb6rkvmngodqwze@ln2isck2a6im>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcjhjs3yp7odqskzvfzvovhdabov6hnilqnjb6rkvmngodqwze@ln2isck2a6im>

On Wed, Mar 05, 2025 at 02:58:17PM +0900, Sergey Senozhatsky wrote:
>
> Hmm at a price of diverging code bases?  Is it really worth it?

It's still the same function just with different iterators, one
being trivial one being SG-based.

> And it's not guaranteed that all algorithms will switch over to SG,
> so the linerisation will stay around.

Any algorithm could be converted over to handle non-linear data,
if people cared enough to do it.

If nobody cares then sure you can just do the copy.  The point
is that the copy needs to be in the API layer and not further up,
otherwise you're forcing it on all algorithms, even if it's capable
of handling non-linear input.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
