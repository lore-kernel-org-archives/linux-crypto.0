Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E4733E342
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 21:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765922336; cv=none; b=ta3mj3K3wdOVjmpAcY+gxNMsmAfC8ASfEB19o8yezlN5/ZXdU6XAV5nVseuaosmkNcA9b7S48YqJH9f0KoX1C0YjU39J1VDxzVq5FltRTqQAJL+Rjxw0oDmA5Hq9v/qhUxiC433sfW+BypL7DHttkaT0fId8Xa0dv2hN0muDGOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765922336; c=relaxed/simple;
	bh=6CP3hRX5BQaPm/qBlm8Qc5XbaG+YCClo9EDxVahnc8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fMv5OcrVIy2z19UPPDYoPuJKix8J7xMKErs9IDSqtx0h2UcAzdqR9D7F1ywke910IhvFA3PSYYkSLa6ehYsZmISs3ABHlVVnqNBPUccom0/6ZIwZPivnKMemXgFNuCYj5WNZr/EZQHYbDqXSt/nzStjp0GRBXetgWAInCVhEV6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUBaYuTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUBaYuTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956DBC2BCB2
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 21:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765922335;
	bh=6CP3hRX5BQaPm/qBlm8Qc5XbaG+YCClo9EDxVahnc8w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RUBaYuTQtYEBHCJxUpIH99WeXgQ2VAs/zOXnNrBNvvwjKuJkBRYXTyg5MkxC45VlS
	 ee62YHQz/l5TzI0I1GplXcyeEl93qBFH7gYDmwC7BguRMQY6BUM7+Nhww+IhkSPKeZ
	 vhMXYSSBjpPDpE0/8iws6ojZSyj+dcE+vlfVERn5CHOVk3CLhZnNvu7cooPwV8Btce
	 W6OxcrMnjOdhmnejttNEaLbeETWnLpT1S0GXHlsiqkIulhT2KNTfPdWVmRWMvBV7+z
	 GjV5cwcqyn67Jjwu7XQO2QjXLz4pYgFmwwCtaU6q3IEgWMTGJWwp9d592Xfl+zlEGd
	 Y2U/vDSzWcqCg==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-88860551e39so45259866d6.3
        for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 13:58:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW5kaOyTe7bW4KbvsQ4Bw2XeFNsuNT7ZztszxHoKUHuPeNactrFsz9RxzDOTkjsgqwJ7i3/Wb6QMGFhI1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYfZfeqpAitaFYPxBEq/s9Y05SqFY8ELh+bZ5ptGA5PMv2mA7f
	7+1rpOp5c/zR9xIR2mSqWG4zAMF13CHyKDBasrew7VLtCyGcqeTTpwEw5eb96Ih+3BXWFqrLLQr
	z9f19VaTgY1utPQpIVbeKOivBex97lc0=
X-Google-Smtp-Source: AGHT+IF9QLmgs4U9LIq2aUJffN35K1zm7I1JmhCrt83Bk+WeZR0UQZFFngnES14acgdWyIrqFLuVAI1J9HKCZrKwqjI=
X-Received: by 2002:a05:6214:5f0a:b0:882:6d42:53a7 with SMTP id
 6a1803df08f44-8887e42cd5fmr212286226d6.40.1765922334668; Tue, 16 Dec 2025
 13:58:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251208030117.18892-1-git@danielhodges.dev> <20251208030117.18892-4-git@danielhodges.dev>
In-Reply-To: <20251208030117.18892-4-git@danielhodges.dev>
From: Song Liu <song@kernel.org>
Date: Wed, 17 Dec 2025 06:58:43 +0900
X-Gmail-Original-Message-ID: <CAPhsuW7n2aZQ6ORA60xQd91rieXtbLbheBzKAhfLiwkRCHBzqA@mail.gmail.com>
X-Gm-Features: AQt7F2o5Ad7oXU21koarRoJP-8nzG89C8aGP9TrpNcoTMVvWA7AXG_BGfM67iQM
Message-ID: <CAPhsuW7n2aZQ6ORA60xQd91rieXtbLbheBzKAhfLiwkRCHBzqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/6] bpf: Add SHA hash kfunc for cryptographic hashing
To: Daniel Hodges <git@danielhodges.dev>
Cc: bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org, 
	daniel@iogearbox.net, vadim.fedorenko@linux.dev, yatsenko@meta.com, 
	martin.lau@linux.dev, eddyz87@gmail.com, haoluo@google.com, jolsa@kernel.org, 
	john.fastabend@gmail.com, kpsingh@kernel.org, sdf@fomichev.me, 
	yonghong.song@linux.dev, herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 7, 2025 at 7:01=E2=80=AFPM Daniel Hodges <git@danielhodges.dev>=
 wrote:
[...]
> +
> +       if (!ctx->type->hash)
> +               return -EOPNOTSUPP;
> +
> +       data_len =3D __bpf_dynptr_size(data_kern);
> +       out_len =3D __bpf_dynptr_size(out_kern);
> +
> +       if (data_len =3D=3D 0)
> +               return -EINVAL;
> +
> +       if (!ctx->type->digestsize)
> +               return -EOPNOTSUPP;
> +
> +       unsigned int digestsize =3D ctx->type->digestsize(ctx->tfm);

./scripts/checkpatch.pl will complain about this:

WARNING: Missing a blank line after declarations
#109: FILE: kernel/bpf/crypto.c:387:
+       unsigned int digestsize =3D ctx->type->digestsize(ctx->tfm);
+       if (out_len < digestsize)

Please run ./scripts/checkpatch.pl on all the patches. It also highlights
some other issues, such as we need to update the MAINTAINERS file.

Also, we don't want variable declaration in the middle of a code
block.

> +       if (out_len < digestsize)
> +               return -EINVAL;
> +
[...]
>  static const struct btf_kfunc_id_set crypt_kfunc_set =3D {
> @@ -383,6 +442,7 @@ static int __init crypto_kfunc_init(void)
>         ret =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &crypt=
_kfunc_set);
>         ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT,=
 &crypt_kfunc_set);
>         ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &cryp=
t_kfunc_set);
> +       ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &=
crypt_kfunc_set);

This enables all kfuncs in crypt_kfunc_set for BPF_PROG_TYPE_SYSCALL.
We need a clear explanation why this is needed.

Thanks,
Song
