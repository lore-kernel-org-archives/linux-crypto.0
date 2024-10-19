Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681CA17DE36
	for <linux-crypto@vger.kernel.org>; Sat, 19 Oct 2024 11:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729339087; cv=none; b=tuk3AMWUREtX3JMCsj7vwehVIpvtXVisJzqAO6Ray8ZB1EG8SCIApbhiRnQL1T8DLlwJnQqpb32P7bwHW7MkcX1refJUTekeeSv7+ak5DA9yyjdvK4NmCPYWeAf02PoNHcx9vhRRbu3aStnQmAbDbCRZPcc/jxOjEAr76JeEdZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729339087; c=relaxed/simple;
	bh=4owvqdnBPQrleTF9/nsdBZcsKNdCkanHYcDjKSOgvr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mcyM4svL0N+hTy+B7RiJGFELARbq5XW8m4FFyrokM56QFJE34L7poLPRqq7OiaK8Matgp5scF+BIC70k2ibkvWGzX8i/KoO2RO+jcRFfR/op4oYQH3CMvwouz8XCQ2Ke3oHaZckMaZwbIBTTNRY/70HKkU3JjGa9GcG3QwbrxkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HtVupsdS; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HtVupsdS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W6ydhiWZek9goRNDdKKC634D/Eor2jnIaXxOPM59rEw=; b=HtVupsdS98ZtVSm/6i4KP9D83a
	Y697sxixkVWW6bS7gfQt1cVYDHMQ+eMj0+wWzwwDIP9j+RkO7YKfW+O+RX2zwCDX1jhdNU2V3XS6U
	qScsP5iTm3gytboXxKtq84tqchrll3aoj1sRudKwos5ksvr0chQCe9XfYnIYL0Xtf1czR/KFeuQy3
	OYeW/lDKSAV5LGlXATfXAyt+DticCvBIa3tEoEzDSen8OKdNqBQJistNUVa2QvNDczl5XLvvsXa4c
	tsKSV7HlY8Z/hWQQ2Ks432TwS7r2IGYb5gl19Le8ra249IY5fABrJbgztczAD1A2CurhxNMB+5GdF
	Cm40U2nw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t285p-00AaOv-0r;
	Sat, 19 Oct 2024 19:58:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Oct 2024 19:58:01 +0800
Date: Sat, 19 Oct 2024 19:58:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: jitter - output full sample from test interface
Message-ID: <ZxOeyYXL-1rhGoE3@gondor.apana.org.au>
References: <20241010024734.75871-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010024734.75871-1-git@jvdsn.com>

On Wed, Oct 09, 2024 at 09:47:34PM -0500, Joachim Vandersmissen wrote:
> The Jitter RNG time delta is computed based on the difference of two
> high-resolution, 64-bit time stamps. However, the test interface added
> in 69f1c387ba only outputs the lower 32 bits of those time stamps. To
> ensure all information is available during the evaluation process of
> the Jitter RNG, output the full 64-bit time stamps.
> 
> Any clients collecting data from the test interface will need to be
> updated to take this change into account.
> 
> Additionally, the size of the temporary buffer that holds the data for
> user space has been clarified. Previously, this buffer was
> JENT_TEST_RINGBUFFER_SIZE (= 1000) bytes in size, however that value
> represents the number of samples held in the kernel space ring buffer,
> with each sample taking 8 (previously 4) bytes.
> 
> Rather than increasing the size to allow for all 1000 samples to be
> output, we keep it at 1000 bytes, but clarify that this means at most
> 125 64-bit samples will be output every time this interface is called.
> 
> Reviewed-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
> ---
>  crypto/jitterentropy-testing.c | 31 ++++++++++++++++---------------
>  crypto/jitterentropy.h         |  4 ++--
>  2 files changed, 18 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
