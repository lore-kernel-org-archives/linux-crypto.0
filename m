Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092B5383C8C
	for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 07:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776756130; cv=none; b=K1QtZNCVGLfNtCurfU10qoXEqD+XzOa2xseln8aH7AJk2vX/kLfzzAAMui/NmoLgISdlot0dxy+V60aNkw8db7ZFVzEdVRWdFZkVAirFGYyXVsTI2VSCoaqGU2UgtKuDb5YINHM+Te7zJ8vtNZdQeL22vxtfPqO3SddszT2OeEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776756130; c=relaxed/simple;
	bh=/nrp573DwhJpj1/k7R4DV/aIU3yMZMc0v6Gf7OiUohE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZD8WxRIj0o6bzu2XEu83QrtDxiNXqCDbdYSPPDYyE9JRU2Bgyd4A602Q3FlxfaXh2+0PZODftJZHgv4N3sMGQj/15AgQ8vuDGAgD632jP3VjvbnupcwM1MJfvISV3SMkynewtknjf/APswbiVuCMe2wigB3PfLcSJTztnaRdR0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-6137374b106so2809647137.1
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 00:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776756128; x=1777360928;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vef7/o+WmPKazCENtZbv6mCM1KijxBJaO+QSdIgH84s=;
        b=F2Kswhm16leZMdodgyufefhwngdnHjiHpvtZzoy0Wxhp5u7ZbBSuBaTn2eZouNUWvr
         gnmD/I7aBEw9z8oUqBFpQ1HZEawqiEMdj4PKApMmIdn2nrBkoDNucej3a+vaTPEtFiMJ
         8vmrnxrDDG1nommL0sFW0zWbUWYuXWfAXGtwQLLFQXOBI2qd4RbDCgPkt4eXJ4/b9smg
         c5XFvQiVDTOZYxNAbqD9PFjQf9YX0aK2knWueqlrjHX5gdrXL9nGgu44ghA7PvAc+6A3
         mufNQXbA426ac1g6K3NUIV91BC8b4bdfsq7/iOiR2N3Ah86okMgJYiD68iJuENUfAHej
         y8vg==
X-Gm-Message-State: AOJu0YzgnhgJsV1dK3nIrb14YROZ2xIcpiV8UCTHpq8rfOcp+l0f4YgA
	lc9Xlm9aomtgfdVdAdxKKGWgu79vp83Z62s95myaZtcPd6LQPEbOc/akHxHRemtwBsc=
X-Gm-Gg: AeBDieuAFpweEOV4v9wVvOmkU+jAGqdUa7fFPGX4+AXM0q83r2TzDTnb0ACa/t1bFBu
	ZoIaJpA0FjckMpUyAmaEpP/kcbEfGokaKdAKzexBxFGdzY7p7hevdzFC94oXiwFkPypQrbNMHRQ
	0vCf3TlQf+j2AVZVh7JrZEwgnbnxarfRBlM9v6DumCR6hUM8+fZ7K6s0Ohcjgg52w4OuAStVtMF
	Dou5M4r32+bpG8wJFl9PjTPNV0KN1t8gV6aRwG7jF1eHu4Ijtp8RZ+jgHS9d+0D7fHTHCLWC1+p
	hyte8OlYFsEjbE+erVwf4mMhTn4WRp7MQpiSfP3euBLm25OBzkEmqm1Yx9t63Di2XjGD1dSMTxW
	gEpiS0y17n2ybYmtuylT7aIUoAVCrIR1swlDiKV4D4KOOHIZKSVHaJSRmCRvZ0zjgru9kcmW7bO
	7+0jpiXu8RCVxb92Q+kJntzmzoPFyloP1JYbvswUKRpQBIn5UYS6rw9vVbhuZzFSxUMBG8Flk=
X-Received: by 2002:a05:6102:f8b:b0:607:b901:5d74 with SMTP id ada2fe7eead31-616f4d7d122mr8483188137.9.1776756127881;
        Tue, 21 Apr 2026 00:22:07 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-61745c9e53esm6149941137.5.2026.04.21.00.22.07
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 00:22:07 -0700 (PDT)
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-60579b9c0ccso3125761137.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2026 00:22:07 -0700 (PDT)
X-Received: by 2002:a05:6102:dcd:b0:612:b3af:39f1 with SMTP id
 ada2fe7eead31-616f68d1bafmr8104656137.18.1776756127179; Tue, 21 Apr 2026
 00:22:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260420063422.324906-1-ebiggers@kernel.org> <20260420063422.324906-14-ebiggers@kernel.org>
In-Reply-To: <20260420063422.324906-14-ebiggers@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 21 Apr 2026 09:21:56 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW5AMOAKkEwG4NgtickBkDj6XjB7jjc1P18Te0tDK-a0w@mail.gmail.com>
X-Gm-Features: AQROBzDFdwCHGPM4pzOjJj1bqtvcbOHmC7O1Nx1956DT_BRipwndIqjI6Hh26Os
Message-ID: <CAMuHMdW5AMOAKkEwG4NgtickBkDj6XjB7jjc1P18Te0tDK-a0w@mail.gmail.com>
Subject: Re: [PATCH 13/38] crypto: drbg - Remove support for HASH_DRBG
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, Stephan Mueller <smueller@chronox.de>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Apr 2026 at 19:29, Eric Biggers <ebiggers@kernel.org> wrote:
> Remove the support for HASH_DRBG.  It's likely unused code, seeing as
> HMAC_DRBG is always enabled and prioritized over it unless
> NETLINK_CRYPTO is used to change the algorithm priorities.
>
> There's also no compelling reason to support more than one of
> [HMAC_DRBG, HASH_DRBG, CTR_DRBG].  By definition, callers cannot tell
> any difference in their outputs.  And all are FIPS-certifiable, which is
> the only point of the kernel's NIST DRBGs anyway.
>
> Switching to HASH_DRBG doesn't seem all that compelling, either.  For
> one, it's more complex than HMAC_DRBG.
>
> Thus, let's just drop HASH_DRBG support and focus on HMAC_DRBG.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

>  arch/m68k/configs/amiga_defconfig          |   1 -
>  arch/m68k/configs/apollo_defconfig         |   1 -
>  arch/m68k/configs/atari_defconfig          |   1 -
>  arch/m68k/configs/bvme6000_defconfig       |   1 -
>  arch/m68k/configs/hp300_defconfig          |   1 -
>  arch/m68k/configs/mac_defconfig            |   1 -
>  arch/m68k/configs/multi_defconfig          |   1 -
>  arch/m68k/configs/mvme147_defconfig        |   1 -
>  arch/m68k/configs/mvme16x_defconfig        |   1 -
>  arch/m68k/configs/q40_defconfig            |   1 -
>  arch/m68k/configs/sun3_defconfig           |   1 -
>  arch/m68k/configs/sun3x_defconfig          |   1 -

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
