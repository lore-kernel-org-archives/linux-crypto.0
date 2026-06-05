Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B967B3F0ABF;
	Fri,  5 Jun 2026 10:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780655570; cv=none; b=s/QB0YfjBDfrmiaaMA9aYOyh6VAiAOE5oiQIub3R2dN5/maNgCeUY1dLq5HgYFsKVcGRJ5vBvpxS3pMCGXL18I/5uCaZmK/71p0ixIklOArU96cKv+3wj0te++AzcLA08fTwOudyubiT+UJAbGoWMaSxN+DAsKRtdNHXDnfDbDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780655570; c=relaxed/simple;
	bh=fHl05/w1IbgwP6SoREuVhJHWs1UIpW6MRNXnk2riOm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpgGPALX3Ft73p6GTMSKOM/cuGjU/pPKTu+UIOjWeo1tEg8vq6wnf4SDuVyt+DFezIxwhQ0l6yIC1EnAA8wGG8LSZWSTNGLFIx6ezDXXHCCr8++3wn8qcBjMckpKS2lHtg76IAkBb3Ex77TsxrjlwCHFdVfhgIe/CRDy5jQ7Zxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RKRd/LeE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RKRd/LeE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=WRtp85UFz4JlnQNO7+dLdUvwnb0HU/eXKDOdBxxnGF4=; 
	b=RKRd/LeEzlECFoSCRe9lKRsSmzHa61Ie0qmC96pVSlU1KOfWsf0ZCCo9LIvCq9k55m7sKtqTKZy
	cErKM/ZD2QEToUBYT62isTn/hUUuAyQxg8VQEQcTT3KhHMtLx5NGoWJnRxUG7Z1ztJErJrR/rT2t9
	6dgby4/I4JRpj6C4bQRTrpI0mLVsevcif0we3wHoKnZMXLEEFENFH8cOMOb+8t6dQMnf5T0KRyd5k
	dTibXEwTvDISkR+bMHzm46KusHNrXtJqxEcRU1h0HaKqNswOpAakAEmCAnpWLZ5TB0YYF1lIOe+fQ
	HyLJ9zd0MajxUV6zPuDHTi+LnHoEgBKFQD2A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wVRqx-002nZL-2d;
	Fri, 05 Jun 2026 18:32:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2026 18:32:39 +0800
Date: Fri, 5 Jun 2026 18:32:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chelsio: fix inflight counter leak in
 chcr_aead_op()
Message-ID: <aiKlxxxIKQUAVefp@gondor.apana.org.au>
References: <20260526160655.2298525-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526160655.2298525-1-vulab@iscas.ac.cn>

On Tue, May 26, 2026 at 04:06:55PM +0000, Wentao Liang wrote:
> chcr_aead_op() increments cdev->inflight via atomic_inc() before
> submitting the AEAD operation. If the operation fails after the
> increment (e.g., chcr_start_aead() returns an error), the function
> returns without decrementing cdev->inflight. This leaks a reference
> on the inflight counter, preventing proper teardown sequencing.
> 
> Add atomic_dec(&cdev->inflight) on the error path to balance the
> counter.
> 
> Fixes: d91a3159e8d9 ("Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 1 +
>  1 file changed, 1 insertion(+)

Please merge these patches into one.  There is no need to send
one patch per function.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
