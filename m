Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575187;
	b=ehGwXC5ElS3tzuYEOjxu9YW9EhCu52yJYZrnrEFutge01+LH3fBVD/PKVNtRZZBB4yin
	 AzTCr4G34nKSk1BNvr+mXKHP8kq2SuojvhBweJzKgvEHGSczEl0khoKu340bxnJ044zcd
	 ujyCZwDlNkNirm61ZiVWM7ROp/seQhE7MvC46TUyxdnw7P4pFzMPbmH91ww7UFCW0jcw7
	 RN+tE+lyktYqbj2xiq5NjM3Un+sjxHcdbM16PsaKCKNcD59wmPX4L+cYEtzYz2o9bIgx/
	 8YNhnSygOc0+SECpqA8gFFmxgjdJIw+mAbZ8U8S4zVWbXFSOsEg607zAF2Mj4GxSWNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575187;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=B5ZNtzHwATppubMnGNeEocLS4koNmlaPNVsst0aB8OI=;
	b=TW8PHXcSUCrroHkYx0yrEohu76HC03bo40flqmMHQa7kcc5YK7fCiKc1zKtd35cF3Dv1
	 rCHzZvCPOijhoqAH4pXZe8wTq8KPH9xR+suh13uBDeMFEK7NKZeOCErjyLAuKtS8i5ivF
	 C5dEc6BdRFY2cWFraQzA/5fu0cDcKsgwhoAeG04AyC1P8x+kjXEaH8i0opmqwhfMNiB9V
	 ZKnRfvR0UYLB3fWx9RdI3QlXzsexbWSQE1BHT5KPP6g9mZL+43gtiAK/6xEWPUSGjvx5j
	 Kx2eeAvllO8dGZJI8cCfsDPfTjk3S/6FATCukwkfImGXTBmNNCHoE9iUEnqZjeW3VIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="jE2piUa/";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F651606A882;
	Fri, 13 Nov 2026 13:06:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F651606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=jE2piUa/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=B5ZNtzHwATppubMnGNeEocLS4koNmlaPNVsst0aB8OI=; 
	b=jE2piUa/mZZHLRWBsr1FUNefld7eMTtsmcjreEjHvBfegmPZZ6ooZSLbMLa5zhc+7yXjcwz0Sb2
	WJyeCg1eG9tZAOZhgNaeVVyFd35M4mBiUeWWegld1y6LOgt5AD4lOqoj1YjV1Zy06wNuEInFBLyWj
	Rp0JPvfiy4N+c8+0L6+sXWOYqUDVQAhbfNFPFgLghhj+r7JxkQ9ZHeFRm3dWZ4LwoHjmdXMh//5Dy
	HTxyXWnhqWj1wiya8PUbF+wFTM+U2kTz6mNtVPIPnpAvqbwF/lg4zHtOaJOmHNTdoHrkFEzIFymdp
	x6flPHfdA4VCsijI4hfyUhUIHM3qFuNQRuKA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqz1-0000000EfJL-3BSK;
	Fri, 13 Nov 2026 21:06:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:06:23 +0800
Date: Fri, 13 Nov 2026 21:06:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: ayush.sawal@chelsio.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chcr - Balance inflight count on invalid RFC4106
 AAD length
Message-ID: <avcLT0_C7b79SWm3@gondor.apana.org.au>
References: <20261103075255.1114171-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261103075255.1114171-1-vulab@iscas.ac.cn>

On Tue, Nov 03, 2026 at 07:52:55AM +0000, Wentao Liang wrote:
> chcr_aead_op() increments the device inflight counter before checking
> the RFC4106 associated data length. If the length is invalid, it returns
> -EINVAL without submitting a request or decrementing the counter. No
> completion can balance that increment, so device teardown keeps seeing
> an outstanding request.
> 
> Decrement the counter before returning from this validation failure,
> matching the other synchronous error exits after chcr_inc_wrcount().
> 
> Fixes: d91a3159e8d9 ("Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
