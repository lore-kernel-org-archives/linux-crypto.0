Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A722FD1B2
	for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 12:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758370123; cv=none; b=i6sGPbjhfUvz4To8Nr3A5OD6m2aLKnG+A6EI5NzTZP5p9FzXSYkn6ZYQlLMLqW7V5/1yp8sEdmYFcriOKgWkslNsha642DES7mmDlFYJn1tyh6lyL0R3VIkcvrw2b4sjDDA+RbQyvK1S/TFPxiPxrC5m+bXMbcZKduC27NbbCQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758370123; c=relaxed/simple;
	bh=+75owp6BZWWn6qzgOUeJYK1AlGCtYCoTHjw8eiK6KJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DSYlSwliszxSTe8gK0SoRsTN164ACnV59W+3oJnasJGghdker0ewEDRw897PZgbcPvqcyktDa2wb/NMSxo7QKPgxgNYWKrnkrlX9K8jpYCKnJqLgGOE+5x5lrEh517NM0SjZJerYjsyo7WEkffbHJcOLvMyPWia2OS0DXj21sX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tVSGdpXR; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tVSGdpXR"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-796fe71deecso22341096d6.1
        for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 05:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758370120; x=1758974920; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rg0aAAaEFwb8WUGfzZYLj8KGkf4Q3J2CuRbPLZDHdFI=;
        b=tVSGdpXRZH8lfkU7KGdh4r039dOHQafqSRc2hBddNTss500mSXaNCsx8+nBbMIP5XY
         XPDjPvomVS4hCk5+1J8CCy9K0qEt7qJIKKG9NNSDSumrJRN6W+kHPfqqX1brMRV3p55W
         r0DqJ8Ql7nBhekb0dJBwbUCOE1cjyLLZ64ymMXDmrzuh6Ql7EDrjmNurIN++ZgK13nQ8
         5b+0TFXY+6ZzdAo82krbCJyaPLnTssUHoJhNNjlrSYQ4+1RgbHvpzbicU6Osk4ghhf/j
         tItJ3QnO85yEUfkbf3WHO8BmXMoIURaQucu53UKgWF+PUcwbc2LKb6mhIBcgchPKb8QD
         5gzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758370120; x=1758974920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rg0aAAaEFwb8WUGfzZYLj8KGkf4Q3J2CuRbPLZDHdFI=;
        b=kJOklt0ZrvelJMVh6kPj16TUlSv8cvWlW0oNMefQtvHDEQ5skN3owlQEW30zpTkPYH
         dDCP9J9XESyXSMzt0kTeua9jI+45FPkR3Jfr5CIewaKRJpAR7vO5qHaXuwVZ2Ovy0pVw
         aIVAEOsrc5t7zq3hC3tyN9EKpJLGXlCS4Rf7PhIZe0sNCncRmgPUWYtmNz/tmoBB/fFV
         qtJmDU9tyM93p2EKDgr3XGJ5baSyarhL4OUvEdme+bjxjU5W0PLzZSIeaZ7lx9pz5vFX
         H4i8ZQe8L67BySV733fqEAS9J1NRyUfud9ltAC0cnGBb1kxC8byQridwJGF4uIrVf7Se
         qJbg==
X-Forwarded-Encrypted: i=1; AJvYcCWWGHvR1uRVS0wvc7+NGCsZ987oaf1mlumTTWHet0G6RUA0L05GSe5qFRynWtPZqfMPBWMVmooWTL/FLtg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyliZF6AHEBWQfsfvAxexjIeQYto4DnSIMe2dw389npEy+gxv5W
	laanIP7wb/ZXr0UjiunF0qicMzkSASQ7UL7mr4RFam2ApnaRLybiD059kVyJy+xx9Aft/UUjoPr
	1PnZUDVFdgiJlR1ipSVvfYdXo0/mPSYVpZsGpWtOR
X-Gm-Gg: ASbGncstYWuUCqqNDuMFxYjRPyebNFNX0pE+YQj4ZkAAZgWOg/eIRbmJgxhO2iFfwNW
	8PV70whdHWemOzB5CBxBN/D11fS7RKr5eY5Djix0OAlv5BFwwV51KzilJM/f8QgVjM70KXrIjm3
	Ch7e+D1YwOfIvhypQXAKch5nu9UrdY4YeRJVrFcPlxZub+IU9oO1+u/zVnbpidtGfgDAV5ETVXv
	T2XTDQZxGBvxcgjgEyEc1Fdl2aijMEUlIjVfA==
X-Google-Smtp-Source: AGHT+IGrLhGnLin4JPn3IEJL16TDaAaIyPUzt4DPnDcGALtByT5b0deWvFSW43f3QYgleVc8ho2F2zEcC/AGvOdoPJI=
X-Received: by 2002:a05:6214:5712:b0:7b0:d5a0:c60d with SMTP id
 6a1803df08f44-7b0d5a0c6c5mr11507116d6.10.1758370120098; Sat, 20 Sep 2025
 05:08:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
 <20250919145750.3448393-9-ethan.w.s.graham@gmail.com> <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
In-Reply-To: <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Sat, 20 Sep 2025 14:08:01 +0200
X-Gm-Features: AS18NWBVqpbu6_S8igqrpC6d_4rlaGzIrca9Y3paJY9H7AfaiH53k8LL1oZq4JA
Message-ID: <CAG_fn=XTcPrsgxg+MpFqnj9t2OoYa=SF1ts8odHFaMqD+YpZ_w@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org, 
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com, 
	dhowells@redhat.com, dvyukov@google.com, elver@google.com, 
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz, 
	jannh@google.com, johannes@sipsolutions.net, kasan-dev@googlegroups.com, 
	kees@kernel.org, kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 20, 2025 at 12:54=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Fri, Sep 19, 2025 at 5:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gm=
ail.com> wrote:
> >
> > From: Ethan Graham <ethangraham@google.com>
> >
> > Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
> > file under /drivers/auxdisplay/tests.
> >
> > To validate the correctness and effectiveness of this KFuzzTest target,
> > a bug was injected into parse_xy() like so:
> >
> > drivers/auxdisplay/charlcd.c:179
> > - s =3D p;
> > + s =3D p + 1;
> >
> > Although a simple off-by-one bug, it requires a specific input sequence
> > in order to trigger it, thus demonstrating the power of pairing
> > KFuzzTest with a coverage-guided fuzzer like syzkaller.
>
> ...
>
> > --- a/drivers/auxdisplay/charlcd.c
> > +++ b/drivers/auxdisplay/charlcd.c
> > @@ -682,3 +682,11 @@ EXPORT_SYMBOL_GPL(charlcd_unregister);
> >
> >  MODULE_DESCRIPTION("Character LCD core support");
> >  MODULE_LICENSE("GPL");
> > +
> > +/*
> > + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to =
ensure
> > + * that KFuzzTest targets are built.
> > + */
> > +#ifdef CONFIG_KFUZZTEST
> > +#include "tests/charlcd_kfuzz.c"
> > +#endif /* CONFIG_KFUZZTEST */
>
> No, NAK. We don't want to see these in each and every module. Please,
> make sure that nothing, except maybe Kconfig, is modified in this
> folder (yet, you may add a _separate_ test module, as you already have
> done in this patch).

This is one of the cases in which we can't go without changing the
original code, because parse_xy() is a static function.
Including the test into the source is not the only option, we could as
well make the function visible unconditionally, or introduce a macro
similar to VISIBLE_IF_KUNIT.
Do you prefer any of those?
