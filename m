Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20A81D5CFE
	for <linux-crypto@vger.kernel.org>; Sat,  1 Mar 2025 07:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740814485; cv=none; b=sNWxR1Jh5INFtsqLCsvjyuzzEhdA+HDKTH32IHuKOArYfsM5fvAMUG0ZF45Iui4k+pTbfwXaDtY8ClsFzzDiP6DwvpBl+jwKypZavTLUTa3gf0pPmhGySQcoPW1GCfnv5IUpocj5znMalyJK7Nsc56srr6FsNu0+e/lHa3llVWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740814485; c=relaxed/simple;
	bh=V8MLLwst7C1dx6b2kJQ69fBleIxwsmVkeHS5rlcnxnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4Hk5Av8nm+bupWw58N0dYIefblIt79Ty6a+iyWNM1p+Az/mj1VlKRruZAYBL9yLv+D+kgBKfCHYrIEhiCsvXnZMd2/Hv4l30/TjFXNW3EYCC2AcY2N+F0etLYY8d0RBw557ZAgmsBCZEOx23+6ID/IKGLxNVTHsVVdR2p+EmUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EDAnrl7+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EDAnrl7+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PODAUuveZdAsaMrFa/5PaE8AwJBQJeaYR927PYVrJjU=; b=EDAnrl7+/6K3zZtzCcrwnXcxc4
	HygiRMzzr9+RmclT1XYYGgihvfwJNCAmKbhE8XR/ugXbETyYKtRU8FosLrcIdFrZTBwz8nPkdHXq4
	SG7sqHTfNDvDQLENNdO6upw4ItVmyZ0q17CS8NLecYRedJF/VSkXhbo5YgogprWQsSACGdxsr3pxO
	l/C4T+1TmWC/E3tC9V/cnNk6oAgzKmuL+GlxegPiksanN5w3MXtK+jhsiFRsP2NCoGgJd5bIyHEIx
	UJ9RMjrfNzZe7xaMykYJ2WZe9pvBtu5eiFH92Ml1M2l4T/19UX6Nw7Oy3bh0mtDbRaVgDzWkYt/WB
	fHEqxnEg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toHMn-002mbh-2t;
	Sat, 01 Mar 2025 15:34:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 01 Mar 2025 15:34:33 +0800
Date: Sat, 1 Mar 2025 15:34:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8K4ibtteV3_hs7e@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227183847.GB1613@sol.localdomain>

On Thu, Feb 27, 2025 at 10:38:47AM -0800, Eric Biggers wrote:
>
> Well, unfortunately this patchset still uses sg_init_one() on the virtual
> address, so AFAICS it doesn't work with arbitrary virtual addresses.

Right, you can't do sg_init_one on highmem memory.  But the problem
here is that this pointer (the source for decompression) should
never have been linear to start with.

Had it been an SG list, things would have just worked.

In fact, digging deeper reveals even more reasons why it should be
non-linear.  The object that we're decompressing is often split over
two physical pages.  In order to produce a linear pointer, the
zsmalloc code is actually forcing a copy (incidentally, that's
why an extra copy is being added in zswap because the zsmalloc
copy is done with a per-CPU buffer that cannot be used with async).

Had this be done with SG lists none of these issues would've existed
and things would just work whether you're doing software compression
or hardware offload.

So I'm withdrawing my acomp patch-set because the premise was wrong.
The only user for acomp actually wants SG lists.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
