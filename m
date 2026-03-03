Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18EC3815C1
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772524660; cv=none; b=eQOJjXDNa9PD9ZGczpW2xtPwPJcQV4soygQBELskV0P7Nlqz6Du7lJeGzX6ViaA/CPXswzIKRc+h5/JzabpXeBYdCvV52Cr2LZ2ofXcoZb/LDgyIMyxycT5Al81AiZRfZMJ2W34bsuOHNy2G+AXjrEop+v5YJW99iUvrNXgSlC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772524660; c=relaxed/simple;
	bh=BJMjSsg0pOTDkaZ8VEKp43NRK5eF19bLvzIw43wXngA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JnWZmZrU2Ca4GRafjyGzjmxokLuPAoPE3pWrD81+wkdhkS+G3v1FyJbX8ogzfgTjJVRpr+p5dmiB49ef5XhGKZ3vOH9a44tfrNcMb1SHliPEj7rQPqIPal4EeuLcZqOkSSGxVW+ujy4g8HfV5iNt94XfUmuWgd0EQ6JmsvWums4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5ff28393b18so2703037137.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 23:57:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772524658; x=1773129458;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7c6DQTzlmh3T5HbSDRKM0fAxmMFUY9NxRbC8vxrvC0=;
        b=alWJoSmG5kJEVBouot3BhIsELfngfO5sjafF+AaykKpstbC6djBRnB/lbJoI3MF+t6
         5Xl57HuqWSlJewXAE+gSPSXjmLD5/pk6eOrfV2iiEQq38UIWdqLDq15j1wllhaQsdFph
         T5Qi+jUbf8Whny7zEEDIr4jvhwyBbAvA5icxFRTuiwzWsl9YZm1H53P+YeufaVTABq/H
         wGoXKOm4BOdg+MTlYOAPyDaBWYqi7D7wQHUETgTR7OElD5+st2PKznZuvHI0VOvbyjLk
         Q3mYtTbJOYhBStvT5CqBpA/fNlmQGkOj08x82zQkrcPbmpX8/ST8mz50MxATseg25bT9
         Ovig==
X-Forwarded-Encrypted: i=1; AJvYcCWGAmmG7bJyMVwJrR+oSWK0+h76/gWQHkkjci/lquDjO4ZKbkY8wFAyoGvO4A+50vHosxzEFtrAbAl0t74=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDakZ6EJrJTQMD4i8vOvMbwrbFtkYqrAmXIe6jDb2jZSdqMCCY
	70oLWoYQcfg5xtaWhnay+VVAFwRWbItkLqoOxw4it4zHzHz05OVBHiRyU4lWv2bs
X-Gm-Gg: ATEYQzz8v4kExwammetScTzt6acMyKcXFOVdicXfxxWYx/O1zRKjQ5J5Vrng4bnlaUe
	mexk0lioMdkewqXNL5Bi/nBKkq/xewyslbjF3LvFgY9sQot2T9p0BXAyaaOemZZNpIDAgl6Ys2V
	2jd5SBNrh55d0RgcrY31jlLJtHFqW/AWZM4fKDcteblO3ePq3Dvpet70q5/vKFOQL5e4TbZnM8r
	somk66Ef1LMVLQPOlp18smYCIhRn8Wrfzhm7SEAumZvpNgyJeuJfgSS0C/tT5AuvHwo7jcftRqh
	Iza4/n64l5/S1rJ0p1QOT6zzyhkR8VWhfH4JIZx2BHV7nWI/AhQPMajKIoq9E9kXFr4PhOQVkhi
	whTwhAoREjkbtN/b2dGUtr2NwkYv/QHjo2TPOnBW6+5hPfvD6PJE1eLu8L2OCbNXX2OIg2IHp1n
	ZTPHqqZHXKcncBLIehL8YHE4Y9d9PktTtYslMREpg+zoMLqJ8HFaz54ehFKc7i
X-Received: by 2002:a05:6102:3048:b0:5fd:e7da:8e83 with SMTP id ada2fe7eead31-5ff8faaf1b0mr535569137.15.1772524657701;
        Mon, 02 Mar 2026 23:57:37 -0800 (PST)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-5ff1e7afde2sm15870703137.1.2026.03.02.23.57.37
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 23:57:37 -0800 (PST)
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-5fdf71f3327so4471708137.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 23:57:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXucRYqmUrLE6vplPP+BRH3esS/oR0QyG/msqXiiO6uuVF0e1A0/7Q2Vb/RWU9gAABw349G1WclLbtPdl8=@vger.kernel.org
X-Received: by 2002:a05:6102:f0e:b0:5fd:ed7c:b7fa with SMTP id
 ada2fe7eead31-5ff8fc283f5mr530822137.21.1772524657122; Mon, 02 Mar 2026
 23:57:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772116160.git.geert+renesas@glider.be> <20260226195440.GH2251@sol>
 <20260302234149.GB20209@quark>
In-Reply-To: <20260302234149.GB20209@quark>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 3 Mar 2026 08:57:26 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVgvPUaSDCYjrLm8jLaeVQQx52aM9XCxtzS21CNPUNR3g@mail.gmail.com>
X-Gm-Features: AaiRm52x8RYyD1-YIMwg8ANO07c59tzLteXSooWtQBdzWUwP_e2sEqdhvoigGWE
Message-ID: <CAMuHMdVgvPUaSDCYjrLm8jLaeVQQx52aM9XCxtzS21CNPUNR3g@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: Drop stale usages in various help texts
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Tue, 3 Mar 2026 at 00:42, Eric Biggers <ebiggers@kernel.org> wrote:
> On Thu, Feb 26, 2026 at 11:54:40AM -0800, Eric Biggers wrote:
> > On Thu, Feb 26, 2026 at 03:46:04PM +0100, Geert Uytterhoeven wrote:
> > > This patch series drops stale references to subsystems that are using
> > > various crypto algoritms.  It was triggered by "make oldconfig" in
> > > v7.0-rc1 showing new prompts about BLAKE2b, SHA-256, xxHash, and CRC32c
> > > algorithms.  When querying these symbols, the corresponding help texts
> > > incorrectly claim they are used by btrfs.
> > >
> > > Notw that even if correct, there is no need for such references, as all
> > > users should select the needed symbols anyway.
> > >
> > > Geert Uytterhoeven (5):
> > >   crypto: Drop stale CRYPTO_BLAKE2B usage
> > >   crypto: Drop stale CRYPTO_SHA256 usage
> > >   crypto: Drop stale CRYPTO_XXHASH usage
> > >   crypto: Drop stale CRYPTO_CRC32C usage
> > >   crypto: Drop stale CRYPTO_CRC32 usage
> > >
> > >  crypto/Kconfig | 9 ---------
> > >  1 file changed, 9 deletions(-)
> >
> > Thanks for cleaning this up!
> >
> > If there are no objections I'd like take these through libcrypto-fixes,
> > given that they are related to the library conversions.
>
> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes
>
> I adjusted the commit titles to make it clear that the changes are to
> the help text, not e.g. to selections of the symbols.
>
>     crypto: Clean up help text for CRYPTO_CRC32

Thank you!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
