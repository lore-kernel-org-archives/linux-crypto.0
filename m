Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169E420FB
	for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2023 02:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="mlxHF7hy"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-35fd52f765cso7135915ab.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Dec 2023 18:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1703211308; x=1703816108; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GanUfZ5OO281UHDSAl+g80nfHe8/nHv9cA4rNmyqZrc=;
        b=mlxHF7hyYQGryZjbZWsVW1fJB3bt91jpBHDVkBYfka4qzP14TbNTzeuJREOJDZacMB
         8Q70hAR8iJ9mWScwi8z0N/bMqjoV1sSl4wXKl06L0qNKjbYhM/YXsSpfFYuj93urTrPh
         QFIT1s/zQCG19QiAmkNXRexUh/cSVjKuxa49LY60E25TSxfibE9fA1gf2dogp9oTGxos
         Gj3NGsBnAdkkLw7SckM8r/VnHujJSyy/ALBXFpeTCPaTSpHWPpGr8wbbZXUqruwotb0t
         vsXsG2L7S/mKftLF82AjTqE8icQHe0g4xz3o3wgGXysPqx1IbehydF7oA5lFeHu09czz
         YUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703211308; x=1703816108;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GanUfZ5OO281UHDSAl+g80nfHe8/nHv9cA4rNmyqZrc=;
        b=axPWdCOwZqdPutn8NiYi9xKxoXl0AD4hDbWeYftknMJGkGSn9UgPYZZx+dcQ6q6PLV
         picI3uOB2GXfvYoSp+GLKYJiRloI0Cziye9BlAtOfFttBHOD7cHIgvTAYp44laz6oyMx
         JN80tg1T/Qu0dMRBzZcr39M8+qYgCirXGb13N4raanvRoVMc1xe8krqlr+CkSFNiVY1S
         yJ8H3csibn9B+sPZL/YsDWw6abq6L+l/iFT33pUsTqkJu1JjJOadwFu5ButmXC8ITesB
         2U7JFCOzWD30GRrfKYcX9LAukxapGwzN7SBgkZhJH2aa9Wz3haj82dbCQ7fZtcC9aq2y
         Ciuw==
X-Gm-Message-State: AOJu0YyS7IXAhMDdLaCyeTyVA6AQPTqHM9EdNa74np6zQrQBIRc1bw4Q
	1rzn8hEhpJ/V8HyD/jCLlCEneXs6m5NLlQ==
X-Google-Smtp-Source: AGHT+IEhcNGVQJDHPyDZIIqhJmZJlW9G8h+PZjwVen1gRm/ymjfOlRDTgRKMvZOENc3bdKlBT/zBWQ==
X-Received: by 2002:a05:6e02:144a:b0:35f:b047:385d with SMTP id p10-20020a056e02144a00b0035fb047385dmr699309ilo.125.1703211308076;
        Thu, 21 Dec 2023 18:15:08 -0800 (PST)
Received: from ?IPv6:2402:7500:5d5:b5a6:112b:fcd:68ec:f43? ([2402:7500:5d5:b5a6:112b:fcd:68ec:f43])
        by smtp.gmail.com with ESMTPSA id w6-20020a636206000000b005cd8866cccesm2243473pgb.27.2023.12.21.18.15.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Dec 2023 18:15:07 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH] crypto: riscv - use real assembler for vector crypto
 extensions
From: Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20231220065648.253236-1-ebiggers@kernel.org>
Date: Fri, 22 Dec 2023 10:15:04 +0800
Cc: linux-crypto@vger.kernel.org,
 linux-riscv@lists.infradead.org,
 Christoph Muellner <christoph.muellner@vrull.eu>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3C51992F-B8F8-4023-81EE-3C95102B072A@sifive.com>
References: <20231220065648.253236-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)

On Dec 20, 2023, at 14:56, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> LLVM main and binutils master now both fully support v1.0 of the =
RISC-V
> vector crypto extensions.  Therefore, delete riscv.pm and use the real
> assembler mnemonics for the vector crypto instructions.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>=20
> Hi Jerry, this patch applies to your v3 patchset
> =
(https://lore.kernel.org/linux-crypto/20231205092801.1335-1-jerry.shih@sif=
ive.com).
> Can you consider folding it into your patchset?  Thanks!

Thank you for the vector crypto asm mnemonics works.
Do you mean that fold this patch or append this one as the separated
commit into my next v4 patchset?

> arch/riscv/Kconfig                            |   6 +
> arch/riscv/crypto/Kconfig                     |  16 +-
> .../crypto/aes-riscv64-zvkned-zvbb-zvkg.pl    | 226 +++++------
> arch/riscv/crypto/aes-riscv64-zvkned-zvkb.pl  |  98 ++---
> arch/riscv/crypto/aes-riscv64-zvkned.pl       | 314 +++++++--------
> arch/riscv/crypto/chacha-riscv64-zvkb.pl      |  34 +-
> arch/riscv/crypto/ghash-riscv64-zvkg.pl       |   4 +-
> arch/riscv/crypto/riscv.pm                    | 359 ------------------
> .../sha256-riscv64-zvknha_or_zvknhb-zvkb.pl   | 101 ++---
> .../crypto/sha512-riscv64-zvknhb-zvkb.pl      |  52 +--
> arch/riscv/crypto/sm3-riscv64-zvksh.pl        |  86 ++---
> arch/riscv/crypto/sm4-riscv64-zvksed.pl       |  62 +--
> 12 files changed, 503 insertions(+), 855 deletions(-)
> delete mode 100644 arch/riscv/crypto/riscv.pm
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index dc51164b8fd4..7267a6345e32 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -531,20 +531,26 @@ config RISCV_ISA_V_PREEMPTIVE
> 	  by adding memory on demand for tracking kernel's V-context.
>=20
> config TOOLCHAIN_HAS_ZBB
> 	bool
> 	default y
> 	depends on !64BIT || $(cc-option,-mabi=3Dlp64 =
-march=3Drv64ima_zbb)
> 	depends on !32BIT || $(cc-option,-mabi=3Dilp32 =
-march=3Drv32ima_zbb)
> 	depends on LLD_VERSION >=3D 150000 || LD_VERSION >=3D 23900
> 	depends on AS_HAS_OPTION_ARCH
>=20
> +# This option indicates that the toolchain supports all v1.0 vector =
crypto
> +# extensions, including Zvk*, Zvbb, and Zvbc.  LLVM added all of =
these at once.
> +# binutils added all except Zvkb, then added Zvkb.  So we just check =
for Zvkb.
> +config TOOLCHAIN_HAS_ZVK
> +	def_bool $(as-instr, .option arch$(comma) +zvkb)
> +

Could we rename to other terms like
`TOOLCHAIN_HAS_VECTOR_CRYPTO/TOOLCHAIN_HAS_V_CRYPTO `?
Some ciphers don't use `ZVK*` extensions.

-Jerry

