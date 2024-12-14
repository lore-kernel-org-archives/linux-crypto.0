Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C2E15383B
	for <linux-crypto@vger.kernel.org>; Sat, 14 Dec 2024 09:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734168595; cv=none; b=lld4gkZ12PsFkt9CqGunOgYk3bESIYFAX1IpKe3QHzjXXnGeHUXVSKmDJqvhadVHnJtxwTSK2xVjp37zH8XPOANVc6wgTdhMGN5iHdSaEbHKrcW3lq9Q9mC9Gsfpmp3D90CddQCoiMg4BrTD9g3FqcW5oFBTVat+PCDY15Dz1BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734168595; c=relaxed/simple;
	bh=XqN4ak1lDqWLbZdN1INbnQaM+LRAt5TMRoIV0Zs4BI8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=U208iXtXs3bWP+zXLZEGckln/hGdoT3MqUQOUBSG+HdD6Xn2SzlZ5GZBWpqED4YW7GPReaI2YcydxI916Z2DFEaZcUBpA29QdkKhWoSxMDPeJPlXQhi7dh6QiYKdEtFmkiOQtef0h0DK+80Wee0vm4mPNC3Ej9l4Un0PYu2AtQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OOqbB58Z; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OOqbB58Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=c5BF1TZo9i4YHmcDo637pboH2y2dtyam9rT8VnpwQl0=; b=OOqbB58ZpzH4D905gLAFTgjIOL
	Xn8zX6ZcTQgLtF06R/9/6sq0LaFb1tBWCRThPXG9/I7YCBrHXPS+vbbHad2p1IhxxBmX0Qh4MNi1/
	n7zu8ed5TH+DeeAnbzikxt5HADG/gA7E/3ngtvBvB1++6dUy8jqahGWjs15gNkPy2VuKmcPLIssWO
	v8oqIIOb9RLXBFF9RimXD0ihNRtXYCmFwOaoml4R/QbS4gT6p6juv77N5HJTVdzNxtcnYIarcP1I4
	uKo61JLncLFBT8Wyriz3/MThY2kE5FiMdMacQFpBw/xsHFK1U+wZr6BAArTgPx3z+BU9g85HzTFJb
	kCqa9E9w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tMOGC-001TMB-29;
	Sat, 14 Dec 2024 17:29:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Dec 2024 17:29:49 +0800
Date: Sat, 14 Dec 2024 17:29:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/8] crypto: more alignmask cleanups
Message-ID: <Z11QDVThxa02yQk0@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241207195752.87654-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> Remove some of the remaining uses of cra_alignmask.
> 
> Eric Biggers (8):
>  crypto: anubis - stop using cra_alignmask
>  crypto: aria - stop using cra_alignmask
>  crypto: tea - stop using cra_alignmask
>  crypto: khazad - stop using cra_alignmask
>  crypto: seed - stop using cra_alignmask
>  crypto: x86 - remove assignments of 0 to cra_alignmask
>  crypto: aegis - remove assignments of 0 to cra_alignmask
>  crypto: keywrap - remove assignment of 0 to cra_alignmask
> 
> arch/x86/crypto/aegis128-aesni-glue.c |  1 -
> arch/x86/crypto/blowfish_glue.c       |  1 -
> arch/x86/crypto/camellia_glue.c       |  1 -
> arch/x86/crypto/des3_ede_glue.c       |  1 -
> arch/x86/crypto/twofish_glue.c        |  1 -
> crypto/aegis128-core.c                |  2 -
> crypto/anubis.c                       | 14 ++---
> crypto/aria_generic.c                 | 37 ++++++------
> crypto/keywrap.c                      |  1 -
> crypto/khazad.c                       | 17 ++----
> crypto/seed.c                         | 48 +++++++---------
> crypto/tea.c                          | 83 +++++++++++----------------
> 12 files changed, 82 insertions(+), 125 deletions(-)
> 
> 
> base-commit: b5f217084ab3ddd4bdd03cd437f8e3b7e2d1f5b6

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
