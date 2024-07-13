Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A5147F64
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jul 2024 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720866218; cv=none; b=n23ZfSJS+4gpygg5e4Pe6H6GcDI0wiOI9XS2DnPVAkEGNmRN51Ns9/Tbgb/Y0uZ3CWVrapycSOdKxA8jp9VNGT74mD+fNlcCpmokijlhJNpsKjU9lACqDd0xjI1ghXEVU8CvqdyNzzeZN4jlZaWEnybesL+2MnIERhP9UebF32I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720866218; c=relaxed/simple;
	bh=o/YPL0fVT/SnADhTjmHikYdCGv/8RNq/bdhQTcqUdrY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hrMyF8u1XEtfyBg07ur+soF3OuEW3M5T2mOmznLtRwcrWZQWR5AscZeqJ3uZamdeOVSGcLJaeBENCJ9xYMovAn5Y2d6Kqez2WwpW+r7QfQ2S8OCdM7NN056H2ArXb3oQP4rxelh5wX2v/PV0QLpqRseToTp1Vdxuhs/s7kiNixw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPtuPeOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPtuPeOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E62C4AF10
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jul 2024 10:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720866217;
	bh=o/YPL0fVT/SnADhTjmHikYdCGv/8RNq/bdhQTcqUdrY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UPtuPeOdivWmOeuxsvUTKemaNjKJJKVz30YnjhmxHAKqCmYCo9M00QyhE16o4F8Cd
	 nQBhcTknDZpQYM9jJn3/E+esrFQsajkqw5VDwk1edozZek+Tiw/ZPTeaYet34LkLq6
	 VQZWLtURtfRplqwuFMRcAZ6Kcj/F+QXT+Ldc2eNL5fSHJlwlOSNr45Crp19c+hyAAv
	 C65/ujTFEzKAVY8NQ6kv/NBcISuJC1fSnbYx0HSjrKQBv98XWu1LYVaEgt30mFLCFY
	 DdHYqqQXFL5Ig7HGl69wLXTuUqzQbXmoXTbGod5GveYwGWeS676HRIGiFFRnFt1mgY
	 A/GlW9t1cPk9w==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52e9a920e73so3109835e87.2
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jul 2024 03:23:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXua4lDp4DT0ke2YuBXbYSeVyPXCWQJqWvNXx5gy3V8+oZl4P5ZpnUiFmftmQyVZkb/laAPC6p06p7pZHEtj12PVSk5Fr+GKWtjJmUz
X-Gm-Message-State: AOJu0YzNSVUGaCs6cbFeee22E5hLLAJa1zNr4GtJO6aAdBUYwjY3INdv
	RiT0AXoIaa/HD5St+Hg5j6WEYWezZ7ufMQPCFeUywj1Phfa2BfVOOS9VgG4cy26Qlh8y3Ij038N
	ysJKbNZkrbB3B/Q840N4/nZFDuDs=
X-Google-Smtp-Source: AGHT+IFYEJl6C7+VBes19kaNroQPm9QBArCGjbU2XfveHoiHEp6oQkDOmbE9CENHnr6ItHUNVo5ZfRjJreqEFDJ/b68=
X-Received: by 2002:a05:6512:2350:b0:52c:987f:b355 with SMTP id
 2adb3069b0e04-52eb99cc6abmr10157158e87.42.1720866215853; Sat, 13 Jul 2024
 03:23:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712113656.30422-1-flyingpeng@tencent.com>
In-Reply-To: <20240712113656.30422-1-flyingpeng@tencent.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 13 Jul 2024 12:23:24 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGDc6ix0YDcwMj9-DJhKp73oZL60afZFxrVoWvjVx3KPw@mail.gmail.com>
Message-ID: <CAMj1kXGDc6ix0YDcwMj9-DJhKp73oZL60afZFxrVoWvjVx3KPw@mail.gmail.com>
Subject: Re: [PATCH] crypto/ecc: increase frame warning limit
To: flyingpenghao@gmail.com, Arnd Bergmann <arnd@arndb.de>, 
	Nathan Chancellor <nathan@kernel.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="UTF-8"

(cc Arnd, Nathan)

On Fri, 12 Jul 2024 at 13:37, <flyingpenghao@gmail.com> wrote:
>
> From: Peng Hao <flyingpeng@tencent.com>
>
> When building kernel with clang, which will typically
> have sanitizers enabled, there is a warning about a large stack frame.
>
> crypto/ecc.c:1129:13: error: stack frame size (2136) exceeds limit (2048) in 'ecc_point_double_jacobian' [-Werror,-Wframe-larger-than]
> static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
>             ^
>
> Since many arrays are defined in ecc_point_double_jacobian, they occupy a
> lot of stack space, but are difficult to adjust. just increase the limit
> for configurations that have KASAN or KCSAN enabled.
>
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  crypto/Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/crypto/Makefile b/crypto/Makefile
> index edbbaa3ffef5..ab7bebaa7218 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -190,6 +190,12 @@ obj-$(CONFIG_CRYPTO_ECC) += ecc.o
>  obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
>  obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
>
> +ifneq ($(CONFIG_FRAME_WARN),0)
> +ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
> +CFLAGS_ecc.o = -Wframe-larger-than=2776
> +endif
> +endif
> +

I don't think this is an acceptable workaround - this applies to all
functions in the file, which call into each other as well.

It would be better if we could figure out why the stack blows up like
this on clang, which could be related to inlining behavior or other
compiler heuristics that prevent stack allocations from being reused.

Arnd, Nathan: any insights?
