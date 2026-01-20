Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFB847278A;
	Tue, 20 Jan 2026 19:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768936426; cv=none; b=tya7kFZTgL+HHWeUGhEw3kuTrmOAaaaPez6HLHRcQ6ITy9Unjgc5g38laNLeeBp+15kdOpLzn4kURH8J7y3aCndLeT613YzWqf1RAwobV/iPN4pmTLMqBFofNAkprAcYHa7TqKcsKUYQB2FrhCisX0/p+v5prYKFOuLQxXavgyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768936426; c=relaxed/simple;
	bh=hR7VS+eGnEIFJeV2CJ6Lyfs5CIcoszKcZFkapk5y51A=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=XZmpEILd8enAzk/mL0FgXY8MnsDfEimZWA0eiHstU7wFLb4xK98Y+08zongAKzQnW/iYPNg/cuzfrrs448RHfr5qi4GIAqrXVOeePeuWuhC6I5m0gk5SLYGK+qD5FRNVE3fpxc2Bdij4pXI4F3vJRPmrV1J0OeBn6en3OxKz4WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fIXHpLSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fIXHpLSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5DCC19425;
	Tue, 20 Jan 2026 19:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768936426;
	bh=hR7VS+eGnEIFJeV2CJ6Lyfs5CIcoszKcZFkapk5y51A=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=fIXHpLSjwwcIrK3t16Ux31rx7B3CC/uf12EHkBRtXsIKsaIIfMTIMmPAAxa+7ZnXb
	 uxmxogIu+BEGZ9asCjo/Z622Clnq807VAt2nQMHzAgvaeU4qAbuSClhoOdHWzRkptb
	 pN6YitKMvni2EsFreIafxjsyNmkDPhzbRn746kO9sf30/3OnwCUzJtWEn0azwm16kl
	 UPmr5rk9BcDd39oiCwgNe/ntDIPy9Y+MKESY971qTJF/RpjYiZxWJ7kVwWnaok49J4
	 fzMiHk04TnuYIzRrpO0C11GMD1g/9tw17UtOWxAI5R+VO4fMN9VUQlVD2d4MIaVh3i
	 zPWyqTkyXHHJQ==
Content-Type: multipart/mixed; boundary="===============7877633429921621322=="
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <b1f74213800152dbd91fa2649b82c182058c295f6c1c15799a5b5871aa5ced48@mail.kernel.org>
In-Reply-To: <20260120184701.23082-4-git@danielhodges.dev>
References: <20260120184701.23082-4-git@danielhodges.dev>
Subject: Re: [PATCH bpf-next v5 3/7] crypto: Add BPF signature algorithm type registration module
From: bot+bpf-ci@kernel.org
To: git@danielhodges.dev,bpf@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,vadim.fedorenko@linux.dev,song@kernel.org,yatsenko@meta.com,martin.lau@linux.dev,eddyz87@gmail.com,haoluo@google.com,jolsa@kernel.org,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,yonghong.song@linux.dev,herbert@gondor.apana.org.au,davem@davemloft.net,linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,git@danielhodges.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 20 Jan 2026 19:13:44 +0000 (UTC)

--===============7877633429921621322==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/crypto/bpf_crypto_sig.c b/crypto/bpf_crypto_sig.c
> new file mode 100644
> index 000000000000..1d6521a066be
> --- /dev/null
> +++ b/crypto/bpf_crypto_sig.c

[ ... ]

> +static const struct bpf_crypto_type bpf_crypto_sig_type = {
> +	.alloc_tfm	= bpf_crypto_sig_alloc_tfm,
> +	.free_tfm	= bpf_crypto_sig_free_tfm,
> +	.has_algo	= bpf_crypto_sig_has_algo,
> +	.get_flags	= bpf_crypto_sig_get_flags,
> +	.setkey		= bpf_crypto_sig_setkey,
> +	.verify		= bpf_crypto_sig_verify,
> +	.owner		= THIS_MODULE,
> +	.type_id	= BPF_CRYPTO_TYPE_SIG,
> +	.name		= "sig",
> +};

The bpf_crypto_sig_type struct does not set .ivsize or .statesize callbacks.
In bpf_crypto_ctx_create() in kernel/bpf/crypto.c, there is an unconditional
call:

    ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);

If a BPF program creates a crypto context with type="sig", this will call
NULL function pointers and crash the kernel.

I see this is fixed later in the series by commit 76d771a64b50 ("bpf: Add
hash kfunc for cryptographic hashing") which adds NULL checks:

    if (type->ivsize && type->statesize)
        ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);

Should this fix be folded into this commit to avoid the intermediate crash?

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21183820118

--===============7877633429921621322==--
