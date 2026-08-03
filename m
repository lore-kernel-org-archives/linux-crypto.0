Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB4E331A6E;
	Mon,  3 Aug 2026 19:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785783944; cv=none; b=TLKzOL25wUfG5q0wKdoA8NO4LYYJphnRNxMILwJxk5/8v+CJbL7MNSjJuuKh9cX1WpYgFXtlmcZ6GrKoE3GIWERX2Hp0iTiMP2owgAFikEq5fOEegFLWBinwaDIaqjk3I8tBY5o3ioU4Ue7cw+zRS+CO2fvuI7ZaVuewv2bcKOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785783944; c=relaxed/simple;
	bh=X2Juq4KDJTB7xe0JkXMJS4fPX5RMs1O+lqocuabRcFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HMcj7bPNBdWsiLuJ60/xFUv7GgtO5sLUhTw0mwtdkSS30qCz1CHexSpkipsdpy5eR3rL/8P5QEf3JkJZVSRnIJiaBRcLFKEkezmmnf09JOkL3CRulPOAasj+Gjjh8sgafQSNT/7W9ID58pUn8vk14eJ7eUh9IXgbBtJCPmzRkPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nLffy898; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nLffy898"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3005E1F000E9;
	Mon,  3 Aug 2026 19:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785783942;
	bh=DHaLER+rxQbLxAsG1T6qyr3mne6nc5rxVXr1Ko+RY9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nLffy898OcP541/fHZrY5dZqlozCJa/7LazWz0kjH8T4EFh4NtoqzhW9nZcauWvQt
	 aawoCbkpiXMZ68S2gb1eSghSCoF9gLswUExIUUaw3Zldy7P1l7i8xSlvPslibgAW7y
	 xeyjkHFum+SKDfDK1zdWrDpH2aFs04kM5dQNZ/LmDtEtLIUnzqEgzyWE4geMdBkj6r
	 92s6AQkrK9dmbd4NASwARJAfRyZ1pofHmhZz2/qIntzMgEadM5m/Fn0+eEMThxBXl0
	 /WV5x3yJBL3EHGzrtp7yjooA69n+HmFQFHBpcSzMCNTKSJp5AuJX3sEKMMBpvDyV5/
	 kpizWNuSW7uww==
Date: Mon, 3 Aug 2026 12:05:40 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH v2 1/9] crypto: Provide a wrapper for zeroizing
 crypto_aes_ctx
Message-ID: <20260803190540.GD2062@quark>
References: <20260803094432.70505-1-thuth@redhat.com>
 <20260803094432.70505-2-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803094432.70505-2-thuth@redhat.com>

On Mon, Aug 03, 2026 at 11:44:20AM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> Several crypto drivers need to zeroize their local crypto_aes_ctx
> structures after use to avoid leaking key material on the stack.
> Currently some call sites do this with their own memzero_explicit()
> call, which is error-prone since it is easy to miss a return path
> (what already happened in some drivers). Some other call sites miss
> to clear crypto_aes_ctx completely.
> 
> Provide an aes_clear_ctx() helper that can be used with __cleanup()
> to automatically zeroize the context when it goes out of scope.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/crypto/aes.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/crypto/aes.h b/include/crypto/aes.h
> index 3279cfa546085..5ca7b1ab50e8c 100644
> --- a/include/crypto/aes.h
> +++ b/include/crypto/aes.h
> @@ -159,6 +159,19 @@ static inline int aes_check_keylen(size_t keylen)
>  int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
>  		  unsigned int key_len);
>  
> +/**
> + * aes_clear_ctx - Zeroize a crypto_aes_ctx structure
> + * @ctx:	The location of the context that should be zeroized
> + *
> + * Explicitly fills the crypto_aes_ctx with zeroes. This should be done
> + * once the context is not required anymore to avoid that its contents
> + * are leaked on the stack or heap.
> + */
> +static inline void aes_clear_ctx(struct crypto_aes_ctx *ctx)
> +{
> +	memzero_explicit(ctx, sizeof(*ctx));
> +}

Acked-by: Eric Biggers <ebiggers@kernel.org>

I guess we should start using __cleanup with type-specific zeroization
functions like this more often.  One gotcha is that __cleanup and 'goto'
should not be mixed in the same function; see the comment at
include/linux/cleanup.h line 148.  Patch 8 of this series doesn't follow
that in safexcel_aead_setkey().

- Eric
