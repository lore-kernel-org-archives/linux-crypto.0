Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92C413EFEC
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714123796; cv=none; b=HlX7uueR2vaB3ZcsxHR4RnzRioEMe+f2SiDjtHUqLiX24nNISg0TcKB8P+SPnvwEecp6NFcrQHCjPO5VdWJP8WQqJg6A95bDMVfbfn0vDDECGj1UnO368cTXsemQ1MBaU0tNgY/NFmd+gdsZoncirQRPzxf6X2Z2uylXWg8Ks/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714123796; c=relaxed/simple;
	bh=BElsTt4RnOLXMaGFZ+giyx8skT/rztFPKHgqjBJM7uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qS34FfRg57ZIyoHN4a6hW1W34UTQSYk4wvYozOG/TW2z9dPhgRaOVtLG7fN0Jt/x2hS6BfYWoHNHeRlo1/K8wPAkF59MTkuq8C6r3/lhU7MgI33A6yr3rxSvC/dGI1Vv0bMtUWme+pTUKNY5RdisdYtb2yvYc68dsfJZZTfT4Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0Htt-006eI2-N8; Fri, 26 Apr 2024 17:29:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:30:07 +0800
Date: Fri, 26 Apr 2024 17:30:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, ebiggers@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: arm64/aes-ce - Simplify round key load sequence
Message-ID: <Zit0H/Zo/WPtkcKL@gondor.apana.org.au>
References: <20240415130425.2414653-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415130425.2414653-2-ardb+git@google.com>

On Mon, Apr 15, 2024 at 03:04:26PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Tweak the round key logic so that they can be loaded using a single
> branchless sequence using overlapping loads. This is shorter and
> simpler, and puts the conditional branches based on the key size further
> apart, which might benefit microarchitectures that cannot record taken
> branches at every instruction. For these branches, use test-bit-branch
> instructions that don't clobber the condition flags.
> 
> Note that none of this has any impact on performance, positive or
> otherwise (and the branch prediction benefit would only benefit AES-192
> which nobody uses). It does make for nicer code, though.
> 
> While at it, use \@ to generate the labels inside the macros, which is
> more robust than using fixed numbers, which could clash inadvertently.
> Also, bring aes-neon.S in line with these changes, including the switch
> to test-and-branch instructions, to avoid surprises in the future when
> we might start relying on the condition flags being preserved in the
> chaining mode wrappers in aes-modes.S
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-ce.S   | 34 ++++++++++++++--------------------
>  arch/arm64/crypto/aes-neon.S | 20 ++++++++++----------
>  2 files changed, 24 insertions(+), 30 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
