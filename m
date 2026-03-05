Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A85D2F5A36;
	Thu,  5 Mar 2026 19:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772739529; cv=none; b=ZhLav7sHLoyaltphhPsQaa1XhMOydad7l62CQMAZ1/i+JvUgAMKPf+ywZ1nj6Auec0dMWutlPbI5zR5jTJi5peTs0VzBovy19OHVEDAdm93EB3WX7oNjwck2doHJywQ9JVjaWfYgnNpvngabk9xPCMYgvk4tCRuWM1o9KsdtQQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772739529; c=relaxed/simple;
	bh=4P7IvlDXVMb8aJ5U3oJEZWYqkie/zWLUSvgwf2HKGvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDZBmk1EZbNjaKeMuzQQT0PquAZGQWPwPI5M0JVIbsnpTP/W5L/qI5DdG6+DmLncFThk8OMlzac368dgTHPFQluCY98ZGT2zbSTFb7HWfOW9WCpTdN0f4Q27MmMI0cJLN2W40hsOQ3oP3ZcqpHUqUDy4JEzagZhCwLqsK6qpw3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=siqIkm64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="siqIkm64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FEAC116C6;
	Thu,  5 Mar 2026 19:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772739529;
	bh=4P7IvlDXVMb8aJ5U3oJEZWYqkie/zWLUSvgwf2HKGvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=siqIkm649lFn7xIxhr0WIePvk7wKgedglH6M6oR19DfqgX0GKWyk9p+7ounXWRR36
	 3ML4TK6cMVqVoRaB7G08WOaps4+8zgHxCHrUooER+oHibIAXsPL8A63mXpOJQusbIf
	 acvx5Oj+WHaoUeil144hzsdqZ7uzoi9HO+B8HUEosPw82NkbPJeXSXu8nfiINAE5DM
	 9P22GVQuRol8fTzTetZbPTWqK3c2+P8NRxlXEg7XalaD8jTl21vp9oPdZf3kb8sYX9
	 3Phyo+X8PDnmDIrETtBriD3GLPOC3oJ/uIhkXDg3xS25l8lyMJLWcbEZQKv8CaXfp0
	 lxC9PMnCgvY0w==
Date: Thu, 5 Mar 2026 11:38:47 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Cheng-Yang Chou <yphbchou0911@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	catalin.marinas@arm.com, will@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, jserv@ccns.ncku.edu.tw
Subject: Re: [PATCH 1/1] crypto: arm64/aes-neonbs - Move key expansion off
 the stack
Message-ID: <20260305193847.GG2796@quark>
References: <20260305183229.150599-1-yphbchou0911@gmail.com>
 <20260305183229.150599-2-yphbchou0911@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305183229.150599-2-yphbchou0911@gmail.com>

On Fri, Mar 06, 2026 at 02:32:24AM +0800, Cheng-Yang Chou wrote:
> aesbs_setkey() and aesbs_cbc_ctr_setkey() trigger -Wframe-larger-than=
> warnings due to struct crypto_aes_ctx being allocated on the stack,
> causing the frame size to exceed 1024 bytes.
> 
> Allocate struct crypto_aes_ctx on the heap instead to reduce stack
> usage. Use a goto-based cleanup path to ensure memzero_explicit() and
> kfree() are always called.
> 
> Signed-off-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
> ---
>  arch/arm64/crypto/aes-neonbs-glue.c | 39 ++++++++++++++++++-----------
>  1 file changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
> index cb87c8fc66b3..a24b66fd5cad 100644
> --- a/arch/arm64/crypto/aes-neonbs-glue.c
> +++ b/arch/arm64/crypto/aes-neonbs-glue.c
> @@ -76,19 +76,25 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
>  			unsigned int key_len)
>  {
>  	struct aesbs_ctx *ctx = crypto_skcipher_ctx(tfm);
> -	struct crypto_aes_ctx rk;
> +	struct crypto_aes_ctx *rk;
>  	int err;
>  
> -	err = aes_expandkey(&rk, in_key, key_len);
> +	rk = kmalloc(sizeof(*rk), GFP_KERNEL);
> +	if (!rk)
> +		return -ENOMEM;
> +
> +	err = aes_expandkey(rk, in_key, key_len);
>  	if (err)
> -		return err;
> +		goto out;
>  
>  	ctx->rounds = 6 + key_len / 4;
>  
>  	scoped_ksimd()
> -		aesbs_convert_key(ctx->rk, rk.key_enc, ctx->rounds);
> -
> -	return 0;
> +		aesbs_convert_key(ctx->rk, rk->key_enc, ctx->rounds);
> +out:
> +	memzero_explicit(rk, sizeof(*rk));
> +	kfree(rk);
> +	return err;
>  }
>  
>  static int __ecb_crypt(struct skcipher_request *req,
> @@ -133,22 +139,27 @@ static int aesbs_cbc_ctr_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
>  			    unsigned int key_len)
>  {
>  	struct aesbs_cbc_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
> -	struct crypto_aes_ctx rk;
> +	struct crypto_aes_ctx *rk;
>  	int err;
>  
> -	err = aes_expandkey(&rk, in_key, key_len);
> +	rk = kmalloc(sizeof(*rk), GFP_KERNEL);
> +	if (!rk)
> +		return -ENOMEM;
> +
> +	err = aes_expandkey(rk, in_key, key_len);
>  	if (err)
> -		return err;
> +		goto out;
>  
>  	ctx->key.rounds = 6 + key_len / 4;
>  
> -	memcpy(ctx->enc, rk.key_enc, sizeof(ctx->enc));
> +	memcpy(ctx->enc, rk->key_enc, sizeof(ctx->enc));
>  
>  	scoped_ksimd()
> -		aesbs_convert_key(ctx->key.rk, rk.key_enc, ctx->key.rounds);
> -	memzero_explicit(&rk, sizeof(rk));
> -
> -	return 0;
> +		aesbs_convert_key(ctx->key.rk, rk->key_enc, ctx->key.rounds);
> +out:
> +	memzero_explicit(rk, sizeof(*rk));
> +	kfree(rk);
> +	return err;
>  }

Instead of memzero_explicit() followed by kfree(), just use
kfree_sensitive().

Also, single patches should not have a cover letter.  Just send a single
patch email with all the details in the patch itself.

As for the actual change, I guess it's okay for now.  Ideally we'd
refactor the aes-bs key preparation to not need temporary space.

- Eric
