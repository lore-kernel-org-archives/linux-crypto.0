Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542064A1D
	for <linux-crypto@vger.kernel.org>; Sat,  3 Aug 2024 00:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722645432; cv=none; b=beLdU5f1GTvYNUP34cjl3p5z0FtlvB83axgwGXJ/mCYgzjqxYiq5KQKcVkqvMob+ExubLhKnfuKaeTqRLpjdYmq7QSlgJPEuNcrdphpUN4NN/Wv97ZdsT4evb9zOCgdqMNnz/5fxRHN3FAYiEe8u9Ne1uBfIgayqdY8JAqyeViI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722645432; c=relaxed/simple;
	bh=yt3f+Yv32YFD/wqRhWCwoAslbG6gIdc9NATB4BI6Jyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KG0UrdbJTNfAJ7r3jf9n3bmIOo5xz2tg/prZe5T7I5jp7ZNv6qiSw3ufrszdXFw+ygkfBAJWM0YvEDjImIuzdhNeHzzNsKj/mIeEQinqpp5V4g+k+5mDa0pw6O2sUYlblgc9G5QLn0oLmNAB5evJ/ofMR0Kg9tyaFW+D45Q9sYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sa2dA-00273b-1i;
	Sat, 03 Aug 2024 08:37:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 03 Aug 2024 08:37:05 +0800
Date: Sat, 3 Aug 2024 08:37:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@google.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <Zq17sZgSGueOsGiO@gondor.apana.org.au>
References: <20240802102333.itejxOsJ@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802102333.itejxOsJ@linutronix.de>

On Fri, Aug 02, 2024 at 12:23:33PM +0200, Sebastian Andrzej Siewior wrote:
> kernel_fpu_begin() disables preemption. gcm_crypt() has a
> skcipher_walk_done() invocation within a preempt disabled section.
> skcipher_walk_done() can invoke kfree() which requires sleeping locks on
> PREEMPT_RT and must not be invoked with disabled preemption.
> 
> Keep FPU access enabled while skcipher_walk_done() is invoked.
> 
> Fixes: b06affb1cb580 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index cd37de5ec4046..be92e4c3f9c7f 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -1403,7 +1403,9 @@ gcm_crypt(struct aead_request *req, int flags)
>  			aes_gcm_update(key, le_ctr, ghash_acc,
>  				       walk.src.virt.addr, walk.dst.virt.addr,
>  				       nbytes, flags);
> +			kernel_fpu_end();
>  			err = skcipher_walk_done(&walk, 0);
> +			kernel_fpu_begin();

What if the user already did a preempt_disable()? This would still
be buggy, right?

The Crypto API allows this to be called with preemption disabled.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
