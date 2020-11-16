Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18AFC4742C
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 18:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B4EE22409
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 18:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="no7KwtrM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgKPSyx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:54:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgKPSyx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 13:54:53 -0500
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76E252231B;
        Mon, 16 Nov 2020 18:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552892;
        bh=VUgJn3gCDf8LQvqGJa0Q1W2ju75Kaw313SrTYPIIguA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=no7KwtrMBTttsCn1fg0tI1bOmdl35zp7bdNWYTgYRLZ1Avqp9sXhE5Xtu5LgDWkFI
         x0mUv1e5sKqCguFn/uK09NdetwAut6wP8n2RmNcBrrlkKgFbrzRbTjXKR78hr9JJJk
         tOcdml4xDl3FRHh1Oe7Jh6gmp3+YaIcT9cdgvNsY=
Received: by mail-ot1-f48.google.com with SMTP id f16so16995792otl.11;
        Mon, 16 Nov 2020 10:54:52 -0800 (PST)
X-Gm-Message-State: AOAM532S3o+jbzuV6eJjHa5KSE2npB70FgoTYP7/1/7zIi7YeSZVrNLu
        67yvJUiPOzz27dRSbweswFb8wxWgrvXL/qb/dg==
X-Google-Smtp-Source: ABdhPJwGvsSVV4wVtv/wz445N2G+m7CZ57dR9o2XykijQzjw0jqj+bo8Xq6WnU3sswimSpwcaX3xfZQUJ4STsn0scJQ=
X-Received: by 2002:a05:6830:2259:: with SMTP id t25mr532760otd.192.1605552891767;
 Mon, 16 Nov 2020 10:54:51 -0800 (PST)
MIME-Version: 1.0
References: <20200916071950.1493-1-gilad@benyossef.com> <20200916071950.1493-2-gilad@benyossef.com>
 <20200923015702.GA3676455@bogus> <CAOtvUMekoMjFij_xDnrwRj2PsfgO8tKx4Jk6d7C5vq-Vh+boWw@mail.gmail.com>
 <CAOtvUMfAKnodo+7EYx2M4yAvxu_VmxwXNRmgOW=KFWi3Wy7msQ@mail.gmail.com>
In-Reply-To: <CAOtvUMfAKnodo+7EYx2M4yAvxu_VmxwXNRmgOW=KFWi3Wy7msQ@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 16 Nov 2020 12:54:40 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJditVYJ=4K9i11BjoV2ejABnuMbRyLtm8+e93ApUTu9w@mail.gmail.com>
Message-ID: <CAL_JsqJditVYJ=4K9i11BjoV2ejABnuMbRyLtm8+e93ApUTu9w@mail.gmail.com>
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

On Thu, Oct 22, 2020 at 1:18 AM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
>
> Hi again,
>
> Any opinion on the suggested below?

Sorry, lost in the pile...

> Thanks!
> Gilad
>
>
> On Tue, Sep 29, 2020 at 9:08 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>
>>
>> On Wed, Sep 23, 2020 at 4:57 AM Rob Herring <robh@kernel.org> wrote:
>> >
>> > On Wed, Sep 16, 2020 at 10:19:49AM +0300, Gilad Ben-Yossef wrote:
>> > > Document ccree driver supporting new optional parameters allowing to
>> > > customize the DMA transactions cache parameters and ACE bus sharability
>> > > properties.
>> > >
>> > > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> > > ---
>> > >  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 4 ++++
>> > >  1 file changed, 4 insertions(+)
>> > >
>> > > diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
>> > > index 6130e6eb4af8..1a1603e457a8 100644
>> > > --- a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
>> > > +++ b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
>> > > @@ -13,6 +13,10 @@ Required properties:
>> > >  Optional properties:
>> > >  - clocks: Reference to the crypto engine clock.
>> > >  - dma-coherent: Present if dma operations are coherent.
>> > > +- awcache: Set write transactions cache attributes
>> > > +- arcache: Set read transactions cache attributes
>> >
>> > dma-coherent already implies these are 011x, 101x or 111x. In my limited
>> > experience configuring these (Calxeda SATA and ethernet), writeback,
>> > write-allocate was pretty much always optimal.
>>
>> Indeed and these are the default. But not all SoC are born equal and
>> we got a request to allow setting these.
>>
>> Maybe instead of numerical values have three possible verbal setting
>> would be better?
>>
>>
>> > > +- awdomain: Set write transactions ACE sharability domain (712, 703, 713 only)
>> > > +- ardomain: Set read transactions ACE sharability domain (712, 703, 713 only)
>> >
>> > This probably needs something common. We may need something for Mali,
>> > too. I don't think different settings for read and write makes much
>> > sense nor does anything beyond IS or OS.
>>
>> I agree. Maybe
>>
>> sharability_domain: either "IS" or "OS"?

It's still an Arm thing, so it would need at least an 'arm,' prefix.
But ideally it wouldn't be Arm specific though I'm not sure if any
such thing is needed for other arches. If common either for Arm or
across arches, then it needs to be documented in a common doc with
some wider agreement than what a device specific property needs.

>> > These could also just be implied by the compatible string (and requiring
>> > an SoC specific one).
>>
>> hm... we could do it but this will require us to know (and publicly
>> acknowledge) of every SoC making use of this piece of hardware design.

That's already a requirement in general. Sometimes we can avoid it,
but that's cases of getting lucky.

>> There is currently no other part of the driver that needs this.

If your DT is part of firmware, then waiting until adding some driver
feature or quirk based on a new DT property is too late. Whereas with
a SoC specific compatible, you can handle any new feature or quirk
without a DT change (e.g. just a stable kernel update). Some platforms
may not care about that model, but in general that's the policy we
follow. Not doing that, we end up with the DWC3 binding.

A fallback compatible is how we avoid updating drivers for every
single SoC unless needed.

Rob
