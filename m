Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C780346FA4
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 11:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763723050; cv=none; b=LoNarGarXaRfz0HMrkHdk0VzphvicxiyE46fIainM5V+3J9b+AIHJMkvqTl8782+l/NBT6ED6XdcEytoOv01o0IUp8L7+2ws0hJzMGidhSUX++Eu0rVHRIb0fT5v6ZVZt+MOSWVsYquBye1da+jf6m/CKalQtOCDQQym8iYZiSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763723050; c=relaxed/simple;
	bh=cITPS7ZwzO9o7Jo8ImdTf0R68AAchr4pmouMb36x7cY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D6o2lVADp4mIRdtMMcuwbs4YdZl9OcDgt9LWRf6a7MvIg2X4fjUrJCmMl/91Uv+wqF1ha7rTjjwXKNvLLknetNS1hfjdCdDVzqruP0eIE2haqYbNq/zd5Vwdslx/ArfCpJ0fw17ulKDOWqhpL/G7TdZSXZCsVJ1pitq86/1MA/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDpnPdkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDpnPdkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB26C16AAE
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 11:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763723049;
	bh=cITPS7ZwzO9o7Jo8ImdTf0R68AAchr4pmouMb36x7cY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hDpnPdkdUiOTS9OLYelCK+F6zytvGa3SxHCTdFls1/dHL4ZMCqoTtzLnQgl5fr5hs
	 dT8fWmEmYhRDsrxXW70c0jFtudw2sWUw9RnSIB9+T1FHmiEVRJ2R3xb8Hde+XJUrW+
	 Ggo4abTYYOVErSce3l4zrmBmuWhC8TzEEB5TGB6VoR2BOcIwtUsRvi+1d8i14O858W
	 /cgpDeAY7Fv7de5be+xw3yecj+kJUju6FdfBA9ls1xEY6r5422A5dnI9KWVM5yac4W
	 tOitFupgn3d//UWlQwTQc/fIgl0ub6/xa0I8obyyYyCenhWkvSQFI8hEB/5kds0T1v
	 fo9HQ10XPXvKg==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-37a3a4d3d53so14851281fa.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 03:04:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU58XQ2rI/x/Kp8xE8sSGbE9/UJdS5tCWo9c23ew4kyrI0oXXsw+dlV5DAcdbB22AZ/mR02xip/HQVpHys=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBfNUMXXvVOnGFTAz3ixgnTQdrFZ7x9au4Xv8g1GT26o1P0WGH
	2SEH69ISl5cYY1CjQKziHbpm8+2xfflenWkgOVIxX9ykHK/MYc9P37hPYzOs2m8+rICd5jc9q2E
	bZjJvbDGbDQLhkp8t4r805go1HQCnnTg=
X-Google-Smtp-Source: AGHT+IFRB2pMor1DNalmicQjEbKtjFpd8UK+kJQ4uqWO1cCgZyQfVKFyOOh5vu/UX7CPYtmysuXtdtA/syBMt2g/zFQ=
X-Received: by 2002:a2e:8796:0:b0:37a:3189:e7b9 with SMTP id
 38308e7fff4ca-37cd91efee8mr4095731fa.16.1763723048233; Fri, 21 Nov 2025
 03:04:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120011022.1558674-1-Jason@zx2c4.com> <20251120011022.1558674-2-Jason@zx2c4.com>
In-Reply-To: <20251120011022.1558674-2-Jason@zx2c4.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 21 Nov 2025 12:03:56 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEYhP+5dM-Vx29aUPoxNeH4dsH_sYB8bzQ6h6iaB2ZO5Q@mail.gmail.com>
X-Gm-Features: AWmQ_bkkBmlUM8R5s70_HMp5Mg8r2DZrWiRglv0NzKNrxfnLNUUU_9dBAkEgtK8
Message-ID: <CAMj1kXEYhP+5dM-Vx29aUPoxNeH4dsH_sYB8bzQ6h6iaB2ZO5Q@mail.gmail.com>
Subject: Re: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers@kernel.org>, 
	Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Nov 2025 at 02:11, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Clang and recent gcc support warning if they are able to prove that the
> user is passing to a function an array that is too short in size. For
> example:
>
>     void blah(unsigned char herp[at_least 7]);
>     static void schma(void)
>     {
>         unsigned char good[] =3D { 1, 2, 3, 4, 5, 6, 7 };
>         unsigned char bad[] =3D { 1, 2, 3, 4, 5, 6 };
>         blah(good);
>         blah(bad);
>     }
>
> The notation here, `static 7`, which this commit makes explicit by
> allowing us to write it as `at_least 7`, means that it's incorrect to
> pass anything less than 7 elements. This is section 6.7.5.3 of C99:
>
>     If the keyword static also appears within the [ and ] of the array
>     type derivation, then for each call to the function, the value of
>     the corresponding actual argument shall provide access to the first
>     element of an array with at least as many elements as specified by
>     the size expression.
>
> Here is the output from gcc 15:
>
>     zx2c4@thinkpad /tmp $ gcc -c a.c
>     a.c: In function =E2=80=98schma=E2=80=99:
>     a.c:9:9: warning: =E2=80=98blah=E2=80=99 accessing 7 bytes in a regio=
n of size 6 [-Wstringop-overflow=3D]
>         9 |         blah(bad);
>           |         ^~~~~~~~~
>     a.c:9:9: note: referencing argument 1 of type =E2=80=98unsigned char[=
7]=E2=80=99
>     a.c:2:6: note: in a call to function =E2=80=98blah=E2=80=99
>         2 | void blah(unsigned char herp[at_least 7]);
>           |      ^~~~
>
> And from clang 21:
>
>     zx2c4@thinkpad /tmp $ clang -c a.c
>     a.c:9:2: warning: array argument is too small; contains 6 elements, c=
allee requires at least 7
>           [-Warray-bounds]
>         9 |         blah(bad);
>           |         ^    ~~~
>     a.c:2:25: note: callee declares array parameter as static here
>         2 | void blah(unsigned char herp[at_least 7]);
>           |                         ^   ~~~~~~~~~~
>     1 warning generated.
>
> So these are covered by, variously, -Wstringop-overflow and
> -Warray-bounds.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  include/linux/compiler.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 5b45ea7dff3e..cbd3b466fdb9 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -379,6 +379,17 @@ static inline void *offset_to_ptr(const int *off)
>   */
>  #define prevent_tail_call_optimization()       mb()
>
> +/*
> + * This designates the minimum number of elements a passed array paramet=
er must
> + * have. For example:
> + *
> + *     void some_function(u8 param[at_least 7]);
> + *
> + * If a caller passes an array with fewer than 7 elements, the compiler =
will
> + * emit a warning.
> + */
> +#define at_least static
> +
>  #include <asm/rwonce.h>
>
>  #endif /* __LINUX_COMPILER_H */
> --
> 2.52.0
>
