Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9612849C
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jan 2025 03:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736826391; cv=none; b=tJOsDiSHYrtsBR3Ihkl0OfoXuGc1NQSHIUNCkg7MftOP7YrQ3jUx9k8c/4ubrj5TyM/PLQ4ig98RS6kMmfJqzPUkOyZNCm1nODB56TSlZvAXtvVx9w9j7RFG7PW0XBUfLpep1qciYQMkBbrzLFGuJbu3EY3EFb9SX62j8IrkmrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736826391; c=relaxed/simple;
	bh=HRMZEZhU5DhXdv4Yfp5JrrRbVFv6OMHTpS3Q1WxLCAA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=JiltmbEhu7U0/ZhSur5wPJlLpZ1xiWwFc8dpOJqgfXKoadX/cwL1QsV+cSbeb5xMvohrUQynjPVvumf0VZoaoVd9mJzOl5rARefTXHs0nCj5iwZIJd0/Fs3IvS+2St4DcWXfkJdSDyUMGUndNaLeVB/bSA0HHZhLbkZIlRWDD44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cyFCgZhI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cyFCgZhI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YjWA12Z3aapEwee8Tr3ezb9DnjBHAtx/3jZv1PuHZyE=; b=cyFCgZhIowU/TwrFK/4ScMH27p
	pND7rST1Yw/CFEn9pA0lw6ReCmfJC3bjiclKQcEtM8oJy1mYkO31SsZsoa/n3AORvOhIUstimkNzy
	crfJ3AUp/shA4i6yhODlE46Q20ux3GTsl+z+yJ9HY6Olv11zhsW65bOEchZNWUEdp9Okm1qD6FFo0
	LmnZG9Za4eh7+ok0bP1xyerMhuG35QWG+r2O2r2lzFaqMH4bkRpguUDMqqqEVa612BP6OWMgWUQTf
	Cqm6tYMFCUksbIwXQrUQiPpabRY0WgDsJ9CTkhGgPEWO2SV9jq8ZuFTXBEyoumwbMG3jndgdlzHO7
	pRH7aN+Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tXXft-008xcn-1i;
	Tue, 14 Jan 2025 11:46:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Jan 2025 11:46:26 +0800
Date: Tue, 14 Jan 2025 11:46:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto: skcipher_walk cleanups
Message-ID: <Z4XeEiZtN7rLXCZV@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250105193416.36537-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> This series cleans up and optimizes some of the skcipher_walk code.
> 
> I've split this out from my original series
> "crypto: scatterlist handling improvements"
> (https://lore.kernel.org/linux-crypto/20241230001418.74739-1-ebiggers@kernel.org/).
> Please consider applying this smaller set for 6.14, and we can do
> patches 11-29 of the original series later.
> 
> Other changes in v3:
>   - Added comments in the patch
>     "crypto: skcipher - optimize initializing skcipher_walk fields"
> 
> Eric Biggers (8):
>  crypto: skcipher - document skcipher_walk_done() and rename some vars
>  crypto: skcipher - remove unnecessary page alignment of bounce buffer
>  crypto: skcipher - remove redundant clamping to page size
>  crypto: skcipher - remove redundant check for SKCIPHER_WALK_SLOW
>  crypto: skcipher - fold skcipher_walk_skcipher() into
>    skcipher_walk_virt()
>  crypto: skcipher - clean up initialization of skcipher_walk::flags
>  crypto: skcipher - optimize initializing skcipher_walk fields
>  crypto: skcipher - call cond_resched() directly
> 
> crypto/skcipher.c                  | 206 +++++++++++++----------------
> include/crypto/internal/skcipher.h |   2 +-
> 2 files changed, 90 insertions(+), 118 deletions(-)
> 
> 
> base-commit: 7fa4817340161a34d5b4ca39e96d6318d37c1d3a

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
