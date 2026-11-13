Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575585;
	b=Iow+BcoW1BLkdICGSYZCK159Far+yoH2HIK9kx98RyI+03CSX/HOiTbiMzarnqtIWDuE
	 3FhnPtVA0V2Ax2/+Xh8SUiJsnfvJvL8e8/Dbbro6lRonKQYI4kEYQO/7unXrM2TkHoEaa
	 mIZrBRTiQIJJipOm8BEby7wcylX7xlzltfsbSyJ1F9ZQGBfavewj1J8prD5Z71q+3GNkD
	 NvuxBr4+BUEJx3qMmEy0oJTxKCUJfDsQtqaInWFQuHKp+fD3SRZoQgFky5cU1KgqfQmP8
	 4I1q6I3xH1gHmPpzYa8p+zGtdhVxXp5RjoFLTZIHI5iWwj+uQAd5+9XR854vst+Y9Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575585;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ZlRQC6aB7K5njLBjed5wisGDqXExe13Gn7D0OCZUp/w=;
	b=1sgqpfytnpqLo8ucm3VQYmK2XyVnf6sgxTP1zUFYMvqHxSrm2gDOUjyY7w1KoQRvtFjS
	 c1mu5lIZne1YQwhHFCRachVTgcwNarC1INCZS+laZucW71+RenNsimX+gsmEeMK9GGEW/
	 jqjCcIEi3bJx6oq7QbYQMaQrZ10gU9fyWoAyom1shxbctje8UXM62QSGLIn2W4wjCrN/6
	 a7XD/y64AQ0Rd7BUh304ZzNX2wBcPedSJBDzGGpSrTnqAP9VhTdwzVaBkGDQ8lIbkB+YK
	 bz0z7WXQfGM6WSnjA6LOf76sKdAaqznlC+SEhJ6q5vJ/ELI+4jV1yP8AqEEv8UlU7WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=cVVREm3L;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF1B606A331
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 13:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAF1B606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=cVVREm3L
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ZlRQC6aB7K5njLBjed5wisGDqXExe13Gn7D0OCZUp/w=; 
	b=cVVREm3LKQ6laGqnWMKa3W815h9za8DkCBLVrQz9uLOc1KcapZkkvtmSkPSKKVYuzYW+1op+OnV
	WmevY8ruONSxlly9rJ8L6kLXe/ZUi2QdhU0+pXpmAUDQWXjzPc5dqiIrcC9jGv/gzqF/XD1oZybgG
	IqgU5kwtMUQsqvwAXUUjO6fHAazhA/TsWuzrUudtJ3td+C0t/mwObvWtLrO6sLcattrcQZ3nz2v7w
	6/uwXVmw5NXoyZsPnh58pB3U1zwYKHQq/SPhRtko8LgGc52OHR2cvFwaTW46g14o4Vpc3M7LWeiO0
	KOQldPJz+uLOM2//NWq8QYHz8CeFgJCRlFCw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRr5Q-0000000EfTU-006E;
	Fri, 13 Nov 2026 21:13:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:12:59 +0800
Date: Fri, 13 Nov 2026 21:12:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v2] crypto: stdrng - Mitigate FIPS RNG failures
Message-ID: <avcM27FUnnnQTpRy@gondor.apana.org.au>
References: <20261106193711.3844890-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106193711.3844890-1-ebiggers@kernel.org>

On Fri, Nov 06, 2026 at 07:37:11PM +0000, Eric Biggers wrote:
> If the kernel is booted with fips=1 and jitterentropy fails its health
> check, crypto_stdrng_get_bytes() can return an error and leave its
> output buffer uninitialized.
> 
> While the fallibility of the FIPS RNG is by design, leaving the output
> buffer uninitialized lacks practical defense-in-depth, as callers can
> forget to check the error code.  For example, the TPM2 driver didn't
> check the error code from ECDH private key generation
> (https://lore.kernel.org/r/20261025211119.138277-1-ebiggers@kernel.org/).
> Thus, fips=1 mode (ironically) caused a vulnerability.
> 
> Mitigate such bugs by filling the buffer with get_random_bytes_wait() in
> case of failure.  This helps in practice.  (For FIPS certifiability it
> makes no difference, as no "approved" entropy is claimed on failure.)
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> v2: Resending this because Sashiko failed to apply it earlier, despite
>     my use of prerequisite-patch-id.  Its prerequisites are merged now,
>     so Sashiko should review it now.  I also added Jarkko's Reviewed-by.
>     This applies to cryptodev/master 82e91fe19fb8
> 
>  crypto/drbg.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
