Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDE3221F1A
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555231; cv=none; b=JpgBodqYhOAvtCOIOZl55DZOvZQf72qqZSeDj0m2nscZjoWb/zNDpLaoBkORjbcQ3jJRjHl8uDOrI7W0vV+qSJHsBbPx9cSF+J2igeeE8mx4JHMiOPlVENv1XqOfH6ZgTqFqtvfFsJldTnlL67XdS7pmUB/aaMppn/2zj/zQixU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555231; c=relaxed/simple;
	bh=QnANiC0/d4Tx3mxHf1CkhOgs9w3o04dw2fDHr2RALNc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=DI33c4fA5ZZmKNk8+Mu4dFWQmQpmjwa0ervWIezmh+b3BCl4nUa3/ajF8CEMlfUYzwvRQWIblWa2tK7zMec0/lRRPyN4MkAKDASVH6VvJLSaGJAOKIiumaNkBnMTB56jfdDMEoI/K604jWBg6/o3lqXlhSYcQ69u92IydjxA2XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hu8pFesq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hu8pFesq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gGKMdORnJh6ezs7Fc/z5RgPUUQMS4aDfZhf8GcL8hNU=; b=hu8pFesqG/vb5eSRL5TaisdN/E
	AHOKsCvUWZbKkI7LIvtMj/o4HDqAIZfhFMllY2mP7s4afB1FjlRnKhCpEklLmDCjsbF+pl1j/4TSb
	XLZYcJMpKaX43ytdqYAlUYpqE9BDnhuJdiya0gxl/K82or5ha9Evjm09+cDBdmhI5cjwSpGuk4vpi
	z/LEEDgolZwfdDkIBAlohvpskA0fpWiB547Ystd6ptuIG2+Kxd1oXMQFG8eTnOpLiDgCPDIuiOV/z
	01lif//tacQypU0lxP5y3R6qOzxzRLAZxdI9lTms2aou3pZ4LPDioojP1uoglyR7BW6psYMbe5+l9
	0v9Kcq3Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaDR-0090GR-2r;
	Fri, 21 Mar 2025 19:07:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:07:05 +0800
Date: Fri, 21 Mar 2025 19:07:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/chacha - remove unused arch-specific init
 support
Message-ID: <Z91IWeOoitS-nTA3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316045747.249992-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> All implementations of chacha_init_arch() just call
> chacha_init_generic(), so it is pointless.  Just delete it, and replace
> chacha_init() with what was previously chacha_init_generic().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/arm/crypto/chacha-glue.c                    | 10 ++--------
> arch/arm64/crypto/chacha-neon-glue.c             | 10 ++--------
> arch/mips/crypto/chacha-glue.c                   | 10 ++--------
> arch/powerpc/crypto/chacha-p10-glue.c            | 10 ++--------
> arch/s390/crypto/chacha-glue.c                   |  8 +-------
> arch/x86/crypto/chacha_glue.c                    | 10 ++--------
> crypto/chacha_generic.c                          |  4 ++--
> include/crypto/chacha.h                          | 11 +----------
> tools/testing/crypto/chacha20-s390/test-cipher.c |  4 ++--
> 9 files changed, 16 insertions(+), 61 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
