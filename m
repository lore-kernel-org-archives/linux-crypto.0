Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D0E7D098
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758505217; cv=none; b=UxaOK7j/QjC/9LMQxAaBwLaYy5rQc5CIVwGd3/i9NUffGTE2BZ1jArgDznUkBppoZAkf0wg566qi/p7QvZGL9dqeP+G03hyvz3YNE+ho7A9xbzzh7m6NnPd/tGif6otIFTGRDdyXZFQVAbcbIIWMXD1xZFNSX/fu/MFaKbSrxLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758505217; c=relaxed/simple;
	bh=8RalfTuL7bTI4etfHiacBIjuSWq1u6s8MB6DHqsZjVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLy/oDrQ5+ZrOylF8E468Exur7xbpQ7Ru1oFbZdme6IartDfHarBXmzrPduJC/TSmEWpzynNupnrd6ZFt+cgrlAJyYETGLquVmCZaKBecSmhw0Sm5t6x58oBtSJU09fLKuNlElijby9ogDQTPKvqHDTcl3EGYzYaSV6ed03DuX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=U3mVn8wU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="U3mVn8wU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=ZFLxyhninTH6ycOdQ1oWpBPOh32RZPNbSEbu7oEjvXE=; b=U3mVn8wU58spV0pQNKZFA8h9Z+
	IesxMf0OMcqm3KVfCp8Y3gMjWTPcIA9+oj6oU7DMnxEARcdAKeMUmVEgbkajh2URzEiZsQLbg3siY
	4WVQWQNdnlt7gQy19jzip9TGAaDZphUsZkYy/mvqGzBCUQRFQSupiUJx6ddSCD91dzTHygZBwwnca
	gqZxB+jgK49XPqWnsT8iVKl5u2g/Xu8YqV1gY2JZzCLGbzA0fnv+Uo8yIBhV6kgO54ncGIF/sKyWq
	yGyOkaiFoUxKpWEgwbunzAOQb49cNgWs/7M6q6R9X3NPAjRbVtvN6iC+GhW09t2zlQI4Y6e/xOq2L
	t2kiY72Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v0VX5-007HNY-1B;
	Mon, 22 Sep 2025 09:40:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 22 Sep 2025 09:39:59 +0800
Date: Mon, 22 Sep 2025 09:39:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: "David S. Miller\"" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	Karina Yankevich <k.yankevich@omp.ru>
Subject: Re: [PATCH] crypto: drbg - drop useless check in
 drbg_get_random_bytes()
Message-ID: <aNCo7yjktKTFg9HH@gondor.apana.org.au>
References: <35bd2eaa-3cb2-481a-a02b-79fa1bc98016@omp.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35bd2eaa-3cb2-481a-a02b-79fa1bc98016@omp.ru>

On Sun, Sep 21, 2025 at 11:33:36PM +0300, Sergey Shtylyov wrote:
> drbg_fips_continuous_test() only returns 0 and -EAGAIN, so an early return
> from drbg_get_random_bytes() could never happen, so we can drop the result
> check from the *do/while* loop...
> 
> Found by Linux Verification Center (linuxtesting.org) with the Svace static
> analysis tool.
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> ---
> The patch is against the master branch of Linus Torvalds' linux.git repo
> (I'm unable to use the other repos on git.kernel.org and I have to update
> Linus' repo from GitHub).
> 
>  crypto/drbg.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux/crypto/drbg.c
> ===================================================================
> --- linux.orig/crypto/drbg.c
> +++ linux/crypto/drbg.c
> @@ -1067,8 +1067,6 @@ static inline int drbg_get_random_bytes(
>  	do {
>  		get_random_bytes(entropy, entropylen);
>  		ret = drbg_fips_continuous_test(drbg, entropy);
> -		if (ret && ret != -EAGAIN)
> -			return ret;

That's a bug waiting to happen.  Does the compiler actually fail
to optimise away?

If you can show that this makes a difference to the compiled output,
then please change the drbg_fips_continuous_test function signature
so that it can no longer return an error.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
