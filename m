Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B987303A04;
	Wed, 25 Feb 2026 21:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772053602; cv=none; b=LhN9sd//AlFNAQeQ42iztgDvPrOFh6fJW9Q+kPUkdk0bUkvZp8ps9xMMDF5BpsJhr0u+T5dfpeMb20rwIbZWe7NotOPIXb627AgICFyeOtG46ra0sWCFeUc1B8i1KTytN0fUCB38Y9Cnd+aJH8VqmJ/B8NijIxH9a7JFZBPIhWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772053602; c=relaxed/simple;
	bh=dgVUcg5h0F/5rdQgXU6jWV/I3Z8iC65i5+Eqs9p8nXs=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=hiHXV3jT5nsqR6cr3Z8xmbVpx0BQjHzT6HTX2/k+tRQ/cW8CLkaMxMOlohxBXgkLTkN9U1h1w63SB9eumIxBqeQ7UJw2cQwIMr1mszue/3hO6SUczCWmv9mCIWQAgND2Cgo3iaDKdOjhhfqxHiyEIm/R2RYkQ01x9fOx3J5DRvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugwRTs0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugwRTs0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95CCC116D0;
	Wed, 25 Feb 2026 21:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772053601;
	bh=dgVUcg5h0F/5rdQgXU6jWV/I3Z8iC65i5+Eqs9p8nXs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=ugwRTs0D8xDEBxAPXPTRj1sk9quW659aQDtIFlQTPc502a/rMoTtrzdufXQik7jLQ
	 ACCH6cK79I0WHaNyd/eph9KWYr0Qppt/I3IkIg+8qZPYjeecBectcs5GhE9xXmVDt2
	 /ylHNnae0nT44Q6j5D8LwTEafT4FKNU/FkoEuYrGB//7eVyKnNQj8ztnT3xqxvNL2F
	 MxGnJINMstRiB8XI6kYYscgg6IcymYCZ4rLcDktQvEinoIufU17JOrSJdauIVDT46U
	 dn+FEcQhE3okGiJcztJnJu7AXjLfeWJWNYUJ6vzJ2LnzsqAoofgiQDO8sdcClA+iY6
	 3qvGoP/lktGhw==
Content-Type: multipart/mixed; boundary="===============2090170065257609829=="
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <bf515a9784c17b9b0dcfeff987e9cc7c328fc6d330cdb97b1cfe77448eafcc27@mail.kernel.org>
In-Reply-To: <20260225202935.31986-2-git@danielhodges.dev>
References: <20260225202935.31986-2-git@danielhodges.dev>
Subject: Re: [PATCH bpf-next v8 1/4] bpf: Add hash kfunc for cryptographic hashing
From: bot+bpf-ci@kernel.org
To: git@danielhodges.dev,bpf@vger.kernel.org,linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,vadim.fedorenko@linux.dev,song@kernel.org,yatsenko@meta.com,martin.lau@linux.dev,eddyz87@gmail.com,haoluo@google.com,jolsa@kernel.org,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,yonghong.song@linux.dev,herbert@gondor.apana.org.au,davem@davemloft.net,git@danielhodges.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 25 Feb 2026 21:06:39 +0000 (UTC)

--===============2090170065257609829==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/crypto/bpf_crypto_shash.c b/crypto/bpf_crypto_shash.c
> --- /dev/null
> +++ b/crypto/bpf_crypto_shash.c
> @@ -0,0 +1,96 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/bpf_crypto.h>
> +#include <crypto/hash.h>
> +
> +struct bpf_shash_ctx {
> +	struct crypto_shash *tfm;
> +	struct shash_desc desc;
> +};

[ ... ]

> +static void *bpf_crypto_shash_alloc_tfm(const char *algo)
> +{

[ ... ]

> +	ctx->tfm = tfm;
> +	ctx->desc.tfm = tfm;
> +
> +	return ctx;
> +}

[ ... ]

> +static int bpf_crypto_shash_hash(void *tfm, const u8 *data, u8 *out,
> +				 unsigned int len)
> +{
> +	struct bpf_shash_ctx *ctx = tfm;
> +
> +	return crypto_shash_digest(&ctx->desc, data, len, out);
> +}

bpf_crypto_shash_alloc_tfm() creates one bpf_shash_ctx per
bpf_crypto_ctx, with a single embedded shash_desc. Multiple BPF
programs can acquire references to the same bpf_crypto_ctx
concurrently via bpf_crypto_ctx_acquire() (which just does
refcount_inc_not_zero), and the hash kfunc is marked KF_RCU which
provides no mutual exclusion.

When two CPUs call bpf_crypto_hash() with the same context, both
end up in crypto_shash_digest() using the same desc:

  CPU0                           CPU1
  bpf_crypto_hash(ctx)           bpf_crypto_hash(ctx)
    bpf_crypto_shash_hash()        bpf_crypto_shash_hash()
      crypto_shash_digest(desc)      crypto_shash_digest(desc)
        alg->digest(desc, ...)         alg->digest(desc, ...)
        // writes desc->__ctx          // writes desc->__ctx
        memset(desc->__ctx, 0)         memset(desc->__ctx, 0)

crypto_shash_op_and_zero() in crypto/shash.c writes to
shash_desc_ctx(desc) via the algorithm callback and then zeroes it
with memset. Both CPUs race on this buffer, producing silently
corrupted hash output.

The existing encrypt/decrypt path does not have this problem because
crypto_lskcipher_encrypt() treats the tfm as read-only (the key
schedule is pre-computed) and the mutable IV state is passed
per-call through the siv dynptr.

Would it make sense to allocate a shash_desc per-call on the stack,
or use a per-cpu descriptor, to avoid this race?

> diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
> --- a/kernel/bpf/crypto.c
> +++ b/kernel/bpf/crypto.c

[ ... ]

> +#if IS_ENABLED(CONFIG_CRYPTO_HASH2)
> +/**
> + * bpf_crypto_hash() - Compute hash using configured context
> + * @ctx:	The crypto context being used. The ctx must be a trusted pointer.
> + * @data:	bpf_dynptr to the input data to hash. Must be a trusted pointer.
> + * @out:	bpf_dynptr to the output buffer. Must be a trusted pointer.
> + *
> + * Computes hash of the input data using the crypto context. The output buffer
> + * must be at least as large as the digest size of the hash algorithm.
> + */
> +__bpf_kfunc int bpf_crypto_hash(struct bpf_crypto_ctx *ctx,
> +				const struct bpf_dynptr *data,
> +				const struct bpf_dynptr *out)
> +{

[ ... ]

> +	return ctx->type->hash(ctx->tfm, data_ptr, out_ptr, data_len);
> +}
> +#endif /* CONFIG_CRYPTO_HASH2 */


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/22414975518

AI-authorship-score: low
AI-authorship-explanation: Eight revision iterations with active reviewer engagement on lore.kernel.org and incremental changes addressing feedback are consistent with human-driven development.
issues-found: 1
issue-severity-score: medium
issue-severity-explanation: Data race on shared shash_desc in bpf_crypto_hash() produces silently corrupted cryptographic hash output when two CPUs use the same context concurrently, which could affect integrity checking and authentication use cases.

--===============2090170065257609829==--
