Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8A3C4361B
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66FFF230FF
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438818AbgLLKy7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 05:54:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgLLKy7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 05:54:59 -0500
X-Gm-Message-State: AOAM530MgMyFxV64AKMHo3/fqrGgkMYA46ZH1Q7F0pR3uRNBZzNKIgli
        pbahEjyBu04PfwTzrdC2uMNiaHKTDGyXmOLIIm8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607770458;
        bh=I2k6JcKef6p2Y07EpasqSQz/C60x4ofi+mzysUW+G74=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=R/u+XyxMYztIqz8elA/Sbr1Ln9z4A8v83dLt3pCpLOD/ZbY1zpSX1Yomgz6SflZrU
         LMvGh6LS3Tja5Li8eCYqSENBJc6/0usA0wIhkEK/I8prf+6p3i/mOxV92bpCsdz5av
         utUoGJrT8BdlMWKJFR830qULVrpSuy4XleiRLctvklEk+nD6b0riDEyo+E4teI3Mcf
         8un+dmK7m+f4tTG0tQtLHpDokw01aO2T9OUeSTlR1IlkhKUBk5swqAO5yG4K7S7txC
         CcI75E11StEX6xBMTUp+8huAH6NLFuJ9Ti87z0aY0cj2zqkXsl0uVdzm0CXqAaOqH+
         LH92h+vWMxm/Q==
X-Google-Smtp-Source: ABdhPJzTVu8UnT9t8lYDnzh23onvGBawiayLuGYYV5y7vjFoQ76zU9aHbwkc5nGeieLtu61vp0i14GB6Mi/WOJPGPyE=
X-Received: by 2002:a05:6830:1c24:: with SMTP id f4mr12718462ote.108.1607770458126;
 Sat, 12 Dec 2020 02:54:18 -0800 (PST)
MIME-Version: 1.0
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <X9Ov3RWDpUik7gXo@sol.localdomain> <CAMj1kXEDjQG_my5FWVY+b7Q43-_waW74sZyBAPCkd7EEdku+Rw@mail.gmail.com>
In-Reply-To: <CAMj1kXEDjQG_my5FWVY+b7Q43-_waW74sZyBAPCkd7EEdku+Rw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 12 Dec 2020 11:54:07 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH=u7+_DSEsUmFbtgGdPqCUs=AfTqX0mgL+DYvW2hAc8g@mail.gmail.com>
Message-ID: <CAMj1kXH=u7+_DSEsUmFbtgGdPqCUs=AfTqX0mgL+DYvW2hAc8g@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        TimGuo-oc@zhaoxin.com, CooperYan@zhaoxin.com,
        QiyuanWang@zhaoxin.com, HerryYang@zhaoxin.com,
        CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 12 Dec 2020 at 10:36, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Fri, 11 Dec 2020 at 20:07, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc wrote:
> > > The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
> > > On platforms with Zhaoxin CPUs supporting this X86 feature, When
> > > crc32c-intel and crc32c-generic are both registered, system will
> > > use crc32c-intel because its .cra_priority is greater than
> > > crc32c-generic. This case expect to use crc32c-generic driver for
> > > some Zhaoxin CPUs to get performance gain, So remove these Zhaoxin
> > > CPUs support from crc32c-intel.
> > >
> > > Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
> >
> > Does this mean that the performance of the crc32c instruction on those CPUs is
> > actually slower than a regular C implementation?  That's very weird.
> >
>
> This driver does not use CRC instructions, but carryless
> multiplication and aggregation. So I suppose the pclmulqdq instruction
> triggers some pathological performance limitation here.
>

Just noticed it uses both crc instructions and pclmulqdq instructions.
Sorry for the noise.

> That means the crct10dif driver probably needs the same treatment.

Tony, can you confirm that the problem is in the CRC instructions and
not in the PCLMULQDQ code path that supersedes it when available?
