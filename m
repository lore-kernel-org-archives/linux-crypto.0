Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156F03806AB;
	Wed, 23 Sep 2026 04:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790137381; cv=none; b=jjlecxVjZjlYOG61jMd59RLF1GFxRnGYUCKenu1IxVp0DsHkkFrNfDVg0ZnXsAqoepTFmVBWxv3TCaeOg6cTLvSUzN29VI9Xrf5NuKUsMHopU2MxhZ+t50N7maA/VPqGkQ/CORC/l6jQtPVS1L/n4qyZZfXYRuPLd17f2fkiNz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790137381; c=relaxed/simple;
	bh=kERN3nirdCDImWuZxrGf0a3UcWYedwQ+gqhAnShPMzM=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=LD7VbsjR/tdt8UGg8he7JX39Cw5FOKw8pnv9mSyOQMPKFzNwAh/pK6Bp7pUsxfxHKSrajMBc2Xjv+lg5dDNvvmFNhPGJbR6CHd2ZMWjWheTY+R8lF8A2EpzTrcyPVOBO0CtF70tU7LMCC2Ag6lLxxoMYk6HJ/ro/8a7RSkLQk4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFWEyvM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFWEyvM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9380B1F000FF;
	Wed, 23 Sep 2026 04:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790137379;
	bh=2YJ89MmcjHMt5JvaeKT4zxPvjJxnsv18Y2TXX1vLqa8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=GFWEyvM5ptV4i5St00T5s73Ph8IwEX5LReXEzjG2ro78nCuu84nR3nF4vKJS9Cp3s
	 FlLu44l91GjfLgE2d+ElPp86jLchZ5CfHt5FET1pB5CsmUAIwXTAdigDKMWAhaw7Ah
	 jgc9EeNzwxDzZCplYqEbKs3oVIiMZIjICqf69GdSOWBdhYRnlCu6oe17xEuA5TycGr
	 aJWMq7axJpLQiWNXVTNVqA2K3CE2JMNyVWZp1hcS8aeIaxa1AdrAzBwipjZEIUZ6Gv
	 bps0tqewDomKDfvDkPFgUOzzx234D/lN+MwoRaDnmgJQsSB0Sj0LWwHpkQL+loSozB
	 7r0RhmCT2rwhA==
Content-Type: multipart/mixed; boundary="===============2323606412187480710=="
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <a5e07fdd93b0f6b38dfce4cf977e88eac653bed08ee713372bf31bc6cff349e7@mail.kernel.org>
In-Reply-To: <20260923032703.59816-1-ebiggers@kernel.org>
References: <20260923032703.59816-1-ebiggers@kernel.org>
Subject: Re: [PATCH bpf-next v4] bpf: crypto: Use AES-CBC and AES-ECB libraries
From: bot+bpf-ci@kernel.org
To: ebiggers@kernel.org,bpf@vger.kernel.org,vadim.fedorenko@linux.dev,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com
Cc: linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,john.fastabend@gmail.com,kmehltretter@gmail.com,ebiggers@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 23 Sep 2026 04:22:57 +0000 (UTC)

--===============2323606412187480710==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
> index 51f89cecefb4..784e2bd5ca92 100644
> --- a/kernel/bpf/crypto.c
> +++ b/kernel/bpf/crypto.c

[ ... ]

> @@ -36,94 +30,53 @@ struct bpf_crypto_params {
>  	u32 authsize;
>  };
>
> +enum bpf_crypto_algo_id {
> +	BPF_ALGO_AES_CBC,
> +	BPF_ALGO_AES_ECB,
> +};
> +
> +/**
> + * struct bpf_crypto_ctx - refcounted BPF crypto context structure
> + * @algo:	The crypto algorithm ID
> + * @key:	The crypto key
> + * @rcu:	The RCU head used to free the crypto context with RCU safety.
> + * @usage:	Object reference counter. When the refcount goes to 0, the
> + *		memory is released back to the BPF allocator, which provides
> + *		RCU safety.
> + */
> +struct bpf_crypto_ctx {
> +	enum bpf_crypto_algo_id algo;
> +	union {
> +		struct aes_key aes;
> +	} key;
> +	struct rcu_head rcu;
> +	refcount_t usage;
> +};

This isn't a bug, but struct aes_enckey pads itself so the round keys
can be 16-byte aligned for better performance (as documented in
include/crypto/aes.h). Putting the 4-byte algo enum before the key union
means key.aes lands at offset 4, so the round keys can never hit that
alignment. Would putting key first (or aligning it) be worth considering
here?

[ ... ]

> +static int bpf_aes_cbc_crypt(u8 *dst, u32 dst_len, const u8 *src, u32 src_len,
> +			     u8 *iv, u32 iv_len,
> +			     const struct bpf_crypto_ctx *ctx, bool decrypt)
> +{
> +	if (iv_len != AES_BLOCK_SIZE)
> +		return -EINVAL;
> +	if (src_len % AES_BLOCK_SIZE || dst_len < src_len)
> +		return -EINVAL;
> +	if (decrypt)
> +		aes_cbc_decrypt(dst, src, src_len, iv, &ctx->key.aes);
> +	else
> +		aes_cbc_encrypt(dst, src, src_len, iv, &ctx->key.aes);
> +	return 0;
> +}
> +
> +static int bpf_aes_ecb_crypt(u8 *dst, u32 dst_len, const u8 *src, u32 src_len,
> +			     u8 *iv, u32 iv_len,
> +			     const struct bpf_crypto_ctx *ctx, bool decrypt)
> +{
> +	if (iv_len != 0)
> +		return -EINVAL;
> +	if (src_len % AES_BLOCK_SIZE || dst_len < src_len)
> +		return -EINVAL;
> +	if (decrypt)
> +		aes_ecb_decrypt(dst, src, src_len, &ctx->key.aes);
> +	else
> +		aes_ecb_encrypt(dst, src, src_len, &ctx->key.aes);
> +	return 0;
> +}

This isn't a bug, but both helpers repeat the same src_len %
AES_BLOCK_SIZE and dst_len < src_len checks. Could that validation stay
in bpf_crypto_crypt() next to the existing length checks, leaving only
the iv_len check per mode?

Also, bpf_aes_ecb_crypt() takes an iv parameter but never uses it (only
iv_len is checked). Would it read more clearly to drop the iv argument
from this function, or drop both iv and iv_len and do the iv_len != 0
check in the ECB arm of bpf_crypto_crypt()?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35815287581
--===============2323606412187480710==--
