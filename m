Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F261A316A;
	Fri,  4 Apr 2025 08:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743756375; cv=none; b=Pw8h8Xpy+sJmUAaKUuDLKFZKGSZ5zyAQUrQeYwyZaUAHXmaK2kdmlO/stIZuNq5X1Sl0/i3cl6Tux911xRLJqiNL61yWE+/gWGIR6VBK4sZjfNGkGkdx9Yohy8qafuPQjxxHw6G2359Q4Df4c67Qkk3om7XPOit8uidxhHxZwxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743756375; c=relaxed/simple;
	bh=U+qQ7pPdcSkGjmRrgrAC29ChDfgI5BkPrBje4kN75+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8SH77ndw6WNHMDtV1WQ7N+YLtDN896XLkm569rOu6/EqlQ0RzCuGbohZebR+p65eqDmjDNPeLx68DzMjU9rvw9RJJC9rZtDZuyu42Gx7qX5puX/WnwmBHcNETO40ehXLgSHvJicwWECx6K5UmHsuRPOLOZhjlzc6v9ZTE07GoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cn8LN7CV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cn8LN7CV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1QyhuqlkJjaA1p21YKwlGJzD+w7/jhv1314mzzJkJHU=; b=cn8LN7CVTxIhtJ2+2DIVLS+GN3
	nXjeTxuBNIzgoLL1lEXwwJQnBdeRBlP/U1lPh0u/U3n8Ue4Ltm/FMPV7jHKiXOQ/bKlIx2B+Y7i6Y
	xq+8VLJo8gDNSSNq/T7F3peHS5xR/F8buBV8PU3hsww02wbl3MQ+x43Zr+VON3JHTnwHczo8YoqCt
	79NK+CAkkaI6uhxNe0Ov/WA9DkqdLwzkmJoBFqAcLIwtS2hhMPpJz7u6/SdMnOqQt0cHg/7jM/Kr7
	G6AeROrh44rdc8UID2OcratELu8+2YGeHvaKqDvhVQx0O/I0WinMw2uZ01cCcerw8zHXeT3MXfVV+
	BF6KJHVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u0cgm-0000000BBO8-3FuU;
	Fri, 04 Apr 2025 08:46:12 +0000
Date: Fri, 4 Apr 2025 01:46:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	David Howells <dhowells@redhat.com>
Subject: Re: Chaining is dead
Message-ID: <Z--cVCsfWxk427qE@infradead.org>
References: <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
 <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
 <20250331165630.GA3893920@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331165630.GA3893920@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 31, 2025 at 04:56:30PM +0000, Eric Biggers wrote:
> > My strategy is to allocate the whole thing if we can (2KB or 4KB
> > depending on your digest size), and if that fails, fall back to
> > a stack buffer of 512 bytes (or whatever number that keeps the
> > compiler quiet regarding stack usage).  Even if we're on the stack,
> > it should still give more than enough to data to satiate your
> > multibuffer hash code.
> 
> Extending the generic crypto infrastructure to support bios and folios is an
> interesting idea.

The right way to do that is to make it work on an iov_iter.  David
Howells talked about that at LSF/MM and might even have done that work
at least at a POC level.  That way you can trivially pass in a bio
because it's just an ITER_BVEC iter, and for a folio you'd build a
single entry bvec.

The primary intent here is to avoid building the scatterlist for crypto
work in network file systems, but just about any other caller would
benefit as well, but that scatterlist isn't a good fit for any of the
callers I've looked at, it a really bad fit for software crypto and at
least once we get the new two step DMA API also a bad fit for hardware
offload.

