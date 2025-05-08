Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CF6A927;
	Thu,  8 May 2025 12:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746709175; cv=none; b=cVT7zWn0vPoELkkEMELXP5NZaHGqrOnSfCpdj6ezJtPr0MVqaJDTyDvkevlDb/cqCR7bDzbzeeRl6xR2E7u5/oNOMsMbxYtVkrtbx6HuFYvGJUMLcnSWMV6BU25bxjYaEGq08tWkv4c3MX9lMNYfTa17Un0T8LP/ERbrJEHZ/YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746709175; c=relaxed/simple;
	bh=aJSE6ncB4PWgfyV5v7DV6bvwyMhTYTShI15ytKls2K0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jhrSwnACryNbKi/OLLYBDzGszE85fmZm/Wh4wwts/ZvKWCL+F3+3zBD+db4yl7ZvCLft2tIDED7RqTGjRAp3/nb0smrEI5WdHUvCvljX6HCRSxxRh44puUcj5fyby+KZRMXS1vDEUaI9W09MlPaS5/kcyS1QwnkTi6vNleKq+oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-879c44a1dc4so227749241.3;
        Thu, 08 May 2025 05:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746709171; x=1747313971;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=01ZSEgdLjUpD4xto7wBwz7+BoSwten0GUTJr0EeQUdg=;
        b=VsrWPwqrOQtLSESXiZ9PV/128ao3PGdqYL2qKXrftjJnMU5dgAITeF6hocVa8Fzph/
         qhipr17QcbdIprkHNDbIsamet7+w3xKn2pQhtWI5d9/l85nakDjktedFnidrKgwexPCJ
         Abio6P6omh6mlHqOprTzbVFUcVni9Vuc3b4ZEB5Rm+heOnXHaHEO6pdQ7OWRgvov+CxK
         YfAA86j5rI5IAUwKFhFGGYoIlX51YbuheIsO3jtxRWPZO9glor3FzZR0zonC9ANCMUfD
         PDyO7/kroVZ9UFIh+LoI8+LU/y+M7QS0gz8AvLiChCjUnZnCmYmd3vO8D7c4N/a3bwQd
         dfkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYmxul031+Szh8qkBlHEpFxjiABW+WBV/FMOeFiEf9A+D8GhcBvejqHAJmAZPBwQ+RlbxiKrNyPEL6jN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxtG7SBsT+5mJCkmEnmzth1yoG1R4eR/ybrgAVTZM3UkBNrDM2
	qXpTXBN3qE1R9dSo4+TgEsjZsk7uH4ZHhZt4/sM5cNatkQPiS0WdqHWd+hR3
X-Gm-Gg: ASbGncuCKAVB9ubnkFzyFKBH5Yp8vk32kVB87sAu5082ML5FJxv4JRgwA4bJMvEFa3w
	2FcBVKCqqO66BX4Konl778I+i9YWD7mbzrlLtkxUafiKr0cdMPkgE8WQrLtfZdsUOBr10+bDCh6
	4qhsIWFNHJ0OchABVpLjf0JCkyL+6VbMSYUE07tMUXRdqKPGmvjHbPdgeKUko0dPalJvqODPa/A
	Depqxjyx6zltU82JalP/92LR4FYTSWEHkFNSuu7VcZg7HHHnD+JXfU5UUb/CJIG1qLMJCouUXQc
	VBFD0WiXTR9iyaghJfqg9mU7k0Dvo3MfNEx4l7pQsj221eKJ+Qk8Vj6o1djp7yZM2fhE26I72LK
	Jtns=
X-Google-Smtp-Source: AGHT+IEPKv0VOn5vxekpsRMVhuMjevRmsVsb7itTSpASMTikCugYnYCEz4dI9aRKyvYs1VSsaXaOIg==
X-Received: by 2002:a05:6102:5794:b0:4da:fc9d:f0a with SMTP id ada2fe7eead31-4dc738070afmr5044262137.15.1746709171094;
        Thu, 08 May 2025 05:59:31 -0700 (PDT)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-8780b0216aesm2541923241.20.2025.05.08.05.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 05:59:30 -0700 (PDT)
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-879edc092e7so142639241.0;
        Thu, 08 May 2025 05:59:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWM50TVp0QmloO6WEhBqxXUye5FzVyTgGWTUH4YByuI+1TQfXfsXN6ifGFYzd/9ZanTkZ+4v47BYLZUbpg=@vger.kernel.org
X-Received: by 2002:a05:6102:5794:b0:4da:fc9d:f0a with SMTP id
 ada2fe7eead31-4dc738070afmr5044224137.15.1746709170498; Thu, 08 May 2025
 05:59:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250505203345.802740-1-ebiggers@kernel.org> <20250505203345.802740-2-ebiggers@kernel.org>
In-Reply-To: <20250505203345.802740-2-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 8 May 2025 14:59:18 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXhXMxE9yL7BeSgiw5mt5+-kMy3LaJ+QR6buxjWUxPFrQ@mail.gmail.com>
X-Gm-Features: AX0GCFtEaUD2NCZLiE9qGON2RilPUzfQ6k2Dn9KkdLXJ6kvr02NTCLgMF07u628
Message-ID: <CAMuHMdXhXMxE9yL7BeSgiw5mt5+-kMy3LaJ+QR6buxjWUxPFrQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] crypto: tcrypt - rename CRYPTO_TEST to CRYPTO_BENCHMARK
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 5 May 2025 at 22:37, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> tcrypt is actually a benchmarking module and not the actual tests.  This
> regularly causes confusion.  Update the kconfig option name and help
> text accordingly.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

>  arch/m68k/configs/amiga_defconfig           |  2 +-
>  arch/m68k/configs/apollo_defconfig          |  2 +-
>  arch/m68k/configs/atari_defconfig           |  2 +-
>  arch/m68k/configs/bvme6000_defconfig        |  2 +-
>  arch/m68k/configs/hp300_defconfig           |  2 +-
>  arch/m68k/configs/mac_defconfig             |  2 +-
>  arch/m68k/configs/multi_defconfig           |  2 +-
>  arch/m68k/configs/mvme147_defconfig         |  2 +-
>  arch/m68k/configs/mvme16x_defconfig         |  2 +-
>  arch/m68k/configs/q40_defconfig             |  2 +-
>  arch/m68k/configs/sun3_defconfig            |  2 +-
>  arch/m68k/configs/sun3x_defconfig           |  2 +-

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
