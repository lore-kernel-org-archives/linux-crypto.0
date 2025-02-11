Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D651D5178;
	Tue, 11 Feb 2025 08:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739261207; cv=none; b=kZD/utoB34vaTC7ryt0vXw237kewwYDkZr3+/by8jceK4rxdZ2LrCMuCdNfFeEDqvW/T/cG0Te+e89qMGfNKzwsgy/ivX6oEtNVvh8wKpx+VC275HE+gE0TK6wHaoJYMITr9IpQf5gbP1XTZcu5393U8jlBJIdPXhshqpqPTzmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739261207; c=relaxed/simple;
	bh=2jP2zbkt7LWl+/bugR4lAeF/IEYJn8uooGiAdMDZA1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YVXrrfwkIroJwvrmr+qhq0tpEg+SIlonHwjGVG79iStiDISHAIP85awU//IoweYjph7FaS8BQ93zKB/WC6LIVUY9Uo8NdorGEf1UK+FgCGoBQ2R9hswyMq/LBr60mzJD7MieCboxRNTF1vrN+ywIIdA99kVT2CYMlOXKjvFmjfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQN1Ek6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQN1Ek6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6BBC4CEDD;
	Tue, 11 Feb 2025 08:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739261206;
	bh=2jP2zbkt7LWl+/bugR4lAeF/IEYJn8uooGiAdMDZA1Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EQN1Ek6/+md+VOZqr40C3pMmVqA4uCPEakT1Vkt6yPelL4pCqzyX6Y+HVTCNc2K7c
	 os2A6Dj04h7adub0avYREMeSlgjttxxqFDfqtiuJypOfSwKdyWm7/siJOyYAEfYqcF
	 13jvCKGi2/G72hxiVtbIbpDmcXVmYkYYY9cJH7fv2e4J7euwtY8bJUbAvtsYFyaqPh
	 WNYnrpPnA2UCYVxPCE1kdd9SMGJXdgEccbbtagh5FRGc9JTEgYiqB2IBlk2s6yifZF
	 PLr3If0Cu+Lgdlts/90+fZHptG9BFq5rTONZxuG2+kllfjlliVUrpn7a0/yZoj/Wpt
	 flaaY6xA7pvRw==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5450cf0cb07so1476699e87.0;
        Tue, 11 Feb 2025 00:06:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXucw7K0h6rJaHZ/RQf7etugecHugN2V5ndK7JCHdcJgMHQcZCriXDwo1iPwRstay3LgQGpwZ8Awu/9O9E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlMiGdthntk/bo06HseM3Skq1Xu2lkJvLqmAOetMKRCMg2nAOO
	kgw8Cyc3P58yyx8/GOyMXWAyARU0z5NJX+NEuk/jYwqu5y3G6Qak4IdLijhbEsUInaJHbP2xKO2
	O3DCLQIO7lAy84AbR0TiyzPYO0jk=
X-Google-Smtp-Source: AGHT+IEaV6exEDwvJeZ33T3YoFFE0sQrHjviLq59act6YoD68VrvkRY8otxx6UM7RDIa8Is3qHmc6Q9/DAdHpUZuSBk=
X-Received: by 2002:a05:6512:220b:b0:545:944:aadd with SMTP id
 2adb3069b0e04-5450944abc4mr2306081e87.37.1739261204716; Tue, 11 Feb 2025
 00:06:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250210165020.42611-1-ebiggers@kernel.org>
In-Reply-To: <20250210165020.42611-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 11 Feb 2025 09:06:33 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEn2tGa0w5R2868L_yw_K1hXGi+RHq2BiO_vgC9TS7GLQ@mail.gmail.com>
X-Gm-Features: AWEUYZnGSdBcP4cvXyx1aQOKl0cK8T3e1AMQ0-W26Qvg0ba6gExtyK9lONyNotg
Message-ID: <CAMj1kXEn2tGa0w5R2868L_yw_K1hXGi+RHq2BiO_vgC9TS7GLQ@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: x86/aes-ctr - rewrite AESNI+AVX optimized CTR
 and add VAES support
To: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 10 Feb 2025 at 17:51, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Delete aes_ctrby8_avx-x86_64.S and add a new assembly file
> aes-ctr-avx-x86_64.S which follows a similar approach to
> aes-xts-avx-x86_64.S in that it uses a "template" to provide AESNI+AVX,
> VAES+AVX2, VAES+AVX10/256, and VAES+AVX10/512 code, instead of just
> AESNI+AVX.  Wire it up to the crypto API accordingly.
>
> This greatly improves the performance of AES-CTR and AES-XCTR on
> VAES-capable CPUs, with the best case being AMD Zen 5 where an over 230%
> increase in throughput is seen on long messages.  Performance on
> non-VAES-capable CPUs remains about the same, and the non-AVX AES-CTR
> code (aesni_ctr_enc) is also kept as-is for now.  There are some slight
> regressions (less than 10%) on some short message lengths on some CPUs;
> these are difficult to avoid, given how the previous code was so heavily
> unrolled by message length, and they are not particularly important.
> Detailed performance results are given in the tables below.
>
> Both CTR and XCTR support is retained.  The main loop remains
> 8-vector-wide, which differs from the 4-vector-wide main loops that are
> used in the XTS and GCM code.  A wider loop is appropriate for CTR and
> XCTR since they have fewer other instructions (such as vpclmulqdq) to
> interleave with the AES instructions.
>
> Similar to what was the case for AES-GCM, the new assembly code also has
> a much smaller binary size, as it fixes the excessive unrolling by data
> length and key length present in the old code.  Specifically, the new
> assembly file compiles to about 9 KB of text vs. 28 KB for the old file.
> This is despite 4x as many implementations being included.
>
> The tables below show the detailed performance results.  The tables show
> percentage improvement in single-threaded throughput for repeated
> encryption of the given message length; an increase from 6000 MB/s to
> 12000 MB/s would be listed as 100%.  They were collected by directly
> measuring the Linux crypto API performance using a custom kernel module.
> The tested CPUs were all server processors from Google Compute Engine
> except for Zen 5 which was a Ryzen 9 9950X desktop processor.
>
> Table 1: AES-256-CTR throughput improvement,
>          CPU microarchitecture vs. message length in bytes:
>
>                      | 16384 |  4096 |  4095 |  1420 |   512 |   500 |
> ---------------------+-------+-------+-------+-------+-------+-------+
> AMD Zen 5            |  232% |  203% |  212% |  143% |   71% |   95% |
> Intel Emerald Rapids |  116% |  116% |  117% |   91% |   78% |   79% |
> Intel Ice Lake       |  109% |  103% |  107% |   81% |   54% |   56% |
> AMD Zen 4            |  109% |   91% |  100% |   70% |   43% |   59% |
> AMD Zen 3            |   92% |   78% |   87% |   57% |   32% |   43% |
> AMD Zen 2            |    9% |    8% |   14% |   12% |    8% |   21% |
> Intel Skylake        |    7% |    7% |    8% |    5% |    3% |    8% |
>
>                      |   300 |   200 |    64 |    63 |    16 |
> ---------------------+-------+-------+-------+-------+-------+
> AMD Zen 5            |   57% |   39% |   -9% |    7% |   -7% |
> Intel Emerald Rapids |   37% |   42% |   -0% |   13% |   -8% |
> Intel Ice Lake       |   39% |   30% |   -1% |   14% |   -9% |
> AMD Zen 4            |   42% |   38% |   -0% |   18% |   -3% |
> AMD Zen 3            |   38% |   35% |    6% |   31% |    5% |
> AMD Zen 2            |   24% |   23% |    5% |   30% |    3% |
> Intel Skylake        |    9% |    1% |   -4% |   10% |   -7% |
>
> Table 2: AES-256-XCTR throughput improvement,
>          CPU microarchitecture vs. message length in bytes:
>
>                      | 16384 |  4096 |  4095 |  1420 |   512 |   500 |
> ---------------------+-------+-------+-------+-------+-------+-------+
> AMD Zen 5            |  240% |  201% |  216% |  151% |   75% |  108% |
> Intel Emerald Rapids |  100% |   99% |  102% |   91% |   94% |  104% |
> Intel Ice Lake       |   93% |   89% |   92% |   74% |   50% |   64% |
> AMD Zen 4            |   86% |   75% |   83% |   60% |   41% |   52% |
> AMD Zen 3            |   73% |   63% |   69% |   45% |   21% |   33% |
> AMD Zen 2            |   -2% |   -2% |    2% |    3% |   -1% |   11% |
> Intel Skylake        |   -1% |   -1% |    1% |    2% |   -1% |    9% |
>
>                      |   300 |   200 |    64 |    63 |    16 |
> ---------------------+-------+-------+-------+-------+-------+
> AMD Zen 5            |   78% |   56% |   -4% |   38% |   -2% |
> Intel Emerald Rapids |   61% |   55% |    4% |   32% |   -5% |
> Intel Ice Lake       |   57% |   42% |    3% |   44% |   -4% |
> AMD Zen 4            |   35% |   28% |   -1% |   17% |   -3% |
> AMD Zen 3            |   26% |   23% |   -3% |   11% |   -6% |
> AMD Zen 2            |   13% |   24% |   -1% |   14% |   -3% |
> Intel Skylake        |   16% |    8% |   -4% |   35% |   -3% |
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>
> Changed in v4:
> - Used 'varargs' in assembly macros where appropriate.
>
> Changed in v3:
> - Dropped the patch removing the non-AVX AES-CTR for now
> - Changed license of aes-ctr-avx-x86_64.S to Apache-2.0 OR BSD-2-Clause,
>   same as what I used for the AES-GCM assembly files.  I've received
>   interest in this code possibly being reused in other projects.
> - Updated commit message to remove an ambiguous statement
> - Updated commit message to clarify that the non-AVX code is unchanged
> - Added comment above ctr_crypt_aesni() noting that it's non-AVX
>
> Changed in v2:
> - Split the removal of the non-AVX implementation of AES-CTR into a
>   separate patch, and removed the assembly code too.
> - Made some minor tweaks to the new assembly file, including fixing a
>   build error when aesni-intel is built as a module.
>
>  arch/x86/crypto/Makefile                |   2 +-
>  arch/x86/crypto/aes-ctr-avx-x86_64.S    | 592 +++++++++++++++++++++++
>  arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 597 ------------------------
>  arch/x86/crypto/aesni-intel_glue.c      | 404 ++++++++--------
>  4 files changed, 803 insertions(+), 792 deletions(-)
>  create mode 100644 arch/x86/crypto/aes-ctr-avx-x86_64.S
>  delete mode 100644 arch/x86/crypto/aes_ctrby8_avx-x86_64.S
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

I've tested this with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y on a CPU
that supports all variants, so

Tested-by: Ard Biesheuvel <ardb@kernel.org>
