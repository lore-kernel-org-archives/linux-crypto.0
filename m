Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAB326CE3F
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 12:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759927479; cv=none; b=mHISW3qevq9fzu6sxyJOp32dv6SHf8Q0495COw7Pl5IfVF3rK5DNsOB5ZWAD6joC6aYNVkuFmbJmPZh8R4t4NmJZf716XDwZf1/Uyymlt+IZcB4qrZL6zOfjPwxzo86psedklIb5XTwbwJeHBrGksDvu1K8BEDQiCEN48+qKn7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759927479; c=relaxed/simple;
	bh=N31ilv74oly5MwZpmaMuwEenXmb62MTdPxYq3RqSmIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VfTPJqmz0KnxLCRLGZVWNMCS+SMUVh2vV2C3y1hy6jnm3sc3oQRKJBJB45qje5Nb45eCIf0mlBIfUwFK66/5KzxfvQz9iXLKD+yMeg3dnnF5c3hwlwMhIbLf44nQ2zkX4g3myU096duFzmLmyvSkLvkkA2NIahbxqMKseaUHQL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqQieQZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqQieQZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659EAC16AAE
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 12:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759927479;
	bh=N31ilv74oly5MwZpmaMuwEenXmb62MTdPxYq3RqSmIA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aqQieQZR3vwxlStqo6iOnZZELag0xnqfCqNBsbDX3546Y4eKN3ZTJ1grDd7Gp2MKt
	 LuRzdtmFmH5PCT6bSeA3wb3Yhyu/LZ1CUlZmGxT9tlAFPhtehcNOx+LeyBY54+UV8g
	 zRYRGt2eTGJNopitgAcobC87SgArwTUUtVdrfd10dPmT1XMOaUabpFmXyp0dTdahUH
	 M/WStRHaNOHBHXO2R/m1VRe4LBLMElhSSAO+J0Y2NQFuuJaRByy+j7qZdcXy2gMHuc
	 F0/nGHKc+HnovDn3Gi3VervfYb9rN6yd6xvuH7Wfr3k3Qy6qaV0e8YqR86LY6Its9N
	 //Dc23NlkmS/w==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-579363a4602so8247433e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 05:44:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUoDmtkHYCcAC4vweUQ966VIz27YILktw2MigkLFQTMPSAG3uB8g4/WKUkwHDf5rENyBPPrIAvGd8uAjXs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9mD84HI9hO0T6jjIOYcmeUWwU3KXDPFE6TxAzFeQBzwV3ibGP
	MjWcfVJK5dgOcbznHmKL10JPNzW0TGm/a9bKboVztrVuueg+SxPvX+7oa+Pl7+LdRGoMvAWN1qE
	ZwU02ZAQ3WTSh9AlQvzzZl4QNV8Bb8jU=
X-Google-Smtp-Source: AGHT+IFb/9iVZyCeacRA4eV5KNX9g58E3Jlitn31uEFl4qngdAtE1ZMjpaLTq+Y+xAVeNotQ9Yk5di84F5oEAA9lL/Y=
X-Received: by 2002:a05:6512:138e:b0:579:f4b3:bd2d with SMTP id
 2adb3069b0e04-5906de92179mr905583e87.57.1759927477667; Wed, 08 Oct 2025
 05:44:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com> <20251001210201.838686-23-ardb+git@google.com>
 <94214ee4-3eec-4151-a5a7-9d5e030fbca3@sirena.org.uk>
In-Reply-To: <94214ee4-3eec-4151-a5a7-9d5e030fbca3@sirena.org.uk>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 8 Oct 2025 05:44:25 -0700
X-Gmail-Original-Message-ID: <CAMj1kXEfw4RnY4wg6JBz01Hoa7r2amdJnj-eD-Kt0D+r6kAEtA@mail.gmail.com>
X-Gm-Features: AS18NWAvgP-PCFNPrGtZ5EtJZD86tidAj6ogMQQ_6DyA-DVZJAXzTHykQTP7Ti8
Message-ID: <CAMj1kXEfw4RnY4wg6JBz01Hoa7r2amdJnj-eD-Kt0D+r6kAEtA@mail.gmail.com>
Subject: Re: [PATCH v2 01/20] arm64: Revert support for generic kernel mode FPU
To: Mark Brown <broonie@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 2 Oct 2025 at 09:23, Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Oct 01, 2025 at 11:02:03PM +0200, Ard Biesheuvel wrote:
>
> > However, dropping that flag allows the compiler to use FPU and SIMD
> > registers in other ways too, and for this reason, arm64 only permits
> > doing so in strictly controlled contexts, i.e., isolated compilation
> > units that get called from inside a kernel_neon_begin() and
> > kernel_neon_end() pair.
>
> > The users of the generic kernel mode FPU API lack such strict checks,
> > and this may result in userland FP/SIMD state to get corrupted, given
> > that touching FP/SIMD registers outside of a kernel_neon_begin/end pair
> > does not fault, but silently operates on the userland state without
> > preserving it.
>
> Oh dear, that's nasty - I didn't see the patch when it was going in:
>

Actually, there is a check, it just wasn't wired up correctly by the
amdgpu driver, due to the fact that it wraps kernel_fpu_begin()/end()
calls into its own API, which are therefore always made from a
compilation unit where it is supported.

The trick is to #include <linux/fpu.h> into the definition of their
own wrapper API, so that using /that/ from FP/SIMD code also triggers
a build error.

So I'll drop this patch.
