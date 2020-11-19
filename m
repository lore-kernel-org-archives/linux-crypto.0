Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DBCC6379D
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 11:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57C4B246F0
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 11:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="IJttzj9X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgKSLlt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 06:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgKSLls (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 06:41:48 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C1CC0613D4
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 03:41:48 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id 10so4877148ybx.9
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 03:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y7gXUJuJroGDctb9/xAAop+cbgneqpYN5WNiStetQys=;
        b=IJttzj9XDz6eT4IBxRgTtGGVTfPee+TtvdKB3QuW2sHAxRxDgNwYLV4gLxmv5AL8xJ
         LE6kMxCW0w+jFFwIshKvT6UwBFVpFIPA7aBwADHV+g1+e/WTl0gpjeruXyU30bySbKs6
         /K927NvXkcGCfCufmx963X0O6Gmh7zakYWtWMHkmlPTbV6gTXnm/KHOg9XCd7Y8X3FBo
         YlAReXOI1YsVXD4vJH2MhK7sKTc+44Wp9QyAs3l4FMoOfdXXaqouJQu6ZmZAhmeUpdJ8
         n+zG0+b3smN2ubonnvSxSwN/PmCVf8AxB6PrM72O67kbvXz9j9Gup19TYFA6oTtXipNY
         t7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y7gXUJuJroGDctb9/xAAop+cbgneqpYN5WNiStetQys=;
        b=gqoG5MzCAihjAmKlTS/YIjMQkaDO2h5g4wD3VckPxPYH9TcfrK4pqM3PGgI+Vjjqwl
         hBFRFIMgZrjeS06+C3cR7YGPrOoplYN7tDRaY8oKE+cI8SfYvRSKS9fNlOlQ0X9dmDHQ
         j7r27pJvEKq+RTPlU41V3AL+4I/TWlkem9skEP8g0kZAH+VYnD9Qc7GsdZ5OgvtfW0xk
         opNdKr5TmHBYw7h94AWdIJWWMFGisqAd8qe6gNM/R01tc4xcOiS8c8v61KV8HVH24bpr
         xnnQlJCW6C6Dh/XWR4NK3XDIHptB7aaVnIaOMj3HPkY5Ztcka4n1ItgMD2qFOdXhDtWj
         KD8g==
X-Gm-Message-State: AOAM530Gg6Af8bZHWVoqxJsKqYlawa71NvNsUNd8C/8dq6JELIvOhGXS
        wjuOflnkXy8D3oxG8KQdeK8uv2ndD5nkt0sQdFX9cA==
X-Google-Smtp-Source: ABdhPJzyIfXZcXP/5LfepboOLV/m3mhlxJZaJGJSNIbP8WUuBJENdPgANYL88+OvOkVlaiTfr/PNbtJl5e4nt0MkR20=
X-Received: by 2002:a25:b90e:: with SMTP id x14mr10614445ybj.307.1605786107494;
 Thu, 19 Nov 2020 03:41:47 -0800 (PST)
MIME-Version: 1.0
References: <20200916071950.1493-1-gilad@benyossef.com> <20200916071950.1493-2-gilad@benyossef.com>
 <20200923015702.GA3676455@bogus> <CAOtvUMekoMjFij_xDnrwRj2PsfgO8tKx4Jk6d7C5vq-Vh+boWw@mail.gmail.com>
 <CAOtvUMfAKnodo+7EYx2M4yAvxu_VmxwXNRmgOW=KFWi3Wy7msQ@mail.gmail.com>
 <CAL_JsqJditVYJ=4K9i11BjoV2ejABnuMbRyLtm8+e93ApUTu9w@mail.gmail.com>
 <CAOtvUMdN2NOJ+7g=XnjOyW7W=77OM=d-d69YDk-a-QmO8Wze5w@mail.gmail.com> <CAL_JsqLh88p6nFprUkac-pBi=r_+De0zyJs0UJAJ3o-S+BPzwg@mail.gmail.com>
In-Reply-To: <CAL_JsqLh88p6nFprUkac-pBi=r_+De0zyJs0UJAJ3o-S+BPzwg@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 19 Nov 2020 13:41:31 +0200
Message-ID: <CAOtvUMdUGL1Sv0TL=us3du1JeSQoD=Aa_cNr9f2kAb4M-_VpYg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: crypto: update ccree optional params
To:     Rob Herring <robh@kernel.org>
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 17, 2020 at 4:58 PM Rob Herring <robh@kernel.org> wrote:

> >
> > > >> > These could also just be implied by the compatible string (and r=
equiring
> > > >> > an SoC specific one).
> > > >>
> > > >> hm... we could do it but this will require us to know (and publicl=
y
> > > >> acknowledge) of every SoC making use of this piece of hardware des=
ign.
> > >
> > > That's already a requirement in general. Sometimes we can avoid it,
> > > but that's cases of getting lucky.
> > >
> > > >> There is currently no other part of the driver that needs this.
> > >
> > > If your DT is part of firmware, then waiting until adding some driver
> > > feature or quirk based on a new DT property is too late. Whereas with
> > > a SoC specific compatible, you can handle any new feature or quirk
> > > without a DT change (e.g. just a stable kernel update). Some platform=
s
> > > may not care about that model, but in general that's the policy we
> > > follow. Not doing that, we end up with the DWC3 binding.
> > >
> > > A fallback compatible is how we avoid updating drivers for every
> > > single SoC unless needed.
> >
> > OK, I now better understand what you meant and that does make some
> > sense and I will defer to your better judgment  about the proper way
> > to do this.
> >
> > Having said that, there is still something that bugs me about this,
> > even just at the level of better understanding why we do things:
> >
> > Way back when, before DT, we had SoC specific code that identified the
> > SoC somehow and set things up in a SoC specific way.
> > Then we introduced DT as a way to say - "hey look, this is how my
> > busses looks like, these are the devices I have, deal with it" and I
> > always assumed that this was meant as a way to release us from having
> > SoC specific setup code.
>
> Yes, but in the end it's a judgement call as to what the boundary is.
> Take clocks for example, in the beginning we were trying to describe
> clocks on a mux/divider/gate level in DT. We realized this would
> result in hundreds to thousands of DT nodes and it would never be
> completely correct. So we model only the leaf clocks for the most part
> and there's lots of SoC code for clock controller blocks still.
>
> The questions for having properties or not to ask is:
>
> Is this board specific? Yes, then use a property.
>
> Who needs to change this and when? Should/would you want to control
> this in your PC BIOS or via a BIOS update?
>
>
> Zero SoC code was never a goal. It was about a standard way to define
> SoCs and having common frameworks (we have a common clock api, but not
> implementation at the time). We have *way* less SoC code per SoC than
> we used to. At the start of the DT conversion for Arm, we had ~400
> boards and now we're at ~1400 last I checked.
>
> > It seems now potentially every SoC vendor needs to modify not just the
> > device tree source (which makes sense of course) but also the driver
> > supporting their platform.
> > It now looks like we've come a full circle to me :-)
>
> As I said, if the h/w is 'exactly the same' (hint: it rarely is), then
> use a fallback compatible. Then the new SoC specific compatible is
> there just in case.
>
> Think of compatible just as a VID/PID in PCI and USB land (though the
> closest thing to a fallback there is class codes). They are the only
> way we can uniquely identify h/w.

Thanks Rob, this makes sense.

Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
