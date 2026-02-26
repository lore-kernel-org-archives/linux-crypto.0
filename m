Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7E62E5B27
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 13:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772111572; cv=none; b=TTAfni+K7UivStBd6xhQDg3Y0jeQpl55479vOL31OXuLKua8RfMTqDaReDJR3vsjXdon2blLfH+J//b7bHLEHVr+gwTk1nBIe9RBHHMB3Ik/DQMw+JqyQ1F3n+5ZP34+VdE5PrqdM/C0b+fh3zSNSF8xaeTYqkuqNKmqGHnreBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772111572; c=relaxed/simple;
	bh=bUKajU34nTbnmdhjV4E0C/FDXuYDhztUhWs9BNHOR80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=REICTVaKiPXHm45J4jHlYgk2STHBqsCpAP2U6sNBGcJZHVxD0mvfBBheM63N93+HNuFeSlQP9xdf5BpdOOkWRvGB532Di7mhdg+ODohgAgFGeDtuKsDSrrWtzikZCFZJ4oVRCmtpzv6fzM72iwRWbZqVA5iWe53tK05vUD/Rae8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-56a9c5cb48bso63190e0c.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 05:12:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772111570; x=1772716370;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0hKnjbv3BL565dFjMkZ/BcbOnxBMvs6z5ncDkkB7tgA=;
        b=tIHLEGBdVODBSVc3vx0wvyeuAaOtHBMTvKfC4XrB6HypywOwmQgQeTKyke4Mxd5gtG
         j+nqBqbE1DFdhdqLdADWSBgc6DYH6pO3CO4wViYCtj1Jbk17miV/zv/+9iVY7y8pHJXV
         HXWJb+jNt/mQqjrLvsE4WbwIrLsmiL1Cw8UPge7ZcOkIT5yPMvlaJKNMIZhJl5jtZLq9
         YBC/Z1xxQFzgpi5omOjYHLZm1EoIuu5cpQPqhQo4bWlFhWKPdc0SCalHTK/hsogelOwb
         TgKN7j6fxmOQS5rA7gTDxOqaaawVcVahgGrVCpirSHRtvRReBapFq2zpTn8eq+3/nuWB
         gTPw==
X-Gm-Message-State: AOJu0Yx13kb2ReTZ4Djpmzw1pGZyAOGX3N4gRuLZ+6vcMH2TiYqf6pHK
	T0U3q42T+hPLL7MYvGny3dr9Ca2JqBa6vIUHPeajX+xddmh1AX9uNz3bKt1roNJ5
X-Gm-Gg: ATEYQzwYsxrhD9sUovPUcfcUQP85gIZDbTRfd/puciHUN2WmJi7kG2mnf1OBoMBi2kQ
	RjFaCq2tv290yg0R+SZAsSrcMCtNpKnOx0FSsAXrCwP2dHCi0jgY7o/xm43kPYJf9/mSSmgJ4tr
	B0EiHv8g3RPVV05l+/LxZvulK+Gwf3S7lzdhxxVXn8S1e4n4DUMkH6tfqJ4f/sIWssMTn+g/i53
	phbIYUjqxNduBOg875rQ3UGJABKWa3CLUdwXXshvlkFUDZnenyxLb+jSlhEZT9OPBR4h2DuXxpE
	kIY9FYCqRfcddkvPRnbsvxWTpN94GyVb1cGHJm0orESbH9/qL/NTGvziJTTblAGBlF43a+bMADA
	P7aUU32v3HRryNOwahd6E82gBfBb2cOf+MH6nH3jGfHJwa3I13OqEn7wSrdgDG1dVA666YTIT0E
	5TSbGK60Po6rfR60VD7z/WXZ9B3sbyZWygRVwHsUtCCAp6hvPXyzVArVlYC3oTIq4E
X-Received: by 2002:a05:6122:4696:b0:563:80e6:3b76 with SMTP id 71dfb90a1353d-568e47a9878mr8379432e0c.7.1772111569601;
        Thu, 26 Feb 2026 05:12:49 -0800 (PST)
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com. [209.85.221.173])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56a91bcc3eesm2469693e0c.8.2026.02.26.05.12.49
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 05:12:49 -0800 (PST)
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-56a9c5cb48bso63186e0c.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 05:12:49 -0800 (PST)
X-Received: by 2002:a05:6102:c4b:b0:5f1:4fc3:855d with SMTP id
 ada2fe7eead31-5feb311d364mr7291638137.38.1772111569094; Thu, 26 Feb 2026
 05:12:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251211011846.8179-1-ebiggers@kernel.org> <20251211011846.8179-3-ebiggers@kernel.org>
In-Reply-To: <20251211011846.8179-3-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 26 Feb 2026 14:12:38 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVFRQZXCKJBOBDJtpENvpVO39AxGMUFWVQdM6xKTpnYYw@mail.gmail.com>
X-Gm-Features: AaiRm52VYzvaWsbmGKoOT8WKSlc9iNIE8yX77bG4Rzm2pI7VadASzUVGgBSmV4w
Message-ID: <CAMuHMdVFRQZXCKJBOBDJtpENvpVO39AxGMUFWVQdM6xKTpnYYw@mail.gmail.com>
Subject: Re: [PATCH 02/12] lib/crypto: tests: Add KUnit tests for NH
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	KUnit Development <kunit-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Thu, 11 Dec 2025 at 02:25, Eric Biggers <ebiggers@kernel.org> wrote:
> Add some simple KUnit tests for the nh() function.
>
> These replace the test coverage which will be lost by removing the
> nhpoly1305 crypto_shash.
>
> Note that the NH code also continues to be tested indirectly as well,
> via the tests for the "adiantum(xchacha12,aes)" crypto_skcipher.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Thanks for your patch, which is now commit 7246fe6cd64475d8
("lib/crypto: tests: Add KUnit tests for NH") in v7.0-rc1.

> --- a/lib/crypto/tests/Kconfig
> +++ b/lib/crypto/tests/Kconfig
> @@ -45,10 +45,18 @@ config CRYPTO_LIB_MLDSA_KUNIT_TEST
>         select CRYPTO_LIB_BENCHMARK_VISIBLE
>         select CRYPTO_LIB_MLDSA
>         help
>           KUnit tests for the ML-DSA digital signature algorithm.
>
> +config CRYPTO_LIB_NH_KUNIT_TEST
> +       tristate "KUnit tests for NH" if !KUNIT_ALL_TESTS
> +       depends on KUNIT
> +       default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
> +       select CRYPTO_LIB_NH

This select means that enabling KUNIT_ALL_TESTS also enables
extra functionality, which may not be desirable in a production system.
Fortunately CRYPTO_LIB_NH is tristate, so in the modular case the
extra functionality is a module, too, and not part of the running
system by default.  Unfortunately CRYPTO_LIB_NH is invisible, so this
cannot just be changed from "select" to "depends on".

> +       help
> +         KUnit tests for the NH almost-universal hash function.
> +
>  config CRYPTO_LIB_POLY1305_KUNIT_TEST
>         tristate "KUnit tests for Poly1305" if !KUNIT_ALL_TESTS
>         depends on KUNIT
>         default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
>         select CRYPTO_LIB_BENCHMARK_VISIBLE

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
