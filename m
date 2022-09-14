Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00140ECAAD3
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Sep 2022 08:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiINITC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Sep 2022 04:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiINITB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Sep 2022 04:19:01 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEFA5757B
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2022 01:19:00 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 198so16490243ybc.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2022 01:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=HuIXq0gxsLhtrekbIwvVhrdsOJWyOZiMwcr+S3al2lw=;
        b=cAprc2ENkwAzsA1ScDy+/sr6d/3f9p0nPP8Mc6N0iDX/hEs+T1BUfS8BVAHrFx8MBJ
         HgdkV+kfd0A7J7ZkjA4pAMF35RkIlAimda9FEzqjxzOjqbAqi6UcEzmg80AYkWzJLeXI
         zCakpoSPHtw0VWKrXcAwGiT2kHvjFGxiv1LWCO1x3nMcoFAgS40VLpeBMd2E2Sq2drcS
         dOMWDCuymV7EHVprME2crDl+J9zBU+jt+l8DKpJSeYYBkVBy0Hjq4GnKe8WMKbvghvh6
         wixA88tuAYTRq3++zVPDafixpOW89tYSoKU9nEYwEn2VMSK/OfJ9UcfIWE7GZqM+8IAZ
         WeeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HuIXq0gxsLhtrekbIwvVhrdsOJWyOZiMwcr+S3al2lw=;
        b=IuidrwXf5d+lxlYhib9jha40AcvIHQ8nyv7MnuBB1ffU20oBSab17C+p87DAk8r5Km
         hPKGkqrNAChunax2uS5d7Pfyq6dNJtQuwxSAmgOKEF0E46g2Q9QdkQ/3PmhzH8AX3Vn1
         h6i1HWDf/N+6BQUeV/YMq5WMk0R2JwCdU5hARrbZ1l2//fY23UdobrKZejmTKbSY8e9T
         np6Y8rN8yu23fL/pSxQOJsvzVsmaDWyR7LtbCGtKWRSJxTWHdOvWocXeOC/3lOLIpkCZ
         xcV5HcB6MIa/i2X0VtP5ATO/xHuSvOcPWrSPqg3uYsf2pr491+5l8lFeD3vkEEwMtUUI
         36ow==
X-Gm-Message-State: ACrzQf0bzz+Wjob5FXbraaCn9Oe2zFTv+c+ZC8f6xwwclJaAiv3j0WW3
        iyk+dBytyFxOw4v4Lk/c6C/24uUH+RMQZ5KlKUA/2w==
X-Google-Smtp-Source: AMsMyM4gAetVuxJCy5rc8GccIvL8xPemtsGubVjAx9z1OYMfS0WxwpXd1nfRIx3By7x7exkAz6pnQPQ/bPRykgvkaz0=
X-Received: by 2002:a25:3f03:0:b0:6af:f33f:7711 with SMTP id
 m3-20020a253f03000000b006aff33f7711mr2350646yba.376.1663143538967; Wed, 14
 Sep 2022 01:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220909095811.2166073-1-glider@google.com> <20220913175210.50945edb0738bf95300dc500@linux-foundation.org>
In-Reply-To: <20220913175210.50945edb0738bf95300dc500@linux-foundation.org>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 14 Sep 2022 10:18:22 +0200
Message-ID: <CAG_fn=XsmcKNi1Sg-HgP9Hh98mf910o0Uo4fCpwijiS_3adgyQ@mail.gmail.com>
Subject: Re: [PATCH -next 1/2] x86: crypto: kmsan: revert !KMSAN dependencies
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Robert Elliott <elliott@hpe.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 14, 2022 at 2:52 AM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> On Fri,  9 Sep 2022 11:58:10 +0200 Alexander Potapenko <glider@google.com=
> wrote:
>
> > This patch reverts "crypto: Kconfig: fix up for "crypto: kmsan: disable
> > accelerated configs under KMSAN" used by Stephen Rothwell to cleanly
> > merge KMSAN patches into linux-next.
> >
> > Because now arch-specific crypto configs reside in a separate Kconfig
> > file, we can disable them all by adding a single !KMSAN before includin=
g
> > that file (done in the following patch).
> >
> > Among others, this patch reverts !KMSAN check for
> > CONFIG_CRYPTO_AEGIS128_SIMD, which is ARM-only and is hence unnecessary=
,
> > because KMSAN does not support ARM yet.
>
> As I understand it, these patches are against linux-next and only
> linux-next because they pertain to linux-next's resolution of conflicts
> between the MM tree and the crypto tree?

The thing is that this patch only makes sense with its counterpart
that adds a !KMSAN condition on "source arch/x86/crypto/Kconfig", and
the latter file is missing in the -mm tree.

> I'm not sure how to handle that, even if anyone wants to.  How about
> you send an update to
> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm's mm-unstable
> branch so the code which is there makes sense?  Then we'll ask Stephen
> to redo the crypto tree resolution?

Because the crypto tree is moving code crypto/Kconfig to
arch/x86/crypto/Kconfig, we'll still need to apply these two patches
to the result of the crypto tree merge.

I was going to send out the updated patch series anyway (there are
minor improvements to the core which let us drop "kmsan: unpoison @tlb
in arch_tlb_gather_mmu()", also there's a new test case).
I could drop "crypto: kmsan: disable accelerated configs under KMSAN"
from it, so that it would be possible to enable accelerated configs
under KMSAN at the cost of false positives (which are only visible if
one builds with KMSAN).
Then, once arch/x86/crypto/Kconfig hits -mm, I can send the remaining
patch that disables accelerated crypto under KMSAN:
https://lore.kernel.org/all/20220909095811.2166073-2-glider@google.com/

Or I could just send v7 patches against mm-unstable and ask Stephen to
apply both https://lore.kernel.org/all/20220909095811.2166073-2-glider@goog=
le.com/
and https://lore.kernel.org/all/20220909095811.2166073-2-glider@google.com/
at merge time.

Which option is better?


--
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
