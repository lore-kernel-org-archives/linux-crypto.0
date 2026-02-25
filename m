Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F782765F8;
	Wed, 25 Feb 2026 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772053598; cv=none; b=W1OiEJyNuPlXKsr0XbwINNMexjhls344jPWk2Qt5lMMEQAQTanlaFkJZ+IplHRLZMjFuAYbIr4OEOI6IXt+5bM8PZbpoY389Q4G3UhRDMnNrGjb0H6WE3GXkJ09yvyFwdekcw4pJxu7jzXftZNtsAFrmGAKgRGJadr8hX9SPdGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772053598; c=relaxed/simple;
	bh=VDN0B3i60kdGknCicyOAy8pUfSpGZbZG1PnMApje9gg=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=CqOIU8U6NfPvVkp1DUXi4qpleyEgjJDYtIfL/bJFjtQrORyht6L7kFyqsLAAk8DCbEVf/FNaAxVpXROYfwyo8gwGe8Tckvv3IOWL/2wrL13fSzsl3cVTgLs5rXiOvhfOgYuhdqz2RC4aYvG+CoucNz96g0hcTbgWft4NOsT2bkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTFwMrLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTFwMrLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC38C116D0;
	Wed, 25 Feb 2026 21:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772053598;
	bh=VDN0B3i60kdGknCicyOAy8pUfSpGZbZG1PnMApje9gg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=WTFwMrLuY4WY03upjs9E2xXPP/liuf6/wNp09KR93mrWo13Lj7codE1b8SXVYnBDA
	 JimUXLDcAs9lyorktKxvRZYa1cVW8meleil1Lj1uX1AgMRdrpC7yU6lKKF9Lhpk4QY
	 f8QavAKIQbo6BBmh940EAwhwuRU/SRWcpBb/4rpovowt1S8JQXRtX2V+pNjJexwopZ
	 kpELoQQsU8vJib+3IP6qaUdgsF609N00ZhFGb9lFpDifcuA/qPEB3w6NeD99kDTAtS
	 bXl2gV1QohDxunlUkEkn3OHtSyzv7bIveLv/My2dvR5kCkGkUixIGHaboCsZGIMB/V
	 YIEk3s4sjmFPQ==
Content-Type: multipart/mixed; boundary="===============0063423508216283793=="
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <8764e69fa3f63a498f9e0008f6936efdeeb0d17546b31b416f22da7ffdb40cac@mail.kernel.org>
In-Reply-To: <20260225202935.31986-4-git@danielhodges.dev>
References: <20260225202935.31986-4-git@danielhodges.dev>
Subject: Re: [PATCH bpf-next v8 3/4] bpf: Add signature verification kfuncs
From: bot+bpf-ci@kernel.org
To: git@danielhodges.dev,bpf@vger.kernel.org,linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,vadim.fedorenko@linux.dev,song@kernel.org,yatsenko@meta.com,martin.lau@linux.dev,eddyz87@gmail.com,haoluo@google.com,jolsa@kernel.org,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,yonghong.song@linux.dev,herbert@gondor.apana.org.au,davem@davemloft.net,git@danielhodges.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 25 Feb 2026 21:06:35 +0000 (UTC)

--===============0063423508216283793==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> Add enum bpf_crypto_type_id for runtime type checking to ensure
> operations are performed on the correct crypto context type. The enum
> values are assigned to all crypto type modules (skcipher, hash, sig).

This paragraph appears to be inaccurate. The enum bpf_crypto_type_id and
all three values (BPF_CRYPTO_TYPE_SKCIPHER, BPF_CRYPTO_TYPE_HASH,
BPF_CRYPTO_TYPE_SIG) were added in the earlier commit ddee9f01e40e
("bpf: Add hash kfunc for cryptographic hashing"), along with the
type_id field in struct bpf_crypto_type and the assignment to the
skcipher module.

Should this paragraph be removed or reworded to reflect what this
commit actually introduces?

> diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
> --- a/kernel/bpf/crypto.c
> +++ b/kernel/bpf/crypto.c

[ ... ]

> @@ -438,6 +549,12 @@ __bpf_kfunc int bpf_sig_maxsize(struct bpf_crypto_ctx *ctx)
>  #if IS_ENABLED(CONFIG_CRYPTO_HASH2)
>  BTF_ID_FLAGS(func, bpf_crypto_hash, KF_RCU)
>  #endif
> +#if IS_ENABLED(CONFIG_CRYPTO_SIG2)
> +BTF_ID_FLAGS(func, bpf_sig_verify, KF_RCU)
> +BTF_ID_FLAGS(func, bpf_sig_keysize)
> +BTF_ID_FLAGS(func, bpf_sig_digestsize)
> +BTF_ID_FLAGS(func, bpf_sig_maxsize)
> +#endif

This isn't a bug, but the existing kfuncs in this file follow the
bpf_crypto_ naming convention: bpf_crypto_encrypt, bpf_crypto_decrypt,
bpf_crypto_hash. The new kfuncs use bpf_sig_ instead. Would
bpf_crypto_sig_verify (and similar) be more consistent for API
discoverability?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/22414975518

AI-authorship-score: medium
AI-authorship-explanation: Formulaic boilerplate code and polished commit message suggest possible AI assistance, but iterative v1-v8 development with lore interaction and a human-like commit message inaccuracy pattern indicate primarily human authorship.
issues-found: 2
issue-severity-score: low
issue-severity-explanation: Commit message inaccuracy about enum addition and kfunc naming inconsistency are documentation and style issues with no runtime impact.

--===============0063423508216283793==--
