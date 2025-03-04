Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186DA1FBEBE
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 08:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741077741; cv=none; b=NzxWIId5+cMCN0TR0JCm1+34A5uuFt+GpIxWNIQyX/kcbzPFR7Eu0Y1PjCRk8nIZxrgNykNFpROJFNthiBton0hmXT3bRYO5G/5pB/IUlHe2BhoSCS8K7VifUV+3omjfPvi0pv48S4060oNwqbOPREzUicfVtveXC4gOMMO1p/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741077741; c=relaxed/simple;
	bh=/yL75oggucnceMKagRztrmabt6VD8GnmEyOrXZF05Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YFN6S8RW4C7WAEkqZvnTz1/weNDOkb6JWM+139rlQusUxxTGhEaiDG7QNbi+dRe0jtCtLlVKfj75n+AOQBQJS9FbxtbpFLyixJ7BudtjsEWHKHZC06AdPQivJpU/2tzHpGCFdKI8jPv0VHn9i8zEgkG+S9sXuxcOJNzCg/cP1ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iYWuQ7m4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iYWuQ7m4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ar9BMCiktZ6mWQxbQm7B6sVN3oJ1CjNwa2zZdCEvfvc=; b=iYWuQ7m4X2dEHbdhiTecUOz3Gc
	kgFz014ZB+G5HgEdftTATRO0XOfNvQtfKT7MEEYhw2Cv2sgXnq2oaQpBm6H6QGTjGItttAVSYsHbd
	hYnZBfhHuIBBIxPDw28zfmvHUq9E/e50xS5hkSRZyl3T8c7aoaAW/MYPUtGhDwN4ePlT+e8/R0BRK
	KTCYJlxfpLRFHOCN3IbFgXCYr+NGZGpc/3zor0YcH1cHEdRhOxMnbgUd9bIiXBQ0kTog2bHJWFBpw
	rASkj3olfNJA1O6KYOBCYlVPcxB4cmFNr0KTEjV8nDERs31xJi1vt45qg5FDA1nyR6Piq5ggPFJcA
	+0/OV3ZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpNqn-003ZEh-1w;
	Tue, 04 Mar 2025 16:42:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Mar 2025 16:42:05 +0800
Date: Tue, 4 Mar 2025 16:42:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8a83Vjmvm81LGOf@gondor.apana.org.au>
References: <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <vghra5lyaxc7zgzgqrewa5yxanziuh4d444w45ukt6dye3hhfg@ukgknqwyru35>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vghra5lyaxc7zgzgqrewa5yxanziuh4d444w45ukt6dye3hhfg@ukgknqwyru35>

On Tue, Mar 04, 2025 at 05:33:05PM +0900, Sergey Senozhatsky wrote:
>
> And at some point you do memcpy() from SG list to a local buffer?
> 
> zsmalloc map() has a shortcut - for objects that fit one physical
> page (that includes huge incompressible PAGE_SIZE-ed objects)
> zsmalloc kmap the physical page in question and returns a pointer
> to that mapping.

If the SG list only has a single entry, there will be no copies
whatsoever even with the existing scomp code (crypto/scompress.c):

static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
{

	...
        if (sg_nents(req->src) == 1 && !PageHighMem(sg_page(req->src))) {
                src = page_to_virt(sg_page(req->src)) + req->src->offset;
	} else {
		Use scratch buffer and do a copy
	}

This still does an unnecessary copy for highmem, but that will
disappear after my acomp patch-set:

                if (sg_nents(req->src) == 1 &&
                    (!PageHighMem(sg_page(req->src)) ||
                     req->src->offset + slen <= PAGE_SIZE))
                        src = kmap_local_page(sg_page(req->src)) + req->src->offset;
		else
			Use scratch buffer and do a copy

I've also modified LZO decompression to handle SG lists which I will
post soon.  That will mean that no copies will ever occur for LZO
decompression.  The same change could be extended to other algorithms
if someone wishes to eliminate the copy for their favourite algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
