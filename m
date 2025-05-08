Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9568713635C
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 11:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746702761; cv=none; b=FaqlpDmxAuThWiDaE4o9kMXyQCN4JNBBYSQtw/BCbT/96Vxj3n3Ws4QI8kbtEB/Zjunrszim48kVs559wC2fPnUtyIHg6J2PqkbSFuBXJQvSkAQd1KLx4e2YndHxWZIq8drZigasqzZyLsV0VQZjQ3PQWgBTg02mEyIKk/H4K8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746702761; c=relaxed/simple;
	bh=dQv4VZZjttjwpAYaN2Cr2j22vzgaZy27VORq9EYvLaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A8lB4EoqrEFO3u7fZD2s21QFFZZRlrmhVRMGnved5Yi/ht2gV4pWL67vDYChTfE2hGRnFnJCzdOkdQNY19O/p01MS2ND8wk+4cTjSM8xr4TnCD+57vSi82qUBkjAVKv8WOMfBW0nXTIFMO1s+i6QsKCBfPfYXrSKsMU51Jm4yAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CV9TL5+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CV9TL5+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C54C4CEEF
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 11:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746702761;
	bh=dQv4VZZjttjwpAYaN2Cr2j22vzgaZy27VORq9EYvLaI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CV9TL5+tLhI/kBY4HRz4UYQxpsR4bXCnb0ZNiqtYiav5pvzlUEPLA2BVeRgjBMo8s
	 xxrojTH2jQnX3lpoRzhgPZOpbJcidKfLxwQDnXykQveiu5u0bUSLxMkdZVMK9q5Dop
	 EisJ+TOF7S8iozeZyWghtaANIs0kEG4gaVw82NYNWnEZdIvA6CYxDp14Aqq/Z5jvDT
	 KksbmddqX1K53NnoWLo/FCU6/cUYfWdVJnHnVUVHXSfR9cgnNNzCCFahw7t199HXzB
	 T68teNWa7Ypop+lyoIcvTujV1SNglzFyG/O4Muw2/+8Cth2uCBPvvVoGnlftg2BVKY
	 ruFRP/ep+qjsQ==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-54e98f73850so943317e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 May 2025 04:12:40 -0700 (PDT)
X-Gm-Message-State: AOJu0YzW681QCOEMfHez7UHpH73N491F8cvw7X1tamSTiNFHsf8akmT/
	C4H8MhNIsDhCChCbsTnCEo5jpVqNGdWgryxXXT7WQMZhbM6yqFUaaVF90ARc+3a3jtehkKKxTY6
	yF/qF/V3xEdABTe62EJFZOyIjLe8=
X-Google-Smtp-Source: AGHT+IFGPDtvLpdITsEEqjXGSwOWV9roUGQMbaVqW0JaYrTV9EEgDYm6kB01vuz+QWi2eIIHHp2FwS1dEfhjWc9mkg8=
X-Received: by 2002:a05:651c:512:b0:30c:2ff9:913f with SMTP id
 38308e7fff4ca-326b87a07b1mr10358451fa.2.1746702759412; Thu, 08 May 2025
 04:12:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250507170901.151548-1-ebiggers@kernel.org>
In-Reply-To: <20250507170901.151548-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 8 May 2025 13:12:28 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEPvPKg3i9NkaYN+m4pGfw6P05g-H6_Dmb3AsQyRmU7MA@mail.gmail.com>
X-Gm-Features: ATxdqUFYGxXGhZglYKPIAlc9mrcFsSZRZtD9O4OPJJK-YwuYX3afTt3dDfEH5W4
Message-ID: <CAMj1kXEPvPKg3i9NkaYN+m4pGfw6P05g-H6_Dmb3AsQyRmU7MA@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/sha256 - fix build when CONFIG_PREEMPT_VOLUNTARY=y
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Thorsten Leemhuis <linux@leemhuis.info>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 May 2025 at 19:09, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Fix the build of sha256-ce.S when CONFIG_PREEMPT_VOLUNTARY=y by passing
> the correct label to the cond_yield macro.  Also adjust the code to
> execute only one branch instruction when CONFIG_PREEMPT_VOLUNTARY=n.
>
> Fixes: 6e36be511d28 ("crypto: arm64/sha256 - implement library instead of shash")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505071811.yYpLUbav-lkp@intel.com/
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/arm64/lib/crypto/sha256-ce.S | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/lib/crypto/sha256-ce.S b/arch/arm64/lib/crypto/sha256-ce.S
> index a8461d6dad634..f3e21c6d87d2e 100644
> --- a/arch/arm64/lib/crypto/sha256-ce.S
> +++ b/arch/arm64/lib/crypto/sha256-ce.S
> @@ -121,14 +121,15 @@ CPU_LE(   rev32           v19.16b, v19.16b        )
>
>         /* update state */
>         add             dgav.4s, dgav.4s, dg0v.4s
>         add             dgbv.4s, dgbv.4s, dg1v.4s
>
> +       /* return early if voluntary preemption is needed */
> +       cond_yield      1f, x5, x6
> +

This will yield needlessly when the condition hits during the final iteration.

>         /* handled all input blocks? */
> -       cbz             x2, 1f
> -       cond_yield      3f, x5, x6
> -       b               0b
> +       cbnz            x2, 0b
>
>         /* store new state */
>  1:     st1             {dgav.4s, dgbv.4s}, [x0]
>         mov             x0, x2
>         ret
>
> base-commit: 20e9579f11b6cbdf0556d9cd85a0aa7653caf341
> --
> 2.49.0
>
