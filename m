Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416D22AE68;
	Thu,  4 Sep 2025 08:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973450; cv=none; b=gH5ApFHrNridUXM5VTmRC1g5N+tJGnwRcl+qiQN1lBZPTNlCj/p8QfTViq3RSlsWwJLM2W2DTHGcPzREC/AFTT8/5XXMHYwKYdraEdJ4UEkd/JzX4CamNfBIVtesWKm/3+VNqbwCBtOeG/C1PSCNErD8EiVi2JwO/Lk/hdnhYJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973450; c=relaxed/simple;
	bh=GreBThaaJNG4I9m75dU7MzXAx9mEa3TvxYUIF2X5gMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mSIoTt7dZI9utZ7iziXIjxZOzLIRk+txzURmjI2RAW0HKGu+a3atzNqC51TKLPWpwuw19PLy9Ldfa4+NIQQHBxWEILscmkNkGU1IEcqv3UxRTzPqgYcheApf5hbePM5QMrjQUcB1X6TLMssE/ux9DxMBhqD2Fj5nwdmw4ECFXFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-544a59e1e87so206238e0c.1;
        Thu, 04 Sep 2025 01:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973446; x=1757578246;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HoP5rZhN/wcN0s5V5G96zFIhY9AxyhN0FPTyV5jomNA=;
        b=Y00fhzU9Ydfs0E8C7K8rLwVzbvILuORDY8y30NYJafWCxPIuaEW0mq3Vn1mSJdJrnQ
         7wa9pVync8gKyF0SptOAZp4vKf23IU6XMl4DtXS+fpCsdOVo4/M+xR1oR/Mp1AsZ5cOy
         aiugj5z4ICNLPHYlnPcl8lO7Q2frh1s5cOZ26VDWeUHPFMaDsy8WG0TWhfNZeEkr2wvh
         tjatb+91takph1UXhxFMWU9QkX+pRxfngoknHSK8x27aUzOGBvK0mfP3Yz8c6DI8qFgq
         3onSzRVKliew7rFcwJnaBkc4yQ+Qw7hmoOQYFhU7/qeaNyiTHGIFZ6C3evjR3ONDhmJ8
         dS2w==
X-Forwarded-Encrypted: i=1; AJvYcCXauks20qAfRgRadiK6QinqMIwWohc0Cxvdkj9wnLaYher4X1TpNCgapTO/QuKJ7xmgftGUUXWTg77gjt4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1r/LdDLUrki84xjLpljJHg17CMePbyH9hjZZYhJ93Grziak2y
	1L5t00Is2q0hq0K0oLSvHXmxwHtDvc76FSJeHVX+s6ujyBgQOfhcn3iJn7dVLahr
X-Gm-Gg: ASbGncskNaqkd7Bif/w5n0SUuG+LI+of/szZF5UwDXb8FZWCHGmL0trS2dQLpB55NTO
	OiD2q4FRxM6+BuTCxH7/viBcOOFo8h9qc+9JYjoXvA1mc2mwsZuqV5sMuAqIicpApeoBa4F29+G
	tJMfIVq9ZgGgqvsdPI7KJ9kH1Oz/gKXtACUdVisb5X3t1+2jsIHFtKD34HvZoprH1E8qwgv2zaL
	4D04R2ETIqoKcwKYpA2tiZrmmVUpIMX9v+pw8S5ryzNmLiqlu2ysUiPGQU99mhoBSYr1m9R6NJE
	QqgSrgveqtz+X5EEZQ9yHvrzut0LMDGOw4rM/lfCFappJ5dqnjeINx76Mf2gWNLn023Jw/QFRNK
	QB/IxMFUKSCO9Mi/uw59K+12MhP8i3iym3bRn/pzM3OOPjW2Z6mGCQ3mTdDM5c9Y1WJE29VE=
X-Google-Smtp-Source: AGHT+IE8bz3pQyC7Ta82XBrfbrleOuTEj9QuF0xfx40Gxej43eFchhQ/xU9vLXwrRFFAv2V4Imh5iQ==
X-Received: by 2002:a05:6122:458b:b0:544:8830:8e15 with SMTP id 71dfb90a1353d-544a02beb7fmr5635765e0c.12.1756973445931;
        Thu, 04 Sep 2025 01:10:45 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-54493cf3f24sm7557601e0c.26.2025.09.04.01.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 01:10:45 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-52dec008261so234500137.0;
        Thu, 04 Sep 2025 01:10:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXTvFEHehI68wymZ38+vW+lYeu0RFaVxqtlhyEKAb0XAdmOCy514I/JKqt66k2GVoY+nQBp5Kh8cRc2Ui0=@vger.kernel.org
X-Received: by 2002:a05:6102:4613:b0:530:f657:c5d with SMTP id
 ada2fe7eead31-530f666561bmr2551182137.20.1756973445172; Thu, 04 Sep 2025
 01:10:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901201815.594177-1-ebiggers@kernel.org> <20250901201815.594177-2-ebiggers@kernel.org>
In-Reply-To: <20250901201815.594177-2-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 4 Sep 2025 10:10:33 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWrJmj9jHJp5CEtzBJk6jiN81ZwmTAogc07U_P9KgyEjA@mail.gmail.com>
X-Gm-Features: Ac12FXxrq9L6kDoaKUhsApHE-2MwPE4zmKHFkt6Jn14vX0EwMHLrIbnzAnxY_AA
Message-ID: <CAMuHMdWrJmj9jHJp5CEtzBJk6jiN81ZwmTAogc07U_P9KgyEjA@mail.gmail.com>
Subject: Re: [PATCH 1/6] crypto: curve25519 - Remove kpp support
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, Zhiqi Song <songzhiqi1@huawei.com>, 
	Longfang Liu <liulongfang@huawei.com>, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Sept 2025 at 22:29, Eric Biggers <ebiggers@kernel.org> wrote:
> Currently, Curve25519 has both a library API and a crypto_kpp API.
> However, the crypto_kpp API to Curve25519 has no users outside
> crypto/testmgr.c.  I.e., no non-test code ever passes "curve25519" to
> crypto_alloc_kpp().  And the crypto/testmgr.c test coverage for
> Curve25519 isn't particularly useful either, since it just runs the same
> list of test vectors that curve25519-selftest uses.
>
> Therefore, all the crypto_kpp support for Curve25519 is unnecessary.
>
> Remove it.  We'll instead focus on the Curve25519 library API, which is
> the API that is actually being used.  Curve25519 remains fully supported
> for in-kernel users via the library API (crypto/curve25519.h).
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

>  arch/m68k/configs/amiga_defconfig             |    1 -
>  arch/m68k/configs/apollo_defconfig            |    1 -
>  arch/m68k/configs/atari_defconfig             |    1 -
>  arch/m68k/configs/bvme6000_defconfig          |    1 -
>  arch/m68k/configs/hp300_defconfig             |    1 -
>  arch/m68k/configs/mac_defconfig               |    1 -
>  arch/m68k/configs/multi_defconfig             |    1 -
>  arch/m68k/configs/mvme147_defconfig           |    1 -
>  arch/m68k/configs/mvme16x_defconfig           |    1 -
>  arch/m68k/configs/q40_defconfig               |    1 -
>  arch/m68k/configs/sun3_defconfig              |    1 -
>  arch/m68k/configs/sun3x_defconfig             |    1 -

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
(although this would be handled during the regular defconfig refresh anyway)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
