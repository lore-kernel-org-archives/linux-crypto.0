Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEBF3E6DD2;
	Tue, 17 Mar 2026 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773758733; cv=none; b=Z+Cj66SzqdIbqC6moVe+h0q62MYtO++MmSJH4snRu3BuTgmCOdBaamnfvPU0Fq3mmvElBo3oSx174zomH++4iE1jumCiDXt9xFRsGCxGI3DI1NSxjvP3Jle3uKb4nRokiZLoBlfABgYVTlJ18x1oLPZKtgyAhQCf/DnPNwIvGYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773758733; c=relaxed/simple;
	bh=SZecp6pnuWM8RfE6GI55TiyqjyIXq0todAGenAsj1cI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXBDisAjMqG9filECEMmN/kqZfFxAT1OmFC0qKLBy4+lKBasBgaACTZD8yFOn+/QvZhJFeD5RvIKMbykakdn7fGSom4Wx6wAUlHt2ScM9zGONVg+GwEP4l7MYAFbRAebg8QvbIwJ4ECEJxxkie3zEohCNcoKPj8rkP8/nsCk3uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c7RIl2pB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c7RIl2pB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wrM1dZaDUTVl4/JXFyuHCBOawOyBf912x/nVczXv2gQ=; b=c7RIl2pBcWhUFS/TgMfv7/sRrK
	syAodNww+0HgO8NJaQqbrHVd3wHB+hiBWZMxCC07c+blTYabD5nvzKbJU5C73rGRFBdkK5KcDrFSH
	2AhGAJBmAClgaQq4EQKqZM6fxI/D6hUq2tL3ApFgybRQkimXedUzZEcZSraSuXsgJ2eC1AEyhkfkm
	/IP8z3PgNwI4TiotRribp9HnQlMy7eywIIENGjMEqR6hGmhBcQ9llj2TiX0lhacVB5x21W4mcG/Wv
	ximnBvTjZ9lIrZMJDdiT5GNI3HoHeo8qVhyPLv309pCLzIUAUl2DUAiToJYidqsRzAXst8E4wIR5t
	bUTZdC3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2Vfm-00000006eWz-48R0;
	Tue, 17 Mar 2026 14:45:31 +0000
Date: Tue, 17 Mar 2026 07:45:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] lib/crypto: arm64: Drop checks for
 CONFIG_KERNEL_MODE_NEON
Message-ID: <ablpCtKCV5goM_AD@infradead.org>
References: <20260314175049.26931-1-ebiggers@kernel.org>
 <38a37b02-602a-42a4-8974-b8a6cd750c3e@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38a37b02-602a-42a4-8974-b8a6cd750c3e@app.fastmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 17, 2026 at 12:09:34PM +0100, Ard Biesheuvel wrote:
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> 
> Actually, we should just get rid of CONFIG_KERNEL_MODE_NEON entirely on arm64, although there is some code shared with ARM that would still need some checks. But anything that is arm64-only should never look at this at all.

I'll also drop it from the XOR series.

Talking about which (sorry for highjacking this thread), arm32 and arm64
have completely different neon XOR implementations, where arm32 uses
#pragma GCC optimize "tree-vectorize" or clang auto-vectorization of
the generic C implementation, and arm64 uses intrinsics.  Is there any
chance those could share a single implementation?

