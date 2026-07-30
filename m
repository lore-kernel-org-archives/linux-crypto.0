Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7B738DC56;
	Thu, 30 Jul 2026 07:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397047; cv=none; b=l/v7l6pMjFT+p9Vm9ZAg680ok9kfWXn/l/jQE5S5uvsO0NLVCBlgfsgpH8fb7OxISrL3XbcrRIvcDJXJULEgOSMicRxJdZkRPdL/N/f+QXg1TqCjpdHoqnKxcXlIjcZa/5SdV+LGi0HhKjpgL/KjARc1RhmClgS3Lcj3+3qTGaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397047; c=relaxed/simple;
	bh=smCRkSaic2NHXMlWnIMBA5GCEc0msDmRVYCM2VMrXns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ua9aJzOS5z+KJ+Qu6moPPimrssgMX+MNXfGouEERhgW1YhuhwlWbzyvrW9OFS0QbCbLgsQBOrr8Y+FFzNfVh2Samkwgs918GYL6ZYVScQxavVW5mBmr8GlyPpjLM1OkcAtmlxbI+9dNwIBtLLRY3lswi1UIaAu1/uALiPyminZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=s4ONcR17; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="s4ONcR17"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dL9L9OdglYlXogE70tEd0Mhunw/fPEybQrHZrCoJgY0=; 
	b=s4ONcR17GrqaFfColFiS0ZOxEOHKV2jph5Mz5QxoOfHyB8GdvP7Qk3lU9IGIin7cIk9Nm7dYDkM
	b5NIZUuoL3Oakn0GNSgcmczXxz07WbHYA3VMdJz7eBGBeox6r+asl1M+BGKtwT71BUzxbcHURE6MQ
	Z0Vn/tsC+bCVg0g/OfodIFtbXDDvpZ4QS+2nZCchI1vJ01pOZRBcSb4/6xirh8nKpN4R4F/q8YCQ5
	pv90rfVRRYdfZlygFiwng4TKhHDzGGqclk7nCKks8yJgshPwcUSVCQH4l2xBQULhvFhJpD+krVHRD
	leGYdFM8+OaIFLl1CDQlQhoHkEEJ9irpvpqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpLKP-00000000Rtf-3HZ1;
	Thu, 30 Jul 2026 15:37:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:37:17 +1000
Date: Thu, 30 Jul 2026 17:37:17 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	demiobenour@gmail.com, davem@davemloft.net, ebiggers@kernel.org,
	upstream+linux@sigma-star.at
Subject: Re: [PATCH] crypto: af_alg: Allow cbc(paes)
Message-ID: <amr_LZMjwUCl_QpH@gondor.apana.org.au>
References: <20260726192716.2351505-1-richard@nod.at>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726192716.2351505-1-richard@nod.at>

On Sun, Jul 26, 2026 at 09:27:16PM +0200, Richard Weinberger wrote:
> Commit 7524070f26d8 ("crypto: af_alg - Drop support for off-CPU cryptography")
> breaks a special use case.  The cbc-paes-caam driver implements the
> algorithm cbc(paes), it offers a way to use AES in CBC mode with key
> material unknown to userspace.  Instead of an AES key a CAAM BLOB is
> passed to the kernel.  So, this crypto operation cannot be
> implemented in a userspace library and needs always help from the
> kernel.
> 
> Explicitly allow this use case.
> 
> Cc: Demi Marie Obenour <demiobenour@gmail.com>
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Fixes: 7524070f26d8 ("crypto: af_alg - Drop support for off-CPU cryptography")
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  crypto/algif_skcipher.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index df20bdfe1f1f..035fed7db81f 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -32,6 +32,7 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/net.h>
> +#include <linux/string.h>
>  #include <net/sock.h>
>  
>  static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
> @@ -309,7 +310,12 @@ static struct proto_ops algif_skcipher_ops_nokey = {
>  
>  static void *skcipher_bind(const char *name)
>  {
> -	return crypto_alloc_skcipher(name, 0, AF_ALG_CRYPTOAPI_MASK);
> +	u32 mask = AF_ALG_CRYPTOAPI_MASK;
> +
> +	if (strcmp(name, "cbc(paes)") == 0)
> +		mask = 0;
> +
> +	return crypto_alloc_skcipher(name, 0, mask);
>  }
>  
>  static void skcipher_release(void *private)
> -- 
> 2.51.0

This does not apply against cryptodev.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
