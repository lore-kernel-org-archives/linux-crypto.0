Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91153C43461
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 18:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B8B2076C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 18:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600107619;
	bh=IiWBHF7Kq1gGCefdLYFTYRZidx/gNkc82SqKKeeSLrE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=cLHXRXFZ4ZVQiQ6y7w52P3Crl03q30v47qzLPc4GKM4NyqQCd/fOvbtwoj52TXb05
	 6i+RkrUjfizKZ9YoHji/+DNnI4pB7xff2S+im8Lhs7hpnq26rfpY1xBKfAHeL3a7Rk
	 WDb4MFrlFanm1rqqPtAktfNwewGxo6j2mrB0F990=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgINSUQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 14:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgINSUN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 14:20:13 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39306214F1;
        Mon, 14 Sep 2020 18:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600107613;
        bh=IiWBHF7Kq1gGCefdLYFTYRZidx/gNkc82SqKKeeSLrE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mWz2BdugR29K6X0Xu8C6SlkOLSe2pjJNYMFlbO+5ax3K2AVcWjnRt44zquff6bMPR
         2Q38a3C4gXui8Qjs0kMiRNMPXSsHXx4rfFjWie+6XEumnVmhP7B1CbuwD1H30pdahk
         2IUwLt/RWlJeeCqbfJUqZJ6R5pdUEYHjy7i+m0o4=
Received: by mail-oi1-f174.google.com with SMTP id w16so896688oia.2;
        Mon, 14 Sep 2020 11:20:13 -0700 (PDT)
X-Gm-Message-State: AOAM532fHsbJzXkpa1rmTpF8S8bRfsBi1mNeXTVTDx5mb5+X5t66lm43
        MGwQVQUE0ynDEBJYQhLTfICIh8uxnOE5BgUP0zk=
X-Google-Smtp-Source: ABdhPJwMTJZEt44jiTicdoE04xOArfMKobGqfvMji4Aedg/dvKLfvk9HfmWAwwB9fGTLAYElkuMXqQAzYNd1iX8bbyk=
X-Received: by 2002:aca:d845:: with SMTP id p66mr400667oig.47.1600107612611;
 Mon, 14 Sep 2020 11:20:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200806163551.14395-1-andrei.botila@oss.nxp.com>
 <20200806163551.14395-2-andrei.botila@oss.nxp.com> <20200821034651.GA25442@gondor.apana.org.au>
 <c360d691-8253-bd99-af92-83d9f8e86a2d@nxp.com> <20200908221019.GA23497@gondor.apana.org.au>
 <67159207-1082-48be-d085-971a84b525e0@nxp.com> <CAMj1kXGg7bSh57kwE57mKRocNRPZCeXifwjF53-3Jb6LYsfZTg@mail.gmail.com>
 <38f9904b-5bf7-ea99-ed8a-27cb49f405bd@nxp.com>
In-Reply-To: <38f9904b-5bf7-ea99-ed8a-27cb49f405bd@nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 14 Sep 2020 21:20:00 +0300
X-Gmail-Original-Message-ID: <CAMj1kXH0jOQms9y1MywORywoKjxQ2p8ttv+Xf9KTOkfORX5XWw@mail.gmail.com>
Message-ID: <CAMj1kXH0jOQms9y1MywORywoKjxQ2p8ttv+Xf9KTOkfORX5XWw@mail.gmail.com>
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

On Mon, 14 Sep 2020 at 20:12, Horia Geant=C4=83 <horia.geanta@nxp.com> wrot=
e:
>
> On 9/14/2020 7:28 PM, Ard Biesheuvel wrote:
> > On Mon, 14 Sep 2020 at 19:24, Horia Geant=C4=83 <horia.geanta@nxp.com> =
wrote:
> >>
> >> On 9/9/2020 1:10 AM, Herbert Xu wrote:
> >>> On Tue, Sep 08, 2020 at 01:35:04PM +0300, Horia Geant=C4=83 wrote:
> >>>>
> >>>>> Just go with the get_unaligned unconditionally.
> >>>>
> >>>> Won't this lead to sub-optimal code for ARMv7
> >>>> in case the IV is aligned?
> >>>
> >>> If this should be optimised in ARMv7 then that should be done
> >>> in get_unaligned itself and not open-coded.
> >>>
> >> I am not sure what's wrong with avoiding using the unaligned accessors
> >> in case data is aligned.
> >>
> >> Documentation/core-api/unaligned-memory-access.rst clearly states:
> >> These macros work for memory accesses of any length (not just 32 bits =
as
> >> in the examples above). Be aware that when compared to standard access=
 of
> >> aligned memory, using these macros to access unaligned memory can be c=
ostly in
> >> terms of performance.
> >>
> >> So IMO it makes sense to use get_unaligned() only when needed.
> >> There are several cases of users doing this, e.g. siphash.
> >>
> >
> > For ARMv7 code, using the unaligned accessors unconditionally is fine,
> > and it will not affect performance.
> >
> > In general, when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is defined,
> > you can use the unaligned accessors. If it is not, it helps to have
> > different code paths.
> >
> arch/arm/include/asm/unaligned.h doesn't make use of
> linux/unaligned/access_ok.h, even if CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCE=
SS
> is set.
>
> I understand the comment in the file, however using get_unaligned()
> unconditionally takes away the opportunity to generate optimized code
> (using ldrd/ldm) when data is aligned.
>

But the minimal optimization that is possible here (one ldrd/ldm
instruction vs two ldr instructions) is defeated by the fact that you
are using a conditional branch to select between the two. And this is
not even a hot path to begin with,

> > This is a bit murky, and through the years, the interpretation of
> > unaligned-memory-access.rst has shifted a bit, but in this case, it
> > makes no sense to make the distinction.
> >
>
> Thanks,
> Horia
