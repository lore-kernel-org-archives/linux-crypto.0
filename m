Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A693112D2
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 13:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772111402; cv=none; b=Xg8zlVSqjs2e9XmQPDK1SR19j8wgv3s6VAGojwICt7Bvz6NnkU5xhdrADRoPOn81k3Cx6FeHvT8D4qtVN8PFHdKXDOm3uHUBNCfBqiSoKt7yIiIL1XssyKtZ3omiMfFFjah5Hudvv79Nv9+0Y0pemkG0S456wOLCAxLNz0J/xdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772111402; c=relaxed/simple;
	bh=a1p1msLbl85XGiJLc5pnzixV/EAE95C8WZQeXpg7yPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F5tdFhVw+IERv4/LOOwc7nVASIiS2nO1xuOY/1eZPudke0b4Tnpqi7x6RaUfmLjj/1ur6x8cyi2DKYn991J77awl/+0vVQJIB4MO9o5of0mG6gHUrd21TBeVdYu1E5nCA//uKNlalTTGExrFSBqGsDoLx8YcUsDPhBfesZ5Ojxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-56a9402b52fso658909e0c.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 05:10:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772111400; x=1772716200;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFo4C5bqe5c13AwLxjM1MlDIBZrqfqokVA35lsfZfy0=;
        b=lkbX93DB32+v3r1V+s6dW/gt8+9BkzfZNx5d/r5PumCRb2krWJBEHp5P5QKdJ77C4b
         Cnq6El9eC35l8PUgaVijKvQlqXoVgz+B7/bUpNzBeeduHLH+KxGBX/VkTiVZkIILb3nB
         /bmKzKuq9jG8eKQQkfYor5r+WTguR9QjRnYc08QHTcvSSXUuGxnWQoZgW8FBlb4RNw1T
         qzTbjGzy2Xc+9AEjT5VzB6ooRGAdXcKma/SCeXevUinn1QUr88RyVFevcURQruD2n74J
         DdQDh5WHduEhMamSTzNuNEOYjIpu7Ik05JdJnUBGTrLpnKL0vr7cwdg3bGZi8/dDWQc+
         m1yw==
X-Gm-Message-State: AOJu0Yw++g3szQJft4AWYfKwQA6sYKg3KhmrT6O3+DR+/h/vwqGZUXAh
	d5Ixj47NSI4vGNHcRDwxX2ds+qCam6ISKzVFcetxitJgRQtv3EvF9rFifRZs3CMm
X-Gm-Gg: ATEYQzwXT3kPpPwl4xEDODcM+8oJFOntAAMisl75aX6NhgXwmFziCsiFnoRvXz9DwRr
	FkJn39YKT2rwY3tKUDOTgpE7IaNokrLd+hCttZReqH1LTjgB9EXaKuxqND5iE6Ap00xdiSx333D
	teMUU8bknmawnlniiHoNPg2kSPJGXwq2R1zOfKZcg45H+XAmJRnOyt2XpNbTq2YWe7kMKakD7/k
	DMGdi+l2d862qHfaoCiql3RS2H/CiSCjFUq+thQiFhwiJDFFFE79r1XHI+yhN6n27veL5qf1LP2
	HtuGRKbD0QtBwc6Gg8pYz12RlO6qhLaDe5yLD6n7F8fUx1Cp1+yhLmliE+1vyDLN1AeV87EMRfl
	u/IDtAjFAD4YdxJNN64/lUf7fGQpbDtpjpd8AkS1CEiWB7NFArHrJbPWMO3hldCp8t27At8LvW1
	y+SL2M+FDEs2lP/lr+qSQXEZDbGtRF62pZgd8RUp1o4y6rlRgFF603DC8Tj7CPhuvtVL4W1Q8=
X-Received: by 2002:a05:6122:6e0e:b0:566:3b13:8208 with SMTP id 71dfb90a1353d-56a93084677mr1102283e0c.5.1772111400275;
        Thu, 26 Feb 2026 05:10:00 -0800 (PST)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56a92177fbasm2379686e0c.16.2026.02.26.05.09.58
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 05:09:58 -0800 (PST)
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-94acf9ce1b7so661338241.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 05:09:58 -0800 (PST)
X-Received: by 2002:a05:6102:5112:b0:5dd:c3ec:b66 with SMTP id
 ada2fe7eead31-5ff20c30021mr989167137.30.1772111398038; Thu, 26 Feb 2026
 05:09:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251214181712.29132-1-ebiggers@kernel.org> <20251214181712.29132-3-ebiggers@kernel.org>
In-Reply-To: <20251214181712.29132-3-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 26 Feb 2026 14:09:47 +0100
X-Gmail-Original-Message-ID: <CAMuHMdULzMdxuTVfg8_4jdgzbzjfx-PHkcgbGSthcUx_sHRNMg@mail.gmail.com>
X-Gm-Features: AaiRm51PaPKg5xcCQeCnUb9vy0Lr9tZrrIwLkmaSIGSq-OyO54vQniCM8N9qQps
Message-ID: <CAMuHMdULzMdxuTVfg8_4jdgzbzjfx-PHkcgbGSthcUx_sHRNMg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] lib/crypto: tests: Add KUnit tests for ML-DSA verification
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Stephan Mueller <smueller@chronox.de>, Lukas Wunner <lukas@wunner.de>, 
	Ignat Korchagin <ignat@cloudflare.com>, keyrings@vger.kernel.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	KUnit Development <kunit-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

CC kunit

On Sun, 14 Dec 2025 at 19:18, Eric Biggers <ebiggers@kernel.org> wrote:
> Add a KUnit test suite for ML-DSA verification, including the following
> for each ML-DSA parameter set (ML-DSA-44, ML-DSA-65, and ML-DSA-87):
>
> - Positive test (valid signature), using vector imported from leancrypto
> - Various negative tests:
>     - Wrong length for signature, message, or public key
>     - Out-of-range coefficients in z vector
>     - Invalid encoded hint vector
>     - Any bit flipped in signature, message, or public key
> - Unit test for the internal function use_hint()
> - A benchmark
>
> ML-DSA inputs and outputs are very large.  To keep the size of the tests
> down, use just one valid test vector per parameter set, and generate the
> negative tests at runtime by mutating the valid test vector.
>
> I also considered importing the test vectors from Wycheproof.  I've
> tested that mldsa_verify() indeed passes all of Wycheproof's ML-DSA test
> vectors that use an empty context string.  However, importing these
> permanently would add over 6 MB of source.  That's too much to be a
> reasonable addition to the Linux kernel tree for one algorithm.  It also
> wouldn't actually provide much better test coverage than this commit.
> Another potential issue is that Wycheproof uses the Apache license.
>
> Similarly, this also differs from the earlier proposal to import a long
> list of test vectors from leancrypto.  I retained only one valid
> signature for each algorithm, and I also added (runtime-generated)
> negative tests which were missing.  I think this is a better tradeoff.
>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Tested-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Thanks for your patch, which is now commit ed894faccb8de55c
("lib/crypto: tests: Add KUnit tests for ML-DSA verification")
in v7.0-rc1.

> --- a/lib/crypto/tests/Kconfig
> +++ b/lib/crypto/tests/Kconfig
> @@ -36,10 +36,19 @@ config CRYPTO_LIB_MD5_KUNIT_TEST
>         select CRYPTO_LIB_MD5
>         help
>           KUnit tests for the MD5 cryptographic hash function and its
>           corresponding HMAC.
>
> +config CRYPTO_LIB_MLDSA_KUNIT_TEST
> +       tristate "KUnit tests for ML-DSA" if !KUNIT_ALL_TESTS
> +       depends on KUNIT
> +       default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
> +       select CRYPTO_LIB_BENCHMARK_VISIBLE
> +       select CRYPTO_LIB_MLDSA

These two selects mean that enabling KUNIT_ALL_TESTS also enables
extra functionality, which may not be desirable in a production system.
Fortunately CRYPTO_LIB_MLDSA is tristate, so in the modular case
the extra functionality is a module, too, and not part of the running system
by default.  Unfortunately CRYPTO_LIB_MLDSA is invisible, so this cannot
just be changed from "select" to "depends on". But as CRYPTO_MLDSA
also selects it, perhaps the test can be made dependent on CRYPTO_MLDSA?

> +       help
> +         KUnit tests for the ML-DSA digital signature algorithm.
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
