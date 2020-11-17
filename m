Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D80C64E7A
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 14:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1EC224198
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 14:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6+F9+39"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgKQO6X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 09:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729875AbgKQO6X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 09:58:23 -0500
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B67B24198;
        Tue, 17 Nov 2020 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605625102;
        bh=ntJaD8fOjxDYGmX2Qdy51YlJpyvBSJbhwkEb7CuraqY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L6+F9+39hJDJ2LJ07FgxJsizUSiHF4hhUH8EyvtqzZSXTJXV9IuJjM4C7bHwckbEr
         fwqAg8tVHb5cTonFG6VVP28EwX+VaiDxpG8SsRUn9hxD3bNg41d8GSy1sMp7e10jBl
         6QMw1HhE1xkaelac5XtdVIHyksI5y1bdKZYfrbpw=
Received: by mail-ot1-f52.google.com with SMTP id 79so19626435otc.7;
        Tue, 17 Nov 2020 06:58:22 -0800 (PST)
X-Gm-Message-State: AOAM531+eGMGdPOFYUkDu4I0ZMg9PfFEEeVg38s+cKDb+YBexFibE8ef
        j1D+2w+j9WUAVyFSFBALV63fHUwi/1gC3qrupw==
X-Google-Smtp-Source: ABdhPJwJY25KwVJRjJCwnl/SMbCUykxVzPqGEFaXZ7R5w36zpxQ3ggqNg4707acf03hjg1ZUuAa9bHo6M3JMJtJiqU0=
X-Received: by 2002:a9d:5e14:: with SMTP id d20mr3083096oti.107.1605625101656;
 Tue, 17 Nov 2020 06:58:21 -0800 (PST)
MIME-Version: 1.0
References: <20200916071950.1493-1-gilad@benyossef.com> <20200916071950.1493-2-gilad@benyossef.com>
 <20200923015702.GA3676455@bogus> <CAOtvUMekoMjFij_xDnrwRj2PsfgO8tKx4Jk6d7C5vq-Vh+boWw@mail.gmail.com>
 <CAOtvUMfAKnodo+7EYx2M4yAvxu_VmxwXNRmgOW=KFWi3Wy7msQ@mail.gmail.com>
 <CAL_JsqJditVYJ=4K9i11BjoV2ejABnuMbRyLtm8+e93ApUTu9w@mail.gmail.com> <CAOtvUMdN2NOJ+7g=XnjOyW7W=77OM=d-d69YDk-a-QmO8Wze5w@mail.gmail.com>
In-Reply-To: <CAOtvUMdN2NOJ+7g=XnjOyW7W=77OM=d-d69YDk-a-QmO8Wze5w@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 17 Nov 2020 08:58:10 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLh88p6nFprUkac-pBi=r_+De0zyJs0UJAJ3o-S+BPzwg@mail.gmail.com>
Message-ID: <CAL_JsqLh88p6nFprUkac-pBi=r_+De0zyJs0UJAJ3o-S+BPzwg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: crypto: update ccree optional params
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Robin Murphy <Robin.Murphy@arm.com>,
        Steven Price <steven.price@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 17, 2020 at 1:39 AM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> On Mon, Nov 16, 2020 at 8:54 PM Rob Herring <robh@kernel.org> wrote:
> >
> > On Thu, Oct 22, 2020 at 1:18 AM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > >
> > >
> > > Hi again,
> > >
> > > Any opinion on the suggested below?
> >
> > Sorry, lost in the pile...
>
> No problem at all. I know how it is...
>
>
> > >
> > >
> > > On Tue, Sep 29, 2020 at 9:08 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > >>
> > >>
> > >> On Wed, Sep 23, 2020 at 4:57 AM Rob Herring <robh@kernel.org> wrote:
> > >> >
> > >> > On Wed, Sep 16, 2020 at 10:19:49AM +0300, Gilad Ben-Yossef wrote:
> > >> > > Document ccree driver supporting new optional parameters allowing to
> > >> > > customize the DMA transactions cache parameters and ACE bus sharability
> > >> > > properties.
> > >> > >
> > >> > > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > >> > > ---
> > >> > >  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 4 ++++
> > >> > >  1 file changed, 4 insertions(+)
> > >> > >
> > >> > > diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> > >> > > index 6130e6eb4af8..1a1603e457a8 100644
> > >> > > --- a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> > >> > > +++ b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> > >> > > @@ -13,6 +13,10 @@ Required properties:
> > >> > >  Optional properties:
> > >> > >  - clocks: Reference to the crypto engine clock.
> > >> > >  - dma-coherent: Present if dma operations are coherent.
> > >> > > +- awcache: Set write transactions cache attributes
> > >> > > +- arcache: Set read transactions cache attributes
> > >> >
>
> <snip>
>
> > >> > These could also just be implied by the compatible string (and requiring
> > >> > an SoC specific one).
> > >>
> > >> hm... we could do it but this will require us to know (and publicly
> > >> acknowledge) of every SoC making use of this piece of hardware design.
> >
> > That's already a requirement in general. Sometimes we can avoid it,
> > but that's cases of getting lucky.
> >
> > >> There is currently no other part of the driver that needs this.
> >
> > If your DT is part of firmware, then waiting until adding some driver
> > feature or quirk based on a new DT property is too late. Whereas with
> > a SoC specific compatible, you can handle any new feature or quirk
> > without a DT change (e.g. just a stable kernel update). Some platforms
> > may not care about that model, but in general that's the policy we
> > follow. Not doing that, we end up with the DWC3 binding.
> >
> > A fallback compatible is how we avoid updating drivers for every
> > single SoC unless needed.
>
> OK, I now better understand what you meant and that does make some
> sense and I will defer to your better judgment  about the proper way
> to do this.
>
> Having said that, there is still something that bugs me about this,
> even just at the level of better understanding why we do things:
>
> Way back when, before DT, we had SoC specific code that identified the
> SoC somehow and set things up in a SoC specific way.
> Then we introduced DT as a way to say - "hey look, this is how my
> busses looks like, these are the devices I have, deal with it" and I
> always assumed that this was meant as a way to release us from having
> SoC specific setup code.

Yes, but in the end it's a judgement call as to what the boundary is.
Take clocks for example, in the beginning we were trying to describe
clocks on a mux/divider/gate level in DT. We realized this would
result in hundreds to thousands of DT nodes and it would never be
completely correct. So we model only the leaf clocks for the most part
and there's lots of SoC code for clock controller blocks still.

The questions for having properties or not to ask is:

Is this board specific? Yes, then use a property.

Who needs to change this and when? Should/would you want to control
this in your PC BIOS or via a BIOS update?


Zero SoC code was never a goal. It was about a standard way to define
SoCs and having common frameworks (we have a common clock api, but not
implementation at the time). We have *way* less SoC code per SoC than
we used to. At the start of the DT conversion for Arm, we had ~400
boards and now we're at ~1400 last I checked.

> It seems now potentially every SoC vendor needs to modify not just the
> device tree source (which makes sense of course) but also the driver
> supporting their platform.
> It now looks like we've come a full circle to me :-)

As I said, if the h/w is 'exactly the same' (hint: it rarely is), then
use a fallback compatible. Then the new SoC specific compatible is
there just in case.

Think of compatible just as a VID/PID in PCI and USB land (though the
closest thing to a fallback there is class codes). They are the only
way we can uniquely identify h/w.

Rob
