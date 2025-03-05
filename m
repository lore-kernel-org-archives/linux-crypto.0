Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792E82E338C
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 07:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741160787; cv=none; b=UNlEtPvWr9MyHu2zRXqF7o3IvfvoPj35KJsDu9y9i/ZMLjjUlKgv7+faBPtbmx+HEob+bRF3SMzNWZRYhdIRcgGUsIS3cVnXVmI0C5fBRiYD3VddHITseC3Tfx/v1yetE/ZrlOw8p/MRfYTCvKnTby5G/r4g5TfQGWiCz4+2QIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741160787; c=relaxed/simple;
	bh=8SbhBn5bz1P/2lEiCttUgjOafkwRhOKxUE7b5/p/6mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7VoAk5cKVcvg0KKII3aJ+5RMEx9QKEXoohR0nGWqhonNOW8H5N5cMlYiUNKq4aABMHIFrl0cZxxg4ge/TpK9Pm6sdySp1pw+WzIEM7jQ/jRVLSqHfHHnaLs6d4r2l2J7LwvalApLB42UyGe3idpEOe0sN4Z5g7BjLNwch7yqyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qe+eWC4f; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qe+eWC4f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7lxQGJWnptYN6UJuItgLOi8alFXoRtXtR7MzeGJQRmg=; b=qe+eWC4f6x2IYkKkc+nU+IYq/k
	pzd31Tex4VcnHP0W5MTbJxjFiALMM9PlcJPtU5bu1iBRjKfHFpePibNeNKDMLbWTKqjhcKeY4Cwa/
	L6ILmIRrjd5gB9Go1bL3qJH+QcKdw7yGPByPA5wi5VUnJSU2ybc0VDxfZ2fbDI/nk2WewAv9Q4klx
	h32bSitkn1/otCUcy0PvC8RStgIrABoupRZkl94hXpI7AoahRMGdLM2Uvj9I7Fjc5c3zRPN5OvqKU
	oPGTuCB4KW+G8C8h4vD10HXBu323DYLYH2P/8HH1iYcasd0EZ2pn11dxbHz8QTYKpt2Zyo94qlvkB
	S45N+g7g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpjSM-003tvh-0I;
	Wed, 05 Mar 2025 15:46:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Mar 2025 15:46:18 +0800
Date: Wed, 5 Mar 2025 15:46:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8gBSgasXlu_0_s2@gondor.apana.org.au>
References: <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8fHyvF3GNKeVw0k@gondor.apana.org.au>
 <Z8fsXZNgEbVkZrJP@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8fsXZNgEbVkZrJP@google.com>

On Wed, Mar 05, 2025 at 06:17:01AM +0000, Yosry Ahmed wrote:
>
> Actually I just sent out a series that I had sitting in my local tree
> for a bit to complete Sergey's work and completely remove the map/unmap
> APIs:
> https://lore.kernel.org/lkml/20250305061134.4105762-1-yosry.ahmed@linux.dev/.

Looks good to me!
 
> I am not objecting to switch the API to use SG lists if we intend to
> switch multiple compression algorithms to use them and will completely
> switch to using SG-based APIs in both zswap and zram. But I don't want
> us to have two separate interfaces please.

Fair enough.  I will wait until crypto_acomp can replace zcomp
before posting more SG list changes to zswap.

> Also, please take a look at patch 2 in this series for another reason, I
> want to make sure if your virtual address series can be used to remove
> the !virt_addr_valid() memcpy() case completely.

Yes it should work provided that you specify the memory as nondma.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
