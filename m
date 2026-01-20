Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266EE43E9FF;
	Tue, 20 Jan 2026 19:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768936423; cv=none; b=eBa00F9jFzMay7CWvz5/8X4kYjgz+gK76yBcAm69v34cX2e9CXDoJxJ3Y5Er1mLZypNpP1ZIQ65Mt1H6KQGKyBTq6Lqd+ekOxYHrBYijjYf8wKczCOR2DWJ/Tfsu69dPdD6+NmtGCrPWFejyRBflv5M1+9kYbU9se64lyNRzh2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768936423; c=relaxed/simple;
	bh=vilp2Rq6f8QY1I2zQzlF3hPntVSFbgK28Pjbl9Zciuw=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=hZqDADnv8u0IbxJl26yS5e1eeX5lXSYPe8i0d2NPuq3rjNKY4KMVXn+5Kbp6ufy+lw0r9XOwAB22DSaf7UvLhwMswNHrJqy3cnw7GNXahg9k9Ig9UmbKNfIDUFVT8RKv7mGjwCUT54/xcHmBu77wVyejqIZWOIQz7O3G6gIZ2yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9ZETNdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9ZETNdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91431C16AAE;
	Tue, 20 Jan 2026 19:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768936422;
	bh=vilp2Rq6f8QY1I2zQzlF3hPntVSFbgK28Pjbl9Zciuw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=T9ZETNdrNmFkfS/pxA7G6I/FFhsx9D+I4HR5tejrIoIrgldoEoz3J3nsJGi1UNOcs
	 S3kAmgNI7BeFfFnc1/L1lDzhGQX1LALd7sy1uEBEkFWdw9H7yP4UVLpUyZViOsMmRJ
	 zWCn8uJyufWtLjf1e+69yIxGUpUhwr6n+pqml4VR8tvWouKBqthByXyjmDeqsJk+93
	 w65EMOMlW7jT3ZKtVnMdt+xAT+MNcwcRRSPrImXbtbNz3fMlCLpHpXN5EkBnAhCaP3
	 xhVr+Wxei3dW0VHnJ5dH1+eGZdMCm2xDi4NzsGGAUP6rYGRRJoe3p9hAsfGfzjyshA
	 7gdMz5hsymyRw==
Content-Type: multipart/mixed; boundary="===============3459075531568831871=="
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <e3277b8c7dfe09fae49d0ea7caacc2327f37a18261176964b0be6a67da50c6be@mail.kernel.org>
In-Reply-To: <20260120184701.23082-3-git@danielhodges.dev>
References: <20260120184701.23082-3-git@danielhodges.dev>
Subject: Re: [PATCH bpf-next v5 2/7] crypto: Add BPF hash algorithm type registration module
From: bot+bpf-ci@kernel.org
To: git@danielhodges.dev,bpf@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,vadim.fedorenko@linux.dev,song@kernel.org,yatsenko@meta.com,martin.lau@linux.dev,eddyz87@gmail.com,haoluo@google.com,jolsa@kernel.org,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,yonghong.song@linux.dev,herbert@gondor.apana.org.au,davem@davemloft.net,linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,git@danielhodges.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 20 Jan 2026 19:13:40 +0000 (UTC)

--===============3459075531568831871==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/crypto/bpf_crypto_shash.c b/crypto/bpf_crypto_shash.c
> new file mode 100644
> index 000000000000..6e9b0d757ec9
> --- /dev/null
> +++ b/crypto/bpf_crypto_shash.c

[ ... ]

> +static const struct bpf_crypto_type bpf_crypto_shash_type = {
> +	.alloc_tfm	= bpf_crypto_shash_alloc_tfm,
> +	.free_tfm	= bpf_crypto_shash_free_tfm,
> +	.has_algo	= bpf_crypto_shash_has_algo,
> +	.hash		= bpf_crypto_shash_hash,
> +	.digestsize	= bpf_crypto_shash_digestsize,
> +	.get_flags	= bpf_crypto_shash_get_flags,
> +	.owner		= THIS_MODULE,
> +	.type_id	= BPF_CRYPTO_TYPE_HASH,
> +	.name		= "hash",
> +};

Can this cause a NULL pointer dereference when a BPF program calls
bpf_crypto_ctx_create() with type="hash"?

The bpf_crypto_ctx_create() function in kernel/bpf/crypto.c unconditionally
calls type->setkey(), type->ivsize(), and type->statesize():

    *err = type->setkey(ctx->tfm, params->key, params->key_len);
    ...
    ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);

But bpf_crypto_shash_type does not implement these callbacks, leaving them
as NULL.

Note: This appears to be fixed later in the series by commit 76d771a64b50
("bpf: Add hash kfunc for cryptographic hashing") which adds NULL checks
before calling these function pointers. Should this commit be squashed
with 76d771a64b50 to ensure each patch in the series is bisectable without
introducing crashes?

> +module_init(bpf_crypto_shash_init);
> +module_exit(bpf_crypto_shash_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Hash algorithm support for BPF");


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21183820118

--===============3459075531568831871==--
