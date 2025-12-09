Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5E32BEC27
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 04:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765254389; cv=none; b=XDDkBCngZAyen7ioCQIOmJABuG7KHkycEcJkrPVUxOMujRB5Zfh+5xqNzquGNy7fGt5gWUFyfxddPz2z/K0ijiLNOzF7sraWlGa5QS7yiphp7ZJ9YeCwS/6+u4+OiP8yfbLIPA/R3pu2UlEuYdeu8e9f61s+HFxBYyhQdnYXuGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765254389; c=relaxed/simple;
	bh=+jXp364WAzM9xwWFBvHkY3DKUklTKUVYtX/u2Wc/OxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QLSc5ii/3SbxX11Ol8bGQc1WX86HtiZTjZZFwASEBNc9Qz57Dz4zh+cxiqDCh0qXXwqt7kAnO4c0q02F6ja1RpZNIC7PWKSKxzdHnRISkR2tCVClHLD+8nB3yW3jSAoEQwEifQEja/+X8AzVOafoBujkLZMLY/Y9g5M8IyfVYc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=FE2a4X8b; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="FE2a4X8b"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-37e578d04b5so43378891fa.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 Dec 2025 20:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1765254385; x=1765859185; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTHKBpK1r9/QXVkfGq5Zpqp+C9e4nuUAoI+dJvTTj8c=;
        b=FE2a4X8bpf3ZujUCxafspWlWGP6IBX9KUZmYzROHQTw/WapmCiSMOutlGnPv/5/Zmd
         nB8A75BuwUIWlPzz/4HMUb+cGjF8G3NtFPZ97o8Ujtc5UXzJ8ltyjoZ26H6xWdcImJpH
         txYJ0y//StgYMoxLoBLrlDTPK+WQeFYBUZyJ0YLRes/ePZCt25LpCJ0FAg2ZsKP8IZI6
         8ZJLN5ed+8tqEOU3hJp1OMXMeuHitnvi052tVT/4dtRgrRU9yLQMnHTB6c9KvZQZ3aAw
         YHBpEW2ktaiYRiG694DVE0Yu4Se+gSiCj0GgHM239WHrrqToc3sVAS+jzZV6Q3etWXeo
         atig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765254385; x=1765859185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QTHKBpK1r9/QXVkfGq5Zpqp+C9e4nuUAoI+dJvTTj8c=;
        b=iUXdEJEjoBAMFt5QAXyOq8/z4SP0HJpnRtVcoAsv1u5f9oWKESPf5m78y7I3rKp+Nq
         /CEXfmTy5VOXsVf9+FkBYoaBzsISvc+sEvwcA0haoVkOLA/9mprbUkGB7I69eci/36Cp
         Td72e5ByxyKuI4CbFlOeGWWOUe2W9U2kvY44GJ18KiKrCUAQB9t65ElE73mFYjLM+7gj
         E1nK3tbBw6DeFrKrgzFpZx8RxFVEmxny5iV/goES5hCe1Ng5JxINhZTZHnIqAxSEUCeB
         9DxjXek1GYAq6q8UIeWzgv3oJHinS2uL3PHiy+TG8xe15MvKJ05R62mkES3YY9tCA0Qj
         7ZhQ==
X-Gm-Message-State: AOJu0Yx4B121aBmozpyWXugMjbiusoMUkvc3YtfCgmawwPXfwjuffwho
	jA9zWt5qZ7qfxK8y78Gm5mUkFNaWxzLS/SmFWR9fdYsWPfWHH0MMTTSJSqBCvZNaOStjh0LYAWh
	dTev0bJX1W4b/+UlyN7r+noiBgSUOTFyh0TOYzLoGsA==
X-Gm-Gg: ASbGncsbkypmLc7BWdm/CF5KMBLGMAvSNM+f9faIpB7yCEm1O5s0mO9ANT1AhyCAimK
	2ZPCH3aZzg5Lb4PheEZOjgNsWgFWKUyOl3WpBb535btC0tMcWwS9+oGleHXbisSqmXAkWD/w0jd
	HvBg7R67xQb65/DpmCEMcrAegsNm5wsk4c8zSIQwLGwYeQ38c4o4ey/5+GhK6+SmFipIZpRFbnY
	ypJWzEG/9fDS6jH5bRP7dGkfF2+Sfbcj5pREJ+JFFShoONN52yzW9vAHkCMCW9PykKNqHnuKhuW
	vgrLbhFDq/CWtJYmsksTM7Wns2/usd1XSWJnjRBoz2nmVQsGDywnSpfWBhs=
X-Google-Smtp-Source: AGHT+IEuwzsJ4iV/hppl7a+6AO2kFJTb1s8y+TSbQtxey/3zGokRC7kaOoo9yRzyTlRYxagbo5MXAG+kmUtRs73p+UA=
X-Received: by 2002:a05:651c:254c:20b0:37b:a981:102c with SMTP id
 38308e7fff4ca-37ed200a5admr22604601fa.18.1765254385419; Mon, 08 Dec 2025
 20:26:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251206213750.81474-1-ebiggers@kernel.org>
In-Reply-To: <20251206213750.81474-1-ebiggers@kernel.org>
From: Jerry Shih <jerry.shih@sifive.com>
Date: Tue, 9 Dec 2025 12:26:13 +0800
X-Gm-Features: AQt7F2rTqXUuqCjvRaHnuo7-SDbJXdxT1X5i9wZAPz9F_2e7btemAb2GuvQSqHI
Message-ID: <CABO+C-AfQ6PV-NJpCD86sdx7zSPcPQMsOasDKc_s2Qqtq60FNQ@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: riscv: Depend on RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Vivian Wang <wangruikang@iscas.ac.cn>, 
	"David S . Miller" <davem@davemloft.net>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Alexandre Ghiti <alex@ghiti.fr>, "Martin K . Petersen" <martin.petersen@oracle.com>, Han Gao <gaohan@iscas.ac.cn>, 
	linux-riscv@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 7, 2025 at 5:39=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> Replace the RISCV_ISA_V dependency of the RISC-V crypto code with
> RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS, which implies RISCV_ISA_V as
> well as vector unaligned accesses being efficient.
>
> This is necessary because this code assumes that vector unaligned
> accesses are supported and are efficient.  (It does so to avoid having
> to use lots of extra vsetvli instructions to switch the element width
> back and forth between 8 and either 32 or 64.)
>
> This was omitted from the code originally just because the RISC-V kernel
> support for detecting this feature didn't exist yet.  Support has now
> been added, but it's fragmented into per-CPU runtime detection, a
> command-line parameter, and a kconfig option.  The kconfig option is the
> only reasonable way to do it, though, so let's just rely on that.
>
> Fixes: eb24af5d7a05 ("crypto: riscv - add vector crypto accelerated AES-{=
ECB,CBC,CTR,XTS}")
> Fixes: bb54668837a0 ("crypto: riscv - add vector crypto accelerated ChaCh=
a20")
> Fixes: 600a3853dfa0 ("crypto: riscv - add vector crypto accelerated GHASH=
")
> Fixes: 8c8e40470ffe ("crypto: riscv - add vector crypto accelerated SHA-{=
256,224}")
> Fixes: b3415925a08b ("crypto: riscv - add vector crypto accelerated SHA-{=
512,384}")
> Fixes: 563a5255afa2 ("crypto: riscv - add vector crypto accelerated SM3")
> Fixes: b8d06352bbf3 ("crypto: riscv - add vector crypto accelerated SM4")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  arch/riscv/crypto/Kconfig | 12 ++++++++----
>  lib/crypto/Kconfig        |  9 ++++++---
>  2 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
> index a75d6325607b..14c5acb935e9 100644
> --- a/arch/riscv/crypto/Kconfig
> +++ b/arch/riscv/crypto/Kconfig
> @@ -2,11 +2,12 @@
>
>  menu "Accelerated Cryptographic Algorithms for CPU (riscv)"
>
>  config CRYPTO_AES_RISCV64
>         tristate "Ciphers: AES, modes: ECB, CBC, CTS, CTR, XTS"
> -       depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
> +       depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
> +                  RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
>         select CRYPTO_ALGAPI
>         select CRYPTO_LIB_AES
>         select CRYPTO_SKCIPHER
>         help
>           Block cipher: AES cipher algorithms
> @@ -18,21 +19,23 @@ config CRYPTO_AES_RISCV64
>           - Zvkb vector crypto extension (CTR)
>           - Zvkg vector crypto extension (XTS)
>
>  config CRYPTO_GHASH_RISCV64
>         tristate "Hash functions: GHASH"
> -       depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
> +       depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
> +                  RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
>         select CRYPTO_GCM
>         help
>           GCM GHASH function (NIST SP 800-38D)
>
>           Architecture: riscv64 using:
>           - Zvkg vector crypto extension
>
>  config CRYPTO_SM3_RISCV64
>         tristate "Hash functions: SM3 (ShangMi 3)"
> -       depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
> +       depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
> +                  RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
>         select CRYPTO_HASH
>         select CRYPTO_LIB_SM3
>         help
>           SM3 (ShangMi 3) secure hash function (OSCCA GM/T 0004-2012)
>
> @@ -40,11 +43,12 @@ config CRYPTO_SM3_RISCV64
>           - Zvksh vector crypto extension
>           - Zvkb vector crypto extension
>
>  config CRYPTO_SM4_RISCV64
>         tristate "Ciphers: SM4 (ShangMi 4)"
> -       depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
> +       depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
> +                  RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
>         select CRYPTO_ALGAPI
>         select CRYPTO_SM4
>         help
>           SM4 block cipher algorithm (OSCCA GB/T 32907-2016,
>           ISO/IEC 18033-3:2010/Amd 1:2021)
> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index a3647352bff6..6871a41e5069 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -59,11 +59,12 @@ config CRYPTO_LIB_CHACHA_ARCH
>         depends on CRYPTO_LIB_CHACHA && !UML && !KMSAN
>         default y if ARM
>         default y if ARM64 && KERNEL_MODE_NEON
>         default y if MIPS && CPU_MIPS32_R2
>         default y if PPC64 && CPU_LITTLE_ENDIAN && VSX
> -       default y if RISCV && 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTO=
R_CRYPTO
> +       default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
> +                    RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
>         default y if S390
>         default y if X86_64
>
>  config CRYPTO_LIB_CURVE25519
>         tristate
> @@ -182,11 +183,12 @@ config CRYPTO_LIB_SHA256_ARCH
>         depends on CRYPTO_LIB_SHA256 && !UML
>         default y if ARM && !CPU_V7M
>         default y if ARM64
>         default y if MIPS && CPU_CAVIUM_OCTEON
>         default y if PPC && SPE
> -       default y if RISCV && 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTO=
R_CRYPTO
> +       default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
> +                    RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
>         default y if S390
>         default y if SPARC64
>         default y if X86_64
>
>  config CRYPTO_LIB_SHA512
> @@ -200,11 +202,12 @@ config CRYPTO_LIB_SHA512_ARCH
>         bool
>         depends on CRYPTO_LIB_SHA512 && !UML
>         default y if ARM && !CPU_V7M
>         default y if ARM64
>         default y if MIPS && CPU_CAVIUM_OCTEON
> -       default y if RISCV && 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTO=
R_CRYPTO
> +       default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
> +                    RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
>         default y if S390
>         default y if SPARC64
>         default y if X86_64
>
>  config CRYPTO_LIB_SHA3
>
> base-commit: 43dfc13ca972988e620a6edb72956981b75ab6b0
> --
> 2.52.0
>

Reviewed-by: Jerry Shih <jerry.shih@sifive.com>

Thanks,
-Jerry
