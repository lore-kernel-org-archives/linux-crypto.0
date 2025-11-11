Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71506258CD7;
	Tue, 11 Nov 2025 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762881149; cv=none; b=WbP1iCDsJLKw4p5XRzn/wmqr2IGTkKsdXERqBiF/Zbx01jmx2gxDHji9ymLdzgbXybO6ATFJdM/DqRGB7sjX7knq9GqI8EYlFwh7RbBWjBm0X/0U8gVN/7LvBx3CF3/uQzbF1cLegQLSpW/JWyRPI4wR1E66cQr6x0wcGFg+qZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762881149; c=relaxed/simple;
	bh=wA1v/5K7nr9vmQOy0S5/hiIpm8ILDbanX/rFh69HcQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOvX3oAso1AGxm+lVz6KtuSlDzexzJSZJO8y7EuqqaWexnAFXE/n+x95zdKjWpl8wRikOUyiMFVDhbTa6oB8bfJIwejMEzcrR1t6qt30jJA7+n+xG1LHs++d8Jn0xP2+zwpssnHaTwmOw/c9jd3njhgh3aPQroDH+bs//spcCOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F73C116D0;
	Tue, 11 Nov 2025 17:12:26 +0000 (UTC)
Date: Tue, 11 Nov 2025 17:12:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 00/21] arm64: Move kernel mode FPSIMD buffer to the
 stack
Message-ID: <aRNudxVu_qNjk0I0@arm.com>
References: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>

On Fri, Oct 31, 2025 at 11:38:59AM +0100, Ard Biesheuvel wrote:
> Ard Biesheuvel (21):
>   crypto/arm64: aes-ce-ccm - Avoid pointless yield of the NEON unit
>   crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the NEON unit
>   crypto/arm64: sm4-ce-gcm - Avoid pointless yield of the NEON unit
>   arm64/simd: Add scoped guard API for kernel mode SIMD
>   ARM/simd: Add scoped guard API for kernel mode SIMD
>   crypto: aegis128-neon - Move to more abstract 'ksimd' guard API
>   raid6: Move to more abstract 'ksimd' guard API
>   lib/crc: Switch ARM and arm64 to 'ksimd' scoped guard API
>   lib/crypto: Switch ARM and arm64 to 'ksimd' scoped guard API
>   crypto/arm64: aes-ccm - Switch to 'ksimd' scoped guard API
>   crypto/arm64: aes-blk - Switch to 'ksimd' scoped guard API
>   crypto/arm64: aes-gcm - Switch to 'ksimd' scoped guard API
>   crypto/arm64: nhpoly1305 - Switch to 'ksimd' scoped guard API
>   crypto/arm64: polyval - Switch to 'ksimd' scoped guard API
>   crypto/arm64: sha3 - Switch to 'ksimd' scoped guard API
>   crypto/arm64: sm3 - Switch to 'ksimd' scoped guard API
>   crypto/arm64: sm4 - Switch to 'ksimd' scoped guard API
>   arm64/xorblocks:  Switch to 'ksimd' scoped guard API
>   net/mlx5: Switch to more abstract scoped ksimd guard API on arm64
>   arm64/fpu: Enforce task-context only for generic kernel mode FPU
>   arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack

For the series, especially the arm64 bits:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Since most of this is crypto library changes, I'm fine for it to go
upstream via your tree but please keep it on a stable branch in case we
need to solve any conflicts.

Thanks.

-- 
Catalin
