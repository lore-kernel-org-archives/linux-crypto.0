Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E842C43461
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 10:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C6621D7B
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 10:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600165600;
	bh=SH8Dp+QzQCSHxgh8TqHJRZNVk1Eg9GOmjGHakRH8ces=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=R/RJuDC+prFYtcIFx/JsNQ6hnfNUfovB3YAXkRqDPDtE8rzHPc1jlQiQya70h8sNQ
	 2rTWIDNPGByB2M2Fw5TbLkQUJ/y1q72SlX5ZIQ6zLz8PkFua/bh8vJHZAW9vQFV86K
	 3C7fAQSuhpqumAzbKe5LMeY2B8gVAjgKovsQ5+V8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgIOK0j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 06:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgIOK0h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 06:26:37 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F1621D7F;
        Tue, 15 Sep 2020 10:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600165596;
        bh=SH8Dp+QzQCSHxgh8TqHJRZNVk1Eg9GOmjGHakRH8ces=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OFeYcIQs7EGv7ICNQRWVRDJjrifVDO8N32/Fi7OWiUzCGK5zHYW7IYxrPLoxco2QW
         fC39wZuVgGByy0mGQekhjB1UCQRbSITsK4q0uJBXGZUVqni7GtEY+1ci4rZZ9xYhv7
         zvTmKQjoOcYplaYSFMxFrwzcM49Nhq3FDmcXtRRA=
Received: by mail-ot1-f42.google.com with SMTP id g10so2705668otq.9;
        Tue, 15 Sep 2020 03:26:36 -0700 (PDT)
X-Gm-Message-State: AOAM532VVNqEDt4KhuSPNok0vpsKEJjRD72D8beE2IDzl5kMAAzIBVk4
        /sg7fyT0TTuNa6nc2QfzXHIKexUoVXjiPQt+ICE=
X-Google-Smtp-Source: ABdhPJyrlF4uKoitENlyz1TmjztqK3EItAtSzPMu7QRe3q1Fy0bUJNeHjAite9Lli1Ck0TUnM2ymjA4GQ90bQk2xlyU=
X-Received: by 2002:a9d:6193:: with SMTP id g19mr12010747otk.108.1600165595917;
 Tue, 15 Sep 2020 03:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com> <20200821034651.GA25442@gondor.apana.org.au>
 <c360d691-8253-bd99-af92-83d9f8e86a2d@nxp.com> <20200908221019.GA23497@gondor.apana.org.au>
 <67159207-1082-48be-d085-971a84b525e0@nxp.com> <CAMj1kXGg7bSh57kwE57mKRocNRPZCeXifwjF53-3Jb6LYsfZTg@mail.gmail.com>
 <38f9904b-5bf7-ea99-ed8a-27cb49f405bd@nxp.com> <CAMj1kXH0jOQms9y1MywORywoKjxQ2p8ttv+Xf9KTOkfORX5XWw@mail.gmail.com>
 <4393bf96-30fd-0d1c-73fe-f5ef7c967f76@nxp.com>
In-Reply-To: <4393bf96-30fd-0d1c-73fe-f5ef7c967f76@nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 15 Sep 2020 13:26:25 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFeZP7_TQ73yLq0dfb=3wMS0VxqbKKUCGny0xHW1xL+5g@mail.gmail.com>
Message-ID: <CAMj1kXFeZP7_TQ73yLq0dfb=3wMS0VxqbKKUCGny0xHW1xL+5g@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/9] crypto: caam/jr - add fallback for XTS with
 more than 8B IV
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 15 Sep 2020 at 13:02, Horia Geant=C4=83 <horia.geanta@nxp.com> wrot=
e:
>
> On 9/14/2020 9:20 PM, Ard Biesheuvel wrote:
> > On Mon, 14 Sep 2020 at 20:12, Horia Geant=C4=83 <horia.geanta@nxp.com> =
wrote:
> >>
> >> On 9/14/2020 7:28 PM, Ard Biesheuvel wrote:
> >>> On Mon, 14 Sep 2020 at 19:24, Horia Geant=C4=83 <horia.geanta@nxp.com=
> wrote:
> >>>>
> >>>> On 9/9/2020 1:10 AM, Herbert Xu wrote:
> >>>>> On Tue, Sep 08, 2020 at 01:35:04PM +0300, Horia Geant=C4=83 wrote:
> >>>>>>
> >>>>>>> Just go with the get_unaligned unconditionally.
> >>>>>>
> >>>>>> Won't this lead to sub-optimal code for ARMv7
> >>>>>> in case the IV is aligned?
> >>>>>
> >>>>> If this should be optimised in ARMv7 then that should be done
> >>>>> in get_unaligned itself and not open-coded.
> >>>>>
> >>>> I am not sure what's wrong with avoiding using the unaligned accesso=
rs
> >>>> in case data is aligned.
> >>>>
> >>>> Documentation/core-api/unaligned-memory-access.rst clearly states:
> >>>> These macros work for memory accesses of any length (not just 32 bit=
s as
> >>>> in the examples above). Be aware that when compared to standard acce=
ss of
> >>>> aligned memory, using these macros to access unaligned memory can be=
 costly in
> >>>> terms of performance.
> >>>>
> >>>> So IMO it makes sense to use get_unaligned() only when needed.
> >>>> There are several cases of users doing this, e.g. siphash.
> >>>>
> >>>
> >>> For ARMv7 code, using the unaligned accessors unconditionally is fine=
,
> >>> and it will not affect performance.
> >>>
> >>> In general, when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is defined,
> >>> you can use the unaligned accessors. If it is not, it helps to have
> >>> different code paths.
> >>>
> >> arch/arm/include/asm/unaligned.h doesn't make use of
> >> linux/unaligned/access_ok.h, even if CONFIG_HAVE_EFFICIENT_UNALIGNED_A=
CCESS
> >> is set.
> >>
> >> I understand the comment in the file, however using get_unaligned()
> >> unconditionally takes away the opportunity to generate optimized code
> >> (using ldrd/ldm) when data is aligned.
> >>
> >
> > But the minimal optimization that is possible here (one ldrd/ldm
> > instruction vs two ldr instructions) is defeated by the fact that you
> > are using a conditional branch to select between the two. And this is
> > not even a hot path to begin with,
> >
> This is actually on the hot path (encrypt/decrypt callbacks),
> but you're probably right that the conditional branching is going to offs=
et
> the optimized code.
>

This is called once per XTS request, right? And you are saying the
extra cycle makes a difference?

> To avoid branching, code could be rewritten as:
>
> #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>         size =3D *(u64 *)(req->iv + (ivsize / 2));
> #else
>         size =3D get_unaligned((u64 *)(req->iv + (ivsize / 2)));
> #endif
>
> however in this case ARMv7 would suffer since
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy and
> ldrd/ldm for accesses not word-aligned are inefficient - lead to traps.
>

CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS means 'just use the unaligned
accessors as they are basically free'. Casting a potentially
misaligned u8* to a u64* is not permitted by the C standard.

> Would it be ok to use:
> #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && !defined(CONFIG_AR=
M)
> to workaround the ARMv7 inconsistency?
>

No, please just use the get_unaligned() accessor.
