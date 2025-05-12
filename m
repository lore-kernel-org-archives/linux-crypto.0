Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81320EEBB
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747028770; cv=none; b=LG2uK0xiVxM1ogmWqvSeUEgpbjrXVJMKWaFXWMx205crXZceJI3rMuqZ0Q562Vbbg/sJf0vb9/yDtjsaUPxITLLADFo1aoK6esnaYn4LWlIDIMsB9uSqZBcj2wX18gsqyVCrtpds8X25wz2RnaFOGpoHX4FwqUWgtsvUy8VpT1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747028770; c=relaxed/simple;
	bh=t3Cn07Nzlic8wwiEDFzr0tVDKcrLI1ptK5dTrVSqUSM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=kd7QEOKJ3gZ6Sup3zuOhcxY3YweVVQYFb6IgP3IcV/61pCo3KSMegHHZAGUAF+kDNImbIHoHeLsENHoxb4qG+CVIoBM5vyrSMrXMw1sddxR7+P0/aJYVlvb2BOtmJRKxh3vgXLZgzHG5alqakkJkRYAKdLeQBigRAuy41jDryzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c0vkgXA2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c0vkgXA2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hifOKPYcbW0IGdHP/w1Sf4+UnmuWboVpxUv4TR+sJBw=; b=c0vkgXA2yGcAaEpxyfG22a4NN0
	ay8jmfbSuA9SMMJ25Rnb2B8JYr2hxFioswTMSbIUjLONq4NIq8AsIKYwh6+gw4c4uef7TBYwFIPZy
	Bdzclv5qyYWHkAyZ9J+1OLpJ+NUiJy8CWEVC8fO2Tdr9STjPJaFyou21vQTT0ic61V7A5MEI1nO/X
	N0DKwCftu0LEH4VUb9oU4vvNJL5XTzJIm8MV0fag4/sCDRr83/YubSlDP3zyPxPP8kkGQ/phOARBN
	N6UTmaaE8iALQ5T4REYpDkhz/slXxIemcZcVnZhIAXkurYp8IdnCyFPDLgoqCFsWeSnUzQCy+7WHR
	R1Zx6F8Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uELzH-005LnT-2M;
	Mon, 12 May 2025 13:46:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 May 2025 13:46:03 +0800
Date: Mon, 12 May 2025 13:46:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/8] crypto: use memcpy_sglist() instead of null skcipher
Message-ID: <aCGLG8JSaHkefVdj@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505191045.763835-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> For copying data between two scatterlists, just use memcpy_sglist()
> instead of the so-called "null skcipher".  This is much simpler.
> 
> Eric Biggers (8):
>  crypto: algif_aead - use memcpy_sglist() instead of null skcipher
>  crypto: authenc - use memcpy_sglist() instead of null skcipher
>  crypto: gcm - use memcpy_sglist() instead of null skcipher
>  crypto: geniv - use memcpy_sglist() instead of null skcipher
>  crypto: krb5enc - do not select CRYPTO_NULL
>  crypto: null - remove the default null skcipher
>  crypto: null - merge CRYPTO_NULL2 into CRYPTO_NULL
>  crypto: null - use memcpy_sglist()
> 
> crypto/Kconfig                  |  15 +----
> crypto/Makefile                 |   2 +-
> crypto/algif_aead.c             | 101 ++++++--------------------------
> crypto/authenc.c                |  32 +---------
> crypto/authencesn.c             |  38 +-----------
> crypto/crypto_null.c            |  70 ++--------------------
> crypto/echainiv.c               |  18 +-----
> crypto/gcm.c                    |  41 ++-----------
> crypto/geniv.c                  |  13 +---
> crypto/seqiv.c                  |  17 +-----
> include/crypto/internal/geniv.h |   1 -
> include/crypto/null.h           |   3 -
> 12 files changed, 41 insertions(+), 310 deletions(-)
> 
> 
> base-commit: 64745a9ca890ed60d78162ec511e1983e1946d73

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
