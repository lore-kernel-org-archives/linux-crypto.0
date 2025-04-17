Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4481C84C1;
	Thu, 17 Apr 2025 07:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744874751; cv=none; b=rECtrqlFWyNxsvnL4v5wjKI2xF1dOL6YX/hqRVnFS44apZkwc32FRHIdlPYEBlyahTrWh34RKns8Ex9EJfo9xlAeUv4C6wBS2haw/NRyn1gBj02keJWP5DbPnC5T1vf/ZVRJKfgHfEm2QV6dRANeXsaegsNNO0RRqUH/8E9NHgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744874751; c=relaxed/simple;
	bh=ScgvDSJXIKMetnW//CzM1itj/hEAbwvKKqoZ4Qw+2iw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jgqp2RTg958Q9vOLGfTfDIFs88wMlhHV0Pml6e5KJbcQjS4audOvvzDGnjiqOHfjoWuMy40fBalcMPb5KyKQqGh9Czybp5bznfSXzRqOaiUKNnIjcRS6+B1XcXkPd2sSwWor4S4oUV/4Bx1tQqqc+ftLJX7Mx9YV4z8WjN7m4ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VqyuffI6; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VqyuffI6"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e3978c00a5aso392897276.1;
        Thu, 17 Apr 2025 00:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744874749; x=1745479549; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+6omS8qFdHgeBrC3YXQ2F75X2vgg9HVXzQut2+kiIg=;
        b=VqyuffI6VTYvCMRYPhrW+M+cbfhH7UxF3u5oCIpB+vPy5Sb72FpYQT5AHLRCD3rOeY
         sVt3sdcOZY5s3mg7Kv50e5L7w5sAo8hYusr1ojy1EBpAyALUTejc0u/C+EIJbYw44Fo+
         ycUjL6UN6I7olCmIm8YJcW6wMFllyA0LyW9MeJnU5m0fPQl7SyYK/buIH87+ESaqxxqO
         C0He1hN+uAT3ZtiYEFWU5FbA7Cy+r9S9c8bhjhI2g9hPeM/5zEoDzRr/4t10ZvARiOsr
         elWmKsck9XbIFNyTXhhd8echxgHNNSxrZAG/RRCsd75hhw/fEES6b+Mo40XwA2sz5U7F
         GJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744874749; x=1745479549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d+6omS8qFdHgeBrC3YXQ2F75X2vgg9HVXzQut2+kiIg=;
        b=SKr59wyc++mTHIHjPkKGdYBrBa8ZqtJnD0zJ7lutGAMERXiNEneynepzDK9HKJrVMJ
         yYRngEHWjxLAahl2JaHpMWc2UH34I2zwppTyqdtHaKn0830UFTmHiyD3sTt4/XIbAll0
         2bKrvPb0pW41t4wzdHTkmDhD8aPg3wV4aWt+5pBRDVxRc4z8TvmLHUbmAl5VWES6mLex
         ku9UmyqQS7VJx7pHnTu1UYixKm2bPDIayFSqt9k5tpF55eStGA7ZUw26gFtwv7KatlvT
         Nz4uQQVmi7qpdjM2MavHkt4dFJgwiRGN8muOlkeHQ63Ekk+3uipMP7NCCmjbb26H2nG1
         ilTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWybRgHj3ZLAtZDmCXa8fM1/GQZql48MiwC4HPO2eL1woP70vBN27QowZU8r+lgw6sFjfdVROXxHkqzYayx@vger.kernel.org, AJvYcCXpGGgKIiKFqOK3CEZkp5DdhB+cRFZcLQxeqcuULgUFOpLzfw4mbChtk0AgKdLivbUbPvE1uMuhtoiOHFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyixZWajzt0555rDslJqaJxu8bhQ6u+AlZmovlbR0/HQlptj9tT
	VSSZfBLcIRE12ZLqWwwB1JCLhlFoKVmYjRXYUKnEXp4zx42y/wkYtnQmeM/IVPJOIpPZGN0aufk
	zEiZgLuvs1gVPa70WNOWfeXMDCTY=
X-Gm-Gg: ASbGnctSHIMfMRDrxbxReEPACIcC7xqQPbqIU/GlRbLuJ8IMj28BVXdtkpzlcL8pwc2
	qH1u+iiMgWetUv4/jAjW6pTkWn6Lhzi8oHsgsfqmmRns5ZlXwOk1YT3oJkyKw7vNU6aRThEHBCC
	SBCDtvhlf6s6u7IMXW6qIh5yycoKpy9j8MarLE9g==
X-Google-Smtp-Source: AGHT+IHNhX5FyTBj0UsN+DoR+c+A4Qnutg6OA5LPNfd4CP2jsuJHQX2673RgCB8Q3v/aIhw+/Ev5YMuntcdU39Cmj6w=
X-Received: by 2002:a05:6902:15c5:b0:e6d:f048:2b65 with SMTP id
 3f1490d57ef6-e7275988e38mr7146043276.21.1744874749187; Thu, 17 Apr 2025
 00:25:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417064940.68469-1-dqfext@gmail.com> <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
In-Reply-To: <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
From: Qingfang Deng <dqfext@gmail.com>
Date: Thu, 17 Apr 2025 15:25:38 +0800
X-Gm-Features: ATxdqUFVWX06hgLw7RMPLAQMePr8t5dD5yi9HmuxQPrwkgjDOLRcbA08fu5uZ94
Message-ID: <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>, 
	Heiko Stuebner <heiko.stuebner@vrull.eu>, Qingfang Deng <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard,

On Thu, Apr 17, 2025 at 2:58=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
> (cc Eric)
>
> On Thu, 17 Apr 2025 at 08:49, Qingfang Deng <dqfext@gmail.com> wrote:
> >
> > From: Qingfang Deng <qingfang.deng@siflower.com.cn>
> >
> > Add a scalar implementation of GHASH for RISC-V using the Zbc (carry-le=
ss
> > multiplication) and Zbb (bit-manipulation) extensions. This implementat=
ion
> > is adapted from OpenSSL but rewritten in plain C for clarity.
> >
> > Unlike the OpenSSL one that rely on bit-reflection of the data, this
> > version uses a pre-computed (reflected and multiplied) key, inspired by
> > the approach used in Intel's CLMUL driver, to avoid reflections during
> > runtime.
> >
> > Signed-off-by: Qingfang Deng <qingfang.deng@siflower.com.cn>
>
> What is the use case for this? AIUI, the scalar AES instructions were
> never implemented by anyone, so how do you expect this to be used in
> practice?

The use case _is_ AES-GCM, as you mentioned. Without this, computing
GHASH can take a considerable amount of CPU time (monitored by perf).

> ...
> > +static __always_inline __uint128_t get_unaligned_be128(const u8 *p)
> > +{
> > +       __uint128_t val;
> > +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS means that get_unaligned_xxx()
> helpers are cheap. Casting a void* to an aligned type is still UB as
> per the C standard.

Technically an unaligned access is UB but this pattern is widely used
in networking code.

>
> So better to drop the #ifdef entirely, and just use the
> get_unaligned_be64() helpers for both cases.

Currently those helpers won't generate rev8 instructions, even if
HAVE_EFFICIENT_UNALIGNED_ACCESS and RISCV_ISA_ZBB is set, so I have to
implement my own version of this to reduce the number of instructions,
and to align with the original OpenSSL implementation.

>
> (same below)
>
> Also, do you need to test for int128 support? Or is that guaranteed
> for all compilers that are supported by the RISC-V port?

I believe int128 support is available for all 64-bit targets.
