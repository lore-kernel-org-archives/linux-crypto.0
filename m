Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAEC25C818
	for <linux-crypto@vger.kernel.org>; Mon,  6 Oct 2025 08:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759739017; cv=none; b=qU9pVXSx0AgI89B6niKiyQr8kSJvBDEKdl7x1Wo6Tw/5DgJlApQmCeVtcBoXOH0hjX12Uu/O6Tko8oLVSOo1HC9YuqnAfsEN84qleM61Mpzror68g1T2WiW5aR8611yL893hMIGTs+VbcLsP4EsxY5oXS/dgg3Nrit/AWpI+Rc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759739017; c=relaxed/simple;
	bh=yPJ4uhScVV52KX4qfADm9W+4Y+fnBc/G5x2E3kGOXeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wue8yHJNHQPtmmuebupGJnpWL4ydaAW52Lhq/WL5qmfRgUQWgUNYyQW9oEOxvVP/UdfcRQVF7muzmKraDxKCAE+RZ3ErEDFbRHnG6D55DsCkYik0oWAGpmaLVIXwUuz3MrmPFCb2a2Q4szR6cQfqwWV90GZ0Y4KzOhV0YN3PUhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-5a3511312d6so1825868137.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 01:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759739014; x=1760343814;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VCOFbZedcMVlIFhZ5V9Jemyp+1b5l06JAScJmhtxVpA=;
        b=PMWf5+2v7okgIC1zDi3w7iYhLSNsKadI9qCeAz1StFr7hyNZ59RDEUkKx09dkOW0FT
         j3K9Lw3/GxKuoJRuM14BIVWd3/vqmUs96fpGaiEU46erFenRUSGelhuYiW6fyc9iff6+
         RF1bCQ0lXIJ0WYqXRgE5bqSlk3ncRLZ8lDX8YA9QZ12Q6O3yLMH5FnaLVZPzRi4INnWS
         JEtAzD80DbvC//1UuoTWgBWHnR76lI7+In7jVYpwavoqKesKskGfDSqYTE0knxldfEiZ
         p6e1VzczND45dq7kzll3tkIOQpZbJfHqTma9myjA8Z94vUP9NP3nZpg6sySxuK03Nx/i
         MlsA==
X-Forwarded-Encrypted: i=1; AJvYcCVrpOWop6IsYBAcetjrBAmwf4r/C9+X3SYN+QcLk5HYo2gn1Yvztkb1NUQ777RfNAAlttc0JyHa3M3PWhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyW3BjD3mcS54I5nIsIS5gdIdRXOH8burnCa2jZ0Q3dd0rQBA5q
	fdq2DRO0HX3v7oCYWhuO5AGJAoNepVpI7YS4K244Wd3+CayZj0hXly6kEzTbaaKh
X-Gm-Gg: ASbGnctQ8ygtXAm5LeeKUiWfaLVps3FVKrAZzLxPKzY/mf5sy4bmljvDsRnhdutzpSy
	WRwv82+0r7+YBBuUum7mJpKHf9WrpVoLAOkIvVFK7jiehXCAMWdUzjVvz0mMygYQMM7nXtsnZms
	SRBvyHBX5qTAQKn4UhIDAA2bN+b+U78uFSmnUvYwQv1zFZ/45UnmhgAT5+/JvmDMQ0cLslHFJPC
	WZMyE5BcHQ/uP8zU1D9Q6FFiN9Vj06SpeZ/dgkwyAv25hybE/uBns8Sj92ZCoBHTc+wIJU9635d
	w3Glg/rl5IxZOzh13FNjKX0ufrhOtm0q7wTf4d8wnGCWnjwukOYd38mtuRC2YkviInnEsgqxQOD
	+mBoQU24kTf0G0MLH5GB34AbqvxDNk3CS9Z8wFaFCQubzESC/ccR1y0mp7FtIylxXX/SHmgxLbx
	USqn/rtcE3
X-Google-Smtp-Source: AGHT+IH7wBcDm7UGshbShHBRUdNqdISJdEZUAz9RhAlb670kgYroi2ekZVwqo/FDCj97qAfsUfWlEw==
X-Received: by 2002:a05:6102:5129:b0:5a4:69bc:aae with SMTP id ada2fe7eead31-5d41d10c4e2mr3742828137.29.1759739013926;
        Mon, 06 Oct 2025 01:23:33 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-92eb4da2345sm2711268241.5.2025.10.06.01.23.33
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 01:23:33 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5997f407c85so1686207137.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 01:23:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUGDnmSvQiHEzQaZ4cUQvxPPK4Msh/pTvPvhIY2ljjZg8bkvF5AfmgWN58BMWGu46NIMtKLHGv800llMJ0=@vger.kernel.org
X-Received: by 2002:a05:6102:5548:b0:4de:d08f:6727 with SMTP id
 ada2fe7eead31-5d41d0015a6mr3619673137.13.1759739012879; Mon, 06 Oct 2025
 01:23:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729152804.2411621-1-arnd@kernel.org>
In-Reply-To: <20250729152804.2411621-1-arnd@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 6 Oct 2025 10:23:21 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW6jCbB80JhUVjBPnMCAXn5Amdr6KM48jvnd+VnMR40gg@mail.gmail.com>
X-Gm-Features: AS18NWApwbBW2RVTzdSSIapTOtWIdeCfjdH3fDWaLQJJ19wwGQqxgXBBfp0nwbw
Message-ID: <CAMuHMdW6jCbB80JhUVjBPnMCAXn5Amdr6KM48jvnd+VnMR40gg@mail.gmail.com>
Subject: Re: [PATCH] hwrng: nomadik: add ARM_AMBA dependency
To: Arnd Bergmann <arnd@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Cai Huoqing <cai.huoqing@linux.dev>, Arnd Bergmann <arnd@arndb.de>, Dragan Simic <dsimic@manjaro.org>, 
	Francesco Dolcini <francesco.dolcini@toradex.com>, Daniel Golle <daniel@makrotopia.org>, 
	Christian Marangi <ansuelsmth@gmail.com>, Aurelien Jarno <aurelien@aurel32.net>, 
	Markus Mayer <mmayer@broadcom.com>, Lukas Bulwahn <lukas.bulwahn@redhat.com>, 
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Arnd,

On Tue, 29 Jul 2025 at 17:28, Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Compile-testing this driver is only possible when the AMBA bus driver is
> available in the kernel:
>
> x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_remove':
> nomadik-rng.c:(.text+0x67): undefined reference to `amba_release_regions'
> x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_probe':
> nomadik-rng.c:(.text+0xee): undefined reference to `amba_request_regions'
> x86_64-linux-ld: nomadik-rng.c:(.text+0x18d): undefined reference to `amba_release_regions'
>
> The was previously implied by the 'depends on ARCH_NOMADIK', but needs to be
> specified for the COMPILE_TEST case.
>
> Fixes: d5e93b3374e4 ("hwrng: Kconfig - Add helper dependency on COMPILE_TEST")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for your patch, which is now commit efaa2d815a0e4d1c ("hwrng:
nomadik - add ARM_AMBA dependency") upstream.

> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -312,6 +312,7 @@ config HW_RANDOM_INGENIC_TRNG
>  config HW_RANDOM_NOMADIK
>         tristate "ST-Ericsson Nomadik Random Number Generator support"
>         depends on ARCH_NOMADIK || COMPILE_TEST
> +       depends on ARM_AMBA
>         default HW_RANDOM
>         help
>           This driver provides kernel-side support for the Random Number

After seeing CONFIG_HW_RANDOM_NOMADIK disappear from m68k
all{mod,yes}config, I became intrigued, as it did build fine before?
If CONFIG_ARM_AMBA is not enabled, both __amba_driver_register() and
amba_driver_unregister() become static inline dummies, and the rest
of the code and data is not referenced, thus optimized away by the
compiler.  I verified this is the case on amd64 allmodconfig, too.
How come this failed for you?

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
