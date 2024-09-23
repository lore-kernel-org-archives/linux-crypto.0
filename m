Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C931F9D4;
	Mon, 23 Sep 2024 07:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727075739; cv=none; b=aBT8Z5ZZz775ie62b3zndbbtz+zOtrv+fxH589sqOY57SfcSMqTFPA61j4Sfk7c90yEw7OmSUqq/rPbAftcEvcgUnBETXhVgtqIjA1U53etPVw7uM4QZtn1yBTs0uJjHRV4smLRcrArkLs8LtnjEnE/Wq+Rx+IjtMOeRClASt2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727075739; c=relaxed/simple;
	bh=Om7eMagdVPo99EOw/w/Ir5+YmzCTKIPzgYlOKGurKIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dlXf17nBqR3U2iZI20z8kUzr1uvif3BjkZy1LX/vmo5PS0/Ep9KIr8HDmRvygLy5klwBZjLsA8uVY5xP9N3C6lR9YE76XOgCAwTIjA4omYOiWdXM7aEDOG1Zw2gMbCRtSohy6dgq29m9M19nCvLy2PlpFevk4SdxX9l84NMbf9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kAVVUipQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kAVVUipQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E687CC4CECE;
	Mon, 23 Sep 2024 07:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727075738;
	bh=Om7eMagdVPo99EOw/w/Ir5+YmzCTKIPzgYlOKGurKIw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kAVVUipQAS1iYRRwL9L2IEFb+OhntDJYnSASLbisPtjILzFia/3vaGxWlHpt2Lmro
	 yaXNa6xlyQ16lAGUjDgaVIczl4ULvtVwWq2zng5K7KD1f3WoYkUgQif1LzgYOEfZ8o
	 9AcEBEaWY4HYNDaHGc9tb2RgzvwJMtZqmjigvazVO1HlCYvgellX0Bi7c/Wb+M79H3
	 naALv9Jiq2PGlpfLL8u3T8lrwXXJrgaQze1EBKcoVmX6R0en9u7n6FaWKFWeP0eHXA
	 pEsM+u020o7D76mRBdYd5Qls8aFwgg9LrdzSFWVjuRfpItWP1+snlcGz+Pg4IjTC8r
	 Qk+9gawD0fm3w==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8d446adf6eso629541566b.2;
        Mon, 23 Sep 2024 00:15:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUbQKqovTt6zXI96PAtFVLcRUPC5HucfFSYEKkbUJVg1g82nlvxOxEPsN8p5n1z2+Y8x8X9uato8HWG1Lg6@vger.kernel.org, AJvYcCWOrIjTqXtakKxGn+Q9++wtgF3bjYIsOud5AjoLUt/1+1ViGl01IEKKsBAvseJEvssXQicKlDr1GKv0eYc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1I86p8pYZHGAUt6S2cZwj2gvSrxrB1ytHU8d7QydD/S0t5SdK
	oPi+TE1fEBzPIoYXSfhC9aGvkzQPGDZaivPHb9livmGj7VH45rqxvSDRfw3x68p+MamQDxYq3Bf
	Dlxm+j2BKiO4VonBayGCUgQ7OPKY=
X-Google-Smtp-Source: AGHT+IHeetYoo6cXLgYc/tRpV8uRi8E/BGXcLnSZ734kpCK/9e9XWCD4sNoJFtxLSPNxMJZjgLfsc9z8B8v/nRQEFjw=
X-Received: by 2002:a17:907:ea2:b0:a8d:1545:f48a with SMTP id
 a640c23a62f3a-a90d5114e8cmr1091934366b.61.1727075737448; Mon, 23 Sep 2024
 00:15:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240919091359.7023-1-xry111@xry111.site>
In-Reply-To: <20240919091359.7023-1-xry111@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 23 Sep 2024 15:15:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H68HOsX4=yZAmnCMW0VWf5SsqEckcHJQytSzjK8dHHW6g@mail.gmail.com>
Message-ID: <CAAhV-H68HOsX4=yZAmnCMW0VWf5SsqEckcHJQytSzjK8dHHW6g@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: vDSO: Tune the chacha20 implementation
To: Xi Ruoyao <xry111@xry111.site>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, WANG Xuerui <kernel@xen0n.name>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jinyang He <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Ruoyao,

On Thu, Sep 19, 2024 at 5:15=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> As Christophe pointed out, tuning the chacha20 implementation by
> scheduling the instructions like what GCC does can improve the
> performance.
>
> The tuning does not introduce too much complexity (basically it's just
> reordering some instructions).  And the tuning does not hurt readibility
> too much: actually the tuned code looks even more similar to a
> textbook-style implementation based on 128-bit vectors.  So overall it's
> a good deal to me.
>
> Tested with vdso_test_getchacha and benched with vdso_test_getrandom.
> On a LA664 the speedup is 5%, and I expect a larger speedup on LA[2-4]64
> with a lower issue rate.
>
> Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Link: https://lore.kernel.org/all/77655d9e-fc05-4300-8f0d-7b2ad840d091@cs=
group.eu/
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---
>  arch/loongarch/vdso/vgetrandom-chacha.S | 92 +++++++++++++++----------
>  1 file changed, 55 insertions(+), 37 deletions(-)
>
> diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vds=
o/vgetrandom-chacha.S
> index 7e86a50f6e85..0c5f1183c480 100644
> --- a/arch/loongarch/vdso/vgetrandom-chacha.S
> +++ b/arch/loongarch/vdso/vgetrandom-chacha.S
> @@ -9,23 +9,11 @@
>
>  .text
>
> -/* Salsa20 quarter-round */
> -.macro QR      a b c d
> -       add.w           \a, \a, \b
> -       xor             \d, \d, \a
> -       rotri.w         \d, \d, 16
> -
> -       add.w           \c, \c, \d
> -       xor             \b, \b, \c
> -       rotri.w         \b, \b, 20
> -
> -       add.w           \a, \a, \b
> -       xor             \d, \d, \a
> -       rotri.w         \d, \d, 24
> -
> -       add.w           \c, \c, \d
> -       xor             \b, \b, \c
> -       rotri.w         \b, \b, 25
> +.macro OP_4REG op d0 d1 d2 d3 s0 s1 s2 s3
> +       \op     \d0, \d0, \s0
> +       \op     \d1, \d1, \s1
> +       \op     \d2, \d2, \s2
> +       \op     \d3, \d3, \s3
>  .endm
>
>  /*
> @@ -74,6 +62,23 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>  /* Reuse i as copy3 */
>  #define copy3          i
>
> +/* Packs to be used with OP_4REG */
> +#define line0          state0, state1, state2, state3
> +#define line1          state4, state5, state6, state7
> +#define line2          state8, state9, state10, state11
> +#define line3          state12, state13, state14, state15
> +
> +#define        line1_perm      state5, state6, state7, state4
> +#define        line2_perm      state10, state11, state8, state9
> +#define        line3_perm      state15, state12, state13, state14
> +
> +#define        copy            copy0, copy1, copy2, copy3
The indentation here is strange, it seems some of them are spaces and
some of them are tabs.

Huacai

> +
> +#define _16            16, 16, 16, 16
> +#define _20            20, 20, 20, 20
> +#define _24            24, 24, 24, 24
> +#define _25            25, 25, 25, 25
> +
>         /*
>          * The ABI requires s0-s9 saved, and sp aligned to 16-byte.
>          * This does not violate the stack-less requirement: no sensitive=
 data
> @@ -126,16 +131,38 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>         li.w            i, 10
>  .Lpermute:
>         /* odd round */
> -       QR              state0, state4, state8, state12
> -       QR              state1, state5, state9, state13
> -       QR              state2, state6, state10, state14
> -       QR              state3, state7, state11, state15
> +       OP_4REG add.w   line0, line1
> +       OP_4REG xor     line3, line0
> +       OP_4REG rotri.w line3, _16
> +
> +       OP_4REG add.w   line2, line3
> +       OP_4REG xor     line1, line2
> +       OP_4REG rotri.w line1, _20
> +
> +       OP_4REG add.w   line0, line1
> +       OP_4REG xor     line3, line0
> +       OP_4REG rotri.w line3, _24
> +
> +       OP_4REG add.w   line2, line3
> +       OP_4REG xor     line1, line2
> +       OP_4REG rotri.w line1, _25
>
>         /* even round */
> -       QR              state0, state5, state10, state15
> -       QR              state1, state6, state11, state12
> -       QR              state2, state7, state8, state13
> -       QR              state3, state4, state9, state14
> +       OP_4REG add.w   line0, line1_perm
> +       OP_4REG xor     line3_perm, line0
> +       OP_4REG rotri.w line3_perm, _16
> +
> +       OP_4REG add.w   line2_perm, line3_perm
> +       OP_4REG xor     line1_perm, line2_perm
> +       OP_4REG rotri.w line1_perm, _20
> +
> +       OP_4REG add.w   line0, line1_perm
> +       OP_4REG xor     line3_perm, line0
> +       OP_4REG rotri.w line3_perm, _24
> +
> +       OP_4REG add.w   line2_perm, line3_perm
> +       OP_4REG xor     line1_perm, line2_perm
> +       OP_4REG rotri.w line1_perm, _25
>
>         addi.w          i, i, -1
>         bnez            i, .Lpermute
> @@ -147,10 +174,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>         li.w            copy3, 0x6b206574
>
>         /* output[0,1,2,3] =3D copy[0,1,2,3] + state[0,1,2,3] */
> -       add.w           state0, state0, copy0
> -       add.w           state1, state1, copy1
> -       add.w           state2, state2, copy2
> -       add.w           state3, state3, copy3
> +       OP_4REG add.w   line0, copy
>         st.w            state0, output, 0
>         st.w            state1, output, 4
>         st.w            state2, output, 8
> @@ -165,10 +189,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>         ld.w            state3, key, 12
>
>         /* output[4,5,6,7] =3D state[0,1,2,3] + state[4,5,6,7] */
> -       add.w           state4, state4, state0
> -       add.w           state5, state5, state1
> -       add.w           state6, state6, state2
> -       add.w           state7, state7, state3
> +       OP_4REG add.w   line1, line0
>         st.w            state4, output, 16
>         st.w            state5, output, 20
>         st.w            state6, output, 24
> @@ -181,10 +202,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
>         ld.w            state3, key, 28
>
>         /* output[8,9,10,11] =3D state[0,1,2,3] + state[8,9,10,11] */
> -       add.w           state8, state8, state0
> -       add.w           state9, state9, state1
> -       add.w           state10, state10, state2
> -       add.w           state11, state11, state3
> +       OP_4REG add.w   line2, line0
>         st.w            state8, output, 32
>         st.w            state9, output, 36
>         st.w            state10, output, 40
> --
> 2.46.1
>
>
