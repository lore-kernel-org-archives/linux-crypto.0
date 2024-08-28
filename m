Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AC64D108;
	Wed, 28 Aug 2024 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724864978; cv=none; b=engRZwYkzjr5yz/B4wh0GPjV/ayLIE6x4vQMfB54WRfmfJh3fNhk+LYkm7VFevc6F9dk4BaAA0CGm8yrSswuIMJ6oljFtBZY6rllyUI8WOfZmKCdHUtq9GJfLq3sARTRn4jhVZlsLXu1J8q0gcQlrn3CHF5c77842IQSA6ax0PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724864978; c=relaxed/simple;
	bh=hLrtdaS0IbwhEdLlc7BKEJ/m94woIEHrv3hsrclg+Os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=FtUM2L6gZ3KfqPNMSzHNQHHvFZ0fEI1ruUuBCvR4T/uomPxgJKZXZH9P7YB07kaHx9cysEuvK3c0HyA3RXQrKZ7PPIBwYFIQstKQYXD4uOCB0/k3Rf7RSDISmynT+kBzrX/7g2A8w7TzklKogHt5sHjUMJjh0Un1ZXbbAgF10Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=oRmuBa/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oRmuBa/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4B4C4CEC0;
	Wed, 28 Aug 2024 17:09:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oRmuBa/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724864976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TRa0Oy3swmJKpeyvLt+BJYnp5j/yY79FMtPICGa1eNQ=;
	b=oRmuBa/ClnrRm/bXKmwWI6CZqmcjRs5MgC2kCKGuprvYaG7WUqO8AMqdq+aLMINuX+TzDI
	f97BDI7QqeuovRgfYPu2hZxubE3AOco+F11Si4XqWXvwmkipG2vjC5IwwkYHLTbBj2nVwE
	yvdg/vDYEMZQq1HKnT6wJw5cNkcf5Ng=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3ccebf61 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 28 Aug 2024 17:09:36 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-27032e6dbf2so4423607fac.1;
        Wed, 28 Aug 2024 10:09:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUUbRinqABL4A1IB++wYuUM3yZu0xUg9fimPOjKTU8zx7NtDX8uO+ROLOms1O+brHoYSa2mjmOa0qBiLAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY17zTews051JX1ozO9LubOeveTSjQsgAXicFtfwuhRdu5iUoj
	kU332TWJY3SWI81u/vefPx58bHMhxRJQyJZACq/2vTdvDAtIh6SikA3K4BfmEKDXQKcDiph6kYR
	rsdmvy2qCFUictz/FDfZYRcmvPTc=
X-Google-Smtp-Source: AGHT+IHtc5Sc9Zp333rli9wgkEV6Vpz2zkyfqbEEjtaBOWpnhd1CscB9Awf3cmXhZuddJCX2WiFx+oK7dIjUu+cqC1g=
X-Received: by 2002:a05:6870:a447:b0:261:1f7d:cf71 with SMTP id
 586e51a60fabf-2779026ffd3mr253318fac.34.1724864975358; Wed, 28 Aug 2024
 10:09:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828170350.3422587-1-Jason@zx2c4.com>
In-Reply-To: <20240828170350.3422587-1-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 28 Aug 2024 19:09:24 +0200
X-Gmail-Original-Message-ID: <CAHmME9qMCsAfqRR+p5CYj878R0EBGp+RbV8K=fz3XNfsK2gFXQ@mail.gmail.com>
Message-ID: <CAHmME9qMCsAfqRR+p5CYj878R0EBGp+RbV8K=fz3XNfsK2gFXQ@mail.gmail.com>
Subject: Re: [PATCH] random: vDSO: assume key is 32-bit aligned on x86_64
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 7:03=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> The prototype of this function ensures a u32* type for the key, and all
> uses of it are using state->key, which is a u32 array. When userspace
> slices up a memory region into an array of states, it does so using a
> state size that also ensures the alignment. So it's safe to assume that
> the key is always 32-bit aligned. That in turn means it's possible to
> use movaps instead of movups for loading the key.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/x86/entry/vdso/vgetrandom-chacha.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/entry/vdso/vgetrandom-chacha.S b/arch/x86/entry/vds=
o/vgetrandom-chacha.S
> index bcba5639b8ee..07ae91dcdbda 100644
> --- a/arch/x86/entry/vdso/vgetrandom-chacha.S
> +++ b/arch/x86/entry/vdso/vgetrandom-chacha.S
> @@ -43,8 +43,8 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>         /* copy0 =3D "expand 32-byte k" */
>         movaps          CONSTANTS(%rip),copy0
>         /* copy1,copy2 =3D key */
> -       movups          0x00(key),copy1
> -       movups          0x10(key),copy2
> +       movaps          0x00(key),copy1
> +       movaps          0x10(key),copy2

Zomg, no coffee today. movaps requires 128-bit alignment! So this
won't do. Forget you ever saw this.
