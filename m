Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FEEC48BD5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 18:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D46262085A
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 18:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="skHlmuAc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbfFYShi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 14:37:38 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41379 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729912AbfFYShi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 14:37:38 -0400
Received: by mail-io1-f66.google.com with SMTP id w25so1124279ioc.8
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2019 11:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uzbXVhLuWBgDc1jic57o1bW8+6/W59REcwpOxrFqvA0=;
        b=skHlmuAcD1adX1m675KbDbT6NX6DuaZxN8knJ2/gVu7l2+3ETGYFnInAp70Tw0VZnv
         f1151GBimbrvjyerxHobRneh5rgnrj7QXYRgfs6Kl4enH/Q6L59HVHIA0pLpdCtWPGHu
         wL418ia+e7JCmncnWXYzaMn9o8imzYcBhpZZJb8RjYyRvSRJ5gddF92sJKK+bO0HqMIw
         IEUyN7+c/JkMONV1Gf9q2s6OfecxOucQ6Uzz8sXkBNATN3b/PNDisCV8Rf23zoIE8a+r
         4DUNGhEI7LFzRs+ob74gLajTdRFGo6OUdyXHheoDYlkqO0RRRdic2qjf0gC7yeCbQ4fQ
         EOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uzbXVhLuWBgDc1jic57o1bW8+6/W59REcwpOxrFqvA0=;
        b=bHpEl1i4b+nMjX8PSuihqo3Wy9ze0aqNznw2yq9gS8hp0X9rRgMhVdMlOj+9zvd0qF
         Ggn/3fP1T538SmDsBwk+PK6mclSKVdY/Zb0BzQ8khyz4nC9WxD1VaKmqBAXwNkxNMyzv
         hxbg08Uzhts5gmy2Kgj4QbptdBGlAN4S1tCb060nxUPdO/69RlU0WDPyytP9A5lLKer2
         lj2y+I6+NmJASDjA3snqIcAQRK0x3y36t3A7cXpF67jZELR7IVTNM5aAw6Zx5hoYweAV
         yeGXIKiI0fMLxuDX000KarrkmxbIJ+TeNcLU9/Lx03b/jDkwDqXVy1gY50NeGvk2qLsQ
         B9Qg==
X-Gm-Message-State: APjAAAXySej6e+MNXjitCg+UEj77/f9mOjeZsz4aC10U/pKe3VfBrNnC
        Jgq+JWlKA29saY/2/BJUZwEpHWdR8cRmbG1eBqo6pA==
X-Google-Smtp-Source: APXvYqy2Hv+4ElfvM9wdIfLV64nTzJCK+1TKIzjBbjU3Kaz0lGiiDzcRMhCbr7lttLi+ZRuN1Gm1yMztEWHXrJMZLL8=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr20969iob.49.1561487856930;
 Tue, 25 Jun 2019 11:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org> <20190625171234.GB81914@gmail.com>
In-Reply-To: <20190625171234.GB81914@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 25 Jun 2019 20:37:23 +0200
Message-ID: <CAKv+Gu8P4AUNbf636d=h=RDFV+CPEZCoPi9EZ+OtKEd5cBky5g@mail.gmail.com>
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 25 Jun 2019 at 19:12, Eric Biggers <ebiggers@kernel.org> wrote:
>
> [+Cc Milan]
>
> On Tue, Jun 25, 2019 at 04:52:54PM +0200, Ard Biesheuvel wrote:
> > MORUS was not selected as a winner in the CAESAR competition, which
> > is not surprising since it is considered to be cryptographically
> > broken. (Note that this is not an implementation defect, but a flaw
> > in the underlying algorithm). Since it is unlikely to be in use
> > currently, let's remove it before we're stuck with it.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/m68k/configs/amiga_defconfig     |    2 -
> >  arch/m68k/configs/apollo_defconfig    |    2 -
> >  arch/m68k/configs/atari_defconfig     |    2 -
> >  arch/m68k/configs/bvme6000_defconfig  |    2 -
> >  arch/m68k/configs/hp300_defconfig     |    2 -
> >  arch/m68k/configs/mac_defconfig       |    2 -
> >  arch/m68k/configs/multi_defconfig     |    2 -
> >  arch/m68k/configs/mvme147_defconfig   |    2 -
> >  arch/m68k/configs/mvme16x_defconfig   |    2 -
> >  arch/m68k/configs/q40_defconfig       |    2 -
> >  arch/m68k/configs/sun3_defconfig      |    2 -
> >  arch/m68k/configs/sun3x_defconfig     |    2 -
> >  arch/x86/crypto/Makefile              |   13 -
> >  arch/x86/crypto/morus1280-avx2-asm.S  |  622 ---------
> >  arch/x86/crypto/morus1280-avx2-glue.c |   66 -
> >  arch/x86/crypto/morus1280-sse2-asm.S  |  896 -------------
> >  arch/x86/crypto/morus1280-sse2-glue.c |   65 -
> >  arch/x86/crypto/morus1280_glue.c      |  209 ---
> >  arch/x86/crypto/morus640-sse2-asm.S   |  615 ---------
> >  arch/x86/crypto/morus640-sse2-glue.c  |   65 -
> >  arch/x86/crypto/morus640_glue.c       |  204 ---
> >  crypto/Kconfig                        |   56 -
> >  crypto/Makefile                       |    2 -
> >  crypto/morus1280.c                    |  542 --------
> >  crypto/morus640.c                     |  533 --------
> >  crypto/testmgr.c                      |   12 -
> >  crypto/testmgr.h                      | 1707 -------------------------
> >  include/crypto/morus1280_glue.h       |   97 --
> >  include/crypto/morus640_glue.h        |   97 --
> >  include/crypto/morus_common.h         |   18 -
> >  30 files changed, 5843 deletions(-)
> >  delete mode 100644 arch/x86/crypto/morus1280-avx2-asm.S
> >  delete mode 100644 arch/x86/crypto/morus1280-avx2-glue.c
> >  delete mode 100644 arch/x86/crypto/morus1280-sse2-asm.S
> >  delete mode 100644 arch/x86/crypto/morus1280-sse2-glue.c
> >  delete mode 100644 arch/x86/crypto/morus1280_glue.c
> >  delete mode 100644 arch/x86/crypto/morus640-sse2-asm.S
> >  delete mode 100644 arch/x86/crypto/morus640-sse2-glue.c
> >  delete mode 100644 arch/x86/crypto/morus640_glue.c
> >  delete mode 100644 crypto/morus1280.c
> >  delete mode 100644 crypto/morus640.c
> >  delete mode 100644 include/crypto/morus1280_glue.h
> >  delete mode 100644 include/crypto/morus640_glue.h
> >  delete mode 100644 include/crypto/morus_common.h
>
> Maybe include a link to the cryptanalysis paper
> https://eprint.iacr.org/2019/172.pdf in the commit message, so people seeing
> this commit can better understand the reasoning?
>

Sure.

> Otherwise this patch itself looks fine to me, though I'm a little concerned
> we'll break someone actually using MORUS.  An alternate approach would be to
> leave just the C implementation, and make it print a deprecation warning for a
> year or two before actually removing it.  But I'm not sure that's needed, and it
> might be counterproductive as it would allow more people to start using it.
>

Indeed. 'Breaking userspace' is permitted if nobody actually notices,
and given how broken MORUS is, anyone who truly cares about security
wouldn't have chosen it to begin with. And if it does turn out to be a
real issue, we can always put the C version back where it was.

> From a Google search I don't see any documentation floating around specifically
> telling people to use MORUS with cryptsetup, other than an email on the dm-crypt
> mailing list (https://www.spinics.net/lists/dm-crypt/msg07763.html) which
> mentioned it alongside other options.  So hopefully there are at most a couple
> odd adventurous users, who won't mind migrating their data to a new LUKS volume.
>
