Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA0E3B38B9;
	Mon, 10 Aug 2026 14:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786371288; cv=none; b=C0v1E1NbuvJzMzf++sBt/m1CY+DlbxIzghRx0PR+eqAc6ODQ52VK38Hrb/2Pzir4sZn/gYrhV0pgRAqNNiK+Bstf6yMlejRZ5oFwAxcK11Y5E7kL8he5bRIu+GMe/Vag/5cjSF1yJ0z93+P2kcQjpFGKlWzFrNtzeSdGJ8sFzPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786371288; c=relaxed/simple;
	bh=p9u0D0WCBKRMC6hFnRaF5Glo/PNiCB3LQM46VjphLts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XBM1cqoqNhH9XSv2EIRVVV0WV7yqjrzJuqrFZ/1ci7C3QFJk5Yczwy8WYRW53e9KgNIlLN5462IeRdn8vm+70OtXgqyvmSTzY9II6FXN7lu+qfp3UzC6b+8Rl2GkT2PRwsnIEAmkXBGxKqh0gZIBjtJeaAaUJnF+gW7McR2jM38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnouANdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnouANdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016BF1F000E9;
	Mon, 10 Aug 2026 14:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786371286;
	bh=Ml9OgBggzFQ50QKUwIePxIeCnKu/IhksLgmAK/2Uwm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hnouANdqOgmHzbOxbO5qqqpKeH2zqU9BliZbtfmK9JOGys4gVvqAshP4f3akfe/Aj
	 RS+Nfkqcj+MsrtQcGjfI62jUMkGJvkDVlC4sqC6tXkYlpHXEB4t3SSBmP6BigsPwkq
	 DxpB4PEZOepmhWFMsD2fGpyPdiuKsYU1AU89raAVj2WsHHbg52BHvDRVbZn0ntd7kx
	 /pRjv2aRZPOyYOBhG1iwLFvbZu2uqbMbGjfTNzvJFASfG0eJpIfU5hD05G7chxzEYG
	 wa5qMpqNTnhB0WE03ZYYoFMAfpOZMMkc/Gu7aTTc/gGMdSM60l0xgydeaIvDyaUGnZ
	 /BjIRYmItmJDw==
Date: Mon, 10 Aug 2026 16:14:43 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Christian Marangi <ansuelsmth@gmail.com>, 
	linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 10/10] crypto: eip93 - Simplify the check for a valid
 AES key
Message-ID: <annct0Jm1Xa0l9R5@kwain>
References: <20260810093009.608090-1-thuth@redhat.com>
 <20260810093009.608090-11-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810093009.608090-11-thuth@redhat.com>

On Mon, Aug 10, 2026 at 11:30:05AM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> eip93_aead_setkey() currently uses aes_expandkey() to check for a valid
> AES key, but then does not use the crypto_aes_ctx afterwards anymore,
> i.e. this is just a wasteful way of checking the key length, and thus
> aes_check_keylen() should be used instead.
> This also fixes a potential leak of sensitive data via the stack, since
> this function forgot to zeroize crypto_aes_ctx before returning to the
> caller.
> 
> Suggested-by: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

> ---
>  drivers/crypto/inside-secure/eip93/eip93-aead.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.c b/drivers/crypto/inside-secure/eip93/eip93-aead.c
> index 2bbd0af7b0e0e..0b7a899b14d76 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-aead.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-aead.c
> @@ -92,7 +92,6 @@ static int eip93_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>  	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
>  	struct eip93_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
>  	struct crypto_authenc_keys keys;
> -	struct crypto_aes_ctx aes;
>  	struct sa_record *sa_record = ctx->sa_record;
>  	u32 nonce = 0;
>  	int ret;
> @@ -126,7 +125,7 @@ static int eip93_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>  
>  		break;
>  	case EIP93_ALG_AES:
> -		ret = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
> +		ret = aes_check_keylen(keys.enckeylen);
>  		if (ret)
>  			return ret;
>  
> -- 
> 2.55.0
> 
