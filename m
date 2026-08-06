Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BF038551D;
	Thu,  6 Aug 2026 08:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786003810; cv=none; b=DGjCIwAoIL4oJGEymwXPz3X6V7NuF4HQY/lF4Nbdh/rSq7c+Ezg2ehuAMZ/UqWXBYEhlVYZt/vFAjzW8fPfTMqJp/3fF19E+aUnISJi4P1Kv8CCp5CvSWCsD84jmX4fKXad3S7oN3Y58oRZ2TCefra4PgU7KtBsIS5eRYv05/CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786003810; c=relaxed/simple;
	bh=Qbq3lBJESX+Elg4OmX0AwrclWJfT4GeO6gkBZIJUIAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cxC1T3cOsh8XqTJrL6F3Nud7whlziFaN0hhNBU4OFRjhdnXICdMKmA43O706v/e1wPIK7xt7LwTNITeOvyuRelMITUFPY7uNm3mGQhYc5TBRAqR1HkXrldEIos/3LQYPbm2fdILXoccgX5ATv+PIeTFiVs9xlIKMj+21dnZba+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/1R42+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/1R42+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0629B1F000E9;
	Thu,  6 Aug 2026 08:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786003809;
	bh=ih7h6JIzTiRKtn0VjiPjDD9AEsbefI5PQ4Ob3mMLVVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b/1R42+Nog/giqa33ZLZ0IlQ3s5PHQhF2r3QAJiXXmTW/fQrb8Ah980nJAqwMIt4V
	 4zmmXPUuB6GJpgcNSIBgwFfk4LPp8rOy0RnyHpt759eaQblmh/3S9rZ1H4M+KnviUX
	 IfHKevw70Se6EZFRiKo8/Y9taJT2r/U76sUVIqc4LdLwcA/xW5Ao7ifak5lm+MKVUv
	 Fr4F9g7tY2F9Okv7XfNr+ciZ8OltuRu5lYjdbvRGvkElDw+8pAAESeQWqC49XrctPi
	 iG0hJuzPPhf3itx6z/xMIwp38152Pm+PhfPcFjRz04AkjS0YCYQpJSXNzOXPTXDodN
	 lh0VUhkpdW+oA==
Date: Thu, 6 Aug 2026 10:10:06 +0200
From: Antoine Tenart <atenart@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 09/10] crypto: safexcel - Rework cleanup of sensitive
 structs in safexcel_aead_setkey
Message-ID: <anQ9UdZqmj39hfgD@kwain>
References: <20260805115749.392672-1-thuth@redhat.com>
 <20260805115749.392672-10-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805115749.392672-10-thuth@redhat.com>

On Wed, Aug 05, 2026 at 01:57:47PM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> The crypto_authenc_keys structure only contains pointers to keys,
> but not the key data itself. So explicitly clearing the structure
> at the end of safexcel_aead_setkey() is not really necessary.
> 
> On the other hand, the crypto_aes_ctx might contain sensitive information,
> so this structure should be cleaned up at the end instead. Do this
> now via the new __cleanup(aes_zeroize_ctx) marker.

Looking at other crypto drivers it seems zeroing the key pointers was
explicitly added (sometimes later) and my impression is a good chunk of
the users are zeroing it. I don't know whether removing that is fine or
not, my limited understanding is that provides in-depth defense against
leaking were the key reside in memory. Would love to see an explicit
statement from someone with that knowledge.

(On the other hand mixing gotos and __cleanup is not advised but is that
an issue here? Or if zeroing crypto_authenc_keys is actually important
can we use __cleanup too?).

> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -407,17 +407,17 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>  	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
>  	struct safexcel_crypto_priv *priv = ctx->base.priv;
>  	struct crypto_authenc_keys keys;
> -	struct crypto_aes_ctx aes;
> -	int err = -EINVAL, i;
> +	struct crypto_aes_ctx aes __cleanup(aes_zeroize_ctx);
> +	int err, i;
>  	const char *alg;

> @@ -430,25 +430,25 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>  	case SAFEXCEL_DES:
>  		err = verify_aead_des_key(ctfm, keys.enckey, keys.enckeylen);
>  		if (unlikely(err))
> -			goto badkey;
> +			return err;
>  		break;
>  	case SAFEXCEL_3DES:
>  		err = verify_aead_des3_key(ctfm, keys.enckey, keys.enckeylen);
>  		if (unlikely(err))
> -			goto badkey;
> +			return err;
>  		break;
>  	case SAFEXCEL_AES:
>  		err = aes_expandkey(&aes, keys.enckey, keys.enckeylen);
>  		if (unlikely(err))
> -			goto badkey;
> +			return err;
>  		break;
>  	case SAFEXCEL_SM4:
>  		if (unlikely(keys.enckeylen != SM4_KEY_SIZE))
> -			goto badkey;
> +			return err;

'err' is uninitialized here. You can use '-EINVAL' instead.
