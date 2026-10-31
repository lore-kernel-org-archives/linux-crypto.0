Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793444481;
	b=MQCcwr1TRNR4CCFyBaTtWY5ohEyxzhcIF0GGruVEyHnOA+FZaTxsU+fNqWqc21ENtjfb
	 u2CeiDwIKSbTQFY60/dvGC8JycUqCIktNx5kiffhku0rm7vOoobRkVWHjtUUbzLZumVqH
	 muD8uos4ZtDpj4RHfJAxnxSv3bS64bnV4UwgseKSmpBiM5RQuhcP7UU7n2io0MpHh6GfF
	 Z8HHokHNUkxkKf/ooSzyknWCXymb7Zakg/twpZ7aozLDfQryWBF37y90v7Haty53TWJnW
	 ZHKLXUAUC5TSXjVgsCvDj8maAOsKGz9pNT7Sr7mpvzv9d79gxOUhnz63ZzBMkgI9OmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793444481;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zFHP1wt2zbuyQ8JmVs2AALXpj9shBjg0MxdbpTuthyc=;
	b=TPeuReOett0BVfZzw8EQZ93mI4tbqddddadogdeZS/yXjZfHW2O0Ym9xROKTnljxiG5N
	 2EuZvQRYUx1iXuER8DHbkTTJSnIkqP9KO3+qbi+2EMN+nBpRQb3OlRBoWzwiMkXvSAlvk
	 GhBTjm9Br59MmQL6zsKmNi4daE3OZE2X2pNmcrwmjbsXiO1DD8shOi34NqrjFnPeQgV2E
	 4yWG4DRjmxUbLZvj3I1Xf/GyHKEy0jezy4EO/VBbC1loCMqSuqqpSub7xcnG3zyMoH2qU
	 fooJIUiv2w9VNdej32Jz/nyiSvOCRwUpavHdG+ZkaMgYKC2Ht2+gpSk7tfFxsHFMkkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJswqMkx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33179606A31A;
	Sat, 31 Oct 2026 11:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJswqMkx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C7F1F000C1;
	Sat, 31 Oct 2026 11:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793444480;
	bh=zFHP1wt2zbuyQ8JmVs2AALXpj9shBjg0MxdbpTuthyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hJswqMkx9Pywmx1XVCLQzKgBZbLn6VrwV9OaA5atPhGC/SN4MAfjjJMmTsKhBFvrD
	 ABFiJvgdVpFJRRdD2K0h6NltWABUcpDPJBAA+c6wJC6LmxBdcKj0WCgebhXwjAN809
	 DHhs0nIgCeUPsz6S50IHxE7XrpHChRHiLCd7GKZY=
Date: Sat, 31 Oct 2026 12:01:12 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Roman Demidov <roman.demidov.nn@gmail.com>
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org, Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH 5.10] crypto: ecdh - explicitly zeroize private_key
Message-ID: <2026103104-wasabi-durably-9e01@gregkh>
References: <20260911123140.137198-1-roman.demidov.nn@gmail.com>
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
In-Reply-To: <20260911123140.137198-1-roman.demidov.nn@gmail.com>

On Fri, Sep 11, 2026 at 03:31:37PM +0300, Roman Demidov wrote:
> From: Joachim Vandersmissen <git@jvdsn.com>
> 
> commit 73e5984e540a76a2ee1868b91590c922da8c24c9 upstream.
> 
> private_key is overwritten with the key parameter passed in by the
> caller (if present), or alternatively a newly generated private key.
> However, it is possible that the caller provides a key (or the newly
> generated key) which is shorter than the previous key. In that
> scenario, some key material from the previous key would not be
> overwritten. The easiest solution is to explicitly zeroize the entire
> private_key array first.
> 
> Note that this patch slightly changes the behavior of this function:
> previously, if the ecc_gen_privkey failed, the old private_key would
> remain. Now, the private_key is always zeroized. This behavior is
> consistent with the case where params.key is set and ecc_is_key_valid
> fails.
> 
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> [ Roman: The zeroing is performed before ecdh_supported_curve() which is
> not present in upstream but this does not change the fix's logic. ]
> Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
> ---
> Backport fix for BDU:2025-00987
> 
>  crypto/ecdh.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/crypto/ecdh.c b/crypto/ecdh.c
> index 96f80c8f8e30..2e7acfc42155 100644
> --- a/crypto/ecdh.c
> +++ b/crypto/ecdh.c
> @@ -43,6 +43,8 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
>  	    params.key_size > sizeof(ctx->private_key))
>  		return -EINVAL;
>  
> +	memset(ctx->private_key, 0, sizeof(ctx->private_key));
> +
>  	ndigits = ecdh_supported_curve(params.curve_id);
>  	if (!ndigits)
>  		return -EINVAL;
> -- 
> 2.53.0
> 
> 

Does not apply to 5.10.y :(
