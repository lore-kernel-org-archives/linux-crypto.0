Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2D246762
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 03:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763781536; cv=none; b=JWwPda19IRxwWPcQUSpfvR8o+pg8wXnSZIH5QvdVxc0DA4aYCNEjvh3PzJC9jH9jbQLdvEPBDeQ1dJpWDRKLPFgWc+A7RKMcYh7ONvoeSuoBnPpOQs6/+PDNCz/xXkw15mStlzKJIzD3fBwMceH1BMbdawBWm6u8kpq/Jc/GvXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763781536; c=relaxed/simple;
	bh=W9hg26/x93T1amxSLnc7NQniE+gQXeNkj9q4jDiW8PQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oj6/jayPxgqjGAZkbhOg71WCmhlOH6wbtxqrGLnCU4+oIC6oltoHHTGQ+J1On/P0jddLapv94Dd62LU4YBOzjA++bEVxylQR5a72DVHuM+u7zPmhKbeq+HEXMjs6DXiNdrZjsXICMoQKqQhYbQa8ZAc5O1ygIy/LFImBQbVVt/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RIky/NII; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RIky/NII"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=a7YHDQvDdTK+OeB3yUoeXf2cE9JbRVoURSukrnsPzSQ=; 
	b=RIky/NIIx4jOr4sTo6dPNG1PIaUJTmkMYxMUAUVXFfHlRGO5BJvLg8zvIB2bgrkV6iC5vxQeom0
	sHWIMOBZhYuf2yj0TsY0UIgZUP+VmCr6PrERG96yY3bxAIle1a2SB+ZJIrAXNgU6XlvQ33dXFuINb
	haiudu74qftfuSPTndtKniT9IPMTJ94fsd8Y9R5o2DGdS6edexBaA3pZ3+WE9NAHQq+hgfquEUlwS
	n4t5hCTUo5QMNQdpnrnBQALDmOIe4U3bf5sdoNpkMFE32/BCUucSi0wNCP4mHevALMyd6vxMRy0K+
	tEq4ThKnn7FYizIz9mFbQ+lz7PuBoqZrkCJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMe9C-0056Wy-15;
	Sat, 22 Nov 2025 11:18:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 11:18:50 +0800
Date: Sat, 22 Nov 2025 11:18:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: tcrypt - Remove unused poly1305 support
Message-ID: <aSErmsRlJ2UZwLOc@gondor.apana.org.au>
References: <20251114030344.235748-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114030344.235748-1-ebiggers@kernel.org>

On Thu, Nov 13, 2025 at 07:03:44PM -0800, Eric Biggers wrote:
> Since the crypto_shash support for poly1305 was removed, the tcrypt
> support for it is now unused as well.  Support for benchmarking the
> kernel's Poly1305 code is now provided by the poly1305 kunit test.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting cryptodev/master
> 
>  crypto/tcrypt.c |  4 ----
>  crypto/tcrypt.h | 18 ------------------
>  2 files changed, 22 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
