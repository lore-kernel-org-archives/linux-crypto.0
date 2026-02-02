Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432C022B8B6;
	Mon,  2 Feb 2026 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045632; cv=none; b=DvjWe57C9EbTXlrSv5YxRSlHIsbGYvpz1VtJoZnoT7v9+5yW39/zHLt915+PjYiNe/zAOZ1pgPGlDmbZcBMzYTgGjstuC329Dm+VwXKnk2CkqWXiLZ+41HzwikvugSYVfe3ys2pXkFfSH19L4Ubk0yhTOsyYbqeLFeCHu2HokLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045632; c=relaxed/simple;
	bh=2+BVUp4yJLPs+Eu+0SrlY7RCM7BTt+P0S/7fIW/pv3c=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=AByaGyUveftFA+RRDFBQYSfPscJCwwAfk/rFxotP4MzAqRslH1KaGojDNaltwy2hA6mBg3Gm+pkS39IpufcLSF8pjKcjYLgIM3Pl0eqb3uefFMx+X6iodXi0l0M8KtQznE5MSSKxEPHAqPqcFKBHyjXrd7QWpUxlCR1iIxN8re0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sNMGU0gH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNMGU0gH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AC5C116C6;
	Mon,  2 Feb 2026 15:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770045631;
	bh=2+BVUp4yJLPs+Eu+0SrlY7RCM7BTt+P0S/7fIW/pv3c=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=sNMGU0gHffA2/Fs/gNQCXzz9SII1InPgbmNfNYumw3KUy75LKMo+/Wg7ZdarZ7iQU
	 EAJFHFvIONaG5F9oDsTdz9t+JCAGb2DdjKla5+akO5LPdVhkFPkkTSLIvTy/Djv4gl
	 f5Z73htncVkp5GmY9M2Br4i3s3Hg57KV/myFtWDgnu7UDZLWMe3jMlXpYn4AbBK/po
	 SgRTtGxPRc4r+LbQOouMgDaDu+6fW3I5v/XTTEU6oE81hmWurxdm3aJS8UsgnpMpvG
	 y5nhgVyv4uOkaJICx1593zO2AIA9U3kZTk3UbVsDd3ycthYKndcbEUYx9KXawIWTmn
	 69Lmyp0Y6NtRQ==
Content-Type: multipart/mixed; boundary="===============1114375285770392558=="
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <522069f8c39e10c3f59886c538d973dbf3a1a9035a07fa3ac18fed2dcf55abdb@mail.kernel.org>
In-Reply-To: <20260202144749.22932-4-git@danielhodges.dev>
References: <20260202144749.22932-4-git@danielhodges.dev>
Subject: Re: [PATCH bpf-next v7 3/4] bpf: Add signature verification kfuncs
From: bot+bpf-ci@kernel.org
To: git@danielhodges.dev,bpf@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,vadim.fedorenko@linux.dev,song@kernel.org,yatsenko@meta.com,martin.lau@linux.dev,eddyz87@gmail.com,haoluo@google.com,jolsa@kernel.org,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,yonghong.song@linux.dev,herbert@gondor.apana.org.au,davem@davemloft.net,linux-crypto@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,git@danielhodges.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon,  2 Feb 2026 15:20:31 +0000 (UTC)

--===============1114375285770392558==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
> index bf14856ab5..b763a6c5cd 100644
> --- a/kernel/bpf/crypto.c
> +++ b/kernel/bpf/crypto.c

[ ... ]

> +/**
> + * bpf_sig_keysize() - Get the key size for signature context
> + * @ctx:	The crypto context being used. The ctx must be a trusted pointer.
> + *
> + * Return: The key size in bytes, or negative error code on failure.
> + */
                         ^^^^^^^^

The underlying crypto_sig_keysize() function in include/crypto/sig.h returns
the key size in bits, not bytes:

    /**
     * crypto_sig_keysize() - Get key size
     *
     * Function returns the key size in bits.

Should this documentation say "in bits" instead of "in bytes"?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21595105586

AI-authorship-score: low
AI-authorship-explanation: The code follows established kernel patterns and the documentation error is equally likely a human oversight.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: Documentation comment states wrong units (bytes instead of bits) for bpf_sig_keysize return value, which could mislead BPF program developers.

--===============1114375285770392558==--
