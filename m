Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEFB1D528
	for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2023 07:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sOQhgx7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735CDC433C7
	for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2023 07:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703058519;
	bh=t3YYKmMkhn2PvmtI3Y6LdZx4/HrW+mVrwx/MbVQrYg4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sOQhgx7qmFaesOhw+FvYOkkNU+kfM6wXWFzoeODcds2rQyaYN0qHdDpUg1vv3zk3V
	 Dd+H0NGdrVW1jV7hMVeykc6B1D5HipMiQK3oT1QY9Lgy/iQZ4FZSpLHMOuMT7FacLT
	 qUJO3AnTAi4EBf3u4ABOkWc/U3ePWJO1vj0Xz2skhEphp2GNxEFk5g1Yi5YNdD+BIS
	 ujN9MB5RCh0xXNMoBq/kM1GNOdEYpNVIK1zQyyD47JvqMr5lefYNbIpjN8d2uyyNJU
	 XKVXJ8FePpyMptAb5czh92jSUUAYFo9xGG4uAuBNBdJ1nBEMvPi5+mKeDEzqHBnrXr
	 Mov+YrkINppww==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50e55f8d3afso36383e87.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 Dec 2023 23:48:39 -0800 (PST)
X-Gm-Message-State: AOJu0YzKw4sJCCBa+9tV8ZmhzCxDKOejppCeeKdMaySQtJWRaeWzEU/3
	cZsW8sdndbLisED8gqPmtHWH8rhQO6pMvV9Bxoc=
X-Google-Smtp-Source: AGHT+IG9XuBZ8g9MHc8X54C4ejhYoE6mFRzIuItshsKB1XkfrLcCteK3PdaKiegncPNuTc8Vh9MaaKaOVURh55/awEw=
X-Received: by 2002:a19:6408:0:b0:50e:556e:d241 with SMTP id
 y8-20020a196408000000b0050e556ed241mr71868lfb.100.1703058517690; Tue, 19 Dec
 2023 23:48:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231220065648.253236-1-ebiggers@kernel.org>
In-Reply-To: <20231220065648.253236-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 20 Dec 2023 08:48:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGHOTHi-LjEX=HWMrQwcthAWVN-y2YZ0T2s3_-22eh5dQ@mail.gmail.com>
Message-ID: <CAMj1kXGHOTHi-LjEX=HWMrQwcthAWVN-y2YZ0T2s3_-22eh5dQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: riscv - use real assembler for vector crypto extensions
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jerry Shih <jerry.shih@sifive.com>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, 
	Christoph Muellner <christoph.muellner@vrull.eu>
Content-Type: text/plain; charset="UTF-8"

On Wed, 20 Dec 2023 at 07:57, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> LLVM main and binutils master now both fully support v1.0 of the RISC-V
> vector crypto extensions.  Therefore, delete riscv.pm and use the real
> assembler mnemonics for the vector crypto instructions.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Hi Eric,

I agree that this is a substantial improvement.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>


> ---
>
> Hi Jerry, this patch applies to your v3 patchset
> (https://lore.kernel.org/linux-crypto/20231205092801.1335-1-jerry.shih@sifive.com).
> Can you consider folding it into your patchset?  Thanks!
>
>  arch/riscv/Kconfig                            |   6 +
>  arch/riscv/crypto/Kconfig                     |  16 +-
>  .../crypto/aes-riscv64-zvkned-zvbb-zvkg.pl    | 226 +++++------
>  arch/riscv/crypto/aes-riscv64-zvkned-zvkb.pl  |  98 ++---
>  arch/riscv/crypto/aes-riscv64-zvkned.pl       | 314 +++++++--------
>  arch/riscv/crypto/chacha-riscv64-zvkb.pl      |  34 +-
>  arch/riscv/crypto/ghash-riscv64-zvkg.pl       |   4 +-
>  arch/riscv/crypto/riscv.pm                    | 359 ------------------
>  .../sha256-riscv64-zvknha_or_zvknhb-zvkb.pl   | 101 ++---
>  .../crypto/sha512-riscv64-zvknhb-zvkb.pl      |  52 +--
>  arch/riscv/crypto/sm3-riscv64-zvksh.pl        |  86 ++---
>  arch/riscv/crypto/sm4-riscv64-zvksed.pl       |  62 +--
>  12 files changed, 503 insertions(+), 855 deletions(-)
>  delete mode 100644 arch/riscv/crypto/riscv.pm
>
...
