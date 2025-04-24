Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A871F4627;
	Thu, 24 Apr 2025 07:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745480638; cv=none; b=auyxU3ueuGOUQdaMWwzCUQ5yZi2hSIm6tKIPSWSJeVrRRw9pbxHB9V8ZCSsxfwHzh+mdMFkmtSDjoxXvuf7BHy/RXgdbexjqpEjztNfvvxRmPhnQMwFAlhjtEv8II53zNMfRg6JEe5txyXcXq1RHaaF6AJOACNeNp7lTGDrsFTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745480638; c=relaxed/simple;
	bh=lPSKNqRRxkCEgQYghprMqn+qe5BbcKNl9je/1NCFp/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DpHCDpWD3N6H84ODJZY4R/q/dMUQZenx6wXsouK19VIcDhiw0zeB6rRHEto7eiaSgKHfDyhHbFff8qVE7QXuRTnpGZ1cWvu7/dWs5pB0dC1uuVazasuZ1yEnsw7Rr0UBlCHpdjIbNkaTv+4QZN8F/Lm/pqOFPaJi9iNDlD51NoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-86d6fd581f4so1751461241.1;
        Thu, 24 Apr 2025 00:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745480634; x=1746085434;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z3+rtGo+Fv0zaSKlqOLes8NInWs+DczSgML1WRPljFE=;
        b=OO/LZG0lbqd3QsnkZTuFQkPPg4U4McZyB9cOy+XD8dFASsiJHPxC95LIPyj1ZRkIxG
         /W0edw2xvnB2Dhf7+3hSeK464cCwJ45EOkQ+P4rK0KAvVYuQh+GP0dLvG1TNo4P1CEsO
         58YFi5BZX8oI1Qwe8vFJLadB8Q5h0R1k3kgxhKIMw9lnjQ35eDcvZHzJinjfNkzd9W4p
         xOeDkEgW9I0fOauqbPq/cFb5V4ABDDo8OHzkavAGxh/DQHsxNbzb+4ugPNxoGYx3SmWo
         efmsS6MXFXIseBSPDWBKTXjv1PUeU4YU7bDRd2lp+tUdx8Tyf8FMgW83sAzGvQsj7SZA
         4esw==
X-Forwarded-Encrypted: i=1; AJvYcCWwGaQfiySDFRfsrx7THUjasml8oJ+uTVbe65Q7zfG0xpAkNgnQ8ROKh3CQHVo93ak6H1JHXwzyFj7sp8A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpfdfzFJR5OS+a03svXdlngR1HvgWgGzlNUflLGZXpu4Z/9FHZ
	O1pOrcDtOz1RuGMWWNRxoqBALLquq7jueyaEcgNNh1RBmydHcSJX67ljCmNw
X-Gm-Gg: ASbGncuY0xykt1kdJwDdjWEDolo3FAarTqHMe6UkWRf813LxnT0QB2xVnWoKkqz3DE+
	DsFFRFwEgsxK0b9w+FxU+mDuqLHIARa7vAUa2XejFmMinYXI5nYPJOGWcYABc8woD3/3e1yW/gA
	TjkGfGJtVBn87XsQWNBU8Emw2uyNS2nNhtxaIsW7kfjiLQCnFpKhX0LkQEdG42BqkP81SctSCa9
	qd3asVRF4CPTzIlffrgg1WcMhs5mLarl7ItczKdtlEPU+qZMnKXOTUqExsRyY/7365bCQAUgASM
	BF54RrWlUeldobjZGNj2dDjC9AxjEPla+9lGdzl9BRd3EJNp+ehfsv05LXW2s3JRDjlshtvOnIO
	TkfC0Opg=
X-Google-Smtp-Source: AGHT+IHsRrebLdaJKrq9rKcw1SZIgKFX7g9UTH8pXVIH2Nr6JIzkk5jbMADj+zKru9UE3aFIOHgoXA==
X-Received: by 2002:a05:6102:1495:b0:4af:ed5a:b68d with SMTP id ada2fe7eead31-4d3c7cb4ce7mr603382137.6.1745480634221;
        Thu, 24 Apr 2025 00:43:54 -0700 (PDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com. [209.85.221.174])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-4d3d54783a3sm143672137.15.2025.04.24.00.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 00:43:54 -0700 (PDT)
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5240a432462so726983e0c.1;
        Thu, 24 Apr 2025 00:43:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW7FlOc9BVoY4UsYpKaD7jmcsmVX40F1XtQ/mdZZfVr5Sees49YxxE1nDVI1H+2qsXafWMaYD8FaYfYtp4=@vger.kernel.org
X-Received: by 2002:ac5:c5ae:0:b0:523:eb47:2884 with SMTP id
 71dfb90a1353d-52a79eb08dfmr450089e0c.6.1745480633791; Thu, 24 Apr 2025
 00:43:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422152151.3691-1-ebiggers@kernel.org> <20250422152151.3691-2-ebiggers@kernel.org>
 <CAMuHMdX5XKmeVABxeDv4shrUy2yt6WrMV2hxVPZ5OUe0uWUY6w@mail.gmail.com> <20250423232008.GA2305@sol.localdomain>
In-Reply-To: <20250423232008.GA2305@sol.localdomain>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 24 Apr 2025 09:43:42 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWE+tAOyPd5Roj8BTuAfyUmwF-h1zcDdrOKmEegsHW5+g@mail.gmail.com>
X-Gm-Features: ATxdqUEKCbo6sdy2tjuNUmPPMtqxIzNididLVkHYii9BA-RfFFTRJ5bH7bSDtAk
Message-ID: <CAMuHMdWE+tAOyPd5Roj8BTuAfyUmwF-h1zcDdrOKmEegsHW5+g@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] crypto: tcrypt - remove CRYPTO_TEST from defconfigs
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Thu, 24 Apr 2025 at 01:20, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, Apr 23, 2025 at 08:49:24AM +0200, Geert Uytterhoeven wrote:
> > (replaying my response to v1, which I wrote before I noticed there was a v2)
> >
> > On Tue, 22 Apr 2025 at 17:23, Eric Biggers <ebiggers@kernel.org> wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > CONFIG_CRYPTO_TEST enables a benchmarking module that is only really
> > > useful for developers working on the crypto subsystem.  It is in a bunch
> > > of defconfigs.  But as with most of the other crypto options that tend
> > > to be randomly set in defconfigs, it is unlikely that much thought was
> > > put into these, especially when placed in "production" defconfigs.
> > > Clear it out of the defconfigs for now.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> >
> > Thanks for your patch!
> >
> > All of these are modular, so I don't think it's a big issue, even on
> > "production" defconfigs. It just means the test is available when
> > someone feels the urge to run it.
> > Hence I try to make all tests available as modules in m68k defconfigs.
>
> Okay, but again note that this option isn't the actual crypto tests.  It's a
> benchmark.  Patch #2 renames CONFIG_CRYPTO_TEST to CONFIG_CRYPTO_BENCHMARK

Benchmarks are a kind of performance tests...

> accordingly.  The actual crypto tests are not modular and are controlled by the
> inverted option CONFIG_CRYPTO_MANAGER_DISABLE_TESTS, changed to
> CONFIG_CRYPTO_SELFTESTS by patch #5.  CONFIG_CRYPTO_TEST did used to be the
> actual tests, but that changed in 2008, and no one ever fixed it.

I guess the KUnit janitors will convert it to a proper KUnit module,
one day...

> Due to the renaming I'd need to update the defconfigs anyway, and I figured just
> clearing out the option is the right choice in most cases.  Hence this patch.
> But if you do understand what this option does and think it should be kept in as
> CONFIG_CRYPTO_BENCHMARK=m, we can do that instead (for all defconfigs that had
> it, presumably?).

I would like to keep it as CONFIG_CRYPTO_BENCHMARK=m.  If the
maintainers of the other architectures disagree, you can keep this
patch as-is.  Then CONFIG_CRYPTO_BENCHMARK=m will be added to the
m68k defconfigs during the customary defconfig update.
(To be removed again after the conversion to KUnit, and the addition
 of "default KUNIT_ALL_TESTS" ;-)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
