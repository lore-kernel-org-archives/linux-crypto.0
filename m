Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84990C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 12:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4963720756
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 12:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600174306;
	bh=LZdWBbrQL6aLS9TPzr03MYYTgUas3AG592iIebFzvkU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ptPm9T/mggCVrg1aHphPBFokgCP6hRxxUsa8YNtt4WaUl45s7VkJHVpEB2qvviEIR
	 Xk4OZLWnujlcGkXZ6X1wCLNWV1HtJINRdLfM/j9JLyyQ4KEoL3Hc2zclbDNzFYFD0z
	 rbex9easVfLzWnXaPk42QDXZ04gURekuIcET9mk8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIOMvk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 08:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgIOMvg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 08:51:36 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6244C208E4;
        Tue, 15 Sep 2020 12:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600174295;
        bh=LZdWBbrQL6aLS9TPzr03MYYTgUas3AG592iIebFzvkU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FFq7+BT9hy5ZKiscMBmdmlXtVVYLlW3CjYdt2GIlkM4m7EiyyNLKzEMQ7dfpASbhU
         gi8QVcVAw30MEJe+WVHltDJ+CNdQiYdBk0mVmKqltDwxXAVWRxUoocZGMKD3FMUelF
         CXrTzU7wKnc++Gj9wARmP8impN+ulxnwG1r+wvH4=
Received: by mail-ot1-f48.google.com with SMTP id o8so3107602otl.4;
        Tue, 15 Sep 2020 05:51:35 -0700 (PDT)
X-Gm-Message-State: AOAM533K6K0+/z8F0IF2HF1GHrSi1ZeWqfz+ohQZ32ZM4PSP2kiphSBw
        4CNfDdqgktn0yW0rUWSFuiiUJE15LEFexpJazKI=
X-Google-Smtp-Source: ABdhPJxFOZom2HvyLT9wSeZw9331mqOrV+ArfgN713zaP5D2cxQ+/wJ6mMWlSt81zfYm1Uons7cLMXundrI+hUlDDhs=
X-Received: by 2002:a9d:6193:: with SMTP id g19mr12413615otk.108.1600174294568;
 Tue, 15 Sep 2020 05:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com> <20200821034651.GA25442@gondor.apana.org.au>
 <c360d691-8253-bd99-af92-83d9f8e86a2d@nxp.com> <20200908221019.GA23497@gondor.apana.org.au>
 <67159207-1082-48be-d085-971a84b525e0@nxp.com> <CAMj1kXGg7bSh57kwE57mKRocNRPZCeXifwjF53-3Jb6LYsfZTg@mail.gmail.com>
 <38f9904b-5bf7-ea99-ed8a-27cb49f405bd@nxp.com> <CAMj1kXH0jOQms9y1MywORywoKjxQ2p8ttv+Xf9KTOkfORX5XWw@mail.gmail.com>
 <4393bf96-30fd-0d1c-73fe-f5ef7c967f76@nxp.com> <CAMj1kXFeZP7_TQ73yLq0dfb=3wMS0VxqbKKUCGny0xHW1xL+5g@mail.gmail.com>
 <89b9c29d-afb1-0082-66f6-8bb930710884@nxp.com>
In-Reply-To: <89b9c29d-afb1-0082-66f6-8bb930710884@nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 15 Sep 2020 15:51:23 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHxzX25e0ex4HiyeXyxZhkrWBrewF5s8ZqiSk5Cd2DXVQ@mail.gmail.com>
Message-ID: <CAMj1kXHxzX25e0ex4HiyeXyxZhkrWBrewF5s8ZqiSk5Cd2DXVQ@mail.gmail.com>
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

On Tue, 15 Sep 2020 at 15:45, Horia Geant=C4=83 <horia.geanta@nxp.com> wrot=
e:
>
> On 9/15/2020 1:26 PM, Ard Biesheuvel wrote:
> > On Tue, 15 Sep 2020 at 13:02, Horia Geant=C4=83 <horia.geanta@nxp.com> =
wrote:
> >>
> >> On 9/14/2020 9:20 PM, Ard Biesheuvel wrote:
> >>> On Mon, 14 Sep 2020 at 20:12, Horia Geant=C4=83 <horia.geanta@nxp.com=
> wrote:
> >>>>
> >>>> On 9/14/2020 7:28 PM, Ard Biesheuvel wrote:
> >>>>> On Mon, 14 Sep 2020 at 19:24, Horia Geant=C4=83 <horia.geanta@nxp.c=
om> wrote:
> >>>>>>
> >>>>>> On 9/9/2020 1:10 AM, Herbert Xu wrote:
> >>>>>>> On Tue, Sep 08, 2020 at 01:35:04PM +0300, Horia Geant=C4=83 wrote=
:
> >>>>>>>>
> >>>>>>>>> Just go with the get_unaligned unconditionally.
> >>>>>>>>
> >>>>>>>> Won't this lead to sub-optimal code for ARMv7
> >>>>>>>> in case the IV is aligned?
> >>>>>>>
> >>>>>>> If this should be optimised in ARMv7 then that should be done
> >>>>>>> in get_unaligned itself and not open-coded.
> >>>>>>>
> >>>>>> I am not sure what's wrong with avoiding using the unaligned acces=
sors
> >>>>>> in case data is aligned.
> >>>>>>
> >>>>>> Documentation/core-api/unaligned-memory-access.rst clearly states:
> >>>>>> These macros work for memory accesses of any length (not just 32 b=
its as
> >>>>>> in the examples above). Be aware that when compared to standard ac=
cess of
> >>>>>> aligned memory, using these macros to access unaligned memory can =
be costly in
> >>>>>> terms of performance.
> >>>>>>
> >>>>>> So IMO it makes sense to use get_unaligned() only when needed.
> >>>>>> There are several cases of users doing this, e.g. siphash.
> >>>>>>
> >>>>>
> >>>>> For ARMv7 code, using the unaligned accessors unconditionally is fi=
ne,
> >>>>> and it will not affect performance.
> >>>>>
> >>>>> In general, when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is defined,
> >>>>> you can use the unaligned accessors. If it is not, it helps to have
> >>>>> different code paths.
> >>>>>
> >>>> arch/arm/include/asm/unaligned.h doesn't make use of
> >>>> linux/unaligned/access_ok.h, even if CONFIG_HAVE_EFFICIENT_UNALIGNED=
_ACCESS
> >>>> is set.
> >>>>
> >>>> I understand the comment in the file, however using get_unaligned()
> >>>> unconditionally takes away the opportunity to generate optimized cod=
e
> >>>> (using ldrd/ldm) when data is aligned.
> >>>>
> >>>
> >>> But the minimal optimization that is possible here (one ldrd/ldm
> >>> instruction vs two ldr instructions) is defeated by the fact that you
> >>> are using a conditional branch to select between the two. And this is
> >>> not even a hot path to begin with,
> >>>
> >> This is actually on the hot path (encrypt/decrypt callbacks),
> >> but you're probably right that the conditional branching is going to o=
ffset
> >> the optimized code.
> >>
> >
> > This is called once per XTS request, right? And you are saying the
> > extra cycle makes a difference?
> >
> Yes, once per request and no, not super-important.
>
> >> To avoid branching, code could be rewritten as:
> >>
> >> #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> >>         size =3D *(u64 *)(req->iv + (ivsize / 2));
> >> #else
> >>         size =3D get_unaligned((u64 *)(req->iv + (ivsize / 2)));
> >> #endif
> >>
> >> however in this case ARMv7 would suffer since
> >> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy and
> >> ldrd/ldm for accesses not word-aligned are inefficient - lead to traps=
.
> >>
> >
> > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS means 'just use the unaligned
> > accessors as they are basically free'. Casting a potentially
> > misaligned u8* to a u64* is not permitted by the C standard.
> >
> Seems that I misunderstood CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.
>

You're not the only one :-) I have been intending to get the
discussion going with the networking folks, who rely heavily on this
as well.

> Looking at its usage, e.g. ether_addr_equal() or __crypto_memneq_*(),
> I see similar casts of pointers possibly misaligned.
>

Yes, that is the confusion. CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
should indicate whether using the unaligned accessors is fine in all
cases, or whether you should find other ways to load the data more
efficiently (compare NET_IP_ALIGN, which shifts the entire IP header
so the 32-bit address field appear aligned in memory)

CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS does *not* mean that you can
simply cast any pointer to any type and dereference it, but the
meaning appears to have shifted this way over the years (and the
Documentation/ was even updated to this effect)

Pre-v6 ARM (and MIPS as well, IIRC) require byte sized accesses and
shift/or sequences to do unaligned accesses, whereas v6 and up simply
allows ldr from a misaligned address. So in the former case, you could
use cra_alignmask to align the data in memory, while the latter case
can ignore it. (arch/arm/crypto/aes-cipher-glue.c uses this as well)

> >> Would it be ok to use:
> >> #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && !defined(CONFIG=
_ARM)
> >> to workaround the ARMv7 inconsistency?
> >>
> >
> > No, please just use the get_unaligned() accessor.
> >
> Ok.
>
> Thanks,
> Horia
