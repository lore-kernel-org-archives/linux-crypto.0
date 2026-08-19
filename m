Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822583515D5;
	Wed, 19 Aug 2026 07:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787125254; cv=none; b=VRdNqoxRQepc2Xa/BH1k5z8ym4E/YJJrKLFuwOdtGiAFiYgXM2SP/lLokeUn06PvisyV5HbmIsk8Xv4+03O/l/GH2JrclrMRKTxiWfXqOwWCxqMC7zTKcjqP1y9zFS2qXj1WJP6qCh2m1S5X0oHt/DSuM3LG9QvqlvEuIOEopoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787125254; c=relaxed/simple;
	bh=RFba0Qr1PxY523752/5njO5oJq9t4RbxN9SvdXmiKgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzeakdHZIbva0+5kL95X12oUO4s7/Q48aHfb92jjiWZfU0wTzMqjFfb4hhCRtlajea2bMZT6F6jNHvWVlitfOJkPd/vHPk/tuivcKJCuDZ0OugVM5Qv7rwnEOjBbS6hc33SkM5vFXXInwjyTZmefHvHXCeV2FrZdh3HuQi5kOpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QMVWb8Z+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QMVWb8Z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D5A1F000E9;
	Wed, 19 Aug 2026 07:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787125251;
	bh=Xwm7AFACbvBVWCBEz3RgtoIreGBm/egCAqRVXhGp9RQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QMVWb8Z+phcuXw3wjJguoKrYD3Jr1KW+5cMo1QK5cjx0XxeMGz7lOdAJLSTjmYxv6
	 Vn9ugsXpbvI9K6Aqq2nuHyCPugA7Q+gDAokbWkSgX5kC2ldppViNyoRtE6x6t4iCje
	 QcD4cezNjzElrE3DcvaXim/1cw+x0Qh3hLOmQNNh7Aeb/hO811mVi1stGk6hJ8z3Sl
	 GvgyBU64rqrzfJPB882M+khcn1BFHbMwllflRa9TooaA7PhvJVam2End9D925FHeLt
	 VwFI6zbgEkppbdSjsPm4qmGHaE5kPYAgqlqubh7Ov7URQx7JI2li5+UswtFCn4liLo
	 NVVQiPdYgu9SQ==
Date: Wed, 19 Aug 2026 09:40:48 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Antoine Tenart <atenart@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure - Zeroize temporary arrays on
 stack with sensitive data
Message-ID: <aoVdMMJJH--AZpL9@kwain>
References: <20260814083651.59535-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814083651.59535-1-thuth@redhat.com>

On Fri, Aug 14, 2026 at 10:36:51AM +0200, Thomas Huth wrote:
> This issue has been found by the Sashiko bot while reviewing another
> patch: key_tmp[] in safexcel_xcbcmac_setkey() and consts[] / _const[]
> in safexcel_cmac_setkey() contain crypto key material that should not
> get exposed to the outside once the function is done. Scrub the arrays
> with memzero_explicit() to avoid that the data could leak via the stack.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

This could have both a Reported-by (Sashiko) and a Fixes tag.

With that,

Acked-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index 3402e570d045c..1ae6fbec31298 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -1993,6 +1993,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>  	ret = aes_prepareenckey(ctx->aes,
>  				(u8 *)key_tmp + 2 * AES_BLOCK_SIZE,
>  				AES_MIN_KEY_SIZE);
> +	memzero_explicit(key_tmp, sizeof(key_tmp));
>  	if (ret)
>  		return ret;
>  
> @@ -2104,6 +2105,9 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>  	}
>  	ctx->cbcmac = false;
>  
> +
> +	memzero_explicit(consts, sizeof(consts));
> +	memzero_explicit(_const, sizeof(_const));
>  	return 0;
>  }
>  
> -- 
> 2.55.0
> 
