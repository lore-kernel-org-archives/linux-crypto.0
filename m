Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E52D1DF986;
	Thu, 17 Oct 2024 16:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729182632; cv=none; b=FsNuGMbEst5jPCfC2MMacepQ6wWTGOD8h5262xfs+RKscpMc6VUzRbd3Fk/L24Tyhh/n7Pxq32WPEIDZrLN4uzqyJqiUqin41IKklvNPrzMnJZduXbjCVvgEYi5rruKmFIhkkoPjvDR1xI8K/O+j4y7pvS20gGhPenBP9vwMNng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729182632; c=relaxed/simple;
	bh=It+4pWktUG7oybRnNLLp1wIAMUAiJS7JOaRzZquwmt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vk3BI7tDSBzVrbyBn1is12WJpve/3ETbzUDBk+JjRTDVleDCvHQ3R59HhOjVgGLLGC/GvQ5+b9oLeNlv0Z7b5YMtGw08f3nluoCm5xTi6XdEodbBgPfaYAB6i9Qe3S7bRwtcutOxjClbT1kE/1fOx8pT6QSeJH548XxbqKGxi+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qh0gZzJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qh0gZzJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDA6C4CED0;
	Thu, 17 Oct 2024 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729182632;
	bh=It+4pWktUG7oybRnNLLp1wIAMUAiJS7JOaRzZquwmt0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Qh0gZzJGpJGMLDIXGon3MMbuFHMFY9aCu88kc0A5A+Xk4YvZavVRUzk0H1S5pTXbQ
	 b/7R5RaxmDPSSzLuNaAFiliweaQZ3Xca2xR3XGIszbSO8rMBRmYRQZuwLZQL7E/20r
	 2W6rYGQnj51+va+hwhgth4mmT1MMPrx4C42OY12GF5P3NCDUoEt5wbul0dgKTra154
	 ryCbI7e0rvOCKzjspQC6i/vil50Gxfh1Q/9fHMGqRgt75RueZ+Pkb1qb+4cy1GpODE
	 Zl+ztBS9ElpV9IBNJbWZmT05CE6RPodz+OTAXLaspp8PXx3helMkxfRpZ3yBzqRFz6
	 rTlYD75yhmXCQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fb51f39394so13774481fa.2;
        Thu, 17 Oct 2024 09:30:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVqlRqT3kM6yYKTfBLbU7dtmgdWa585krtdVFwvrzoWOdz2aU586otKnVVf3qF4bj/qMbUy2uth9WvOZ3c=@vger.kernel.org, AJvYcCX/Ybhz2PdGa9c2ZFsMjet/irprutKDBS1KPzxA+rBllXxnqo0/15w5sDoS3aHNdJ61oQPy1KJ0E3XisjGY@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqy+uKhDfLDnzCpfLf40qOFmUdoE7XphIotjrSXFOEcjHhcQHm
	N/SxanfK+yZBGpgXgLhFcsNVTQGws7sKLzoXLqcM8UiE7sab+xAAbj9qLGFVmnMCUTQH9raVkHp
	Lg5mnblFc3soMGvqcEAUjHmL5Ia0=
X-Google-Smtp-Source: AGHT+IGBVa0hWwW7WcaZ0jxSK1IP5TappdCEMBcEkduxevGlF2V1w+R7UXO4d3rJSA7cDtcmVlerb8NpYrHBw3J8uTI=
X-Received: by 2002:a2e:9c49:0:b0:2fb:527a:815b with SMTP id
 38308e7fff4ca-2fb61bacd48mr41993091fa.28.1729182630669; Thu, 17 Oct 2024
 09:30:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241017094132.2482168-4-ardb+git@google.com>
In-Reply-To: <20241017094132.2482168-4-ardb+git@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 17 Oct 2024 18:30:19 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFROGbn_49njp_rivEidqfgnLymOCRnfSkV_dTX_hAz9w@mail.gmail.com>
Message-ID: <CAMj1kXFROGbn_49njp_rivEidqfgnLymOCRnfSkV_dTX_hAz9w@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] arm64: Speed up CRC-32 using PMULL instructions
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, will@kernel.org, 
	catalin.marinas@arm.com, Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 17 Oct 2024 at 11:41, Ard Biesheuvel <ardb+git@google.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The CRC-32 code is library code, and is not part of the crypto
> subsystem. This means that callers may not generally be aware of the
> kind of implementation that backs it, and so we've refrained from using
> FP/SIMD code in the past, as it disables preemption, and this may incur
> scheduling latencies that the caller did not anticipate.
>
> This was solved a while ago, and on arm64, kernel mode FP/SIMD no longer
> disables preemption.
>
> This means we can happily use PMULL instructions in the CRC-32 library
> code, which permits an optimization to be implemented that results in a
> speedup of 2 - 2.8x for inputs >1k in size (on Apple M2)
>
> Patch #1 implements some prepwork to handle the scalar CRC-32
> alternatives patching in C code.
>
> Changes since v2:
> - drop alternatives.h #include (#1)
> - drop unneeded branch (#2)
> - fix comment max -> min (#2)
> - add Eric's Rb
>
> Changes since v1:
> - rename crc32-pmull.S to crc32-4way.S and avoid pmull in the function
>   names to avoid confusion about the nature of the implementation;
> - polish the asm a bit, and add some comments
> - don't return via the scalar code if len dropped to 0 after calling the
>   4-way code.
>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
>
> Ard Biesheuvel (2):
>   arm64/lib: Handle CRC-32 alternative in C code
>   arm64/crc32: Implement 4-way interleave using PMULL
>

I'll need to respin this - the crc32_be code doesn't actually work correctly.
