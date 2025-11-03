Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3926128DF07
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 08:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762157670; cv=none; b=oGOrI6rTqMfWOotu+qBQ6zEwic1VPSPB/TPRVQCVhSyo3vg94ZkQ4cgzJmE3DkPpzrl+V9JLk5Et+f1xPaHWdz9IlY21Na6lZsDozfnkYiG2IUreMl/W1pOqZSBiV19Rq9ZCzO3t0qAWK0Ptl9T6HD00Vk6+6gv50Aj0f8myu3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762157670; c=relaxed/simple;
	bh=jfiTa0PHpvkbUysa0MTlZpz11e99k7fN2R8B5u8nUBg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l7kXD8DPBbWKZXoaTHk3M+bcsQ5E0aQwGS6zbaB3sNkA/Mo1WnNTQl5Ce7H8Hp6+8DADFTbLAHcSn9+wVhxIhw7BPDBDbBh3DMPPKcYB8rfObpxC/KF2/jDq9qJNoMHhpkEmu5jvOvy1u82ynyE0oiowJ2UF2asV0+Rp4ip7FDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCpN/i6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCpN/i6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2FAC116C6
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 08:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762157669;
	bh=jfiTa0PHpvkbUysa0MTlZpz11e99k7fN2R8B5u8nUBg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iCpN/i6SxCZL/WU3jnDPObCRWa/aWdY/aQM7EYuWLXmamNrRWUg6AfU8RLYEHYsvD
	 DnBs+NTfUYhPRZTAbxZ61potYDcx7yGqaMZbyLZkLiEPfk+nOr337cxYkq9bovuOQL
	 mw+Np+9FmzU4TvQJGzrzqibMyMudf3NnAIVSENj89ZZhbtscmAiZrI5gXwcw4kIno5
	 Jh5XzTxot86cp9KLtOD64QJvPmwGemRhtNT+dx8Z1GDDxYNVFDA8Zzr/gqn2zhm/v1
	 Ph3wHUZ9KgjgojvVvd94X7E6J2H4dLhsbpX53rdCY2HFV/cS8Hb9tBwviKKjul9OG+
	 VGWV2NEMDxxJQ==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-378d710caedso37523201fa.3
        for <linux-crypto@vger.kernel.org>; Mon, 03 Nov 2025 00:14:29 -0800 (PST)
X-Gm-Message-State: AOJu0YzOHkdLTDck2DWNpTt2ZtUqpgg05W+vod/oHLnUQPmWXQxbpptj
	iqmYmupQlCPK4vITZ/WZHvIgyBOC4ECbBBAMq/SmwvnHXFxmEK3IFSN2cThd5Q8qeI00KgmebVH
	6AJIv2ATF+WwCLRIVAou782XRE6Dttbc=
X-Google-Smtp-Source: AGHT+IET9yCNKZdZUqP2gNsOSGJPyWmGsmKHSWK/xm0REeOprmYF52ZWGHdc0sLgcLGy17/4f/Rp3sZEIHGSiH3bVyc=
X-Received: by 2002:a05:651c:1502:b0:37a:3902:7d70 with SMTP id
 38308e7fff4ca-37a39028596mr5213041fa.23.1762157668238; Mon, 03 Nov 2025
 00:14:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251102234209.62133-1-ebiggers@kernel.org>
In-Reply-To: <20251102234209.62133-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 3 Nov 2025 09:14:17 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG8eD8Fo_Kk0JY59nth5=pLVpAxZ_DzbrbxJskQapv+DA@mail.gmail.com>
X-Gm-Features: AWmQ_bnxzPEJQzHC_F4JqAUlUdvGNsXGYefhnyIHm59LJI09uuPBexHK4f2bdzE
Message-ID: <CAMj1kXG8eD8Fo_Kk0JY59nth5=pLVpAxZ_DzbrbxJskQapv+DA@mail.gmail.com>
Subject: Re: [PATCH 0/6] x86 BLAKE2s cleanups
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org, 
	Samuel Neves <sneves@dei.uc.pt>
Content-Type: text/plain; charset="UTF-8"

On Mon, 3 Nov 2025 at 00:44, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Various cleanups for the SSSE3 and AVX512 implementations of BLAKE2s.
>
> This is targeting libcrypto-next.
>
> Eric Biggers (6):
>   lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit
>   lib/crypto: x86/blake2s: Drop check for nblocks == 0
>   lib/crypto: x86/blake2s: Use local labels for data
>   lib/crypto: x86/blake2s: Improve readability
>   lib/crypto: x86/blake2s: Avoid writing back unchanged 'f' value
>   lib/crypto: x86/blake2s: Use vpternlogd for 3-input XORs
>


Reviewed-by: Ard Biesheuvel <ardb@kernel.org>


>  lib/crypto/x86/blake2s-core.S | 275 +++++++++++++++++++---------------
>  1 file changed, 157 insertions(+), 118 deletions(-)
>
> base-commit: 5a2a5e62a5216ba05d4481cf90d915f4de0bfde9
> --
> 2.51.2
>
