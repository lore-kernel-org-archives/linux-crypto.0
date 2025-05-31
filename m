Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7914821FF22;
	Sat, 31 May 2025 07:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748675435; cv=none; b=ldFLSHYu8rmlnFSnlwfgQt965YO2g25hlWM6h10H7wO9CDVpMpzfLuvLMfnIcnajVEIB5YAKeFdjKHhwJAYw9PpUQZbdYe9ZGWqJFUvoaK/CUgr8ym5hf8iWzjYe2SIySlVzQvmsrrPYinQG/WNApxC8qZ6Qu91HkWOb+/HIPK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748675435; c=relaxed/simple;
	bh=TYWjAZoovNgxt21J08zPJNOE3b7mJr33wy5LmU8wqsg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=mit/B6htErORqTRBKA4DIBHmfIZqnui63wLi1xv7Ux/rrBXUXdAT3HdkWvNQ8++X2jEopbLeglf/gO4dpzM1tSwR5XB9kK5sz2c2JutrEbBEcmn1kWMEpuLyjkDMmsCvx0AAIlmbEfOw3ZOrNYpnOnsinS9AiKeHSkZhoOz6IXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Rmtizj+E; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Rmtizj+E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lRraTA+MBGkehRSEZR7eedoKVf5LVIw5cNGwe/ECEoY=; b=Rmtizj+Ew8YvbbjvC+4dnPbnlr
	JlPJeE5x8js6fpnKDM3rOUKddHaOKWX7WnC0EBtQytkYFpfegSgn4kXdM0i9oHlravAa6KvIkWX67
	puZw2OLgnZysyWy9DIUqUad8AUDT2cpACqJVeQRcZIqGV1XPbNtY5p3wS5197Zcg4v4WhLIxqM2Uo
	yfwAGtqIK2I4Jk6++/5/vvQrch9DdWd2Ew7iCDst8kniUuX1xC2dDggNedV/AxAoqQKULomtTg7XS
	++mkyGM/mb/AQ8zvrzF31aJ8LbUUtWKDl5Rl70FZ2WC3BxfaUfYFXQszfDjp0VehfUAP/vKzC+U06
	XCkKg7wQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uLGMP-009wp8-2a;
	Sat, 31 May 2025 15:10:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 May 2025 15:10:29 +0800
Date: Sat, 31 May 2025 15:10:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	ardb@kernel.org
Subject: Re: [PATCH] crypto/crc32c: register only one shash_alg
Message-ID: <aDqrZdxx7bmo_Z2Y@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250530161042.13106-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Stop unnecessarily registering a "crc32c-generic" shash_alg when a
> "crc32c-$(ARCH)" shash_alg is registered too.
> 
> While every algorithm does need to have a generic implementation to
> ensure uniformity of support across platforms, that doesn't mean that we
> need to make the generic implementation available through crypto_shash
> when an optimized implementation is also available.
> 
> Registering the generic shash_alg did allow users of the crypto_shash or
> crypto_ahash APIs to request the generic implementation specifically,
> instead of an optimized one.  However, the only known use case for that
> was the differential fuzz tests in crypto/testmgr.c.  Equivalent test
> coverage is now provided by crc_kunit.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> I'm planning to take this through the crc tree.
> 
> crypto/crc32c.c | 70 +++++++------------------------------------------
> 1 file changed, 10 insertions(+), 60 deletions(-)

Ditto with "crc32".  Please remove drivers/crypto/stm32/stm32-crc32.c
first before getting rid of "crc32c-generic".

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
