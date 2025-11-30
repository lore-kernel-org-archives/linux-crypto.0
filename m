Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB8E27816C
	for <linux-crypto@vger.kernel.org>; Sun, 30 Nov 2025 11:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764500411; cv=none; b=nsPYRKWLXSxvi7LuchPDKbBLpwxz81rLiHBIQs4FOIqslKD8jj11tsiwNOPv1KHM8y1o+u85kWquwQ+hSHIC9fLXQey4xvj+jKP33P27Tcuymmy+4z6Q3Q4nsvErjQaiH81GKbJ+zrguIJvlLYsF19lSr2iaJLdOu1k9QGn5Vrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764500411; c=relaxed/simple;
	bh=HcUSOr8pFH4bogJkhQNF+P8ZsaGFmP+aOBXx0g7EPSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=phZwldLZFkun2rMw5VpzSbPsx14KRLYf0QPAm4lSR/qfwT4vb5KGyxBhm8t6unlFYC3AoAEoDNboAjfEpcPvOAXFMt0mpIyezthwKk93BjsmXad3V+ax5iydgg99PQ9mzM6BARlTwuccgEH2/zrWxfdMCO2qcHbVygB28iRmdWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRxq55Pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRxq55Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7E5C2BC86
	for <linux-crypto@vger.kernel.org>; Sun, 30 Nov 2025 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764500411;
	bh=HcUSOr8pFH4bogJkhQNF+P8ZsaGFmP+aOBXx0g7EPSc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GRxq55PcF8BjjIKQg260KKv10ONwrz4WHdb0xp9lPpnGTZRzK3l8OHvMzpUmRZyLR
	 HfQ7IhDALrqMvTCiDxPUjlEjYHWL2cQDeKx1/YrorpFKeHnwPVBeqTcxgRVNtnm6ND
	 8/4PM+oD+UwbnXwbEhQ34xYn7YFi2IZifej7HvyXdBKn7fBJHJbgRUcB7DE4VEhSCi
	 mmpK7YIgGxMdAY7XTUBi00kWj/GkBvogvQVlAE12wXO5VeeHFyaE7QxIgHtXnU4pdD
	 1YE2x6d6y66MABP2zI2uVBXyf+Gs6E4IcNqpIEZMW6sXSrf5rZDHPYFJnMqpLPYXDk
	 gL+xb80EFmAkw==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59445ee9738so2595490e87.3
        for <linux-crypto@vger.kernel.org>; Sun, 30 Nov 2025 03:00:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW5PE9CYZwfDaP5mwD8r9q99RfCizJ0s15/lPHjKQdUhOJOOO9XEdhQLtl6gJqZNfBUKuJd1jjL4yKBR2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJc3QWEdakRKTeSaS12QhaOg52E8BVHYY/kf5acByNHPNjm2nP
	Cu8xewiWGrxC8Qu4B8GhuyGZuOc3bZf5DJ3323LZq+2ug4NnBifug/DcCFH+18iHgMerIU80r4o
	rVoeZXmGd54oWy5axneQ1j04rXHsw6cM=
X-Google-Smtp-Source: AGHT+IGnO6dzAJUT6KEbi1gvwpCyJ2aAu1tioQuHgoyT+Xl3tSHy8MSn/M+kly9aF3p55g1q1Jo0H+JQ11a6usKg+84=
X-Received: by 2002:a05:6512:400c:b0:57b:7c83:d33b with SMTP id
 2adb3069b0e04-596a3eebe6emr11828773e87.47.1764500409472; Sun, 30 Nov 2025
 03:00:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn>
In-Reply-To: <b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 30 Nov 2025 11:59:58 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHesHJ2oFzGPewp2V=rA0-BU2Y_PffuDDhxioftOKZYHg@mail.gmail.com>
X-Gm-Features: AWmQ_blFeYmAOJ2_ZzYIefdJJ1xBVOENLu514PKVIHtnJT_go-rPKsUWnojoXbc
Message-ID: <CAMj1kXHesHJ2oFzGPewp2V=rA0-BU2Y_PffuDDhxioftOKZYHg@mail.gmail.com>
Subject: Re: lib/crypto: riscv: crypto_zvkb crashes on selftest if no
 misaligned vector support
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Jerry Shih <jerry.shih@sifive.com>, Eric Biggers <ebiggers@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Alexandre Ghiti <alex@ghiti.fr>, "Martin K. Petersen" <martin.petersen@oracle.com>, Han Gao <gaohan@iscas.ac.cn>, 
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 30 Nov 2025 at 10:13, Vivian Wang <wangruikang@iscas.ac.cn> wrote:
>
> Hi,
>
> We ran into a problem with chacha_zvkb, where having:
>
> - OpenSBI 1.7+ (for FWFT support)
> - CRYPTO_CHACHA20POLY1305=y and CRYPTO_SELFTESTS=y (and deps, of course)
> - Hardware with Zvkb support
> - Hardware *without* misaligned vector load/store support
>
> Leads to a crash on boot during selftest on a vlsseg8e32.v instruction,
> because it requires 4-byte alignment of the buffers.
>
> OpenSBI by default emulates vector misaligned operations, however Linux
> explicitly disables it with SBI FWFT while not providing vector
> misaligned emulation of its own.
>
> This can be reproduced by running everything in Spike without
> --misaligned, and is reproducible on stable 6.17.9, 6.18-rc1 and
> 6.18-rc7. See log at the end. Note that I had to fix chacha_zvkb
> somewhat to have it retain a frame pointer to get a stack trace - patch
> will be sent later.
>
> Setting cra_alignmask to 3 for everything in crypto/chacha.c "fixes"
> this, but there seems to be no obvious way to say "if use_zvkb then
> cra_alignmask = 3", and, not being familiar with the crypto API stuff, I
> can't figure out a good way to say "if riscv then cra_alignmask = 3" either.
>
> AFAICT, this problem was missed from the very start since commit
> bb54668837a0 ("crypto: riscv - add vector crypto accelerated ChaCha20").
>
> Please advise.
>

I'd suggest to only enable this version of the code if both Zicclsm
and Zvkb are supported (assuming that Zicclsm is the extension that
would result in these misaligned accesses to be permitted).

Playing with the cra_alignmask is likely insufficient, because it does
not fix the use cases that call the library interface directly.
