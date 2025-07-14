Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66297207E03;
	Mon, 14 Jul 2025 05:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752471429; cv=none; b=Q8a/xmC/TvL1deEANFJeTmHztRpcOrwDKdnZaOVsKqnBMSQTKtTNAaH7LlbwaU1TCEiTUfwihHkR2kIFeXiZW2DpilAJZ8zMO8JicdyKev3jTcV8+19hzKtymkq9JjHvJOQtZlsaHvY9Tpl/ZHGW33fL6dyH5fxtHtXdrv8DN/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752471429; c=relaxed/simple;
	bh=XyhzkR8kn5yp6Y96/1ZSlkY7pN7KXbjgCgYXc1dJjM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BfU2pr4pZYCG4QJ+WySd5pSLFKTDenEQ7YzbIuB65bYoneuJqs61/ZeFkoRjl9mnqVMFHxOrzJY3Qbqkp/7J/ypIF3EdhKLym8Nuekx4XHh5m2U5Z8gNQFvD6K6fz4PV4NY+Oypnjy9r/2V8eZpC+lmWfU5dwvvhwCCnHBGQ16I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ook5R8XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ook5R8XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4A1C116C6;
	Mon, 14 Jul 2025 05:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752471428;
	bh=XyhzkR8kn5yp6Y96/1ZSlkY7pN7KXbjgCgYXc1dJjM0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ook5R8XExmGSoVV72P4w0YtMVkmjl+IEsDJm+j8uDYtdLinFR/v63x2jF/6IsGCUZ
	 jarMRksYKjnLH/pnElAB6AIZeLcGV8I8TzwXkoDSuzTweahpyQtVyavfkj1e51R5/Q
	 OJ9KsU46OJMMNWIdH2xIfOknutQ3ATeHkzHUrO4ihfozNK1+UJnXJorXNHlC1S4UsZ
	 6fjPDrujekXcqoWycb5ernD2moX4ozGw5UL/rhtl26RiC+10z8y5rdBMhcrHSxFK0m
	 SjJeDMspn17lIEmxhTXh0voZqnN7eMaElOjACMZFBlg7fQgke6w3irMkBqTtY0Mr/P
	 WF+oWfVmf11ng==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-555163cd09aso3067994e87.3;
        Sun, 13 Jul 2025 22:37:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU+oelNoaGPCvYbQAFZanDjPqY3pRW/+wFR5jv2IgH0YTYmKFCskY1wxJJWoJGFHJfMeAh7cfaTEX5ac74=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWls2iuUPlwVtEk07+EzeSHX04s6IrQ+10EpW7dVQ1ACAe8iYA
	NtC1FNIITA4IJ4xiTQgkcTEarCV7w0Mf8Sl/z6kHEL1A1AJp4x9yUZ37q9UE8em7hpwJysox6an
	omcVwbMnR3C/J1rFKgedvbzpkjh+a+zM=
X-Google-Smtp-Source: AGHT+IEjLMFsOJcHpHskD4wHo7LQqJdzEWyUFIFGBMtsP+J2jmU/HCiSPQLOfrcO+qhjUGvH3kl5l/s52Zh1/13axZI=
X-Received: by 2002:a05:6512:3b11:b0:553:25e9:7f3c with SMTP id
 2adb3069b0e04-55a04608dcbmr3576145e87.37.1752471427301; Sun, 13 Jul 2025
 22:37:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250711212822.6372-1-ebiggers@kernel.org>
In-Reply-To: <20250711212822.6372-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 14 Jul 2025 15:36:55 +1000
X-Gmail-Original-Message-ID: <CAMj1kXFOzbJKf+TJrPBr4+9_+GD8PHG59akFUBE=Dm0az_DkJA@mail.gmail.com>
X-Gm-Features: Ac12FXxuw5I3SgWDlPv4PRMDfxwEkIF84Adsw0KWc-ZL6sUGPtq8QcFrgEAQOuo
Message-ID: <CAMj1kXFOzbJKf+TJrPBr4+9_+GD8PHG59akFUBE=Dm0az_DkJA@mail.gmail.com>
Subject: Re: [PATCH v2] lib/crypto: arm/poly1305: Remove unneeded empty weak function
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Arnd Bergmann <arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 12 Jul 2025 at 07:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Fix poly1305-armv4.pl to not do '.globl poly1305_blocks_neon' when
> poly1305_blocks_neon() is not defined.  Then, remove the empty __weak
> definition of poly1305_blocks_neon(), which was still needed only
> because of that unnecessary globl statement.  (It also used to be needed
> because the compiler could generate calls to it when
> CONFIG_KERNEL_MODE_NEON=n, but that has been fixed.)
>
> Thanks to Arnd Bergmann for reporting that the globl statement in the
> asm file was still depending on the weak symbol.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/arm/poly1305-armv4.pl | 2 +-
>  lib/crypto/arm/poly1305-glue.c   | 5 -----
>  2 files changed, 1 insertion(+), 6 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
