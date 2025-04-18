Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58C926B95E;
	Fri, 18 Apr 2025 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744982686; cv=none; b=EkgD2CpeWb3WS5s7gP/8piyxbL3/071ubwHNR7dlO5O7dPRPAO/Dw0COoVsMHWm5W+vZX+O1bsiCjxyqhlb507Y5JZ7JMrgvSupsyB6iM4eo/n+0YaaSagkqPL7+SFfisieP18AkP7GQI4eaTN/R7Ix/ES9ZsEk2ITW8C0vOI1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744982686; c=relaxed/simple;
	bh=Zpq0zvnXdVEbaBwzWK6PMJI0n8R2FyiSy5j5Qz5uRSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uQ8dtuittzN9wwy2FWDEjEF4JwhmSzDX4yAd21b3SCOy2odChZGmnotYFutzt3kSloVsLwVDovuBKvNuPN0qvSF+4Lpa1rhwK846Lhsh3umPKjbZayEu96eFoGwMkgvM0/QN7BWE7dWZAF44ju96R2xB6OewVv6ABGOE+N+yVU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cionJg7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cionJg7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAA3C4AF09;
	Fri, 18 Apr 2025 13:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744982686;
	bh=Zpq0zvnXdVEbaBwzWK6PMJI0n8R2FyiSy5j5Qz5uRSE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cionJg7L3TmwTFeVS5XuXObcMV/a/qYo6bkBGi7ZmSSxgsmsTHt4a1c0nRpCSi23a
	 8zsy9Xff+wHznJXzWUzsHnGTSGng1tbF7tOfIrWaFOiitIV4LmH+WpnCKIevKApxd4
	 oOmfepaqqrIkagMXTXRZn6rXqFLreXRPNYSeUAt1df9Tg4ZcoiouQ3DiWfc4mXTPwn
	 DpiQM8RU/lNNO2ksMV1wu1expaMSjYlJDfSLEEcDIrNU6ugKC08TmO9DHQKCu0dP8o
	 SgReWFMf7hidWL+yLXuXBWChsbmfkEIdEhholLRGVhH6mE7HOpVzgHffHhFqMY6bat
	 4wKQxfFzabizQ==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30db1bc464dso18401281fa.0;
        Fri, 18 Apr 2025 06:24:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVGYt5swpCG8+/ADb+d4n2U1jr1sWxyevZGqNxe3sptElG43Pg+I+mbt4oPmxLgZfhBjsmWBLCM/EHSjEQ=@vger.kernel.org, AJvYcCWYdKrZH5tAZFauup3R/XubdsWqinRHvbhBm74VTCvA6hDz72hSYwCjANlzDPxBg/M7iEgS6xr5scwcAWsS@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp4dxA9Elj03pjHvBfryg1TqdJJnHjJs4U1dMOLCykPLDB3tKX
	B5cZZKooFW9yVvCmuf97Ikw9pTQRfjwefDW9HfCUcjVLKlad9MSAwJzphapAuUrtoczDMcLag5K
	TtKeRPcZk6AyfOJeBej2+TnF9vfg=
X-Google-Smtp-Source: AGHT+IErep3WGm4BtwQbtUM21QyEnX4Yv4tOQqENF1MhIsvxiD9bDt1+g2ar+vyD71wyvGU9V+mWf5jvr1lqOC2Tljk=
X-Received: by 2002:a05:651c:881:b0:30b:b7c3:949a with SMTP id
 38308e7fff4ca-310905008cfmr7971221fa.18.1744982684428; Fri, 18 Apr 2025
 06:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414174018.6359-1-ebiggers@kernel.org>
In-Reply-To: <20250414174018.6359-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 18 Apr 2025 15:24:32 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGtQ=beo5Yvh38Sr-G3qyb7hYFpJsubUvkQuM4_451CGw@mail.gmail.com>
X-Gm-Features: ATxdqUElMc5hlF675lGEFJTV3nML3Kc9OVzWiwsASn1paK0_oCsLyQuqTnCSjCw
Message-ID: <CAMj1kXGtQ=beo5Yvh38Sr-G3qyb7hYFpJsubUvkQuM4_451CGw@mail.gmail.com>
Subject: Re: [PATCH] arm64: Kconfig: remove unnecessary selection of CRC32
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Apr 2025 at 19:41, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The selection of CRC32 by ARM64 was added by commit 7481cddf29ed
> ("arm64/lib: add accelerated crc32 routines") as a workaround for the
> fact that, at the time, the CRC32 library functions used weak symbols to
> allow architecture-specific overrides.  That only worked when CRC32 was
> built-in, and thus ARM64 was made to just force CRC32 to built-in.
>
> Now that the CRC32 library no longer uses weak symbols, that no longer
> applies.  And the selection does not fulfill a user dependency either;
> those all have their own selections from other options.  Therefore, the
> selection of CRC32 by ARM64 is no longer necessary.  Remove it.
>
> Note that this does not necessarily result in CRC32 no longer being set
> to y, as it still tends to get selected by something else anyway.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>
> Please consider taking this through the arm64 tree.  But if it doesn't
> get picked up there, I'll take it through the crc tree.
>
>  arch/arm64/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index a182295e6f08..14073b0094c1 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -132,11 +132,10 @@ config ARM64
>         select BUILDTIME_TABLE_SORT
>         select CLONE_BACKWARDS
>         select COMMON_CLK
>         select CPU_PM if (SUSPEND || CPU_IDLE)
>         select CPUMASK_OFFSTACK if NR_CPUS > 256
> -       select CRC32
>         select DCACHE_WORD_ACCESS
>         select DYNAMIC_FTRACE if FUNCTION_TRACER
>         select DMA_BOUNCE_UNALIGNED_KMALLOC
>         select DMA_DIRECT_REMAP
>         select EDAC_SUPPORT
>
> base-commit: 8ffd015db85fea3e15a77027fda6c02ced4d2444
> --
> 2.49.0
>
