Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933D3267731;
	Tue, 25 Feb 2025 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740487417; cv=none; b=ScxpHeq76gmWCbVMz8Aw7smIDOiD4LtSuzYojBIyoraj3HoGuOBpzoKvmd5prKuoati8mgKo1+L/RwQJtYI/tglMvKs/OhsxMS36nr9w2sWHd1jX9ZZERA88k5wT86HTfjblld6KDnbQdPdkIn5qKrpJ273r9SaOSb+My8H+KhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740487417; c=relaxed/simple;
	bh=1OwfvkL6kTjgq4tN2T97ZHJ/YRpDQusij7Vrf1nZz9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kXTZYmXnXuPMMqQwRsiBCAIlId/HmvN0p9VpjZTJ7DBcUo1swk3RyeuDDrB+FV5TaRO5f/F3V9BYvR+sUXBxFTHsNW3c2bmch5L5Ezz/0WqFv1KDnNtP2r4WcCpBHnA10cVSXW4ILrdWti4FBevIQNOGncE0F72kl8U/0E/CD2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t3Gd5dHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t3Gd5dHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A185C4CEE9;
	Tue, 25 Feb 2025 12:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740487417;
	bh=1OwfvkL6kTjgq4tN2T97ZHJ/YRpDQusij7Vrf1nZz9Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=t3Gd5dHCYOsj8f+oIw24jdtPMH/DbFHIIuaLLGlI9xFbfLcUqZjCxsOu/aWGeUl5/
	 Sc1/wjxGrqLjt70lQBK0VDO+68XwC8P8/nU2sL30tNmag4exr4ni/u81CJKdO5gxY4
	 d6epU7hxrf1tKuLGK8NnhE9o9v5h7R5vNge0EXPR1tCMiXL4Kg4boIdjXyshkxOh5L
	 CpN/WUg8lRQgY1PZYaydH/8uUN2ofXZeZe8LsdtAAaP35jkPH3tRt3Yi7yvhEBo2ft
	 YeRBgXGSstHoMz+NbS2nDlOnbVeaQ1qj5OErv8MfCaUpGz/bL87lbTcg5hQfy8FT4F
	 2p/BihEQqLAaw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-abb79af88afso1021779866b.1;
        Tue, 25 Feb 2025 04:43:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVlGRgP1BvN7SkK+Mv7I8VgEe6miXrPwV+CqB/BSU4R3ZmaFHK2Rr178MqIoeAFiE/aDqMGWLYBpjjZSmw2@vger.kernel.org, AJvYcCX5wxYN3TfR075nB4TfBvVSyeFc320vr2ibmJR4sbLtH+mInjihpZ41fznOApcGNGq0D6Vhqah8ghZzYEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxtWb2jv4LqL18Xtn9sT8ZwZXOojBqRcurM6auzIYSzDC63kSD
	mBem/mQucLIPMdSQ0AtoN8aPDQPzbgmT1YaPVYsIZTOzQrgGwD5X7VNoCAT/TtzwjFliOG/E/Lv
	kBm+CjqeGgPcEVHNFqt6i7S0bEJA=
X-Google-Smtp-Source: AGHT+IF394hAK3hIpt34lqAuCiGQSZ6t5Z8w9L9Fv+knOt2/+Vcpy+pwWWagwP0ICa/lKMsf5409s9LAdi0WO8c0bEE=
X-Received: by 2002:a17:907:1b26:b0:aaf:1183:e9be with SMTP id
 a640c23a62f3a-abc099b881cmr2114719666b.2.1740487415736; Tue, 25 Feb 2025
 04:43:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250221113341.108063-1-xry111@xry111.site>
In-Reply-To: <20250221113341.108063-1-xry111@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 25 Feb 2025 20:43:23 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4uacrS-kgvvrTQAGxdsGDsjDeE=eb6BcdCjRdgw8HLRg@mail.gmail.com>
X-Gm-Features: AWEUYZlMCcvWaaM-Mso7yvHa--XGcu8ZFfgMrPiYEmxO1O1X9rEvnP9j0aMUixw
Message-ID: <CAAhV-H4uacrS-kgvvrTQAGxdsGDsjDeE=eb6BcdCjRdgw8HLRg@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: vDSO: vgetrandom-chacha: Make use of the t8 register
To: Xi Ruoyao <xry111@xry111.site>
Cc: WANG Xuerui <kernel@xen0n.name>, "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.

Huacai

On Fri, Feb 21, 2025 at 7:34=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> So we don't need to reuse a register and rematerialize a constant.  I
> couldn't count :(.
>
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---
>
> Tested with vdso_test_getrandom and vdso_test_chacha.
>
>  arch/loongarch/vdso/vgetrandom-chacha.S | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vds=
o/vgetrandom-chacha.S
> index c2733e6c3a8d..c4dd2bab8825 100644
> --- a/arch/loongarch/vdso/vgetrandom-chacha.S
> +++ b/arch/loongarch/vdso/vgetrandom-chacha.S
> @@ -58,9 +58,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>  #define copy0          t5
>  #define copy1          t6
>  #define copy2          t7
> -
> -/* Reuse i as copy3 */
> -#define copy3          i
> +#define copy3          t8
>
>  /* Packs to be used with OP_4REG */
>  #define line0          state0, state1, state2, state3
> @@ -99,6 +97,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>         li.w            copy0, 0x61707865
>         li.w            copy1, 0x3320646e
>         li.w            copy2, 0x79622d32
> +       li.w            copy3, 0x6b206574
>
>         ld.w            cnt_lo, counter, 0
>         ld.w            cnt_hi, counter, 4
> @@ -108,7 +107,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>         move            state0, copy0
>         move            state1, copy1
>         move            state2, copy2
> -       li.w            state3, 0x6b206574
> +       move            state3, copy3
>
>         /* state[4,5,..,11] =3D key */
>         ld.w            state4, key, 0
> @@ -167,12 +166,6 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>         addi.w          i, i, -1
>         bnez            i, .Lpermute
>
> -       /*
> -        * copy[3] =3D "expa", materialize it here because copy[3] shares=
 the
> -        * same register with i which just became dead.
> -        */
> -       li.w            copy3, 0x6b206574
> -
>         /* output[0,1,2,3] =3D copy[0,1,2,3] + state[0,1,2,3] */
>         OP_4REG add.w   line0, copy
>         st.w            state0, output, 0
> --
> 2.48.1
>
