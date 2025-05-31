Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0883398B;
	Sat, 31 May 2025 07:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748675384; cv=none; b=iFrthjAdEfdyWyYvTUIMld8oteA4YlIRW6Ao0OgHWHIhKhWe9s5BjXQDEXDnuVIaQUcxJnukhXYaD5CUO7i69GarcQ8VSrLJYYNTzD50mmJYr65bwK8ntjJ4vVavao324ohnBkzjPgZQfpYJJRlrKVIfOJ9jZf+XzFGdXB2j0AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748675384; c=relaxed/simple;
	bh=Z6Gq/f1CXcmVRhtyrER6YQ7RRt58OkBNZhatJf0kqsk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=TSw2XJQhk1Q2cbccRiFkOj9NQ/vcHhpgUoAFUISZT4eRyE+5hRkm8+eLYFI8lcsRHHKrlvUA24BT2m2CaGW4QVaH/uuSPJ2ugMh6Umq8O1cuT4QHLu17ovvBCnkoL85HSixn5Tj2n+rTAEC6FJviJjDROtmKVBRZvmYIWgAuY6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HkNkU3iT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HkNkU3iT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=J4azc6Yc11qa1ew19drbL2Y4D35dU0pLMu0fayd2zss=; b=HkNkU3iT2eSSAZDrHi2ryfKxDf
	iVgXCFBlMaUCtaxGpurRMrC6H/aiLTJwmDdN0VdoQbV1D5ktvUB8Ji5L7lzxSYqKqT9wRgF01RW7Y
	gqipYkYp5/N6+/xhpsepYToWxTtR+0F53z6M4VNEGo/wqfUnFbjrfbcPRGTpFO8OHzl4G63c/H1V1
	0r1EqrGjoGKjoUna3xAUduwR9tuj7lNmGjY22JDNaQ6o624I8k0rNJPIfP6zetqs2HXNHI4xPySBh
	GIPnWon+021UmWXeAb6sF1U84u5pbLobCX5TCyxZhTROs7yMQzgdonibY9n2U94dqXTSdlh6bij+v
	+UBI/CYw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uLGLZ-009woT-0b;
	Sat, 31 May 2025 15:09:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 May 2025 15:09:37 +0800
Date: Sat, 31 May 2025 15:09:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	ardb@kernel.org
Subject: Re: [PATCH] crypto/crc32: register only one shash_alg
Message-ID: <aDqrMb7U18DcMSRl@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250530160940.12761-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Stop unnecessarily registering a "crc32-generic" shash_alg when a
> "crc32-$(ARCH)" shash_alg is registered too.
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
> crypto/crc32.c | 69 ++++++++------------------------------------------
> 1 file changed, 11 insertions(+), 58 deletions(-)

Please don't do this without first removing all drivers providing
"crc32" as otherwise their test coverge will be reduced.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
