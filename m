Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA931E9B3D
	for <linux-crypto@vger.kernel.org>; Sun, 21 Sep 2025 18:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758479179; cv=none; b=jAriiHOO92FynR77mQICDjbPjZ3CyeTDS088XDNTLnjQBJPEPGysf4BOWMwAKhHn4K8TOTx8yfs3Zyh1MSDoq6MapDYaQfuCGyYp5xUOolDWGikcSoUMds74mgOjaHlqgTgY0yI64tdl/BvweF8UatcPZehm8PcgPrB/i+ktzWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758479179; c=relaxed/simple;
	bh=F4zmkAHPjhKHpB7D8+DDrYGAR3U5WXK9thJ0sK89yEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H5CGFpBMpL8dMov9e7wL60xQ48z/LTzY+oZVtwGF2gWfXG9GM6BuKzliQm0ep0icpiGczdBpHOe6Z2to4+L3NAL7XYGzRnkgyWhphZ/fwMqy2/V0Pr1ggZ4DYun0gtZdoTsJyV2Msxn1e5UkInW8ExTqvXNJ7/Yuz/G7iqSx/yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b5ujcx3b; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b5ujcx3b"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b04ba58a84fso625875166b.2
        for <linux-crypto@vger.kernel.org>; Sun, 21 Sep 2025 11:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758479176; x=1759083976; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4zmkAHPjhKHpB7D8+DDrYGAR3U5WXK9thJ0sK89yEc=;
        b=b5ujcx3bRpv6ptjgbdoFrXy6150FCHUzWqfq5IhcJEQteVR/6CKMEo6Yavh1vLPQ7l
         0l52QmsOiEsXdGnuLFxf3+9I15FoDYZb99yTpMSXDvY0BTCcGrSL/7xxiqvZMG2ZsG1h
         wwTVbrxHD8Dt1U1tBFxsbMrJPNXiDdbtwINoHeUzbqCLB/Zan1uz/bWcVps1m7ECophb
         COudEbdoPNBxFP2ohdMx4vRqqXRfhzuKRaWNr9uX2ee+FwqwRRnkTHbwMjfKdkcPKvyl
         cJ8b/+9xjhc1qbzsHSJdXx6W1xTOyKw+I2IfyTfLdWU0icXOIk7CxDj6OZqWjebkQVOo
         0z8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758479176; x=1759083976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F4zmkAHPjhKHpB7D8+DDrYGAR3U5WXK9thJ0sK89yEc=;
        b=h0KCzAaXjYZAZWC4ylbEmD6A8q6MYb6RhMFdEh0IyeIVZozMA5LHsr7l7zYY7HB8jw
         y+9EwIxotTKbTIFCkO81sIJh3Cah9yrOVe1obJTbRxeyhEa4s0BegRpJ7bxXszXfN46w
         CwXyaOG5/WVsEs0Jv8p05mrYDK4g3E6kNsTaasTNSg1wG9Z1UZobFaYbQb/oxzHODv7o
         G56c8SM1k9vfCSY3htwtKQfHe7ZySf6MOSU0etfHqOuEJEtkXyz8gbFHzQkHDfu+RLF9
         y8Joj9FL4PeD6PSP2nvLPSnf0gIGLF1fdVHtNH6kkDEBFqFQYYreO560Y7nKsJOL0l8f
         htrw==
X-Forwarded-Encrypted: i=1; AJvYcCUGgJM8z2Fm96c53eH0VdDkHqcAa/+li1M6JKtPyAoJUC9O8sbhtpoRB1m13fKpr1qPI8/+fX4FHCBSJ34=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQnLHw8s3CC9YINM5YMX5+mpc/1kZBeiefd6iNKbE2Xw/h9OsF
	Z1qjQaGBvZSHQ1pUH7yFYn2rYKBQujDcOjTYo7VtKzhZvJuKvUh6CV1NX02jf8dOJCVx8SU1xC9
	of1XEZPLUCjSdDg6I+yol1PPPXDb0YBA=
X-Gm-Gg: ASbGncsSYqTDNOU/RS7yxtw7/eZ3/+b/scWzSfczH9Civl0z9FKcgq8AiLeC15XDnDi
	hH/gdDubD/mA5if6+eow7GQSSREYG2ARkytAIxDEfiuPL86XJd8glk4fEIUM2+ic8thDRoSlH6w
	pze07GQdV/mgxvFQhWOi9xIf17zJtQmKJsSM4bsCUzVkfYoPP1bvIjjCLe1HlxtPMGG1kDQQVVW
	o67MvA=
X-Google-Smtp-Source: AGHT+IHh9e7xoMHQuFzPAPTA2CQWR9c/d79fb3/OPULapQmLwjGLq95LNatOsDtZ/08h/6VJ4lMyXWHqYMA+9gMoEKQ=
X-Received: by 2002:a17:906:c155:b0:b04:6fc2:ebb9 with SMTP id
 a640c23a62f3a-b24f442d968mr1064293266b.45.1758479176060; Sun, 21 Sep 2025
 11:26:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
 <20250919145750.3448393-9-ethan.w.s.graham@gmail.com> <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
 <CAG_fn=XTcPrsgxg+MpFqnj9t2OoYa=SF1ts8odHFaMqD+YpZ_w@mail.gmail.com> <aM6ibO75IidHOO3m@wunner.de>
In-Reply-To: <aM6ibO75IidHOO3m@wunner.de>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sun, 21 Sep 2025 21:25:39 +0300
X-Gm-Features: AS18NWCeZeZJHwiXQSoRlyelBxs_br4n2Gp5Ptss7c3DoCLdwMlYv5AhZy2eILA
Message-ID: <CAHp75VeyCujEX3dFBVF=ioHOqPbWQRtuB7_zFGndAejYbMW05w@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Lukas Wunner <lukas@wunner.de>
Cc: Alexander Potapenko <glider@google.com>, Ethan Graham <ethan.w.s.graham@gmail.com>, 
	ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmoar@google.com, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 20, 2025 at 3:47=E2=80=AFPM Lukas Wunner <lukas@wunner.de> wrot=
e:
> On Sat, Sep 20, 2025 at 02:08:01PM +0200, Alexander Potapenko wrote:
> > On Sat, Sep 20, 2025 at 12:54 PM Andy Shevchenko <andy.shevchenko@gmail=
.com> wrote:
> > > On Fri, Sep 19, 2025 at 5:58 PM Ethan Graham <ethan.w.s.graham@gmail.=
com> wrote:

...

> > > > +/*
> > > > + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file=
 to ensure
> > > > + * that KFuzzTest targets are built.
> > > > + */
> > > > +#ifdef CONFIG_KFUZZTEST
> > > > +#include "tests/charlcd_kfuzz.c"
> > > > +#endif /* CONFIG_KFUZZTEST */
> > >
> > > No, NAK. We don't want to see these in each and every module. Please,
> > > make sure that nothing, except maybe Kconfig, is modified in this
> > > folder (yet, you may add a _separate_ test module, as you already hav=
e
> > > done in this patch).
> >
> > This is one of the cases in which we can't go without changing the
> > original code, because parse_xy() is a static function.
> > Including the test into the source is not the only option, we could as
> > well make the function visible unconditionally, or introduce a macro
> > similar to VISIBLE_IF_KUNIT.
> > Do you prefer any of those?
>
> Just add something like this to drivers/auxdisplay/Makefile:
>
> ifeq ($(CONFIG_KFUZZTEST),y)
> CFLAGS_charlcd.o :=3D -include $(src)/tests/charlcd_kfuzz.c
> endif
>
> Alternatively, if the file in tests/ always has the same name
> as the source file but with "_kfuzz.c" suffix, consider amending
> scripts/Makefile.build to always include the "_kfuzz.c" file
> if it exists and CONFIG_KFUZZTEST=3Dy, thus avoiding the need
> to amend all the individual Makefiles in the tree.

Thanks, Lukas, for the ideas. Yes, something like this would be acceptable.

--=20
With Best Regards,
Andy Shevchenko
